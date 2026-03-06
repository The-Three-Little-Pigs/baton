import 'package:baton/views/widgets/complete_button.dart';
import 'package:baton/views/write/viewmodel/category_notifier.dart';
import 'package:baton/views/write/viewmodel/content_notifier.dart';
import 'package:baton/views/write/viewmodel/sale_notifier.dart';
import 'package:baton/views/write/viewmodel/write_page_view_model.dart';
import 'package:baton/core/utils/validation/write_validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BottomCompleteBar extends ConsumerWidget {
  const BottomCompleteBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(writePageViewModelProvider).isLoading;
    final content = ref.watch(contentProvider);
    final category = ref.watch(categoryProvider);
    final sale = ref.watch(saleProvider);

    final condition =
        WriteValidation.validateTitle(content.title) == null &&
        WriteValidation.validateCategory(category) == null &&
        WriteValidation.validateContent(content.content) == null &&
        WriteValidation.validatePrice(sale.purchasePrice) == null;

    return Row(
      children: [
        Expanded(
          child: CompleteButton(
            label: "작성 완료",
            isLoading: isLoading,
            condition: condition,
            onPressed: () async {
              final errorMessage = ref
                  .read(writePageViewModelProvider.notifier)
                  .validate();

              if (errorMessage != null) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(errorMessage),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }
              final result = await ref
                  .read(writePageViewModelProvider.notifier)
                  .createPost();

              if (result != null) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(result),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }

              if (!context.mounted) return;
              context.go('/home');
            },
          ),
        ),
      ],
    );
  }
}
