import 'package:baton/core/di/repository/post_provider.dart';
import 'package:baton/core/error/failure.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/post.dart';
import 'package:baton/notifier/like/like_notifier.dart';
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

  Future<void> toggleLike() async {
    // 좋아요 추가,삭제
    final post = state.value;
    if (post == null) return;
    final isLiked = ref
        .read(likeProvider)
        .maybeWhen(
          data: (likedPosts) => likedPosts.any((p) => p.postId == post.postId),
          orElse: () => false,
        );
    final newLikeCount = isLiked
        ? (post.likeCount > 0 ? post.likeCount - 1 : 0)
        : post.likeCount + 1;
    state = AsyncData(post.copyWith(likeCount: newLikeCount));
    try {
      await ref.read(likeProvider.notifier).toggleLike(post);
    } catch (e) {
      state = AsyncData(post);
    }
  }

  void toggleChat() {
    // 채팅 추가,삭제
  }
}
