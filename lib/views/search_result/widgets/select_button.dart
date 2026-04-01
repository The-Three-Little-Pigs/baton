import 'package:baton/core/theme/app_tokens/app_colors.dart';
import 'package:flutter/material.dart';

class SelectCircle extends StatelessWidget {
  const SelectCircle({
    super.key,
    required this.isSelected,
  });

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : const Color(0xFFFCFDFF),
        shape: BoxShape.circle,
        border: isSelected ? null : Border.all(color: AppColors.divider),
      ),
      child: isSelected
          ? const Icon(
              Icons.check,
              size: 14,
              color: Colors.white,
            )
          : null,
    );
  }
}
