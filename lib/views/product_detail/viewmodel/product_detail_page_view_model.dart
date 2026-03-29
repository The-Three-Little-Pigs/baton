import 'package:baton/core/di/repository/post_provider.dart';
import 'package:baton/core/error/failure.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/models/entities/post.dart';
import 'package:baton/notifier/like/like_notifier.dart';
import 'package:baton/models/enum/product_status.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_detail_page_view_model.g.dart';

@riverpod
class ProductDetailPageViewModel extends _$ProductDetailPageViewModel {
  @override
  Stream<Post> build(String postId) {
    final repo = ref.read(postRepositoryProvider);
    // 1. 상세 페이지 진입 시 조회수 1 증가 (이 메서드는 처음 watch될 때 한 번만 실행됩니다)
    repo.incrementViewCount(postId);
    // 2. 실시간 스트림 구독 및 Result 패턴 매핑
    return repo.watchPost(postId).map((result) {
      return switch (result) {
        // 성공 시 순수 Post 객체 반환 (AsyncValue.data가 됨)
        Success(value: final post) => post,
        // 실패 시 에러 throw (AsyncValue.error가 됨)
        Error(failure: final failure) => throw failure.message,
      };
    });
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

  /// ✅ [추가] 약속 상태 변경 등에 따라 UI 상태를 로컬에서 즉시 반영합니다.
  void updateStatusLocally(ProductStatus newStatus) {
    state.whenData((post) {
      if (post.status != newStatus) {
        state = AsyncData(post.copyWith(status: newStatus));
      }
    });
  }
}
