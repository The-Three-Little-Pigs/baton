import 'package:baton/core/di/time_tick_provider.dart';
import 'package:baton/notifier/test/test_auth_notifier.dart';
import 'package:baton/views/_tap/chat/viewmodel/chat_view_model.dart';
import 'package:baton/views/_tap/chat/widgets/chat_category_chips.dart';
import 'package:baton/views/_tap/chat/widgets/chat_room_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart' show GoRouterHelper;

class ChatTap extends ConsumerWidget {
  const ChatTap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatroomStream = ref.watch(chatListStreamProvider);
    // TODO: authNotifier 수정
    final currentUserId = ref.watch(testAuthNotifierProvider);
    final _ = ref.watch(timeTickProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '채팅',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        actions: [
          // TODO: 지워야할 유저 변경 아이콘
          Center(
            child: Text(
              "내 접속: $currentUserId",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),

          IconButton(
            icon: const Icon(Icons.change_circle, color: Colors.blue),
            onPressed: () {
              // 현재 구매자면 -> 판매자로 변경, 판매자면 -> 구매자로 변경
              final newId = currentUserId == 'BUYER_999'
                  ? 'SELLER_123'
                  : 'BUYER_999';
              ref.read(testAuthNotifierProvider.notifier).login(newId);
            },
          ),
          // TODO 채팅테스트 후 제거
          IconButton(
            onPressed: () {
              if (currentUserId == null) return;
              final productId = 'prd1';
              final targetUserId = currentUserId == 'BUYER_999'
                  ? 'SELLER_123'
                  : 'BUYER_999';
              final tempRoomId = _createRoomId(
                currentUserId,
                targetUserId,
                productId,
              );
              context.pushNamed(
                'chatDetail',
                pathParameters: {
                  'roomId': tempRoomId,
                }, // 라우터에 정의한 :roomId 경로 파라미터 매칭
              );
            },
            icon: Icon(Icons.add),
          ),

          const Icon(Icons.more_vert),
        ],
      ),
      body: Column(
        children: [
          ChatCategoryChips(),
          Expanded(
            child: chatroomStream.when(
              data: (chatrooms) {
                if (chatrooms.isEmpty) {
                  return const Center(child: Text('참여중인 채팅방이 없습니다.'));
                }
                return ListView.builder(
                  itemCount: chatrooms.length,
                  itemBuilder: (context, index) {
                    final room = chatrooms[index];
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
                          currentUserId: currentUserId!,
                        ),
                      ),
                    );
                  },
                );
              },
              error: (error, stackTrace) {
                return const Center(child: Text('에러 발생'));
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

  String _createRoomId(String userId1, String userId2, String productId) {
    List<String> userIds = [userId1, userId2];
    userIds.sort();
    return '${userIds[0]}_${userIds[1]}_$productId';
  }
}
