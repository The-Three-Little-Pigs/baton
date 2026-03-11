import 'package:auto_size_text/auto_size_text.dart';
import 'package:baton/core/theme/app_color_extension.dart';
import 'package:baton/models/entities/post.dart' show Post;
import 'package:baton/core/utils/format_currency.dart';
import 'package:baton/models/enum/product_status.dart';
import 'package:baton/models/mapper/format_time_mapper.dart';
import 'package:baton/notifier/like/like_notifier.dart';
import 'package:baton/views/widgets/cupertino_modal_pop_up.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProductItem extends ConsumerWidget {
  const ProductItem({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _ItemImage(post: post),
        const SizedBox(height: 9),
        _ItemInfo(
          title: post.title,
          date: formatTime(post.createdAt),
          price: post.salePrice,
        ),
      ],
    );
  }
}

class _ItemImage extends ConsumerWidget {
  const _ItemImage({required this.post});

  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final appColors = theme.extension<AppColorExtension>();
    final likedPosts = ref.watch(likeProvider).value ?? [];
    final isLiked = likedPosts.any((p) => p.postId == post.postId);

    return GestureDetector(
      onTap: () {
        context.pushNamed(
          'productDetail',
          pathParameters: {'postId': post.postId},
        );
      },
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              post.imageUrls.firstOrNull != null
                  ? Image.network(post.imageUrls.first, fit: BoxFit.cover)
                  : Center(child: Icon(Icons.image)),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    ref.read(likeProvider.notifier).toggleLike(post);
                  },
                  child: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: colors.primary,
                  ),
                ),
              ),
              Center(
                child: post.status == ProductStatus.available
                    ? const SizedBox.shrink()
                    : Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: colors.surface.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          post.status.label,
                          style: TextStyle(
                            color: appColors?.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemInfo extends StatelessWidget {
  const _ItemInfo({
    required this.title,
    required this.date,
    required this.price,
  });

  final String title;
  final String date;
  final int? price;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final appColors = theme.extension<AppColorExtension>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AutoSizeText(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  maxFontSize: 14,
                  minFontSize: 14,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (context) => CupertinoModalPopUp(
                      actions: [
                        {
                          '신고하기': () {
                            context.pop();
                          },
                        },
                      ],
                    ),
                  );
                },
                child: const Icon(Icons.more_vert, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price == null ? '나눔' : '${formatCurrency(price!)}원',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colors.onSurface,
                ),
              ),
              Text(
                date,
                style: TextStyle(fontSize: 12, color: appColors?.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
