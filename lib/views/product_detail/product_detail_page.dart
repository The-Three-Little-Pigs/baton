import 'package:baton/views/product_detail/widgets/bottom_chat_bar.dart';
import 'package:baton/views/product_detail/widgets/other_product.dart';
import 'package:baton/views/product_detail/widgets/product_detail_info.dart';
import 'package:baton/views/product_detail/widgets/profile_header.dart';
import 'package:flutter/material.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key, required this.postId});

  final String postId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [Icon(Icons.more_vert)]),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: ProfileHeader(authorId: '1'),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(20),
                child: ProductDetailInfo(postId: '1'),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 40,
                  top: 10,
                ),
                child: OtherProduct(postId: '1'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: BottomChatBar(),
      ),
    );
  }
}
