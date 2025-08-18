import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';

/// Builds a [ThemeData] instance from tokens.
ThemeData buildAppTheme(
  AppColors colors,
  AppSpacing spacing,
  AppRadius radius,
) {
  final scheme = ColorScheme.fromSeed(seedColor: colors.brandPrimary);
  return ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    extensions: <ThemeExtension<dynamic>>[
      colors,
      spacing,
      radius,
    ],
  );
}
