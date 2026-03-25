import 'package:baton/core/result/result.dart';
import 'package:baton/notifier/like/like_notifier.dart';
import 'package:baton/views/_tap/chat/viewmodel/chat_room_action_notifier.dart';
import 'package:baton/views/product_detail/viewmodel/product_detail_page_view_model.dart';
import 'package:baton/views/widgets/complete_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BottomChatBar extends ConsumerWidget {
  const BottomChatBar({
    super.key,
    required this.productId,
    required this.authorId,
  });
  final String productId;
  final String authorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLiked = ref
        .watch(likeProvider)
        .maybeWhen(
          data: (list) =>
              list.any((p) => p.postId == productId), // productId는 생성자로 받음
          orElse: () => false,
        );
    return Row(
      spacing: 4,
      children: [
        _FavoriteButton(
          isLiked: isLiked,
          onTap: () {
            ref
                .read(productDetailPageViewModelProvider(productId).notifier)
                .toggleLike();
          },
        ),
        Expanded(
          child: CompleteButton(
            label: "채팅하기",
            color: Theme.of(context).colorScheme.primary,
            onPressed: () {
              final result = ref
                  .read(chatRoomActionProvider.notifier)
                  .joinRoom(targetUserId: authorId, productId: productId);

              switch (result) {
                case Success(value: final roomId):
                  context.pushNamed(
                    'chatDetail',
                    pathParameters: {'roomId': roomId},
                  );
                  break;
                case Error(failure: final failure):
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(failure.message)));
                  break;
              }
            },
          ),
        ),
      ],
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  final bool isLiked;
  final VoidCallback onTap;
  const _FavoriteButton({required this.isLiked, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.primary),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox.square(
        dimension: 54,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: GestureDetector(
            onTap: onTap,
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
