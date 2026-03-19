import 'package:baton/core/di/repository/post_provider.dart';
import 'package:baton/core/error/failure.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/enum/post_action_type.dart';
import 'package:baton/notifier/user/user_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_item_notifier.g.dart';

@riverpod
class ProductItemNotifier extends _$ProductItemNotifier {
  @override
  void build() {}

  /// 현재 사용자와 게시글 작성자를 비교하여 가능한 액션 리스트를 반환합니다.
  List<PostActionType> getAvailableActions(String authorId) {
    final currentUser = ref.read(userProvider).value;

    if (currentUser == null) return [];

    final isMyPost = currentUser.uid == authorId;

    if (isMyPost) {
      return [PostActionType.edit, PostActionType.delete];
    } else {
      return [PostActionType.report];
    }
  }

  Future<Result<void, Failure>> deletePost(String postId) async {
    return await ref.read(postRepositoryProvider).deletePost(postId);
  }
}
