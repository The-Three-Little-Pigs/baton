import 'package:baton/core/theme/app_tokens/app_colors.dart';

import 'package:baton/notifier/user/user_notifier.dart';
import 'package:baton/views/chat_detail/viewmodel.dart/chat_detail_notifier.dart';
import 'package:baton/views/chat_detail/widgets/appointment_button.dart';
import 'package:baton/views/chat_detail/widgets/chat_input_field.dart';
import 'package:baton/views/chat_detail/widgets/chat_message_list.dart';
import 'package:baton/views/chat_detail/widgets/chat_product_banner.dart';
import 'package:baton/views/product_detail/viewmodel/author_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    final myUserId = ref.watch(userProvider).value?.uid;
    final parts = roomId.split('_');
    final otherUid = (parts.length >= 2)
        ? (parts[0] == myUserId ? parts[1] : parts[0])
        : '';
    final chatroomState = ref.watch(chatRoomStreamProvider(roomId));
    final opponentAsync = ref.watch(authorProvider(otherUid));
    final opponentNickname = opponentAsync.when(
      data: (user) => user.nickname,
      loading: () => '...',
      error: (_, __) => '알 수 없는 사용자',
    );
    // 1. 초기 진입 시 또는 상태 변경 시 모두 체크하기 위해
    // ref.listen 대신 ref.watch로 값을 일단 가져오고 조용히 업데이트를 쏩니다.
    if (myUserId != null && chatroomState.value != null) {
      final unread = chatroomState.value!.unreadCounts[myUserId] ?? 0;

      if (unread > 0) {
        // 2. build 도중에 상태를 변경하면 프레임워크 에러가 나므로,
        // UI가 다 그려진 직후(PostFrame)에 비동기로 실행되게끔 안전하게 감싸줍니다.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(chatDetailProvider(roomId).notifier).markAsRead(roomId);
        });
      }
    }

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
          actions: [Icon(Icons.more_vert, size: 24)],
        ),
        body: Column(
          children: [
            ChatProductBanner(roomId: roomId),
            AppointmentButton(),
            Divider(color: AppColors.secondary, thickness: 1),
            // TODO: 리스트뷰 안에 넣어서 특정날짜 되면 띄우기
            ChatMessageList(roomId: roomId),
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                bottom: 30,
                top: 10,
              ),
              child: ChatInputField(roomId: roomId),
            ),
          ],
        ),
      ),
    );
  }
}
