import 'package:baton/core/theme/app_color_extension.dart';
import 'package:baton/core/utils/format_currency.dart';

import 'package:baton/models/mapper/format_time_mapper.dart';
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

class ProductDetailPage extends ConsumerWidget {
  const ProductDetailPage({super.key, required this.postId});

  final String postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final appColors = theme.extension<AppColorExtension>();

    final postAsync = ref.watch(productDetailPageViewModelProvider(postId));

    return Scaffold(
      body: postAsync.when(
        data: (post) => CustomScrollView(
          slivers: [
            post.imageUrls.isEmpty
                ? SliverAppBar(actions: [MoreVerButton()])
                : SliverAppBar(
                    expandedHeight: 300,
                    pinned: true,
                    elevation: 0,
                    backgroundColor: colors.surface,
                    surfaceTintColor: Colors.transparent,
                    flexibleSpace: FlexibleSpaceBar(
                      background: ImageSection(imageUrls: post.imageUrls),
                    ),
                    actions: [MoreVerButton()],
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
                      title: post.title,
                      purchasePrice: post.purchasePrice == null
                          ? "0원"
                          : "${formatCurrency(post.purchasePrice!)}원",
                      salePrice: post.salePrice == null
                          ? "나눔"
                          : "${formatCurrency(post.salePrice!)}원",
                      category: post.category.label,
                      createdAt: formatTime(post.createdAt),
                      content: post.content,
                      likeCount: post.likeCount,
                      chatCount: post.chatCount,
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
        data: (post) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: BottomChatBar(
              productId: postId,
              authorId: post.authorId, // ⭐️ post 객체에서 바로 꺼냄 (null 걱정 제로!)
            ),
          ),
        ),
        // 2. 로딩 중이거나 에러 날 때는 바텀 바를 그리지 않음 (SizedBox.shrink)
        loading: () => const SizedBox.shrink(),
        error: (error, stackTrace) => const SizedBox.shrink(),
      ),
    );
  }
}

class MoreVerButton extends StatelessWidget {
  const MoreVerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.more_vert),
      onPressed: () {
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
    );
  }
}
