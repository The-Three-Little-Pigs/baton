import 'package:baton/core/theme/app_tokens/app_colors.dart';
import 'package:baton/models/entities/chat_room.dart';
import 'package:baton/views/product_detail/viewmodel/author_notifier.dart';
import 'package:baton/views/product_detail/viewmodel/product_detail_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class ChatRoomListTile extends ConsumerWidget {
  const ChatRoomListTile({
    required this.room,
    required this.currentUserId,
    super.key,
  });

  final Chatroom room;
  final String currentUserId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otherId = room.participants.firstWhere(
      (id) => id != currentUserId,
      orElse: () => '',
    );
    final parts = room.roomId.split('_');
    final productId = parts.length >= 3 ? parts[2] : '';
    final otherUserAsync = ref.watch(authorProvider(otherId));
    final postAsync = ref.watch(productDetailPageViewModelProvider(productId));
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
              child: postAsync.when(
                data: (post) => post.imageUrls.isNotEmpty
                    ? Image.network(post.imageUrls[0], fit: BoxFit.cover)
                    : SvgPicture.asset('assets/images/empty_image_60.svg'),
                loading: () => const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                error: (_, __) =>
                    const Center(child: Icon(Icons.broken_image, size: 14)),
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
                    Flexible(
                      child: Text(
                        otherUserAsync.when(
                          data: (user) => user.nickname,
                          loading: () => '...',
                          error: (_, __) => '알 수 없는 사용자',
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis, // 넘치는 부분을 '...'으로 표시
                        maxLines: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: postAsync.when(
                        data: (post) {
                          // 상품 작성자와 내 ID가 같으면 '판매', 다르면 '구매'
                          final isSeller = post.authorId == currentUserId;
                          return Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey.shade500,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Text(
                              isSeller ? '판매' : '구매',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          );
                        },
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
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
