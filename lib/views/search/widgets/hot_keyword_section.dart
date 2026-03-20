import 'package:baton/core/theme/app_tokens/app_colors.dart';
import 'package:baton/views/search/viewmodel/hot_keyword_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HotKeywordSection extends ConsumerWidget {
  const HotKeywordSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hotKeywordState = ref.watch(hotKeywordProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 14,
      children: [
        const Text(
          "인기 검색어",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        hotKeywordState.when(
          data: (keywords) {
            if (keywords.isEmpty) {
              return const Center(
                child: Text(
                  '인기 검색어가 없습니다.',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

            // 좌측: 1~5위, 우측: 6~10위 분할
            final leftKeywords = keywords.take(5).toList();
            final rightKeywords = keywords.skip(5).take(5).toList();

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 12,
                    children: List.generate(
                      leftKeywords.length,
                      (index) => SearchTerm(
                        label: leftKeywords[index].keyword,
                        idx: index + 1,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 12,
                    children: List.generate(
                      rightKeywords.length,
                      (index) => SearchTerm(
                        label: rightKeywords[index].keyword,
                        idx: index + 6,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stack) => const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              '인기 검색어를 불러오는데 실패했습니다.',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}

class SearchTerm extends StatelessWidget {
  const SearchTerm({super.key, required this.label, required this.idx});

  final String label;
  final int idx;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Text(
          idx.toString(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: idx <= 3 ? AppColors.primary : Colors.black,
          ),
        ),

        Text(label),
      ],
    );
  }
}
