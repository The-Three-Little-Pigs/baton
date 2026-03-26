import 'package:baton/views/widgets/input_field.dart';
import 'package:baton/views/widgets/sub_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baton/views/write/viewmodel/content_notifier.dart';

class TitleSection extends ConsumerStatefulWidget {
  const TitleSection({super.key});

  @override
  ConsumerState<TitleSection> createState() => _TitleSectionState();
}

class _TitleSectionState extends ConsumerState<TitleSection> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: ref.read(contentProvider).title);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 텍스트 필드 포커스가 없을 때(초기화 시 등) 상태값이 변경되면 컨트롤러 텍스트 동기화
    ref.listen(contentProvider.select((s) => s.title), (previous, next) {
      if (_controller.text != next) {
        _controller.text = next;
      }
    });

    return Column(
      spacing: 4,
      children: [
        const SubTitle(title: "제목", required: true),
        InputField(
          controller: _controller,
          maxLines: 1,
          hintText: "제목을 입력해주세요.",
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp(r'^\s+')), // 맨 앞 공백 차단
          ],
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
