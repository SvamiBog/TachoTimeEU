import 'package:flutter/material.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_typography.dart';

ThemeData buildTheme(Brightness brightness) {
  final c = brightness == Brightness.dark ? AppColors.dark : AppColors.light;
  return ThemeData(
    brightness: brightness,
    fontFamily: AppFonts.ui,
    scaffoldBackgroundColor: c.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: c.drive,
      brightness: brightness,
      primary: c.drive,
      surface: c.surface,
      onSurface: c.text,
      error: c.errorText,
    ),
    textTheme: const TextTheme(
      headlineMedium: AppTextStyles.screenTitle,
      titleLarge: AppTextStyles.header,
      titleMedium: AppTextStyles.rowTitle,
      bodyMedium: AppTextStyles.body,
      bodySmall: AppTextStyles.caption,
    ).apply(bodyColor: c.text, displayColor: c.text),
    extensions: [c],
  );
}
