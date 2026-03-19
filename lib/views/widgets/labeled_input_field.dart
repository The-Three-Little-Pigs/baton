import 'package:baton/core/theme/app_color_extension.dart';
import 'package:baton/views/widgets/input_field.dart';
import 'package:flutter/material.dart';

class LabeledInputField extends StatelessWidget {
  const LabeledInputField({
    super.key,
    required this.label,
    required this.hintText,
    required this.isPriceSection,
    this.onChanged,
    this.border,
    this.controller,
  });

  final String label;
  final String hintText;
  final bool isPriceSection;
  final void Function(String)? onChanged;
  final BoxBorder? border;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final appColors = theme.extension<AppColorExtension>();

    return Container(
      decoration: BoxDecoration(
        border: border,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colors.onSurface,
                ),
              ),
            ),
            VerticalDivider(color: appColors?.divider, thickness: 1, width: 1),
            Expanded(
              child: InputField(
                controller: controller,
                maxLines: 1,
                isPriceSection: isPriceSection,
                hintText: hintText,
                onChanged: onChanged,
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
