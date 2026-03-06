// lib/views/sign_up/widgets/sign_up_header.dart
import 'package:baton/core/theme/app_color_extension.dart';
import 'package:flutter/material.dart';

class SignUpHeader extends StatelessWidget {
  const SignUpHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final appColors = theme.extension<AppColorExtension>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "회원가입",
              style: TextStyle(
                color: colors.outline,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.circle, size: 8, color: colors.primary),
              const SizedBox(width: 4),
              Icon(
                Icons.circle,
                size: 8,
                color: appColors?.textTertiary ?? Colors.grey,
              ),
            ],
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}
