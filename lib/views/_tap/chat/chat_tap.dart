import 'package:baton/core/di/time_tick_provider.dart';
import 'package:baton/models/enum/appointment_status.dart';
import 'package:baton/models/enum/chat_status.dart';
import 'package:baton/notifier/user/user_notifier.dart';
import 'package:baton/views/_tap/chat/viewmodel/chat_list_notifier.dart';
import 'package:baton/views/_tap/chat/viewmodel/selected_chat_status_provider.dart';
import 'package:baton/views/_tap/chat/widgets/chat_category_chips.dart';
import 'package:baton/views/_tap/chat/widgets/chat_list_tile.dart';
import 'package:baton/views/product_detail/viewmodel/product_detail_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart' show GoRouterHelper;

class ChatTap extends ConsumerWidget {
  const ChatTap({super.key});

  /// roomId에서 productId를 추출하는 헬퍼
  String _extractProductId(String roomId) {
    final parts = roomId.split('_');
    return parts.length >= 3 ? parts.sublist(2).join('_') : '';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatroomStream = ref.watch(chatListProvider);
    final currentUserId = ref.watch(userProvider).value?.uid;
    final selectedStatus = ref.watch(selectedChatStatusProvider);
    final _ = ref.watch(timeTickProvider);

    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: const Text(
            '채팅',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
            child: ChatCategoryChips(),
          ),
          Expanded(
            child: chatroomStream.when(
              data: (chatrooms) {
                if (chatrooms.isEmpty) {
                  return const Center(child: Text('참여중인 채팅방이 없습니다.'));
                }

                // 1단계: 예약/완료는 Chatroom 자체 데이터로 즉시 필터링
                final preFiltered = switch (selectedStatus) {
                  ChatStatus.reserved => chatrooms
                      .where(
                        (r) =>
                            r.appointmentStatus ==
                            AppointmentStatus.confirmed.label,
                      )
                      .toList(),
                  ChatStatus.completed => chatrooms
                      .where(
                        (r) =>
                            r.appointmentStatus ==
                            AppointmentStatus.completed.label,
                      )
                      .toList(),
                  _ => chatrooms, // 전체/구매/판매는 아래에서 처리
                };

                // 2단계: 구매/판매는 각 아이템 렌더링 시 Post 조회로 판별
                // (이미 ChatRoomListTile에서 Post를 watch하고 있어 캐시 활용)
                if (selectedStatus == ChatStatus.purchase ||
                    selectedStatus == ChatStatus.sales) {
                  return _FilteredChatList(
                    chatrooms: preFiltered,
                    currentUserId: currentUserId!,
                    filterType: selectedStatus,
                    extractProductId: _extractProductId,
                  );
                }

                if (preFiltered.isEmpty) {
                  return const Center(child: Text('해당하는 채팅방이 없습니다.'));
                }

                return ListView.builder(
                  itemCount: preFiltered.length,
                  itemBuilder: (context, index) {
                    final room = preFiltered[index];
                    return _ChatRoomItem(
                      room: room,
                      currentUserId: currentUserId!,
                    );
                  },
                );
              },
              error: (error, stackTrace) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child:
                        Text('에러 발생: \n$error', textAlign: TextAlign.center),
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
    );
  }
}

/// 구매/판매 필터링을 위한 위젯
/// 각 채팅방의 Post를 조회하여 authorId 기반으로 필터링합니다.
class _FilteredChatList extends ConsumerWidget {
  const _FilteredChatList({
    required this.chatrooms,
    required this.currentUserId,
    required this.filterType,
    required this.extractProductId,
  });

  final List chatrooms;
  final String currentUserId;
  final ChatStatus filterType;
  final String Function(String) extractProductId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 각 방의 Post를 조회하여 구매/판매를 판별
    final filteredRooms = chatrooms.where((room) {
      final productId = extractProductId(room.roomId);
      if (productId.isEmpty) return false;

      final postAsync =
          ref.watch(productDetailPageViewModelProvider(productId));
      return postAsync.whenOrNull(
            data: (post) {
              final isSeller = post.authorId == currentUserId;
              return filterType == ChatStatus.sales ? isSeller : !isSeller;
            },
          ) ??
          false; // 로딩 중이거나 에러면 일단 숨김
    }).toList();

    if (filteredRooms.isEmpty) {
      return const Center(child: Text('해당하는 채팅방이 없습니다.'));
    }

    return ListView.builder(
      itemCount: filteredRooms.length,
      itemBuilder: (context, index) {
        final room = filteredRooms[index];
        return _ChatRoomItem(room: room, currentUserId: currentUserId);
      },
    );
  }
}

/// 개별 채팅방 아이템 (터치 → 상세 이동)
class _ChatRoomItem extends StatelessWidget {
  const _ChatRoomItem({required this.room, required this.currentUserId});
  final dynamic room;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushNamed(
          'chatDetail',
          pathParameters: {'roomId': room.roomId},
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 27.89, right: 20),
        child: ChatRoomListTile(
          room: room,
          currentUserId: currentUserId,
        ),
      ),
    );
  }
}

