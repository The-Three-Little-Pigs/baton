import 'package:baton/core/theme/app_tokens/app_colors.dart';
import 'package:baton/views/chat_detail/widgets/appointment_button.dart';
import 'package:baton/views/chat_detail/dialog/apponitment_bottom_sheet.dart';
import 'package:baton/views/chat_detail/widgets/chat_input_field.dart';
import 'package:baton/views/chat_detail/widgets/chat_message_list.dart';
import 'package:baton/views/chat_detail/widgets/chat_product_banner.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatDetailPage extends StatelessWidget {
  const ChatDetailPage({super.key, required this.roomId});

  final String roomId;

  @override
  Widget build(BuildContext context) {
    // TODO: 약속하기 버튼 완성하면 지우기
    Future.delayed(
      Duration.zero,
      () => AppointmentBottomSheet.showAppointmentDialog(context),
    );
    return Scaffold(
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
            '홍길동',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        centerTitle: true,
        actions: [Icon(Icons.more_vert, size: 24)],
      ),
      body: Column(
        children: [
          ChatProductBanner(),
          // TODO: 리스트뷰 안에 넣어서 특정날짜 되면 띄우기
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                '2026년 3월 3일',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textTertiary,
                ),
              ),
            ),
          ),
          ChatMessageList(),
          AppointmentButton(),
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
              bottom: 30,
              top: 10,
            ),
            child: ChatInputField(),
          ),
        ],
      ),
    );
  }
}
