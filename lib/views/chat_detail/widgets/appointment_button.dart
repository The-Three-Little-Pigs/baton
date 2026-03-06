import 'package:baton/core/theme/app_tokens/app_colors.dart';
import 'package:baton/views/chat_detail/dialog/apponitment_bottom_sheet.dart';
import 'package:flutter/material.dart';

class AppointmentButton extends StatelessWidget {
  const AppointmentButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: () => AppointmentBottomSheet.showAppointmentDialog(context),
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Text(
            '약속하기',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textTertiary,
            ),
          ),
        ),
      ),
    );
  }
}
