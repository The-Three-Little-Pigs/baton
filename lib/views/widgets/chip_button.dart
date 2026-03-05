import 'package:baton/core/theme/app_color_extension.dart';
import 'package:flutter/material.dart';

class ChipButton extends StatelessWidget {
  const ChipButton({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onSelected,
  });

  final String label;
  final bool isSelected;
  final ValueChanged<bool>? onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final appColors = theme.extension<AppColorExtension>();

    final inactiveColor = appColors?.textSecondary ?? Colors.grey;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      backgroundColor: Colors.transparent,
      selectedColor: colors.primary,
      surfaceTintColor: Colors.transparent,
      labelStyle: TextStyle(
        color: isSelected ? colors.onPrimary : inactiveColor,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      side: BorderSide(
        color: isSelected ? colors.primary : inactiveColor,
        width: 1,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(999)),
      ),
    );
  }
}
