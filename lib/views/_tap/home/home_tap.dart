import 'package:baton/notifier/alarm/alarm_notifier.dart';
import 'package:baton/views/_tap/home/viewmodel/filter_notifier.dart';
import 'package:baton/views/_tap/home/viewmodel/home_tap_viewmodel.dart';
import 'package:baton/views/_tap/home/widgets/category_chips.dart';
import 'package:baton/views/_tap/home/widgets/category_select_button.dart';
import 'package:baton/views/widgets/home_logo.dart';
import 'package:baton/views/widgets/product_grid_view.dart';
import 'package:baton/views/widgets/skeleton.dart';
import 'package:baton/views/widgets/top_modal_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeTap extends ConsumerStatefulWidget {
  const HomeTap({super.key});

  @override
  ConsumerState<HomeTap> createState() => _HomeTapState();
}

class _HomeTapState extends ConsumerState<HomeTap> {
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
    final postAsyncValue = ref.watch(homeTapViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: HomeLogo(onTap: _scrollToTop),
        actions: [
          IconButton(
            onPressed: () {
              context.pushNamed('search');
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              context.pushNamed('alarm');
            },
            icon: Badge(
              isLabelVisible: ref.watch(unreadAlarmCountProvider) > 0,
              backgroundColor: Colors.orange,
              smallSize: 8,
              child: const Icon(Icons.notifications),
            ),
          ),
        ],
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
                  postAsyncValue.when(
                    data: (homeTapState) => ProductGridView(
                      posts: homeTapState.posts,
                      onRefresh: () =>
                          ref.read(homeTapViewModelProvider.notifier).refresh(),
                      onReachBottom: () => ref
                          .read(homeTapViewModelProvider.notifier)
                          .fetchPosts(),
                      controller: _scrollController,
                    ),
                    error: (error, stackTrace) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(error.toString()),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () => ref
                                .read(homeTapViewModelProvider.notifier)
                                .refresh(),
                            child: const Text("재시도"),
                          ),
                        ],
                      ),
                    ),
                    loading: () => const SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: ProductGridSkeleton(),
                    ),
                  ),

                  // 2. 배경 어둡게 처리 (Backdrop)
                  if (ref.watch(filterProvider).isOpen)
                    Positioned.fill(
                      child: GestureDetector(
                        onTap: () {
                          ref.read(filterProvider.notifier).close();
                        },
                        child: Container(color: Colors.black.withValues(alpha: 0.3)),
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
                        child: const TopModalSheet(title: '전체 카테고리'),
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
