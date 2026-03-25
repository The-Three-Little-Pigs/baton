import 'package:baton/models/entities/search_field_state.dart';
import 'package:baton/views/search/viewmodel/search_field_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SearchField extends ConsumerStatefulWidget {
  const SearchField({super.key});

  @override
  ConsumerState<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends ConsumerState<SearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ref.read(searchFieldProvider).query,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 프로바이더 상태 변화 감시 및 컨트롤러 텍스트 업데이트
    ref.listen<SearchFieldState>(searchFieldProvider, (previous, next) {
      if (_controller.text != next.query) {
        _controller.text = next.query;
      }
    });

    return TextField(
      controller: _controller,
      onChanged: (value) {
        ref.read(searchFieldProvider.notifier).updateText(value);
      },
      onSubmitted: (value) async {
        final keyword = value.trim();
        if (keyword.isNotEmpty) {
          final notifier = ref.read(searchFieldProvider.notifier);
          if (notifier.allowSearch(keyword)) {
            notifier.recordSearch(keyword);
            await context.pushNamed(
              'searchResult',
              pathParameters: {'keyword': keyword},
            );
            if (context.mounted) {
              notifier.clear();
            }
          }
        }
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(99),
          borderSide: const BorderSide(color: Color(0xFFCDD8E7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(99),
          borderSide: const BorderSide(color: Colors.black),
        ),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_controller.text.isNotEmpty)
              IconButton(
                icon: const Icon(
                  Icons.cancel,
                  color: Color(0xFFB3B3B3),
                  size: 18,
                ),
                onPressed: () {
                  _controller.clear();
                  ref.read(searchFieldProvider.notifier).clear();
                },
              ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () async {
                if (_controller.text.isNotEmpty) {
                  final keyword = _controller.text.trim();
                  final notifier = ref.read(searchFieldProvider.notifier);
                  if (notifier.allowSearch(keyword)) {
                    notifier.recordSearch(keyword);
                    await context.pushNamed(
                      'searchResult',
                      pathParameters: {'keyword': keyword},
                    );
                    if (context.mounted) {
                      notifier.clear();
                    }
                  }
                }
              },
            ),
          ],
        ),
        suffixIconColor: const Color(0xFF1A1A1A),
        hintText: "검색어를 입력해주세요.",
        hintStyle: const TextStyle(color: Color(0xFF1A1A1A)),
      ),
    );
  }
}
