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

      // 🔥 [Soft Delete] 이미 탈퇴 처리된 유저라면 null 반환 (미가입 상태로 취급)
      if (user != null && user.isDeleted) {
        return null;
      }

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

    // 1. Firestore 데이터 삭제 대신 '삭제됨' 표시 (Soft Delete)
    // 닉네임을 변경하여 기존 닉네임을 다른 사람에게 돌려줍니다.
    final result = await userRepo.markUserAsDeleted(currentUser.uid);

    if (result is Error<void, Failure>) {
      onError(result.failure.message);
      return;
    }

    // 2. 소셜 및 Auth 계정 삭제
    final authResult = await ref.read(authRepositoryProvider).deleteAccount();

    switch (authResult) {
      case Success():
        // 🔥 즉시 로그아웃 처리하여 라우터가 로그인 페이지로 인식하게 함
        await FirebaseAuth.instance.signOut();
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

  /// 외부에서 상태 주입 (필요 시)
  void updateState(entity.User? user) {
    state = AsyncData(user);
  }

  Future<void> toggleRecentlySearch(String keyword) async {
    final originUser = state.value;
    if (originUser == null) return;

    final updatedRecentlySearch = Set<String>.from(originUser.recentlySearch);
    final bool isAdding = !updatedRecentlySearch.contains(keyword);

    if (isAdding) {
      updatedRecentlySearch.add(keyword);
    } else {
      updatedRecentlySearch.remove(keyword);
    }

    final updatedUser = originUser.copyWith(
      recentlySearch: updatedRecentlySearch,
    );

    // UI 즉각 반영 (Optimistic Update)
    state = AsyncData(updatedUser);

    // DB 동기화 (Atomic Update)
    final userRepo = ref.read(userRepositoryProvider);
    final Result<void, Failure> result;

    if (isAdding) {
      result = await userRepo.addRecentlySearch(originUser.uid, keyword);
    } else {
      result = await userRepo.removeRecentlySearch(originUser.uid, keyword);
    }

    // DB 업데이트 실패 시 이전 상태로 롤백
    if (result is Error<void, Failure>) {
      state = AsyncData(originUser);
    }
  }

  Future<void> clearRecentlySearch() async {
    final originUser = state.value;
    if (originUser == null) return;

    final updatedRecentlySearch = Set<String>.from(originUser.recentlySearch);
    updatedRecentlySearch.clear();

    final updatedUser = originUser.copyWith(
      recentlySearch: updatedRecentlySearch,
    );

    // UI 즉각 반영 (Optimistic Update)
    state = AsyncData(updatedUser);

    // DB 동기화 (Atomic Update)
    final userRepo = ref.read(userRepositoryProvider);
    final Result<void, Failure> result;

    result = await userRepo.clearRecentlySearch(originUser.uid);

    // DB 업데이트 실패 시 이전 상태로 롤백
    if (result is Error<void, Failure>) {
      state = AsyncData(originUser);
    }
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
