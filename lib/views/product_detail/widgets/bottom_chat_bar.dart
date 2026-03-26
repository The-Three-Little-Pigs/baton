import 'package:baton/core/result/result.dart';
import 'package:baton/models/enum/product_status.dart';
import 'package:baton/notifier/like/like_notifier.dart';
import 'package:baton/notifier/user/user_notifier.dart';
import 'package:baton/views/_tap/chat/viewmodel/chat_room_action_notifier.dart';
import 'package:baton/views/product_detail/viewmodel/product_detail_page_view_model.dart';
import 'package:baton/views/widgets/complete_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:baton/core/utils/ui/app_snackbar.dart';

import 'package:baton/models/entities/post.dart';
import 'package:baton/notifier/like/like_notifier.dart';

class BottomChatBar extends ConsumerWidget {
  const BottomChatBar({super.key, required this.post, required this.productId});
  final Post post;
  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myId = ref.watch(userProvider).value?.uid;
    final postAsync = ref.watch(productDetailPageViewModelProvider(productId));
    final isLiked = ref
        .watch(likeProvider)
        .maybeWhen(
          data: (list) =>
              list.any((p) => p.postId == productId), // productId는 생성자로 받음
          orElse: () => false,
        );
    return postAsync.when(
      data: (post) {
        final isReservedOrSold =
            post.status == ProductStatus.reserved ||
            post.status == ProductStatus.sold;
        final isNotBuyer = post.buyerId != myId;
        final bool isChatDisabled = isReservedOrSold && isNotBuyer;
        return Row(
          spacing: 4,
          children: [
            _FavoriteButton(
              isLiked: isLiked,
              onTap: () {
                ref
                    .read(
                      productDetailPageViewModelProvider(productId).notifier,
                    )
                    .toggleLike();
              },
            ),
            Expanded(
              child: CompleteButton(
                label: "채팅하기",
                color: isChatDisabled
                    ? Theme.of(context).colorScheme.onSurfaceVariant
                    : Theme.of(context).colorScheme.primary,
                onPressed: isChatDisabled
                    ? null
                    : () {
                        final result = ref
                            .read(chatRoomActionProvider.notifier)
                            .joinRoom(
                              targetUserId: post.authorId,
                              productId: productId,
                            );

                        switch (result) {
                          case Success(value: final roomId):
                            context.pushNamed(
                              'chatDetail',
                              pathParameters: {'roomId': roomId},
                            );
                            break;
                          case Error(failure: final failure):
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(failure.message)),
                            );
                            break;
                        }
                      },
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (error, stackTrace) => const SizedBox.shrink(),
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
