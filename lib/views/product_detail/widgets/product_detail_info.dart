import 'package:baton/core/theme/app_tokens/app_spacing.dart';
import 'package:flutter/material.dart';

class ProductDetailInfo extends StatelessWidget {
  const ProductDetailInfo({
    super.key,
    required this.title,
    required this.purchasePrice,
    required this.salePrice,
    required this.category,
    required this.createdAt,
    required this.content,
    required this.likeCount,
    required this.chatCount,
  });

  final String title;
  final String purchasePrice;
  final String salePrice;
  final String category;
  final String createdAt;
  final String content;
  final int likeCount;
  final int chatCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          Text(
            "구매가 : $purchasePrice",
            style: TextStyle(
              fontSize: 12,
              decoration: TextDecoration.lineThrough,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            salePrice,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          Row(
            spacing: 8,
            children: [
              Text(
                category,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              Text("·"),
              Text(
                createdAt,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          AppSpacing.h8,
          Text(
            content,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          AppSpacing.h8,
          Row(
            spacing: 4,
            children: [
              Icon(Icons.favorite, size: 16),
              Text("$likeCount", style: TextStyle(fontWeight: FontWeight.w400)),
              AppSpacing.w8,
              Icon(Icons.chat_bubble, size: 16),
              Text("$chatCount", style: TextStyle(fontWeight: FontWeight.w400)),
            ],
          ),
        ],
      ),
    );
  }
}
