import 'package:baton/models/entities/post.dart';
import 'package:baton/views/_tap/home/widgets/no_product.dart';
import 'package:baton/views/widgets/product_item.dart';
import 'package:flutter/material.dart';

/// 상품 목록을 보여주는 공용 그리드뷰 위젯
class ProductGridView extends StatelessWidget {
  final List<Post> posts;
  final Future<void> Function() onRefresh;
  final VoidCallback? onReachBottom;
  final ScrollController? controller;
  final Widget? emptyWidget;
  final EdgeInsetsGeometry? padding;

  const ProductGridView({
    super.key,
    required this.posts,
    required this.onRefresh,
    this.onReachBottom,
    this.controller,
    this.emptyWidget,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    // 상품이 없는 경우 (새로고침이 가능하도록 SingleChildScrollView로 감싸기)
    if (posts.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            // 적당한 높이를 확보해야 끌어서 새로고침이 잘 작동함
            height: MediaQuery.of(context).size.height * 0.7,
            child: emptyWidget ?? const Center(child: NoProduct()),
          ),
        ),
      );
    }

    // 그리드뷰 본문
    Widget gridView = GridView.builder(
      controller: controller,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 0.7,
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
      ),
      itemBuilder: (context, index) {
        return ProductItem(post: posts[index]);
      },
      itemCount: posts.length,
    );

    // 무한 스크롤(Pagination) 처리
    if (onReachBottom != null) {
      gridView = NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.pixels >=
              notification.metrics.maxScrollExtent * 0.8) {
            onReachBottom!();
          }
          return false;
        },
        child: gridView,
      );
    }

    // 새로고침 처리
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: gridView,
    );
  }
}
