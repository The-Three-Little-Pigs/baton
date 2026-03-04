import 'package:baton/views/widgets/input_field.dart';
import 'package:baton/views/widgets/sub_title.dart';
import 'package:flutter/material.dart';

class TitleSection extends StatelessWidget {
  const TitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4,
      children: [
        const SubTitle(title: "제목", required: true),
        const InputField(hintText: "제목을 입력해주세요."),
      ],
    );
  }
}
