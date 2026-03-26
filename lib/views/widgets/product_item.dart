import 'package:auto_size_text/auto_size_text.dart';
import 'package:baton/core/theme/app_color_extension.dart';
import 'package:baton/models/entities/post.dart' show Post;
import 'package:baton/core/utils/format_currency.dart';
import 'package:baton/models/enum/post_action_type.dart';
import 'package:baton/models/enum/product_status.dart';
import 'package:baton/models/mapper/format_time_mapper.dart';
import 'package:baton/notifier/like/like_notifier.dart';
import 'package:baton/notifier/post/product_item_notifier.dart';
import 'package:baton/core/result/result.dart';
import 'package:baton/views/_tap/home/viewmodel/home_tap_viewmodel.dart';
import 'package:baton/views/widgets/cupertino_modal_pop_up.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:baton/core/utils/ui/app_snackbar.dart';

class ProductItem extends ConsumerWidget {
  const ProductItem({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _ItemImage(post: post),
        const SizedBox(height: 9),
        _ItemInfo(post: post, date: formatTime(post.createdAt)),
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
              post.imageUrls.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: post.imageUrls.first,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(color: Colors.white),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.error_outline,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : SvgPicture.asset(
                      'assets/images/empty_image_160.svg',
                      fit: BoxFit.cover,
                    ),
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
                          color: colors.surface.withValues(alpha: 0.9),
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

class _ItemInfo extends ConsumerWidget {
  const _ItemInfo({required this.post, required this.date});

  final Post post;
  final String date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  post.title,
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
                onTap: () {
                  final actions = ref
                      .read(productItemProvider.notifier)
                      .getAvailableActions(post.authorId);

                  if (actions.isEmpty) return;

                  showCupertinoModalPopup(
                    context: context,
                    builder: (context) => CupertinoModalPopUp(
                      actions: actions.map((action) {
                        return {
                          action.label: () {
                            context.pop();
                            switch (action) {
                              case PostActionType.edit:
                                context.pushNamed(
                                  'write',
                                  queryParameters: {'postId': post.postId},
                                );
                                break;
                              case PostActionType.report:
                                // TODO: 신고하기 로직 실행
                                break;
                              case PostActionType.delete:
                                showCupertinoDialog(
                                  context: context,
                                  builder: (context) => CupertinoAlertDialog(
                                    title: const Text('게시글 삭제'),
                                    content: const Text('게시글을 삭제하시겠습니까?'),
                                    actions: [
                                      CupertinoDialogAction(
                                        onPressed: () => context.pop(),
                                        child: const Text('취소'),
                                      ),
                                      CupertinoDialogAction(
                                        onPressed: () async {
                                          final result = await ref
                                              .read(
                                                productItemProvider.notifier,
                                              )
                                              .deletePost(post.postId);

                                          if (context.mounted) {
                                            context.pop();

                                            switch (result) {
                                              case Success():
                                                AppSnackBar.show(
                                                  context,
                                                  '게시글이 삭제되었습니다.',
                                                );
                                                ref
                                                    .read(
                                                      homeTapViewModelProvider
                                                          .notifier,
                                                    )
                                                    .refresh();
                                                break;
                                              case Error(failure: final f):
                                                AppSnackBar.show(
                                                  context,
                                                  '삭제 실패: ${f.message}',
                                                );
                                                break;
                                            }
                                          }
                                        },
                                        child: const Text(
                                          '삭제',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                                break;
                            }
                          },
                        };
                      }).toList(),
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
                (post.salePrice == 0 || post.salePrice == null)
                    ? '나눔'
                    : '${formatCurrency(post.salePrice!)}원',
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
