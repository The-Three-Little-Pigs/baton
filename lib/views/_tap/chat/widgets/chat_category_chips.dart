import 'package:baton/models/enum/chat_status.dart';
import 'package:flutter/material.dart';

class ChatCategoryChips extends StatelessWidget {
  const ChatCategoryChips({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20, right: 0, top: 8, bottom: 8),
        itemCount: ChatStatus.values.length,
        separatorBuilder: (context, index) {
          return const SizedBox(width: 8);
        },
        itemBuilder: (context, index) {
          return ChoiceChip(
            label: Text(ChatStatus.values[index].name),
            selected: false,
            onSelected: (value) {},
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(999)),
            ),
          );
        },
      ),
    );
  }
}
