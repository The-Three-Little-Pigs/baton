import 'package:baton/core/result/result.dart';
import 'package:baton/core/theme/app_tokens/app_colors.dart';
import 'package:baton/models/enum/appointment_status.dart';
import 'package:baton/models/enum/product_status.dart';
import 'package:baton/notifier/block/block_notifier.dart';
import 'package:baton/notifier/user/user_notifier.dart';
import 'package:baton/views/product_detail/viewmodel/author_notifier.dart';
import 'package:baton/views/_tap/chat/viewmodel/chat_room_action_notifier.dart';
import 'package:baton/views/chat_detail/viewmodel/chat_detail_notifier.dart';
import 'package:baton/views/chat_detail/widgets/appointment_button.dart';
import 'package:baton/views/chat_detail/widgets/chat_input_field.dart';
import 'package:baton/views/chat_detail/widgets/chat_message_list.dart';
import 'package:baton/views/chat_detail/widgets/chat_product_banner.dart';
import 'package:baton/views/product_detail/viewmodel/product_detail_page_view_model.dart';
import 'package:baton/views/widgets/common_dialog.dart';
import 'package:baton/views/widgets/cupertino_modal_pop_up.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:baton/core/utils/ui/app_snackbar.dart';

class ChatDetailPage extends ConsumerWidget {
  const ChatDetailPage({super.key, required this.roomId});

  final String roomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: 약속하기 버튼 완성하면 지우기
    // Future.delayed(
    //   Duration.zero,
    //   () => AppointmentBottomSheet.showAppointmentDialog(context),
    // );
    final myUser = ref.watch(userProvider).value;
    final myUserId = myUser?.uid;
    final parts = roomId.split('_');
    final otherUid = (parts.length >= 2)
        ? (parts[0] == myUserId ? parts[1] : parts[0])
        : '';
    final chatroomState = ref.watch(chatRoomStreamProvider(roomId));
    final chatroom = chatroomState.value;
    final opponentAsync = ref.watch(authorProvider(otherUid));
    final opponentNickname = opponentAsync.when(
      data: (user) => user.nickname,
      loading: () => '...',
      error: (_, __) => '알 수 없는 사용자',
    );
    final blockState = ref.watch(blockProvider);
    final bool iBlockedHim = blockState.isBlockedByMe(otherUid);
    final bool heBlockedMe = blockState.isBlockedMe(otherUid);
    final bool isExited = chatroom?.deletedByUids.contains(otherUid) ?? false;
    final bool isInteractionBlocked = iBlockedHim || heBlockedMe || isExited;

    String blockedMessage = '';
    if (iBlockedHim) {
      blockedMessage = '차단한 사용자입니다. 대화할 수 없습니다.';
    } else if (heBlockedMe || isExited) {
      blockedMessage = '채팅이 종료되었습니다.';
    }

    // 읽음 처리 로직
    if (myUserId != null && chatroomState.value != null) {
      final unread = chatroomState.value!.unreadCounts[myUserId] ?? 0;
      if (unread > 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(chatDetailProvider(roomId).notifier).markAsRead(roomId);
        });
      }
    }
    // 약속 상태 변경 감지
    ref.listen(chatRoomStreamProvider(roomId), (previous, next) {
      final prevStatus = previous?.value?.appointmentStatus;
      final nextStatus = next.value?.appointmentStatus;
      // 약속 상태(대기->확정 등)가 변했다면?
      if (prevStatus != nextStatus && nextStatus != null) {
        final productId =
            roomId.split('_').length >= 3 ? roomId.split('_')[2] : '';
        if (productId.isEmpty) return;

        ProductStatus? newProductStatus;
        if (nextStatus == AppointmentStatus.confirmed.label) {
          newProductStatus = ProductStatus.reserved;
        } else if (nextStatus == AppointmentStatus.cancelled.label) {
          newProductStatus = ProductStatus.available;
        } else if (nextStatus == AppointmentStatus.completed.label) {
          newProductStatus = ProductStatus.sold;
        }

        if (newProductStatus != null) {
          // ✅ .state 직접 수정 대신 Notifier의 메서드 호출
          ref
              .read(productDetailPageViewModelProvider(productId).notifier)
              .updateStatusLocally(newProductStatus);
        }
      }
    });
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, size: 18),
            onPressed: () {
              context.pop();
            },
          ),
          title: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.black, width: 1.6),
              ),
            ),
            child: Text(
              opponentNickname,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: () async {
                showCupertinoModalPopup(
                  context: context,
                  builder: (modalContext) => CupertinoModalPopUp(
                    actions: [
                      {
                        iBlockedHim ? '차단 해제하기' : '신고/차단하기': () async {
                          Navigator.pop(modalContext);
                          if (!iBlockedHim) {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (dialogContext) => CommonDialog(
                                title: '신고/차단하기',
                                content:
                                    '신고/차단하면 상대방의 게시글을\n더 이상 볼 수 없어요.\n신고/차단하시겠습니까?',
                                leftText: '취소',
                                rightText: '신고/차단',
                                onLeftTap: () =>
                                    Navigator.pop(dialogContext, false),
                                onRightTap: () =>
                                    Navigator.pop(dialogContext, true),
                                rightBackgroundColor: AppColors.primary,
                              ),
                            );
                            if (confirmed == true) {
                              await ref
                                  .read(blockProvider.notifier)
                                  .toggleBlock(otherUid);
                            }
                          } else {
                            await ref
                                .read(blockProvider.notifier)
                                .toggleBlock(otherUid);
                          }
                        },
                      },
                      {
                        '채팅방 나가기': () async {
                          modalContext.pop();

                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (dialogContext) => CommonDialog(
                              title: '채팅방 나가기',
                              content: '채팅방을 나가면 메시지를\n더 이상 볼 수 없어요',
                              leftText: '취소',
                              rightText: '나가기',
                              onLeftTap: () =>
                                  Navigator.pop(dialogContext, false),
                              onRightTap: () =>
                                  Navigator.pop(dialogContext, true),
                              rightBackgroundColor: AppColors.primary,
                            ),
                          );
                          if (confirmed != true) return;

                          final result = await ref
                              .read(chatRoomActionProvider.notifier)
                              .leaveChatRoom(roomId);
                          // 3. 결과에 따라 처리
                          switch (result) {
                            case Success():
                              // 성공 시: 채팅 목록으로 이동
                              if (context.mounted) context.pop();
                            case Error(:final failure):
                              // 실패 시: 오류 메시지 스낵바
                              if (context.mounted) {
                                AppSnackBar.show(context, failure.message);
                              }
                          }
                        },
                      },
                    ],
                  ),
                );
              },
              child: const Icon(Icons.more_vert, size: 20),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              ChatProductBanner(roomId: roomId),
              AppointmentButton(roomId: roomId),
              Divider(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                thickness: 1,
              ),
              ChatMessageList(roomId: roomId),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  bottom: 10,
                  top: 10,
                ),
                child: isInteractionBlocked
                    ? _BlockedInputPlaceholder(message: blockedMessage)
                    : ChatInputField(roomId: roomId),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BlockedInputPlaceholder extends StatelessWidget {
  final String message;
  const _BlockedInputPlaceholder({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }
}
