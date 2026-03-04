import 'package:baton/views/widgets/product_item.dart';
import 'package:flutter/material.dart';

class OtherProduct extends StatelessWidget {
  const OtherProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        Text(
          "비슷한 상품들",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return ProductItem(postId: "1");
          },
        ),
      ],
    );
  }
}
