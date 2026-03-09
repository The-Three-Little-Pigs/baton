import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baton/models/entities/user.dart';
import 'package:baton/models/repositories/repository_impl/user_repository_impl.dart';
import 'package:baton/core/result/result.dart';
import 'package:flutter_riverpod/legacy.dart';

final userRepositoryProvider = Provider((ref) => UserRepositoryImpl());

final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return UserNotifier(repo);
});

// 유저 노티파이어 (데이터 저장소)
class UserNotifier extends StateNotifier<User?> {
  final UserRepositoryImpl _repository;

  UserNotifier(this._repository) : super(null);

  Future<void> fetchAndSaveUser(String uid) async {
    final result = await _repository.fetchUserData(uid);

    if (result is Success<User?, dynamic>) {
      state = (result as Success).value;
    } else {
      print("유저 정보 로드 실패");
    }
  }
}
