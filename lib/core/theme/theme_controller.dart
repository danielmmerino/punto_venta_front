import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_theme.dart';

final themeControllerProvider =
    StateNotifierProvider<ThemeController, ThemeData>((ref) {
  return ThemeController()..load();
});

class ThemeController extends StateNotifier<ThemeData> {
  ThemeController() : super(ThemeData(useMaterial3: true));

  Future<void> load() async {
    final data = await rootBundle.loadString('assets/theme/theme.json');
    final jsonMap = json.decode(data) as Map<String, dynamic>;
    final colors = AppColors.fromJson(jsonMap);
    final spacing = AppSpacing.fromJson(jsonMap['spacing']);
    final radius = AppRadius.fromJson(jsonMap['radius']);
    state = buildAppTheme(colors, spacing, radius);
  }
}
