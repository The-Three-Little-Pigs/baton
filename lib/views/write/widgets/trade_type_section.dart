import 'package:baton/views/widgets/chip_button.dart';
import 'package:baton/views/widgets/sub_title.dart';
import 'package:flutter/material.dart';

class TradeTypeSection extends StatelessWidget {
  const TradeTypeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4,
      children: [
        const SubTitle(title: "유형", required: true),
        Row(
          spacing: 8,
          children: [
            ChipButton(label: "판매하기"),
            ChipButton(label: "나눔하기"),
          ],
        ),
      ],
    );
  }
}
