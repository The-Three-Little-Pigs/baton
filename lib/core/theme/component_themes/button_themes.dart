import 'package:flutter/material.dart';

class ButtonThemes {
  static ElevatedButtonThemeData elevatedButtonThemeData(ColorScheme colors) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primary;
          }
          return colors.secondary;
        }),
        foregroundColor: colors.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  static FloatingActionButtonThemeData floatingActionButtonThemeData(
    ColorScheme colors,
  ) {
    return FloatingActionButtonThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      elevation: 0,
      extendedPadding: const EdgeInsets.only(
        top: 10,
        bottom: 10,
        left: 12,
        right: 16,
      ),
      extendedTextStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
    );
  }
}
