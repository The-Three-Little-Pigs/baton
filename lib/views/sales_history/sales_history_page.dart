import 'package:baton/core/theme/app_tokens/app_colors.dart';
import 'package:baton/models/entities/post.dart';
import 'package:baton/models/enum/product_status.dart';
import 'package:baton/notifier/history/history_notifier.dart';
import 'package:baton/notifier/user/user_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:baton/core/di/repository/chat_provider.dart';
import 'package:baton/models/entities/chat_room.dart';

class SalesHistoryPage extends ConsumerStatefulWidget {
  const SalesHistoryPage({super.key});

  @override
  ConsumerState<SalesHistoryPage> createState() => _SalesHistoryPageState();
}
class _SalesHistoryPageState extends ConsumerState<SalesHistoryPage> {
  bool isEditMode = false;
  Set<String> selectedIds = {};
  final Set<String> _expandedPostIds = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(salesHistoryProvider.notifier).refresh();
    });
  }

  void _toggleEditMode() {
    setState(() {
      isEditMode = !isEditMode;
      selectedIds.clear();
    });
  }

  void _selectAll(List<Post> posts) {
    setState(() {
      // 삭제 가능한 포스트(거래중이 아닌 것)들만 필터링
      final deletablePosts =
          posts.where((p) => p.status != ProductStatus.reserved).toList();

      if (selectedIds.length == deletablePosts.length &&
          deletablePosts.isNotEmpty) {
        selectedIds.clear();
      } else {
        selectedIds = deletablePosts.map((p) => p.postId).toSet();
      }
    });
  }

  void _toggleSelection(String id, ProductStatus status) {
    if (status == ProductStatus.reserved) return; // 거래중은 선택 불가

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
    final historyState = ref.watch(salesHistoryProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          isEditMode ? '판매 내역 편집' : '판매내역',
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
                      final deletablePosts =
                          posts.where((p) => p.status != ProductStatus.reserved).toList();
                      final isAllSelected =
                          selectedIds.length == deletablePosts.length &&
                          deletablePosts.isNotEmpty;
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
                    error: (error, stack) => const SizedBox(),
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
                    '아직 판매한 상품이 없어요',
                    style: TextStyle(fontSize: 14, color: Color(0xFF5E6876)),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.push('/write');
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
                          '내 상품 등록하기',
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
                      onTap: () => _toggleSelection(post.postId, post.status),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40, right: 16),
                        child: Icon(
                          isSelected
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: post.status == ProductStatus.reserved
                              ? const Color(0xFFF1F4F8) // 비활성화 느낌
                              : isSelected
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
                                        child: Row(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  right: 8),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                color: post.status ==
                                                        ProductStatus.reserved
                                                    ? AppColors.primary
                                                        .withValues(alpha: 0.1)
                                                    : post.status ==
                                                            ProductStatus.sold
                                                        ? const Color(
                                                                0xFF5E6876)
                                                            .withValues(
                                                                alpha: 0.1)
                                                        : const Color(
                                                                0xFF2CD38B)
                                                            .withValues(
                                                                alpha: 0.1),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                post.status.label,
                                                style: TextStyle(
                                                  color: post.status ==
                                                          ProductStatus.reserved
                                                      ? AppColors.primary
                                                      : post.status ==
                                                              ProductStatus.sold
                                                          ? const Color(
                                                              0xFF5E6876)
                                                          : const Color(
                                                              0xFF2CD38B),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
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
                                          ],
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
                        if (!isEditMode) ...[
                          if (post.status == ProductStatus.sold || post.status == ProductStatus.reserved) ...[
                            // 거래완료 또는 거래중 상태일 때: 약속 일정 확인 아코디언
                            const SizedBox(height: 12),
                            _AppointmentAccordion(
                              post: post,
                              isExpanded: _expandedPostIds.contains(post.postId),
                              onToggle: () {
                                setState(() {
                                  if (_expandedPostIds.contains(post.postId)) {
                                    _expandedPostIds.remove(post.postId);
                                  } else {
                                    _expandedPostIds.add(post.postId);
                                  }
                                });
                              },
                            ),
                          ],
                        ],
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
                '아직 판매한 상품이 없어요', // 에러가 나도 유저가 원한 디자인대로 이 문구를 노출
                style: TextStyle(fontSize: 14, color: Color(0xFF5E6876)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.push('/write');
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
                      '판매글 작성하기',
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
                                _showDeleteConfirmDialog();
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
                          '삭제 선택',
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

  void _showDeleteConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('내역 삭제'),
        content: const Text('선택한 내역을 삭제하시겠습니까?\n삭제된 내역은 복구할 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(salesHistoryProvider.notifier).deletePosts(selectedIds);
              setState(() {
                isEditMode = false;
                selectedIds.clear();
              });
            },
            child: const Text('삭제', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}



class _AppointmentAccordion extends ConsumerWidget {
  final Post post;
  final bool isExpanded;
  final VoidCallback onToggle;

  const _AppointmentAccordion({
    required this.post,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD1DCE9)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '약속 일정 확인',
                    style: TextStyle(
                      color: Color(0xFF5E6876),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: const Color(0xFF5E6876),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            const Divider(height: 1, color: Color(0xFFD1DCE9)),
            _AppointmentTimeFetch(
              postId: post.postId,
              myUid: ref.watch(userProvider).value?.uid ?? '',
            ),
          ],
        ],
      ),
    );
  }
}

class _AppointmentTimeFetch extends ConsumerWidget {
  final String postId;
  final String myUid;
  const _AppointmentTimeFetch({required this.postId, required this.myUid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (myUid.isEmpty) return const SizedBox.shrink();
    
    final chatRoomsAsync =
        ref.watch(chatRepositoryProvider).watchChatRooms(myUid);

    return StreamBuilder<Chatroom?>(
      stream: chatRoomsAsync.map((rooms) {
        try {
          return rooms.firstWhere(
            (r) => r.roomId.endsWith(postId) || r.roomId.contains(postId),
          );
        } catch (_) {
          return null;
        }
      }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
          );
        }

        final room = snapshot.data;
        if (room == null || room.appointmentDateTime == null) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                '확정된 약속 일정이 없습니다.',
                style: TextStyle(color: Color(0xFF5E6876), fontSize: 13),
              ),
            ),
          );
        }

        final dateStr =
            DateFormat('yyyy년 M월 d일', 'ko_KR').format(room.appointmentDateTime!);
        final timeStr =
            DateFormat('a h시 mm분', 'ko_KR').format(room.appointmentDateTime!);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                dateStr,
                style: const TextStyle(
                  color: Color(0xFF5E6876),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                timeStr,
                style: const TextStyle(
                  color: Color(0xFF5E6876),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
