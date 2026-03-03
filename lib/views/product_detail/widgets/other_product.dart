import 'package:baton/views/widgets/product_item.dart';
import 'package:flutter/material.dart';

class OtherProduct extends StatelessWidget {
  const OtherProduct({super.key, required this.postId});

  final String postId;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 900,
      width: double.infinity,
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "비슷한 상품들",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                return ProductItem(postId: postId);
              },
            ),
          ),
        ],
      ),
    );
  }
}
