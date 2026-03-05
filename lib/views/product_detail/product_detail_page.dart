import 'package:baton/core/theme/app_color_extension.dart';
import 'package:baton/views/product_detail/widgets/bottom_chat_bar.dart';
import 'package:baton/views/product_detail/widgets/image_section.dart';
import 'package:baton/views/product_detail/widgets/other_product.dart';
import 'package:baton/views/product_detail/widgets/product_detail_info.dart';
import 'package:baton/views/product_detail/widgets/profile_header.dart';
import 'package:flutter/material.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key, required this.postId});

  final String postId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final appColors = theme.extension<AppColorExtension>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            elevation: 0,
            backgroundColor: colors.surface,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: const FlexibleSpaceBar(
              background: ImageSection(
                imageUrls: [
                  "https://picsum.photos/160/160",
                  "https://picsum.photos/160/160",
                  "https://picsum.photos/160/160",
                  "https://picsum.photos/160/160",
                  "https://picsum.photos/160/160",
                ],
              ),
            ),
            actions: [
              IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: ProfileHeader(authorId: '1'),
                ),
                Divider(color: appColors?.divider),
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: ProductDetailInfo(
                    title: 'title',
                    purchasePrice: 'purchasePrice',
                    salePrice: 'salePrice',
                    category: 'category',
                    createdAt: 'createdAt',
                    content: 'content',
                    likeCount: 'likeCount',
                    chatCount: 'chatCount',
                  ),
                ),
                Divider(color: appColors?.divider),
                const Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 20,
                    top: 10,
                  ),
                  child: OtherProduct(),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: BottomChatBar(),
        ),
      ),
    );
  }
}
