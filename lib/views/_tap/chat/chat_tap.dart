import 'package:baton/views/_tap/chat/widgets/chat_category_chips.dart';
import 'package:baton/views/_tap/chat/widgets/chat_room_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' show GoRouterHelper;

class ChatTap extends StatelessWidget {
  const ChatTap({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '채팅',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        actions: [const Icon(Icons.more_vert)],
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
    );
  }
}
