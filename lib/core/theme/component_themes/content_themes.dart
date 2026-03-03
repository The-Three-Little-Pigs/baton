import 'package:flutter/material.dart';

class ContentThemes {
  static ChipThemeData chipThemeData(ColorScheme colors) {
    return ChipThemeData(
      backgroundColor: colors.surface,
      selectedColor: colors.surface,
      disabledColor: colors.surface,
      showCheckmark: false,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelStyle: TextStyle(fontSize: 14, color: colors.onSurface),
      secondaryLabelStyle: TextStyle(fontSize: 14, color: colors.primary),
      side: BorderSide(color: colors.outline),
    );
  }

  static AppBarTheme appBarTheme(ColorScheme colors) {
    return AppBarTheme(
      titleSpacing: 20,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      titleTextStyle: TextStyle(fontSize: 22, color: colors.onSurface),
      actionsIconTheme: IconThemeData(color: colors.onSurface),
      iconTheme: IconThemeData(color: colors.onSurface),
      actionsPadding: const EdgeInsets.only(right: 20),
    );
  }

  static BottomNavigationBarThemeData navigationBarThemeData(
    ColorScheme colors,
  ) {
    return BottomNavigationBarThemeData(
      backgroundColor: colors.surface,
      selectedItemColor: colors.primary,
      unselectedItemColor: colors.secondary,
      selectedLabelStyle: TextStyle(fontSize: 12, color: colors.primary),
    );
  }
}
