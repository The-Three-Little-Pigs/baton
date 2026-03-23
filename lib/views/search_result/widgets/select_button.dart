import 'package:flutter/material.dart';

class SelectButton extends StatelessWidget {
  const SelectButton({
    super.key,
    required this.label,
    required this.isSelected,
  });

  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: Color(0xFFCDD8E7)),
      ),
      child: Row(
        spacing: 4,
        children: [
          Icon(Icons.circle, size: 18),
          Text(
            label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
