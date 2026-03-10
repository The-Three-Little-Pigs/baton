import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/user.dart' as entity;
import 'package:baton/models/repositories/repository_impl/user_repository_impl.dart';
import 'package:baton/models/repositories/repository_impl/auth_repository_impl.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_notifier.g.dart';

@Riverpod(keepAlive: true)
class UserNotifier extends _$UserNotifier {
  @override
  FutureOr<entity.User?> build() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return null;

    final userRepo = ref.read(userRepositoryProvider);
    final result = await userRepo.fetchUserData(firebaseUser.uid);

    // 💡 여기서 switch 문법을 올바르게 수정했습니다. (화살표 방식)
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
    final authRepo = ref.read(authRepositoryProvider);

    // 1단계: 데이터 삭제
    final dataResult = await userRepo.deleteUserData(currentUser.uid);

    // 💡 여기는 일반 switch 문으로 안전하게 작성합니다.
    switch (dataResult) {
      case Success():
        break;
      case Error(:final failure):
        onError(failure.message);
        return;
    }

    // 2단계: 계정 삭제
    final authResult = await authRepo.deleteAccount();

    switch (authResult) {
      case Success():
        state = const AsyncData(null);
        onSuccess();
        break;
      case Error(:final failure):
        onError(failure.message);
        break;
    }
  }
}
