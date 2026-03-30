import 'package:baton/views/search_result/viewmodel/search_result_viewmodel.dart';
import 'package:baton/views/search_result/widgets/select_button.dart';
import 'package:baton/views/widgets/product_grid_view.dart';
import 'package:baton/views/widgets/search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchResultPage extends ConsumerStatefulWidget {
  final String keyword;

  const SearchResultPage({super.key, required this.keyword});

  @override
  ConsumerState<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends ConsumerState<SearchResultPage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchResultAsyncValue = ref.watch(
      searchResultViewModelProvider(widget.keyword),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(right: 20),
          child: SearchField(),
        ),
        titleSpacing: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              spacing: 10,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    ref
                        .read(searchResultViewModelProvider(widget.keyword).notifier)
                        .toggleUnderPurchasePrice();
                    _scrollToTop();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 4,
                    children: [
                      SelectCircle(
                        isSelected:
                            searchResultAsyncValue.value?.isUnderPurchasePrice ??
                            false,
                      ),
                      const Text(
                        "정가이하",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF5E6876),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    ref
                        .read(searchResultViewModelProvider(widget.keyword).notifier)
                        .toggleIsAvailableOnly();
                    _scrollToTop();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 4,
                    children: [
                      SelectCircle(
                        isSelected:
                            searchResultAsyncValue.value?.isAvailableOnly ?? false,
                      ),
                      const Text(
                        "판매중인 상품",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF5E6876),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: searchResultAsyncValue.when(
              data: (state) => ProductGridView(
                posts: state.filteredPosts,
                controller: _scrollController,
                onRefresh: () => ref
                    .read(searchResultViewModelProvider(widget.keyword).notifier)
                    .refresh(),
                onReachBottom: () => ref
                    .read(searchResultViewModelProvider(widget.keyword).notifier)
                    .fetchMore(),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(error.toString()),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => ref
                          .read(
                            searchResultViewModelProvider(widget.keyword).notifier,
                          )
                          .refresh(),
                      child: const Text("재시도"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
