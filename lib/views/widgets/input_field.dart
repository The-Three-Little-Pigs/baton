import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required this.hintText,
    this.icon,
    this.onChanged,
    this.maxLength,
    this.maxLines,
    this.contentPadding,
    this.border,
    this.isPriceSection,
  });

  final String hintText;
  final Icon? icon;
  final void Function(String)? onChanged;
  final int? maxLength;
  final int? maxLines;
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? border;
  final bool? isPriceSection;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      maxLength: maxLength,
      maxLines: maxLines,
      inputFormatters: isPriceSection == true
          ? [FilteringTextInputFormatter.digitsOnly]
          : null,
      decoration: InputDecoration(
        counterText: "",
        contentPadding:
            contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        hintText: hintText,
        hintStyle: TextStyle(color: Color(0xFFB3B3B3)),
        prefixIcon: icon,
      ),
    );
  }
}
