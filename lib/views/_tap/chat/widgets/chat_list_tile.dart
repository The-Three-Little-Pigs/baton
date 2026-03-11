import 'package:baton/core/theme/app_tokens/app_colors.dart';
import 'package:baton/models/entities/chat_room.dart';
import 'package:flutter/material.dart';

class ChatRoomListTile extends StatelessWidget {
  const ChatRoomListTile({
    required this.room,
    required this.currentUserId,
    super.key,
  });

  final Chatroom room;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 60.7326,
              height: 60.7326,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Center(
                child: Icon(
                  Icons.image,
                  size: 14,
                  color: AppColors.textTertiary,
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      //TODO: nickName
                      '상대방닉네임',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.shade500,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Text(
                          // TODO: 판매인지 구매인지
                          '구매',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  room.lastMessage,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          SizedBox(width: 42.89),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatChatTime(room.updatedAt),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade500,
                ),
              ),
              SizedBox(height: 8),
              if ((room.unreadCounts[currentUserId] ?? 0) > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: AppColors.primary,
                  ),
                  child: Text(
                    (room.unreadCounts[currentUserId] ?? 0).toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String formatChatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    if (difference.inMinutes < 1) {
      return '방금 전';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}분 전';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}시간 전';
    } else if (difference.inDays < 2) {
      return '어제';
    } else if (difference.inDays < 30) {
      return '${difference.inDays}일 전';
    } else if (difference.inDays < 365) {
      return '${difference.inDays ~/ 30}달 전';
    } else {
      return '${difference.inDays ~/ 365}년 전';
    }
  }
}
