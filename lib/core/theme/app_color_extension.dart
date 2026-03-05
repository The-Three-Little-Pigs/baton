import 'package:flutter/material.dart';

@immutable
class AppColorExtension extends ThemeExtension<AppColorExtension> {
  const AppColorExtension({
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textHint,
    required this.textDisabled,
    required this.divider,
    required this.kakaoYellow,
    required this.naverGreen,
  });

  final Color? textPrimary;
  final Color? textSecondary;
  final Color? textTertiary;
  final Color? textHint;
  final Color? textDisabled;
  final Color? divider;
  final Color? kakaoYellow;
  final Color? naverGreen;

  @override
  AppColorExtension copyWith({
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textHint,
    Color? textDisabled,
    Color? divider,
    Color? kakaoYellow,
    Color? naverGreen,
  }) {
    return AppColorExtension(
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textHint: textHint ?? this.textHint,
      textDisabled: textDisabled ?? this.textDisabled,
      divider: divider ?? this.divider,
      kakaoYellow: kakaoYellow ?? this.kakaoYellow,
      naverGreen: naverGreen ?? this.naverGreen,
    );
  }

  @override
  AppColorExtension lerp(ThemeExtension<AppColorExtension>? other, double t) {
    if (other is! AppColorExtension) {
      return this;
    }
    return AppColorExtension(
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t),
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t),
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t),
      textHint: Color.lerp(textHint, other.textHint, t),
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t),
      divider: Color.lerp(divider, other.divider, t),
      kakaoYellow: Color.lerp(kakaoYellow, other.kakaoYellow, t),
      naverGreen: Color.lerp(naverGreen, other.naverGreen, t),
    );
  }
}
