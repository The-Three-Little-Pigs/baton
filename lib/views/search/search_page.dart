import 'package:baton/views/search/widgets/hot_keyword_section.dart';
import 'package:baton/views/search/widgets/recently_search_section.dart';
import 'package:baton/views/widgets/search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: const SearchField(),
        ),
        titleSpacing: 0,
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 24,
            children: [HotKeywordSection(), RecentlySearchSection()],
          ),
        ),
      ),
    );
  }
}
