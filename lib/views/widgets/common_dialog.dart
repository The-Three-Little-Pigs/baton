import 'package:baton/core/theme/app_tokens/app_colors.dart';
import 'package:flutter/material.dart';

class CommonDialog extends StatelessWidget {
  final String title;
  final String content;
  final String leftText;
  final String rightText;
  final VoidCallback onLeftTap;
  final VoidCallback onRightTap;
  final Color? rightBackgroundColor;
  final Color? leftTextColor;
  final Color? rightTextColor;

  const CommonDialog({
    super.key,
    required this.title,
    required this.content,
    required this.leftText,
    required this.rightText,
    required this.onLeftTap,
    required this.onRightTap,
    this.rightBackgroundColor,
    this.leftTextColor,
    this.rightTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: AppColors.white,
      surfaceTintColor: AppColors.white,
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 32),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              content,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onLeftTap,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    height: 52,
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: AppColors.surfaceVariant, width: 1),
                        right: BorderSide(color: AppColors.surfaceVariant, width: 1),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      leftText,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: leftTextColor ?? AppColors.textTertiary,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: onRightTap,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: rightBackgroundColor ?? AppColors.primary,
                      border: Border(
                        top: BorderSide(
                          color: rightBackgroundColor ?? AppColors.primary, 
                          width: 1,
                        ),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      rightText,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: rightTextColor ?? AppColors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
