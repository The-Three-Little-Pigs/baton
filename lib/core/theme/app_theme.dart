import 'package:baton/core/theme/color_schemes.dart';
import 'package:baton/core/theme/component_themes/button_themes.dart';
import 'package:baton/core/theme/component_themes/content_themes.dart';
import 'package:baton/core/theme/component_themes/dialog_themes.dart';
import 'package:baton/core/theme/component_themes/input_themes.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light {
    final colors = ColorSchemes.lightColorScheme;

    return ThemeData(
      useMaterial3: true,
      fontFamily: 'PretendardGOV',
      colorScheme: colors,
      floatingActionButtonTheme: ButtonThemes.floatingActionButtonThemeData(
        colors,
      ),
      elevatedButtonTheme: ButtonThemes.elevatedButtonThemeData(colors),
      snackBarTheme: DialogThemes.snackBarThemeData(colors),
      appBarTheme: ContentThemes.appBarTheme(colors),
      chipTheme: ContentThemes.chipThemeData(colors),
      bottomNavigationBarTheme: ContentThemes.navigationBarThemeData(colors),
      inputDecorationTheme: InputThemes.inputDecorationTheme(colors),
    );
  }
}
