import 'package:baton/core/di/repository/auth_provider.dart';
import 'package:baton/core/error/failure.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/user.dart' as entity;
import 'package:baton/core/di/repository/user_provider.dart';
import 'package:baton/service/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_notifier.g.dart';

@Riverpod(keepAlive: true)
class UserNotifier extends _$UserNotifier {
  @override
  Stream<entity.User?> build() {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return Stream.value(null);

    final userRepo = ref.read(userRepositoryProvider);

    // ⭐️ 실시간 감시 시작 (Stream)
    return userRepo.watchUserData(firebaseUser.uid).map((result) {
      final user = switch (result) {
        Success(:final value) => value,
        Error() => null,
      };

      // 유저 데이터가 로드/업데이트될 때마다 FCM 토큰 갱신 보장
      if (user != null) {
        NotificationService().updateFCMToken(
          user.uid,
          userRepository: userRepo,
        );
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

    // [보안] 탈퇴 전 FCM 토큰 삭제
    await NotificationService().deleteFCMToken(
      currentUser.uid,
      userRepository: userRepo,
    );

    // 1. Firestore 데이터 삭제
    final result = await userRepo.deleteUserData(currentUser.uid);

    if (result is Error<void, Failure>) {
      onError(result.failure.message);
      return;
    }

    // 2. 소셜 및 Auth 계정 삭제
    final authResult = await ref.read(authRepositoryProvider).deleteAccount();

    switch (authResult) {
      case Success():
        ref.invalidateSelf();
        onSuccess();
        break;
      case Error(:final failure):
        onError(failure.message);
        break;
    }
  }

  /// 로그아웃 시 알림 정리
  Future<void> signOut() async {
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

    // 상대방의 blockedBy 필드 업데이트 (상호 필터링을 위함)
    if (isBlocking) {
      await userRepo.addBlockedBy(otherUid, currentUser.uid);
    } else {
      await userRepo.removeBlockedBy(otherUid, currentUser.uid);
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
