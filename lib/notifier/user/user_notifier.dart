import 'package:baton/core/di/repository/auth_provider.dart';
import 'package:baton/core/error/failure.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/core/di/repository/user_provider.dart';
import 'package:baton/views/product_detail/viewmodel/author_notifier.dart';
import 'package:baton/models/entities/user.dart' as entity;
import 'package:baton/service/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_notifier.g.dart';
 
@Riverpod(keepAlive: true)
class AuthTransition extends _$AuthTransition {
  @override
  bool build() => false;

  void start() => state = true;
  void end() => state = false;
}

@Riverpod(keepAlive: true)
class UserNotifier extends _$UserNotifier {
  @override
  Stream<entity.User?> build() {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return Stream.value(null);

    final userRepo = ref.read(userRepositoryProvider);

    // 최초 1회만 FCM 토큰 업데이트 수행
    // (이후 토큰 갱신은 FirebaseMessaging.instance.onTokenRefresh 등에서 별도 처리 권장)
    Future.microtask(() {
      NotificationService().updateFCMToken(
        firebaseUser.uid,
        userRepository: userRepo,
      );
    });

    // ⭐️ 실시간 감시 시작 (Stream)
    return userRepo.watchUserData(firebaseUser.uid).map((result) {
      final user = switch (result) {
        Success(:final value) => value,
        Error() => null,
      };

      // 🔥 [Soft Delete] 이미 탈퇴 처리된 유저라면 null 반환 (미가입 상태로 취급)
      if (user != null && (user.isDeleted || user.deletedAt != null)) {
        return null;
      }

      return user;
    });
  }

  /// 유저 정보를 수동으로 다시 불러옵니다. (필요 시)
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  Future<void> withdraw({
    required void Function() onSuccess,
    required void Function(String) onError,
  }) async {
    final currentUser = state.value;

    if (currentUser == null) {
      onError("탈퇴할 유저 정보가 로드되지 않았습니다.");
      return;
    }

    final userRepo = ref.read(userRepositoryProvider);

    // 🔥 탈퇴 프로세스 시작 (라우터 고정)
    ref.read(authTransitionProvider.notifier).start();

    // [보안] 탈퇴 전 FCM 토큰 삭제
    await NotificationService().deleteFCMToken(
      currentUser.uid,
      userRepository: userRepo,
    );

    // 1. Firestore 데이터 삭제 대신 '삭제됨' 표시 (Soft Delete)
    // 닉네임을 변경하여 기존 닉네임을 다른 사람에게 돌려줍니다.
    final result = await userRepo.markUserAsDeleted(currentUser.uid);

    if (result is Error<void, Failure>) {
      ref.read(authTransitionProvider.notifier).end();
      onError(result.failure.message);
      return;
    }

    // 2. 소셜 및 Auth 계정 삭제 (실패하더라도 로그아웃은 진행하여 세션 종료)
    try {
      final authResult = await ref.read(authRepositoryProvider).deleteAccount();
      
      // 결과와 관계없이 로그아웃을 먼저 진행 (안전한 내비게이션을 위해)
      await FirebaseAuth.instance.signOut();
      ref.invalidateSelf();

      if (authResult is Success) {
        onSuccess();
      } else if (authResult is Error<void, Failure>) {
        onError(authResult.failure.message);
      }
    } catch (e) {
      await FirebaseAuth.instance.signOut();
      ref.invalidateSelf();
      onError("탈퇴 처리 중 오류가 발생했습니다: $e");
    } finally {
      // 🔥 전환 완료
      ref.read(authTransitionProvider.notifier).end();
    }
  }

  /// 로그아웃 시 알림 정리
  Future<void> signOut() async {
    ref.read(authTransitionProvider.notifier).start();
    try {
      final currentUser = state.value;
      if (currentUser != null) {
        final userRepo = ref.read(userRepositoryProvider);
        await NotificationService().deleteFCMToken(
          currentUser.uid,
          userRepository: userRepo,
        );
      }
      await ref.read(authRepositoryProvider).signOut();
      ref.invalidateSelf();
    } finally {
      ref.read(authTransitionProvider.notifier).end();
    }
  }

  /// 즐겨찾기 토글 (추가/제거)
  Future<void> toggleFavorite(String productId) async {
    final currentUser = state.value;
    if (currentUser == null) return;

    final updatedFavorites = Set<String>.from(currentUser.favorites);
    if (updatedFavorites.contains(productId)) {
      updatedFavorites.remove(productId);
    } else {
      updatedFavorites.add(productId);
    }

    final updatedUser = currentUser.copyWith(favorites: updatedFavorites);

    // DB 업데이트 -> Stream이 감지하여 state는 자동 갱신됨
    await ref.read(userRepositoryProvider).updateUserData(updatedUser);
  }

  /// 유저 차단 토글 (추가/제거)
  Future<void> toggleBlockUser(String otherUid) async {
    final currentUser = state.value;
    if (currentUser == null) return;

    // final updatedBlocked = Set<String>.from(currentUser.blockedUsers);
    // if (updatedBlocked.contains(otherUid)) {
    //   updatedBlocked.remove(otherUid);
    // } else {
    final updatedBlocked = List<String>.from(currentUser.blockedUsers);
    final isBlocking = !updatedBlocked.contains(otherUid);

    if (isBlocking) {
      updatedBlocked.add(otherUid);
    } else {
      updatedBlocked.remove(otherUid);
    }

    final updatedUser = currentUser.copyWith(blockedUsers: updatedBlocked);
    final userRepo = ref.read(userRepositoryProvider);

    // DB 업데이트 (내 문서)
    await userRepo.updateUserData(updatedUser);

    // 상대방의 blockedBy 필드 업데이트 (상호 필터링 및 점수 감점)
    if (isBlocking) {
      await userRepo.addBlockedBy(otherUid, currentUser.uid);
      // 🔥 상대방 정보 캐시 무효화 (점수 변화 즉시 반영)
      ref.invalidate(authorProvider(otherUid));
    } else {
      await userRepo.removeBlockedBy(otherUid, currentUser.uid);
      ref.invalidate(authorProvider(otherUid));
    }
  }

  /// 외부에서 상태 주입 (필요 시)
  void updateState(entity.User? user) {
    state = AsyncData(user);
  }

}

// @override
//   FutureOr<entity.User?> build() async {
//     final firebaseUser = FirebaseAuth.instance.currentUser;
//     if (firebaseUser == null) return null;

//     final userRepo = ref.read(userRepositoryProvider);
//     final result = await userRepo.fetchUserData(firebaseUser.uid);

//     final user = switch (result) {
//       Success(:final value) => value,
//       Error() => null,
//     };

//     // [추가] 로그인 성공 상태라면 FCM 토큰 업데이트/서버 전송
//     if (user != null) {
//       NotificationService().updateFCMToken(user.uid, userRepository: userRepo);
//     }

//     return user;
//   }

// @override
//   Stream<entity.User?> build() {
//     final firebaseUser = FirebaseAuth.instance.currentUser;
//     if (firebaseUser == null) return Stream.value(null);

//     final userRepo = ref.read(userRepositoryProvider);
//     // ⭐️ 실시간 감시 시작 (Stream)
//     return userRepo.watchUserData(firebaseUser.uid).map((result) {
//       final user = switch (result) {
//         Success(:final value) => value,
//         Error() => null,
//       };

//       // 유저 데이터가 로드/업데이트될 때마다 FCM 토큰 갱신 보장
//       if (user != null) {
//         NotificationService().updateFCMToken(
//           user.uid,
//           userRepository: userRepo,
//         );
//       }

//       return user;
//     });
//   }
