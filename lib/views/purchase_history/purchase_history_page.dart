import 'package:baton/core/theme/app_tokens/app_colors.dart';
import 'package:baton/models/entities/post.dart';
import 'package:baton/notifier/history/history_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class PurchaseHistoryPage extends ConsumerStatefulWidget {
  const PurchaseHistoryPage({super.key});

  @override
  ConsumerState<PurchaseHistoryPage> createState() =>
      _PurchaseHistoryPageState();
}

class _PurchaseHistoryPageState extends ConsumerState<PurchaseHistoryPage> {
  bool isEditMode = false;
  Set<String> selectedIds = {};

  void _toggleEditMode() {
    setState(() {
      isEditMode = !isEditMode;
      selectedIds.clear();
    });
  }

  void _selectAll(List<Post> posts) {
    setState(() {
      if (selectedIds.length == posts.length) {
        selectedIds.clear(); // 모두 선택된 상태면 초기화
      } else {
        selectedIds = posts.map((p) => p.postId).toSet(); // 전체 선택
      }
    });
  }

  void _toggleSelection(String id) {
    setState(() {
      if (selectedIds.contains(id)) {
        selectedIds.remove(id);
      } else {
        selectedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final historyState = ref.watch(purchaseHistoryProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          isEditMode ? '구매 내역 편집' : '구매내역',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: isEditMode ? const Color(0xFFF7F8F9) : AppColors.white,
        elevation: 0,
        leading: isEditMode
            ? null
            : IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.black,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
              ),
        actions: [
          if (!isEditMode)
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Center(
                child: GestureDetector(
                  onTap: _toggleEditMode,
                  child: const Text(
                    '편집',
                    style: TextStyle(
                      color: Color(0xFF999999),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ),
        ],
        bottom: isEditMode
            ? PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: Container(
                  color: const Color(0xFFF7F8F9),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: historyState.when(
                    data: (posts) {
                      final isAllSelected =
                          selectedIds.length == posts.length &&
                          posts.isNotEmpty;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => _selectAll(posts),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: isAllSelected
                                      ? AppColors.primary
                                      : const Color(0xFFD1DCE9),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  '전체 선택',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF5E6876),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIds.clear();
                              });
                            },
                            child: const Text(
                              '초기화',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF999999),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () => const SizedBox(),
                    error: (_, __) => const SizedBox(),
                  ),
                ),
              )
            : null,
      ),
      body: historyState.when(
        data: (posts) {
          if (posts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        '!',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '아직 구매한 상품이 없어요',
                    style: TextStyle(fontSize: 14, color: Color(0xFF5E6876)),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.go('/home');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '상품 둘러보기',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.chevron_right, size: 18),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: isEditMode ? 100 : 16, // 편집 모드일 때 하단 버튼 공간 확보
            ),
            itemCount: posts.length,
            separatorBuilder: (context, index) => const SizedBox(height: 24),
            itemBuilder: (context, index) {
              final post = posts[index];
              final isSelected = selectedIds.contains(post.postId);
              final dateFmt = DateFormat('yyyy년 MM월 d일').format(post.createdAt);

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isEditMode) ...[
                    GestureDetector(
                      onTap: () => _toggleSelection(post.postId),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40, right: 16),
                        child: Icon(
                          isSelected
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: isSelected
                              ? AppColors.primary
                              : const Color(0xFFD1DCE9),
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dateFmt,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // 카드 정보 영역
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 이미지 컨테이너
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE7ECF4),
                                borderRadius: BorderRadius.circular(12),
                                image: post.imageUrls.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(
                                          post.imageUrls.first,
                                        ),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: post.imageUrls.isEmpty
                                  ? Center(
                                      child: Icon(
                                        Icons.image,
                                        color: Colors.grey[400],
                                        size: 32,
                                      ),
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 16),
                            // 텍스트 정보
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          post.title,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.textPrimary,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.more_vert,
                                          size: 20,
                                        ),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${NumberFormat('#,###').format(post.salePrice ?? 0)}원',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    '!',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '아직 구매한 상품이 없어요', // 에러가 나도 유저가 원한 디자인대로 이 문구를 노출
                style: TextStyle(fontSize: 14, color: Color(0xFF5E6876)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.go('/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '상품 둘러보기',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.chevron_right, size: 18),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: isEditMode
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: _toggleEditMode,
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFFD1DCE9),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          '취소',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextButton(
                        onPressed: selectedIds.isNotEmpty
                            ? () {
                                ref
                                    .read(purchaseHistoryProvider.notifier)
                                    .deletePosts(selectedIds);
                                _toggleEditMode();
                              }
                            : null,
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          disabledBackgroundColor: const Color(0xFFB5C1D0),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          '선택 삭제',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
