import 'package:baton/core/theme/app_tokens/app_colors.dart';
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
          _AppointmentButton(),
          ChatInputField(),
        ],
      ),
    );
  }
}

class _AppointmentButton extends StatelessWidget {
  const _AppointmentButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '약속하기',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.textTertiary,
        ),
      ),
    );
  }
}
