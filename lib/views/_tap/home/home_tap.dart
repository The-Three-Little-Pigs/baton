import 'package:baton/models/enum/category.dart';
import 'package:baton/views/_tap/home/viewmodel/filter_notifier.dart';
import 'package:baton/views/_tap/home/viewmodel/home_tap_viewmodel.dart';
import 'package:baton/views/_tap/home/widgets/category_chips.dart';
import 'package:baton/views/_tap/home/widgets/category_select_button.dart';
import 'package:baton/views/_tap/home/widgets/no_product.dart';
import 'package:baton/views/widgets/product_item.dart';
import 'package:baton/views/widgets/top_modal_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeTap extends ConsumerWidget {
  const HomeTap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postAsyncValue = ref.watch(homeTapViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [const Icon(Icons.notifications)],
      ),
      body: Column(
        spacing: 10,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                CategorySelectButton(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    child: CategoryChips(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ClipRect(
              child: Stack(
                children: [
                  // 1. 메인 본문 레이어 (포스트 리스트)
                  RefreshIndicator(
                    onRefresh: () async {
                      await ref
                          .read(homeTapViewModelProvider.notifier)
                          .refresh();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: postAsyncValue.when(
                        data: (posts) {
                          if (posts.isEmpty) {
                            return Center(child: const NoProduct());
                          }
                          return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 0.7,
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 20,
                                  crossAxisSpacing: 20,
                                ),
                            itemBuilder: (context, index) {
                              return NotificationListener<ScrollNotification>(
                                onNotification: (notification) {
                                  if (notification.metrics.pixels >=
                                      notification.metrics.maxScrollExtent *
                                          0.8) {
                                    ref
                                        .read(homeTapViewModelProvider.notifier)
                                        .fetchPosts();
                                  }
                                  return false;
                                },
                                child: ProductItem(post: posts[index]),
                              );
                            },
                            itemCount: posts.length,
                          );
                        },
                        error: (error, stackTrace) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(error.toString()),
                                ElevatedButton(
                                  onPressed: () {
                                    ref
                                        .read(homeTapViewModelProvider.notifier)
                                        .refresh();
                                  },
                                  child: Text("재시도"),
                                ),
                              ],
                            ),
                          );
                        },
                        loading: () {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                    ),
                  ),

                  // 2. 배경 어둡게 처리 (Backdrop)
                  if (ref.watch(filterProvider).isOpen)
                    Positioned.fill(
                      child: GestureDetector(
                        onTap: () {
                          ref.read(filterProvider.notifier).close();
                        },
                        child: Container(color: Colors.black.withOpacity(0.3)),
                      ),
                    ),

                  // 3. 상단 드롭다운 필터 패널
                  Builder(
                    builder: (context) {
                      final filterState = ref.watch(filterProvider);
                      return AnimatedPositioned(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.fastOutSlowIn,
                        // Stack의 최상단(top: 0)에서 시작
                        top: filterState.isOpen ? 0 : -500, // 더 높게 숨김
                        left: 0,
                        right: 0,
                        child: const TopModalSheet(
                          title: '전체 카테고리',
                        ),
                      );
                    },
                  ),

                  // 4. 경계선 디바이더 (패널 오픈 시 노출)
                  if (ref.watch(filterProvider).isOpen)
                    const Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFE2E8F0),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: SizedBox(
          width: 100,
          height: 40,
          child: FloatingActionButton.extended(
            icon: const Icon(Icons.add, size: 16),
            onPressed: () async {
              final result = await context.pushNamed('write');
              if (result == null) {
                ref.read(homeTapViewModelProvider.notifier).refresh();
              }
            },
            label: const Text("상품 등록"),
          ),
        ),
      ),
    );
  }
}
