import 'package:baton/core/theme/app_tokens/app_colors.dart';
import 'package:baton/core/theme/app_tokens/app_spacing.dart';
import 'package:baton/models/enum/product_status.dart';
import 'package:flutter/material.dart';

class ProductDetailInfo extends StatelessWidget {
  const ProductDetailInfo({
    super.key,
    required this.productStatus,
    required this.title,
    required this.purchasePrice,
    required this.salePrice,
    required this.category,
    required this.createdAt,
    required this.content,
    required this.likeCount,
    required this.chatCount,
    required this.viewCount,
  });

  final ProductStatus productStatus;
  final String title;
  final String purchasePrice;
  final String salePrice;
  final String category;
  final String createdAt;
  final String content;
  final int likeCount;
  final int chatCount;
  final int viewCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (productStatus != ProductStatus.available) ...[
                Text(
                  productStatus.label,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: productStatus == ProductStatus.reserved
                        ? Colors.green
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(width: 8),
              ],
              Text(
                title,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
            ],
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
              Icon(Icons.favorite, size: 16, color: AppColors.secondary),
              Text(
                "$likeCount",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondary,
                ),
              ),
              AppSpacing.w8,
              Icon(Icons.chat_bubble, size: 16, color: AppColors.secondary),
              Text(
                "$chatCount",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondary,
                ),
              ),
              AppSpacing.w8,
              Icon(Icons.visibility, size: 16, color: AppColors.secondary),
              Text(
                "$viewCount",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
