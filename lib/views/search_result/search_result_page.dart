import 'package:baton/views/_tap/home/widgets/no_product.dart';
import 'package:baton/views/search/viewmodel/search_field_notifier.dart';
import 'package:baton/views/search_result/viewmodel/search_result_viewmodel.dart';
import 'package:baton/views/search_result/widgets/select_button.dart';
import 'package:baton/views/widgets/product_item.dart';
import 'package:baton/views/widgets/search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchResultPage extends ConsumerWidget {
  final String keyword;

  const SearchResultPage({super.key, required this.keyword});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 페이지 진입 시 검색 필드 텍스트 동기화
    Future.microtask(() {
      if (ref.read(searchFieldProvider) != keyword) {
        ref.read(searchFieldProvider.notifier).updateText(keyword);
      }
    });

    final searchResultAsyncValue =
        ref.watch(searchResultViewModelProvider(keyword));

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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              spacing: 10,
              children: [
                SelectButton(label: "정가이하", isSelected: true),
                SelectButton(label: "판매중인 상품", isSelected: false),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: searchResultAsyncValue.when(
              data: (posts) {
                if (posts.isEmpty) {
                  return const Center(child: NoProduct());
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(searchResultViewModelProvider(keyword).notifier).refresh();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.7,
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                      ),
                      itemBuilder: (context, index) {
                        return ProductItem(post: posts[index]);
                      },
                      itemCount: posts.length,
                    ),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(error.toString()),
                    ElevatedButton(
                      onPressed: () {
                        ref.read(searchResultViewModelProvider(keyword).notifier).refresh();
                      },
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
