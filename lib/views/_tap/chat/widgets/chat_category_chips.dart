import 'package:baton/models/enum/chat_status.dart';
import 'package:baton/views/widgets/category_tag.dart';
import 'package:flutter/material.dart';

class ChatCategoryChips extends StatelessWidget {
  const ChatCategoryChips({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        // padding: const EdgeInsets.only(left: 20, right: 0, top: 8, bottom: 8),
        itemCount: ChatStatus.values.length,
        separatorBuilder: (context, index) {
          return const SizedBox(width: 8);
        },
        itemBuilder: (context, index) {
          final chatStatus = ChatStatus.values[index];
          return CategoryTag(
            label: chatStatus.label,
            isSelected: false,
            onTap: () {},
            showDeleteIcon: false,
          );
        },
      ),
    );
  }
}
