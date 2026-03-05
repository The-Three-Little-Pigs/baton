import 'package:baton/views/widgets/complete_button.dart';
import 'package:flutter/material.dart';

class BottomCompleteBar extends StatelessWidget {
  const BottomCompleteBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CompleteButton(label: "작성 완료", onPressed: () {}),
        ),
      ],
    );
  }
}
