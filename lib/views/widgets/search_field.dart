import 'package:baton/views/search/viewmodel/search_field_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SearchField extends ConsumerWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      onSubmitted: (value) {
        final keyword = value.trim();
        if (keyword.isNotEmpty) {
          ref.read(searchFieldProvider.notifier).recordSearch(keyword);
          context.pushNamed(
            'searchResult',
            pathParameters: {'keyword': keyword},
          );
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
        suffixIcon: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {},
        ),
        suffixIconColor: const Color(0xFF1A1A1A),
        hintText: "검색어를 입력해주세요.",
        hintStyle: const TextStyle(color: Color(0xFF1A1A1A)),
      ),
    );
  }
}
