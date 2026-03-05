import 'package:baton/views/widgets/input_field.dart';
import 'package:baton/views/widgets/sub_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baton/views/write/viewmodel/content_notifier.dart';

class ContentSection extends ConsumerWidget {
  const ContentSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(contentProvider);
    return Column(
      spacing: 4,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SubTitle(title: "내용", required: true),
            Text(
              state.contentLength == 0
                  ? "(0/1000)"
                  : "(${state.contentLength}/1000)",
              style: TextStyle(color: Color(0xFFB3B3B3), fontSize: 14),
            ),
          ],
        ),
        InputField(
          hintText: "상품에 대한 설명을 자세히 적어주세요\n(판매 금지 물품은 게시가 제한될 수 있어요.)",
          onChanged: (value) {
            ref.read(contentProvider.notifier).setContent(value);
          },
          maxLength: 1000,
          maxLines: 4,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFB5C1D0), width: 1),
          ),
        ),
      ],
    );
  }
}
