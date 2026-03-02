import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(999)),
      ),
    );
  }
}
