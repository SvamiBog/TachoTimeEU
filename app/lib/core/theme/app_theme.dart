import 'package:flutter/material.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';

ThemeData buildTheme(Brightness brightness) {
  final c = brightness == Brightness.dark ? AppColors.dark : AppColors.light;
  bool selected(Set<WidgetState> states) =>
      states.contains(WidgetState.selected);
  return ThemeData(
    brightness: brightness,
    fontFamily: AppFonts.ui,
    scaffoldBackgroundColor: c.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: c.drive,
      brightness: brightness,
      primary: c.drive,
      onPrimary: c.onAccent,
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
    iconTheme: IconThemeData(color: c.text),
    // Нижняя навигация: выбранная вкладка — плашка цвета вождения.
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: c.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      height: 80,
      indicatorColor: c.drive,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => AppTextStyles.label.copyWith(
          color: selected(states) ? c.text : c.textSecondary,
          fontWeight: selected(states) ? FontWeight.w700 : FontWeight.w600,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          size: 22,
          color: selected(states) ? c.onAccent : c.textSecondary,
        ),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: c.background,
      surfaceTintColor: Colors.transparent,
      dragHandleColor: c.switchOff,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.heroCard),
        ),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: c.surface2,
      contentTextStyle: AppTextStyles.body.copyWith(color: c.text),
      behavior: SnackBarBehavior.floating,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: c.drive),
    extensions: [c],
  );
}
