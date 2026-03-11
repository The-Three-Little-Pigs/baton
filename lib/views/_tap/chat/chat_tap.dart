import 'package:baton/core/di/time_tick_provider.dart';
import 'package:baton/models/repositories/repository_impl/auth_repository_impl.dart';
import 'package:baton/notifier/user/user_notifier.dart';
import 'package:baton/views/_tap/chat/viewmodel/chat_list_notifier.dart';
import 'package:baton/views/_tap/chat/widgets/chat_category_chips.dart';
import 'package:baton/views/_tap/chat/widgets/chat_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart' show GoRouterHelper;

class ChatTap extends ConsumerWidget {
  const ChatTap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatroomStream = ref.watch(chatListProvider);
    // 실제 UserNotifier 적용 (AsyncValue<User?> 에서 uid 추출)
    final currentUserId = ref.watch(userProvider).value?.uid;
    final _ = ref.watch(timeTickProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '채팅',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: () {
              context.pushNamed(
                'chatDetail',
                pathParameters: {'roomId': 'test_room_id'},
              );
            },
          ),
          // TODO: 지워야함
          Center(
            child: Text(
              "내 접속: $currentUserId",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
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
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('에러 발생: \n$error', textAlign: TextAlign.center),
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

  String _createRoomId(String userId1, String userId2, String productId) {
    List<String> userIds = [userId1, userId2];
    userIds.sort();
    return '${userIds[0]}_${userIds[1]}_$productId';
  }
}
