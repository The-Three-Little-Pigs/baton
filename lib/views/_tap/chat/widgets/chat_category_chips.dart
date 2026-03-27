import 'package:baton/models/enum/chat_status.dart';
import 'package:baton/views/_tap/chat/viewmodel/selected_chat_status_provider.dart';
import 'package:baton/views/widgets/category_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatCategoryChips extends ConsumerWidget {
  const ChatCategoryChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedStatus = ref.watch(selectedChatStatusProvider);

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: ChatStatus.values.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final chatStatus = ChatStatus.values[index];
          return CategoryTag(
            label: chatStatus.label,
            isSelected: selectedStatus == chatStatus,
            onTap: () {
              ref
                  .read(selectedChatStatusProvider.notifier)
                  .setStatus(chatStatus);
            },
            showDeleteIcon: false,
          );
        },
      ),
    );
  }
}
