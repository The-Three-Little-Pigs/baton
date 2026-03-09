import 'package:baton/notifier/test/test_auth_notifier.dart';
import 'package:baton/views/_tap/chat/widgets/chat_category_chips.dart';
import 'package:baton/views/_tap/chat/widgets/chat_room_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart' show GoRouterHelper;

class ChatTap extends ConsumerWidget {
  const ChatTap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: authNotifier 수정
    final currentUserId = ref.watch(testAuthNotifierProvider);
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

          const Icon(Icons.more_vert),
        ],
      ),
      body: Column(
        children: [
          ChatCategoryChips(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(left: 27.89, right: 20),
              itemCount: 5,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    context.pushNamed(
                      'chatDetail',
                      pathParameters: {'roomId': '$index'},
                    );
                  },
                  child: ChatRoomListTile(),
                );
              },
            ),
          ),
        ],
      ),

      // TODO: 테스트끝나면 제거
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
