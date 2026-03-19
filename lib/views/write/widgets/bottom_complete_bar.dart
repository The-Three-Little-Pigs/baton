import 'package:baton/views/widgets/complete_button.dart';
import 'package:baton/views/write/viewmodel/write_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BottomCompleteBar extends ConsumerWidget {
  const BottomCompleteBar({super.key, this.postId});

  final String? postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = writePageViewModelProvider(postId: postId);
    final isEditMode = postId != null;

    return Row(
      children: [
        Expanded(
          child: CompleteButton(
            label: isEditMode ? "수정 완료" : "작성 완료",
            // condition: condition,
            onPressed: () async {
              final viewModel = ref.read(viewModelProvider.notifier);
              final errorMessage = viewModel.validate();

              if (errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(errorMessage),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }
              FocusScope.of(context).unfocus();

              final result = await viewModel.submitPost();

              if (result == "success") {
                if (context.mounted) context.pop();
              }
            },
          ),
        ),
      ],
    );
  }
}
