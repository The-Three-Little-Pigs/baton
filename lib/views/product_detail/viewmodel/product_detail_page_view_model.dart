import 'package:baton/core/di/repository/post_provider.dart';
import 'package:baton/core/error/failure.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/post.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_detail_page_view_model.g.dart';

@riverpod
class ProductDetailPageViewModel extends _$ProductDetailPageViewModel {
  @override
  Future<Post> build(String postId) async {
    final result = await ref.read(postRepositoryProvider).getPostById(postId);

    return switch (result) {
      Success(value: final post) => post,
      Error(failure: final failure) => throw failure.message,
    };
  }

  Future<Result<void, Failure>> deletePost() async {
    final result = await ref
        .read(postRepositoryProvider)
        .deletePost(state.value!.postId);

    return switch (result) {
      Success() => result,
      Error(failure: final failure) => Error(failure),
    };
  }

  void toggleLike() {
    // 좋아요 추가,삭제
  }

  void toggleChat() {
    // 채팅 추가,삭제
  }
}
