import 'package:baton/models/entities/post.dart';
import 'package:baton/notifier/like/like_notifier.dart';
import 'package:baton/views/_tap/home/viewmodel/category_chips_notifier.dart';
import 'package:baton/views/_tap/home/viewmodel/filter_notifier.dart';
import 'package:baton/views/_tap/home/viewmodel/home_tap_viewmodel.dart';
import 'package:baton/views/_tap/home/widgets/category_chips.dart';
import 'package:baton/views/_tap/home/widgets/category_select_button.dart';
import 'package:baton/views/like/widgets/no_like_product.dart';
import 'package:baton/views/widgets/product_item.dart';
import 'package:baton/views/widgets/top_modal_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LikePage extends ConsumerStatefulWidget {
  const LikePage({super.key});

  @override
  ConsumerState<LikePage> createState() => _LikePageState();
}

class _LikePageState extends ConsumerState<LikePage> {
  // 사용자가 페이지에 머무는 동안은 목록이 변하지 않도록 고정하는 리스트
  List<Post>? _capturedPosts;

  @override
  Widget build(BuildContext context) {
    final likeAsyncValue = ref.watch(likeProvider);
    final selectedCategories = ref.watch(categoryChipsProvider);
    final filterState = ref.watch(filterProvider);

    // 하트를 눌러서 LikeNotifier의 상태가 바뀌어도,
    // 이미 캡처된 _capturedPosts가 있다면 그것을 계속 사용함으로써
    // 리스트에서 상품이 즉시 사라지는 것을 방지합니다.
    if (_capturedPosts == null && likeAsyncValue.hasValue) {
      _capturedPosts = likeAsyncValue.value;
    }

    // 🌟 카테고리 필터링 적용
    final filteredPosts =
        _capturedPosts?.where((post) {
          if (selectedCategories.isEmpty) return true;
          return selectedCategories.contains(post.category);
        }).toList() ??
        [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("관심상품"),
        centerTitle: true,
        actions: [
          // Text(
          //   '편집',
          //   style: TextStyle(
          //     fontSize: 14,
          //     fontWeight: FontWeight.w500,
          //     color: Theme.of(context).colorScheme.tertiary,
          //   ),
          // ),
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              spacing: 10,
              children: [
                Row(
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
                Expanded(
                  child: likeAsyncValue.when(
                    data: (_) {
                      if (filteredPosts.isEmpty) {
                        return Center(child: NoLikeProduct());
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
                          return ProductItem(post: filteredPosts[index]);
                        },
                        itemCount: filteredPosts.length,
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
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ],
            ),
          ),
          // 2. 배경 어둡게 처리 (Backdrop)
          if (filterState.isOpen)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  ref.read(filterProvider.notifier).close();
                },
                child: Container(color: Colors.black.withValues(alpha: 0.3)),
              ),
            ),

          // 3. 상단 드롭다운 필터 패널
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn,
            top: filterState.isOpen ? 0 : -500,
            left: 0,
            right: 0,
            child: const TopModalSheet(title: '전체 카테고리'),
          ),

          // 4. 경계선 디바이더 (패널 오픈 시 노출)
          if (filterState.isOpen)
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
            ),
        ],
      ),
    );
  }
}
