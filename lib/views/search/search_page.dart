import 'package:baton/views/search/widgets/hot_keyword_section.dart';
import 'package:baton/views/search/widgets/recently_search_section.dart';
import 'package:baton/views/search/widgets/search_field.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: SearchField(),
        ),
        titleSpacing: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Column(
          spacing: 24,
          children: [HotKeywordSection(), RecentlySearchSection()],
        ),
      ),
    );
  }
}
