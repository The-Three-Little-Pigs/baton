import 'package:baton/views/widgets/labeled_input_field.dart';
import 'package:baton/views/widgets/sub_title.dart';
import 'package:flutter/material.dart';

class PriceSection extends StatelessWidget {
  const PriceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4,
      children: [
        const SubTitle(title: "가격", required: true),
        const LabeledInputField(label: "구매가", hintText: "가격을 입력해주세요."),
        const LabeledInputField(label: "판매가", hintText: "가격을 입력해주세요."),
      ],
    );
  }
}
