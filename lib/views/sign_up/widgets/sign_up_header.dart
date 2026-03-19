// lib/views/sign_up/widgets/sign_up_header.dart
import 'package:baton/core/theme/app_color_extension.dart';
import 'package:flutter/material.dart';

class SignUpHeader extends StatelessWidget {
  final int step;
  const SignUpHeader({super.key, this.step = 1});

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
              Icon(
                Icons.circle,
                size: 8,
                color: step == 1
                    ? colors.primary
                    : (appColors?.textTertiary ?? Colors.grey),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.circle,
                size: 8,
                color: step == 2
                    ? colors.primary
                    : (appColors?.textTertiary ?? Colors.grey),
              ),
            ],
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}
