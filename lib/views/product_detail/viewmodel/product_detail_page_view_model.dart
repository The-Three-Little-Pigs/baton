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
    final repo = ref.read(postRepositoryProvider);
    
    // 🔥 상세 페이지 진입 시 조회수 1 증가 (Fire and forget 또는 간단히 대기)
    // 에러가 나더라도 무시하거나 로그만 남김 (사용자 경험에 치명적이지 않음)
    await repo.incrementViewCount(postId);

    final result = await repo.getPostById(postId);

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
