import 'dart:ui';
import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.brandPrimary,
    required this.brandSecondary,
    required this.brandTertiary,
    required this.n0,
    required this.n100,
    required this.n200,
    required this.n300,
    required this.n400,
    required this.n500,
    required this.n600,
    required this.n700,
    required this.n800,
    required this.n900,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    required this.surfaceAlt,
    required this.overlay,
    required this.divider,
  });

  final Color brandPrimary;
  final Color brandSecondary;
  final Color brandTertiary;
  final Color n0;
  final Color n100;
  final Color n200;
  final Color n300;
  final Color n400;
  final Color n500;
  final Color n600;
  final Color n700;
  final Color n800;
  final Color n900;
  final Color success;
  final Color warning;
  final Color error;
  final Color info;
  final Color surfaceAlt;
  final Color overlay;
  final Color divider;

  static Color _parse(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  static AppColors fromJson(Map<String, dynamic> json) {
    final brand = json['brand'] as Map<String, dynamic>;
    final neutrals = json['neutrals'] as Map<String, dynamic>;
    final semantic = json['semantic'] as Map<String, dynamic>;
    final surfaces = json['surfaces'] as Map<String, dynamic>;
    return AppColors(
      brandPrimary: _parse(brand['primary'] as String),
      brandSecondary: _parse(brand['secondary'] as String),
      brandTertiary: _parse(brand['tertiary'] as String),
      n0: _parse(neutrals['n0'] as String),
      n100: _parse(neutrals['n100'] as String),
      n200: _parse(neutrals['n200'] as String),
      n300: _parse(neutrals['n300'] as String),
      n400: _parse(neutrals['n400'] as String),
      n500: _parse(neutrals['n500'] as String),
      n600: _parse(neutrals['n600'] as String),
      n700: _parse(neutrals['n700'] as String),
      n800: _parse(neutrals['n800'] as String),
      n900: _parse(neutrals['n900'] as String),
      success: _parse(semantic['success'] as String),
      warning: _parse(semantic['warning'] as String),
      error: _parse(semantic['error'] as String),
      info: _parse(semantic['info'] as String),
      surfaceAlt: _parse(surfaces['surfaceAlt'] as String),
      overlay: _parse(surfaces['overlay'] as String),
      divider: _parse(surfaces['divider'] as String),
    );
  }

  @override
  AppColors copyWith({
    Color? brandPrimary,
    Color? brandSecondary,
    Color? brandTertiary,
    Color? n0,
    Color? n100,
    Color? n200,
    Color? n300,
    Color? n400,
    Color? n500,
    Color? n600,
    Color? n700,
    Color? n800,
    Color? n900,
    Color? success,
    Color? warning,
    Color? error,
    Color? info,
    Color? surfaceAlt,
    Color? overlay,
    Color? divider,
  }) {
    return AppColors(
      brandPrimary: brandPrimary ?? this.brandPrimary,
      brandSecondary: brandSecondary ?? this.brandSecondary,
      brandTertiary: brandTertiary ?? this.brandTertiary,
      n0: n0 ?? this.n0,
      n100: n100 ?? this.n100,
      n200: n200 ?? this.n200,
      n300: n300 ?? this.n300,
      n400: n400 ?? this.n400,
      n500: n500 ?? this.n500,
      n600: n600 ?? this.n600,
      n700: n700 ?? this.n700,
      n800: n800 ?? this.n800,
      n900: n900 ?? this.n900,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      info: info ?? this.info,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      overlay: overlay ?? this.overlay,
      divider: divider ?? this.divider,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      brandPrimary: Color.lerp(brandPrimary, other.brandPrimary, t)!,
      brandSecondary: Color.lerp(brandSecondary, other.brandSecondary, t)!,
      brandTertiary: Color.lerp(brandTertiary, other.brandTertiary, t)!,
      n0: Color.lerp(n0, other.n0, t)!,
      n100: Color.lerp(n100, other.n100, t)!,
      n200: Color.lerp(n200, other.n200, t)!,
      n300: Color.lerp(n300, other.n300, t)!,
      n400: Color.lerp(n400, other.n400, t)!,
      n500: Color.lerp(n500, other.n500, t)!,
      n600: Color.lerp(n600, other.n600, t)!,
      n700: Color.lerp(n700, other.n700, t)!,
      n800: Color.lerp(n800, other.n800, t)!,
      n900: Color.lerp(n900, other.n900, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      info: Color.lerp(info, other.info, t)!,
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
    );
  }
}
