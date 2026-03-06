import 'package:flutter/material.dart';

class CategorySelectButton extends StatelessWidget {
  const CategorySelectButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: ShapeDecoration(
        color: const Color(0xFFFCFDFE),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: const Color(0xFFB5C1D0)),
          borderRadius: BorderRadius.circular(999),
        ),
      ),
      child: Icon(
        Icons.tune_outlined,
        size: 20,
        color: theme.colorScheme.onSurface,
      ),
    );
  }
}
