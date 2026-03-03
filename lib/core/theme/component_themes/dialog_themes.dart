import 'package:flutter/material.dart';

class DialogThemes {
  static SnackBarThemeData snackBarThemeData(ColorScheme colors) {
    return SnackBarThemeData(
      backgroundColor: colors.surfaceContainerHighest,
      contentTextStyle: TextStyle(fontSize: 14, color: colors.primary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
      behavior: SnackBarBehavior.floating,
    );
  }
}
