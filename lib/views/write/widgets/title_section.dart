import 'package:baton/views/widgets/input_field.dart';
import 'package:baton/views/widgets/sub_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baton/views/write/viewmodel/content_notifier.dart';

class TitleSection extends ConsumerWidget {
  const TitleSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      spacing: 4,
      children: [
        const SubTitle(title: "제목", required: true),
        InputField(
          maxLines: 1,
          hintText: "제목을 입력해주세요.",
          onChanged: (value) {
            ref.read(contentProvider.notifier).setTitle(value);
          },
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFB5C1D0), width: 1),
          ),
        ),
      ],
    );
  }
}
