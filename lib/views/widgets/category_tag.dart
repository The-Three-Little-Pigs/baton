import 'package:flutter/material.dart';

class CategoryTag extends StatelessWidget {
  const CategoryTag({
    super.key,
    required this.label,
    this.isSelected = false,
    this.showDeleteIcon = false,
    this.onTap,
    this.onDelete,
  });

  final String label;
  final bool isSelected;
  final bool showDeleteIcon;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Baton 디자인 가이드에 맞춘 색상 정의
    final primaryColor = theme.colorScheme.primary;
    final unselectedBorderColor = const Color(0xFFE2E8F0);
    final unselectedTextColor = const Color(0xFF64748B);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected ? primaryColor : unselectedBorderColor,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? primaryColor : unselectedTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (showDeleteIcon) ...[
              const SizedBox(width: 4),
              GestureDetector(
                onTap: onDelete ?? onTap,
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: isSelected ? primaryColor : unselectedTextColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
