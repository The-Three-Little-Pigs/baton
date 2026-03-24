import 'package:baton/core/di/repository/search_provider.dart';
import 'package:baton/notifier/search/recently_search_notifier.dart';
import 'package:baton/views/search/viewmodel/search_field_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class RecentlySearchSection extends ConsumerWidget {
  const RecentlySearchSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentHistoryAsync = ref.watch(recentlySearchProvider);

    return recentHistoryAsync.when(
      data: (histories) {
        if (histories.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 14,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "최근 검색",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                GestureDetector(
                  onTap: () {
                    ref.read(recentlySearchProvider.notifier).clearAll();
                  },
                  child: const Text(
                    "전체 삭제",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF999999),
                    ),
                  ),
                ),
              ],
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: histories.length,
              itemBuilder: (context, index) {
                final history = histories[index];

                return RecentlySearchItem(
                  label: history.query,
                  onSearch: () {
                    ref
                        .read(searchFieldProvider.notifier)
                        .updateText(history.query);
                    ref
                        .read(searchFieldProvider.notifier)
                        .recordSearch(history.query);
                    context.pushNamed(
                      'searchResult',
                      pathParameters: {'keyword': history.query},
                    );
                  },
                  onDelete: () {
                    ref
                        .read(recentlySearchProvider.notifier)
                        .deleteHistory(history.id);
                  },
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 20);
              },
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class RecentlySearchItem extends StatelessWidget {
  const RecentlySearchItem({
    super.key,
    required this.label,
    required this.onSearch,
    required this.onDelete,
  });

  final String label;
  final VoidCallback onSearch;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSearch,
      behavior: HitTestBehavior.opaque,
      child: Row(
        spacing: 8,
        children: [
          SvgPicture.asset(
            'assets/icons/nest_clock_farsight_analog.svg',
            width: 24,
            height: 24,
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onDelete,
            child: const Icon(Icons.close, color: Color(0xFFB3B3B3), size: 18),
          ),
        ],
      ),
    );
  }
}
