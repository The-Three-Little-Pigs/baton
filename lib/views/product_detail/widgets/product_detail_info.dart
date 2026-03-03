import 'package:baton/core/theme/app_tokens/app_spacing.dart';
import 'package:flutter/material.dart';

class ProductDetailInfo extends StatelessWidget {
  const ProductDetailInfo({super.key, required this.postId});

  final String postId;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "post.title",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          Text(
            "구매가 : post.purchasePrice",
            style: TextStyle(
              fontSize: 12,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          Text(
            "post.salePrice",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          Row(
            spacing: 8,
            children: [
              Text("post.category"),
              Text("·"),
              Text("post.createdAt"),
            ],
          ),
          AppSpacing.h8,
          Text("post.content"),
          AppSpacing.h8,
          Row(
            spacing: 4,
            children: [
              Icon(Icons.favorite, size: 16),
              Text("post.likeCount"),
              AppSpacing.w8,
              Icon(Icons.chat_bubble, size: 16),
              Text("post.chatCount"),
            ],
          ),
        ],
      ),
    );
  }
}
