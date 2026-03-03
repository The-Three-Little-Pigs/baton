import 'package:baton/core/theme/app_tokens/app_colors.dart';
import 'package:flutter/material.dart';

class ColorSchemes {
  static const ColorScheme lightColorScheme = ColorScheme.light(
    primary: AppColors.lightprimary,
    onPrimary: AppColors.lightOnPrimary,
    secondary: AppColors.lightsecondary,
    onSecondary: AppColors.lightOnSecondary,
    surface: AppColors.lightSurface,
    onSurface: AppColors.lightText,
    error: AppColors.lightError,
    surfaceContainerHighest: AppColors.lightVariant,
    outline: AppColors.lightBorder,
  );
}
