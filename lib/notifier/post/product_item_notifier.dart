import 'package:baton/notifier/user/user_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_item_notifier.g.dart';

enum PostActionType {
  edit('게시글 수정'),
  report('신고하기');

  final String label;
  const PostActionType(this.label);
}

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
      return [PostActionType.edit];
    } else {
      return [PostActionType.report];
    }
  }
}
