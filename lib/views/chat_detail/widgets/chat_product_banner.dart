import 'package:baton/core/theme/app_tokens/app_colors.dart';
import 'package:baton/views/product_detail/viewmodel/product_detail_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ChatProductBanner extends ConsumerWidget {
  const ChatProductBanner({super.key, required this.roomId});

  final String roomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parts = roomId.split('_');
    final productId = parts.length >= 3 ? parts[2] : '';
    final postAsync = ref.watch(productDetailPageViewModelProvider(productId));

    return postAsync.when(
      data: (post) {
        final formatter = NumberFormat('#,###');
        final fommattedPrice = "${formatter.format(post.salePrice ?? 0)}원";
        return Container(
          decoration: BoxDecoration(),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 14,
              bottom: 9,
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 50,
                    height: 50,
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    child: post.imageUrls.isNotEmpty
                        ? Image.network(
                            post.imageUrls[0],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    size: 14,
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                          )
                        : Center(
                            child: Icon(
                              Icons.image,
                              size: 14,
                              color: AppColors.textTertiary,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.title,
                        style: TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        fommattedPrice,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 32),
                Container(
                  height: 25,
                  width: 55,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      child: Text(
                        post.status.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      error: (error, stack) => SizedBox.shrink(),
      loading: () => SizedBox(
        height: 50,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
    );
  }
}
