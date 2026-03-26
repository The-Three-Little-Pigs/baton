import 'package:baton/core/theme/app_tokens/app_spacing.dart';
import 'package:flutter/material.dart';

class AppSnackBar {
  static void show(
    BuildContext context,
    String message, {
    IconData icon = Icons.info,
  }) {
    final colors = Theme.of(context).colorScheme;

    // 현재 띄워져 있는 스낵바가 있다면 숨기고 새로 띄움 (중복 방지)
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        width: 230,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: colors.primary, size: 18),
            AppSpacing.w8,
            Flexible(
              child: Text(
                message,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
