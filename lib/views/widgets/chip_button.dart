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
    final primaryColor = Theme.of(context).colorScheme.primary;
    const inactiveColor = Color(0xFF5E6876);

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      backgroundColor: Colors.transparent,
      selectedColor: primaryColor,
      surfaceTintColor: Colors.transparent,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : inactiveColor,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      side: BorderSide(
        color: isSelected ? primaryColor : inactiveColor,
        width: 1,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(999)),
      ),
    );
  }
}
