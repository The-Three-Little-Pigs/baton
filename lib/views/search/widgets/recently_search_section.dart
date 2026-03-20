import 'package:baton/notifier/user/user_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RecentlySearchSection extends ConsumerWidget {
  const RecentlySearchSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentList = ref.watch(userProvider).value?.recentlySearch.toList();

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
            if (recentList?.isNotEmpty ?? false)
              GestureDetector(
                onTap: () {
                  ref.read(userProvider.notifier).clearRecentlySearch();
                },
                child: Text(
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
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recentList?.length ?? 0,
          itemBuilder: (context, index) {
            final term = recentList?[index] ?? "";

            return RecentlySearchItem(
              term: term,
              onTap: (term) {
                ref.read(userProvider.notifier).toggleRecentlySearch(term);
              },
            );
          },
        ),
      ],
    );
  }
}

class RecentlySearchItem extends StatelessWidget {
  const RecentlySearchItem({
    super.key,
    required this.term,
    required this.onTap,
  });

  final String term;
  final void Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        SvgPicture.asset(
          'assets/icons/nest_clock_farsight_analog.svg',
          width: 24,
          height: 24,
        ),
        Text(term, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
        Spacer(),
        GestureDetector(
          onTap: () => onTap(term),
          child: Icon(Icons.close, color: Color(0xFFB3B3B3), size: 18),
        ),
      ],
    );
  }
}
