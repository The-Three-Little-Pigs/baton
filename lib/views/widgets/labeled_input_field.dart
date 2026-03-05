import 'package:baton/views/widgets/input_field.dart';
import 'package:flutter/material.dart';

class LabeledInputField extends StatelessWidget {
  const LabeledInputField({
    super.key,
    required this.label,
    required this.hintText,
    required this.isPriceSection,
  });

  final String label;
  final String hintText;
  final bool isPriceSection;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFB5C1D0)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ),
            const VerticalDivider(
              color: Color(0xFFB3B3B3),
              thickness: 1,
              width: 1,
            ),
            Expanded(
              child: InputField(
                maxLines: 1,
                isPriceSection: isPriceSection,
                hintText: hintText,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
