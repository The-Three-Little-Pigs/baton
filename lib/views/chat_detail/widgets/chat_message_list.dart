import 'package:baton/core/theme/app_tokens/app_colors.dart';
import 'package:baton/models/enum/message_type.dart';
import 'package:baton/notifier/user/user_notifier.dart';
import 'package:baton/views/chat_detail/viewmodel/chat_detail_notifier.dart';
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
    final myUserId = ref.watch(userProvider).value?.uid;
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
              // TODO: 약속하기로 활용
              if (msg.type == MessageType.system) {
                return _SystemMessageBubble(content: msg.content);
              }
              final isReadByTarget = model.isReadByTarget;
              final isMyMessage = msg.senderId == myUserId;
              final nextVisualMsg = index > 0
                  ? uiMessages[index - 1].message
                  : null;
              double bottomMargin = 8.0;
              bool showTime = true; // 기본값: 시간표시
              bool showReadStatus = true; // 기본값: 읽음표시
              // 메세제 주체별 간격조정
              if (nextVisualMsg != null) {
                if (msg.senderId != nextVisualMsg.senderId) {
                  bottomMargin = 18.0;
                } else {
                  bool isSameMinute =
                      msg.createdAt.year == nextVisualMsg.createdAt.year &&
                      msg.createdAt.month == nextVisualMsg.createdAt.month &&
                      msg.createdAt.day == nextVisualMsg.createdAt.day &&
                      msg.createdAt.hour == nextVisualMsg.createdAt.hour &&
                      msg.createdAt.minute == nextVisualMsg.createdAt.minute;

                  if (isSameMinute) {
                    showTime = false;
                    if (isReadByTarget &&
                        uiMessages[index - 1].isReadByTarget) {
                      showReadStatus = false;
                    }
                  }
                }
              }
              // 날짜구분
              bool showDateDivider = false;
              if (index == uiMessages.length - 1) {
                showDateDivider = true;
              } else {
                final previousMsg = uiMessages[index + 1].message;
                if (msg.createdAt.year != previousMsg.createdAt.year ||
                    msg.createdAt.month != previousMsg.createdAt.month ||
                    msg.createdAt.day != previousMsg.createdAt.day) {
                  showDateDivider = true;
                }
              }

              return Column(
                children: [
                  if (showDateDivider)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          DateFormat(
                            'yyyy년 MM월 dd일',
                            'ko_KR',
                          ).format(msg.createdAt),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ),
                    ),
                  _ChatBubble(
                    content: msg.content,
                    type: msg.type,
                    isMyMessage: isMyMessage,
                    isReadByTarget: isReadByTarget,
                    createdAt: msg.createdAt,
                    isPending: msg.isPending,
                    bottomMargin: bottomMargin,
                    showTime: showTime,
                    showReadStatus: showReadStatus,
                  ),
                ],
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
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String content;
  final MessageType type;
  final DateTime createdAt;
  final bool isMyMessage;
  final bool isReadByTarget;
  final bool isPending;
  final double bottomMargin; // 👈 추가된 부분
  final bool showTime;
  final bool showReadStatus;

  const _ChatBubble({
    required this.content,
    required this.type,
    required this.createdAt,
    required this.isMyMessage,
    required this.isReadByTarget,
    required this.isPending,
    required this.bottomMargin, // 👈 추가된 부분
    this.showTime = true,
    this.showReadStatus = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Row 전체의 하단 여백을 동적으로 조절 (연속=8, 교차=18)
      padding: EdgeInsets.only(bottom: bottomMargin),
      child: Row(
        mainAxisAlignment: isMyMessage
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        // 시간을 버블 아래쪽에 맞추기 위해 crossAxisAlignment 조정
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 상대방 메시지일 때: 왼쪽 가장자리 여백 20
          if (!isMyMessage) const SizedBox(width: 20),

          // 내 메시지일 때: 시간 / 읽음표시 영역 (왼쪽)
          if (isMyMessage)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (showReadStatus)
                  Text(
                    isReadByTarget ? '' : '1',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: isReadByTarget
                          ? Colors.grey.shade500
                          : Colors.black,
                    ),
                  ),
                if (showTime)
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

          // 내 메시지일 때 버블과 시간 사이 간격 8
          if (isMyMessage) const SizedBox(width: 8),

          // 실제 메시지 버블 (가변 길이 대응을 위해 Flexible 처리 및 최대 너비 제한)
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth:
                    MediaQuery.of(context).size.width *
                    0.65, // 👈 화면 너비의 70%까지만 커지도록 제한
              ),
              decoration: BoxDecoration(
                color: type == MessageType.image
                    ? Colors.transparent
                    : (isMyMessage ? AppColors.primary : Colors.grey.shade300),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: type == MessageType.image
                  ? EdgeInsets.zero
                  : const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: type == MessageType.image
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: content.isNotEmpty
                          ? Image.network(
                              content,
                              width: MediaQuery.of(context).size.width * 0.6,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.6,
                                      height: 200,
                                      color: Colors.grey.shade200,
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  height: 200,
                                  color: Colors.grey.shade200,
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.broken_image,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        '이미지 오류',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          : Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: 200,
                              color: Colors.grey.shade200,
                              child: const Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                              ),
                            ),
                    )
                  : Text(
                      content,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: isMyMessage ? Colors.white : Colors.black,
                      ),
                    ),
            ),
          ),

          // 상대방 메시지일 때: 버블과 시간 사이 간격 8
          if (!isMyMessage) const SizedBox(width: 8),

          // 상대방 메시지일 때: 오른쪽 시간 표시
          if (!isMyMessage && showTime)
            Text(
              _timeFormat.format(createdAt),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade500,
              ),
            ),

          // 내 메시지일 때: 오른쪽 가장자리 여백 20
          if (isMyMessage) const SizedBox(width: 20),
        ],
      ),
    );
  }
}

/// TODO: 약속하기로 활용
class _SystemMessageBubble extends StatelessWidget {
  final String content;

  const _SystemMessageBubble({required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          content,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade700,
          ),
        ),
      ),
    );
  }
}
