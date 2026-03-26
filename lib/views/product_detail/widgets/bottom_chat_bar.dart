import 'package:baton/core/result/result.dart';
import 'package:baton/views/_tap/chat/viewmodel/chat_room_action_notifier.dart';
import 'package:baton/views/widgets/complete_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:baton/core/utils/ui/app_snackbar.dart';

import 'package:baton/models/entities/post.dart';
import 'package:baton/notifier/like/like_notifier.dart';

class BottomChatBar extends ConsumerWidget {
  const BottomChatBar({
    super.key,
    required this.post,
  });
  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      spacing: 4,
      children: [
        _FavoriteButton(post: post),
        Expanded(
          child: CompleteButton(
            label: "채팅하기",
            color: Theme.of(context).colorScheme.primary,
            onPressed: () {
              final result = ref
                  .read(chatRoomActionProvider.notifier)
                  .joinRoom(targetUserId: post.authorId, productId: post.postId);

              switch (result) {
                case Success(value: final roomId):
                  context.pushNamed(
                    'chatDetail',
                    pathParameters: {'roomId': roomId},
                  );
                  break;
                case Error(failure: final failure):
                  AppSnackBar.show(context, failure.message);
                  break;
              }
            },
          ),
        ),
      ],
    );
  }
}

class _FavoriteButton extends ConsumerWidget {
  const _FavoriteButton({required this.post});

  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likedPosts = ref.watch(likeProvider).value ?? [];
    final isLiked = likedPosts.any((p) => p.postId == post.postId);

    return GestureDetector(
      onTap: () {
        ref.read(likeProvider.notifier).toggleLike(post);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(12),
        ),
        child: SizedBox.square(
          dimension: 54,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
