import 'package:baton/core/result/result.dart';
import 'package:baton/core/theme/app_color_extension.dart';
import 'package:baton/core/utils/format_currency.dart';
import 'package:baton/models/entities/post.dart';
import 'package:baton/models/enum/post_action_type.dart';
import 'package:baton/models/enum/product_status.dart';
import 'package:baton/models/mapper/format_time_mapper.dart';
import 'package:baton/notifier/post/product_item_notifier.dart';
import 'package:baton/notifier/user/user_notifier.dart';
import 'package:baton/views/product_detail/viewmodel/product_chat_count_provider.dart';
import 'package:baton/views/product_detail/viewmodel/product_detail_page_view_model.dart';
import 'package:baton/views/product_detail/widgets/bottom_chat_bar.dart';
import 'package:baton/views/product_detail/widgets/image_section.dart';
import 'package:baton/views/product_detail/widgets/other_product.dart';
import 'package:baton/views/product_detail/widgets/product_detail_info.dart';
import 'package:baton/views/product_detail/widgets/profile_header.dart';
import 'package:baton/views/widgets/cupertino_modal_pop_up.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:baton/core/utils/ui/app_snackbar.dart';

class ProductDetailPage extends ConsumerWidget {
  const ProductDetailPage({super.key, required this.postId});

  final String postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final appColors = theme.extension<AppColorExtension>();

    final postAsync = ref.watch(productDetailPageViewModelProvider(postId));
    final chatCountAsync = ref.watch(productChatCountProvider(postId));

    return Scaffold(
      body: postAsync.when(
        data: (post) => CustomScrollView(
          slivers: [
            post.imageUrls.isEmpty
                ? SliverAppBar(actions: [MoreVerButton(post: post)])
                : SliverAppBar(
                    expandedHeight: 300,
                    pinned: true,
                    elevation: 0,
                    backgroundColor: colors.surface,
                    surfaceTintColor: Colors.transparent,
                    flexibleSpace: FlexibleSpaceBar(
                      background: ImageSection(imageUrls: post.imageUrls),
                    ),
                    actions: [MoreVerButton(post: post)],
                    // actions: [MoreVerButton(authorId: post.authorId)],
                  ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: ProfileHeader(authorId: post.authorId),
                  ),
                  Divider(color: appColors?.divider),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: ProductDetailInfo(
                      productStatus: post.status,
                      title: post.title,
                      purchasePrice: post.purchasePrice == null
                          ? "0원"
                          : "${formatCurrency(post.purchasePrice!)}원",
                      salePrice: (post.salePrice == 0 || post.salePrice == null)
                          ? "나눔"
                          : "${formatCurrency(post.salePrice!)}원",
                      category: post.category.label,
                      createdAt: formatTime(post.createdAt),
                      content: post.content,
                      likeCount: post.likeCount,
                      chatCount: chatCountAsync.value ?? post.chatCount,
                      viewCount: post.viewCount,
                    ),
                  ),
                  Divider(color: appColors?.divider),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 20,
                      top: 10,
                    ),
                    child: OtherProduct(
                      category: post.category,
                      currentPostId: postId,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        error: (Object error, StackTrace stackTrace) =>
            Center(child: Text(error.toString())),
        loading: () => Center(child: CircularProgressIndicator()),
      ),
      bottomNavigationBar: postAsync.when(
        // 1. 성공 시: 데이터(post)가 완벽히 보장되므로 강제 추출(!) 없이 안전하게 호출
        data: (post) {
          final isMyPost = post.authorId == ref.read(userProvider).value?.uid;
          final isAvailable = post.status == ProductStatus.available;

          if (isMyPost || !isAvailable) {
            return const SizedBox.shrink();
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: BottomChatBar(post: post, productId: postId),
            ),
          );
        },
        // 2. 로딩 중이거나 에러 날 때는 바텀 바를 그리지 않음 (SizedBox.shrink)
        loading: () => const SizedBox.shrink(),
        error: (error, stackTrace) => const SizedBox.shrink(),
      ),
    );
  }
}

class MoreVerButton extends ConsumerWidget {
  const MoreVerButton({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // const MoreVerButton({super.key, required this.authorId});
    // final String authorId;

    // @override
    // Widget build(BuildContext context, WidgetRef ref) {
    //   final myUid = ref.watch(userProvider).value?.uid;
    //   final isMyPost = myUid == authorId;
    return IconButton(
      icon: const Icon(Icons.more_vert),
      onPressed: () {
        final actions = ref
            .read(productItemProvider.notifier)
            .getAvailableActions(authorId: post.authorId, status: post.status);

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
                      // 신고/차단 팝업 띄우기
                      showCupertinoDialog(
                        context: context,
                        builder: (dialogContext) => CupertinoAlertDialog(
                          title: const Text("신고/차단하기"),
                          content: const Text(
                            '상대방을 신고/차단하시겠습니까?\n차단 시 점수가 감점되며 더 이상 게시글이 보이지 않습니다.',
                          ),
                          actions: [
                            CupertinoDialogAction(
                              child: const Text("취소"),
                              onPressed: () => Navigator.pop(dialogContext),
                            ),
                            CupertinoDialogAction(
                              isDestructiveAction: true,
                              child: const Text("신고/차단"),
                              onPressed: () async {
                                Navigator.pop(dialogContext);
                                await ref
                                    .read(userProvider.notifier)
                                    .toggleBlockUser(post.authorId);
                                if (context.mounted) {
                                  AppSnackBar.show(
                                    context,
                                    '신고 및 차단이 완료되었습니다.',
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      );
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
                                      productDetailPageViewModelProvider(
                                        post.postId,
                                      ).notifier,
                                    )
                                    .deletePost();

                                if (context.mounted) {
                                  context.pop();

                                  switch (result) {
                                    case Success():
                                      AppSnackBar.show(
                                        context,
                                        '게시글이 삭제되었습니다.',
                                      );
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
            // actions: [
            //   if (!isMyPost)
            //     {
            //       '신고/차단하기': () {
            //         context.pop();
            //         ref.read(userProvider.notifier).toggleBlockUser(authorId);
            //       },
            //     },
            // ],
          ),
        );
      },
    );
  }
}
