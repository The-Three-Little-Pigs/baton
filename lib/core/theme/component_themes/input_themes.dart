import 'package:flutter/material.dart';

class InputThemes {
  static InputDecorationTheme inputDecorationTheme(ColorScheme colors) {
    return InputDecorationTheme(
      border: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.outline),
      ),
      enabledBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.outline),
      ),
      focusedBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.outline),
      ),
    );
  }
}
