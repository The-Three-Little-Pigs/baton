import 'package:baton/models/enum/category.dart';
import 'package:baton/views/product_detail/viewmodel/similar_product_notifier.dart';
import 'package:baton/views/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OtherProduct extends ConsumerWidget {
  const OtherProduct({
    super.key,
    required this.category,
    required this.currentPostId,
  });

  final Category category;
  final String currentPostId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final similarProductsState = ref.watch(
      similarProductProvider(category, currentPostId),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        const Text(
          "비슷한 상품들",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        similarProductsState.when(
          data: (posts) {
            if (posts.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text(
                    "유사한 추천 상품이 없습니다.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              );
            }

            return GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
              ),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return ProductItem(post: post);
              },
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stackTrace) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text(
                "상품을 불러오는 중 오류가 발생했습니다.",
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
