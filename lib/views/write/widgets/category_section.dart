import 'package:baton/views/widgets/input_field.dart';
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
        const InputField(hintText: "카테고리를 입력해주세요."),
      ],
    );
  }
}
