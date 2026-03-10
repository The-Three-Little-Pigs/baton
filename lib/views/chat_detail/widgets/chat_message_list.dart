import 'package:baton/core/theme/app_tokens/app_colors.dart';
import 'package:baton/notifier/test/test_auth_notifier.dart';
import 'package:baton/views/chat_detail/viewmodel.dart/chat_detail_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final _timeFormat = DateFormat('a h:mm', 'ko_KR');

class ChatMessageList extends ConsumerWidget {
  const ChatMessageList({super.key, required this.roomId});

  final String roomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiMessagesAsync = ref.watch(chatMessageUiModelProvider(roomId));
    final myUserId = ref.watch(testAuthNotifierProvider);
    return Expanded(
      child: uiMessagesAsync.when(
        data: (uiMessages) {
          if (uiMessages.isEmpty) {
            return const Center(child: Text('메시지를 보내보세요'));
          }
          return ListView.builder(
            reverse: true,
            shrinkWrap: true,
            itemCount: uiMessages.length,
            itemBuilder: (context, index) {
              final model = uiMessages[index];
              final msg = model.message;
              final isReadByTarget = model.isReadByTarget;
              final isMyMessage = msg.senderId == myUserId;
              return _ChatBubble(
                content: msg.content,
                isMyMessage: isMyMessage,
                isReadByTarget: isReadByTarget,
                createdAt: msg.createdAt,
                isPending: msg.isPending,
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
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String content;
  final DateTime createdAt;
  final bool isMyMessage;
  final bool isReadByTarget;
  final bool isPending;
  const _ChatBubble({
    required this.content,
    required this.createdAt,
    required this.isMyMessage,
    required this.isReadByTarget,
    required this.isPending,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      // 내가 보낸 건 오른쪽, 남이 보낸 건 왼쪽 정렬
      mainAxisAlignment: isMyMessage
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        // 내가 보낸 메시지일 때만 왼쪽에 시간/읽음표시 출력
        if (isMyMessage)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                isReadByTarget ? '읽음' : '안읽음',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: isReadByTarget ? Colors.grey.shade500 : Colors.black,
                ),
              ),
              Text(
                _timeFormat.format(createdAt),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: isPending
                      ? Colors.grey.shade300
                      : Colors.grey.shade500,
                ),
              ),
            ],
          ),

        const SizedBox(width: 8),

        // 실제 메시지 박스
        Container(
          margin: const EdgeInsets.only(bottom: 8, right: 20, left: 20),
          decoration: BoxDecoration(
            color: isMyMessage ? AppColors.primary : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: isMyMessage ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        // 상대방이 보낸 메시지일 때는 오른쪽에 시간 출력
        if (!isMyMessage)
          Text(
            _timeFormat.format(createdAt),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade500,
            ),
          ),
      ],
    );
  }
}
