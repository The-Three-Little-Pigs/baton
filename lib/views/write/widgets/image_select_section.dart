import 'package:baton/views/widgets/sub_title.dart';
import 'package:flutter/material.dart';

class ImageSelectSection extends StatelessWidget {
  const ImageSelectSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SubTitle(title: "사진 등록", required: false),
        Container(
          padding: EdgeInsets.all(10),
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFCDD8E7), width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
        ),
      ],
    );
  }
}
