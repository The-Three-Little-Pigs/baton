import 'package:baton/models/entities/post.dart';
import 'package:baton/models/enum/product_status.dart';

class SearchResultState {
  final List<Post> posts;
  final int currentPage;
  final bool isLastPage;
  final bool isFetchingMore;
  final bool isUnderPurchasePrice;
  final bool isAvailableOnly;

  SearchResultState({
    required this.posts,
    this.currentPage = 0,
    this.isLastPage = false,
    this.isFetchingMore = false,
    this.isUnderPurchasePrice = false,
    this.isAvailableOnly = false,
  });

  /// 필터링된 게시글 리스트를 반환하는 게터
  List<Post> get filteredPosts {
    return posts.where((post) {
      // 1. '정가 이하' 필터링 (판매가 < 구매가)
      if (isUnderPurchasePrice) {
        if (post.purchasePrice == null || post.salePrice == null) return false;
        if (post.salePrice! >= post.purchasePrice!) return false;
      }

      // 2. '판매중인 상품' 필터링
      if (isAvailableOnly) {
        if (post.status != ProductStatus.available) return false;
      }

      return true;
    }).toList();
  }

  SearchResultState copyWith({
    List<Post>? posts,
    int? currentPage,
    bool? isLastPage,
    bool? isFetchingMore,
    bool? isUnderPurchasePrice,
    bool? isAvailableOnly,
  }) {
    return SearchResultState(
      posts: posts ?? this.posts,
      currentPage: currentPage ?? this.currentPage,
      isLastPage: isLastPage ?? this.isLastPage,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      isUnderPurchasePrice: isUnderPurchasePrice ?? this.isUnderPurchasePrice,
      isAvailableOnly: isAvailableOnly ?? this.isAvailableOnly,
    );
  }
}
