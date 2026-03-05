import 'package:baton/views/widgets/sub_title.dart';
import 'package:flutter/material.dart';

class ImageSelectSection extends StatelessWidget {
  const ImageSelectSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SubTitle(title: "사진 등록", required: false),
        Container(
          padding: const EdgeInsets.all(10),
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(color: colors.outline, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.add, color: colors.primary),
        ),
      ],
    );
  }
}
