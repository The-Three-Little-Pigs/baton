import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/user.dart' as entity;
import 'package:baton/models/repositories/repository_impl/user_repository_impl.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_notifier.g.dart';

// ... 상단 import 생략

@Riverpod(keepAlive: true)
class UserNotifier extends _$UserNotifier {
  @override
  FutureOr<entity.User?> build() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return null;

    final userRepo = ref.read(userRepositoryProvider);
    final result = await userRepo.fetchUserData(firebaseUser.uid);

    return switch (result) {
      Success(:final value) => value,
      Error() => null,
    };
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

    // 통합 탈퇴 로직 호출 (Firestore 데이터 삭제 + Auth 계정 삭제 + 로그아웃)
    final result = await userRepo.withdrawAccount();

    switch (result) {
      case Success():
        state = const AsyncData(null);
        ref.invalidateSelf();
        onSuccess();
        break;
      case Error(:final failure):
        onError(failure.message);
        break;
    }
  }

  /// 즐겨찾기 토글 (추가/제거)
  Future<void> toggleFavorite(String productId) async {
    final currentUser = state.value;
    if (currentUser == null) return;

    final updatedFavorites = List<String>.from(currentUser.favorites);
    if (updatedFavorites.contains(productId)) {
      updatedFavorites.remove(productId);
    } else {
      updatedFavorites.add(productId);
    }

    final updatedUser = currentUser.copyWith(favorites: updatedFavorites);
    state = AsyncData(updatedUser);

    // DB 동기화
    final userRepo = ref.read(userRepositoryProvider);
    await userRepo.updateUserData(updatedUser);
  }

  /// 유저 차단 토글 (추가/제거)
  Future<void> toggleBlockUser(String otherUid) async {
    final currentUser = state.value;
    if (currentUser == null) return;

    final updatedBlocked = List<String>.from(currentUser.blockedUsers);
    if (updatedBlocked.contains(otherUid)) {
      updatedBlocked.remove(otherUid);
    } else {
      updatedBlocked.add(otherUid);
    }

    final updatedUser = currentUser.copyWith(blockedUsers: updatedBlocked);
    state = AsyncData(updatedUser);

    // DB 동기화
    final userRepo = ref.read(userRepositoryProvider);
    await userRepo.updateUserData(updatedUser);
  }

  /// 외부(회원가입 완료 등)에서 유저 정보를 수동으로 주입할 때 사용합니다.
  void updateState(entity.User? user) {
    state = AsyncData(user);
  }
}
