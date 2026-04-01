import 'package:baton/core/di/repository/user_provider.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'author_notifier.g.dart';

@riverpod
class AuthorNotifier extends _$AuthorNotifier {
  @override
  Future<User> build(String authorId) async {
    final result = await ref
        .read(userRepositoryProvider)
        .fetchUserData(authorId);

    return switch (result) {
      Success(value: final user) => user ?? _emptyUser(authorId),
      Error() => _emptyUser(authorId),
    };
  }

  User _emptyUser(String id) => User(
    uid: id,
    nickname: "알 수 없는 사용자",
    profileUrl: null,
    score: 5.0,
    favorites: {},

    deletedAt: null,
  );
}
