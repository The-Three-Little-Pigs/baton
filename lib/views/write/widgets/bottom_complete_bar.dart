import 'package:baton/views/widgets/complete_button.dart';
import 'package:baton/views/write/viewmodel/category_notifier.dart';
import 'package:baton/views/write/viewmodel/content_notifier.dart';
import 'package:baton/views/write/viewmodel/image_notifier.dart';
import 'package:baton/views/write/viewmodel/sale_notifier.dart';
import 'package:baton/views/write/viewmodel/write_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:baton/core/utils/ui/app_snackbar.dart';

class BottomCompleteBar extends ConsumerWidget {
  const BottomCompleteBar({super.key, this.postId});

  final String? postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = writePageViewModelProvider(postId: postId);
    final isEditMode = postId != null;

    // 실시간 상태 반영을 위해 개별 Notifier를 단순 구독 (Flutter의 렌더링 성능을 신뢰하는 방식)
    ref.watch(contentProvider);
    ref.watch(saleProvider);
    ref.watch(categoryProvider);
    ref.watch(imageProvider);
    
    final isLoading = ref.watch(viewModelProvider).isLoading;
    final viewModel = ref.read(viewModelProvider.notifier);
    
    final validationError = viewModel.validate();
    final canSubmit = validationError == null && !isLoading;

    return Row(
      children: [
        Expanded(
          child: CompleteButton(
            label: isEditMode ? "수정 완료" : "작성 완료",
            color: canSubmit ? null : Colors.grey,
            onPressed: () async {
              // 이미 validationError를 구독하고 있으므로 별도 호출 없이 처리 가능
              if (validationError != null) {
                AppSnackBar.show(context, validationError);
                return;
              }
              FocusScope.of(context).unfocus();

              final viewModel = ref.read(viewModelProvider.notifier);
              final result = await viewModel.submitPost();

              if (result == "success") {
                if (context.mounted) context.pop();
              } else if (result != null) {
                // 에러 발생 시 사용자에게 메시지 표시
                if (context.mounted) {
                  AppSnackBar.show(context, result);
                }
              }
            },
          ),
        ),
      ],
    );
  }
}
