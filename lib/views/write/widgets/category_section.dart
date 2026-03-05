import 'package:baton/views/widgets/sub_title.dart';
import 'package:flutter/material.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4,
      children: [
        const SubTitle(title: "카테고리", required: true),
        CategorySelectButton(),
      ],
    );
  }
}

class CategorySelectButton extends StatelessWidget {
  const CategorySelectButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        alignment: Alignment.centerRight,
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: const Color(0xFFCDD8E7), width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.chevron_right, size: 24),
      ),
    );
  }
}
