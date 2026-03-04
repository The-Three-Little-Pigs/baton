import 'package:baton/views/widgets/input_field.dart';
import 'package:baton/views/widgets/sub_title.dart';
import 'package:flutter/material.dart';

class ContentSection extends StatelessWidget {
  const ContentSection({super.key});

  void _onChanged(String value) {}

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SubTitle(title: "내용", required: true),
            Text(
              "(1/1000)",
              style: TextStyle(color: Color(0xFFB3B3B3), fontSize: 14),
            ),
          ],
        ),
        InputField(
          hintText: "상품에 대한 설명을 자세히 적어주세요\n(판매 금지 물품은 게시가 제한될 수 있어요.)",
          onChanged: _onChanged,
          maxLength: 1000,
          maxLines: 4,
        ),
      ],
    );
  }
}
