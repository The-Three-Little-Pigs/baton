import 'package:baton/core/theme/app_tokens/app_colors.dart';
import 'package:flutter/material.dart';

class HotKeywordSection extends StatelessWidget {
  const HotKeywordSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 14,
      children: [
        const Text(
          "인기 검색어",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                spacing: 12,
                children: [
                  SearchTerm(label: "", idx: 1),
                  SearchTerm(label: "", idx: 2),
                  SearchTerm(label: "", idx: 3),
                  SearchTerm(label: "", idx: 4),
                  SearchTerm(label: "", idx: 5),
                ],
              ),
            ),
            Expanded(
              child: Column(
                spacing: 12,
                children: [
                  SearchTerm(label: "", idx: 6),
                  SearchTerm(label: "", idx: 7),
                  SearchTerm(label: "", idx: 8),
                  SearchTerm(label: "", idx: 9),
                  SearchTerm(label: "", idx: 10),
                ],
              ),
            ),
          ],
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
