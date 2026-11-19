/// Material theme of the app built from the design tokens.
library;

import 'package:flutter/material.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';

ThemeData buildTheme(Brightness brightness) {
  final c = brightness == Brightness.dark ? AppColors.dark : AppColors.light;
  return ThemeData(
    brightness: brightness,
    fontFamily: AppFonts.ui,
    fontFamilyFallback: const [AppFonts.fallback],
    scaffoldBackgroundColor: c.background,
    colorScheme: _colorScheme(c, brightness),
    textTheme: _textTheme(c),
    iconTheme: IconThemeData(color: c.text),
    navigationBarTheme: _navigationBarTheme(c),
    bottomSheetTheme: _bottomSheetTheme(c),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: c.surface2,
      contentTextStyle: AppTextStyles.body.copyWith(color: c.text),
      behavior: SnackBarBehavior.floating,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: c.drive),
    switchTheme: _switchTheme(c),
    extensions: [c],
  );
}

bool _selected(Set<WidgetState> states) =>
    states.contains(WidgetState.selected);

ColorScheme _colorScheme(AppColors c, Brightness brightness) =>
    ColorScheme.fromSeed(
      seedColor: c.drive,
      brightness: brightness,
      primary: c.drive,
      onPrimary: c.onAccent,
      surface: c.surface,
      onSurface: c.text,
      error: c.errorText,
    );

TextTheme _textTheme(AppColors c) => const TextTheme(
  headlineMedium: AppTextStyles.screenTitle,
  titleLarge: AppTextStyles.header,
  titleMedium: AppTextStyles.rowTitle,
  bodyMedium: AppTextStyles.body,
  bodySmall: AppTextStyles.caption,
).apply(bodyColor: c.text, displayColor: c.text);

/// Нижняя навигация: выбранная вкладка — плашка цвета вождения.
NavigationBarThemeData _navigationBarTheme(AppColors c) =>
    NavigationBarThemeData(
      backgroundColor: c.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      height: 80,
      indicatorColor: c.drive,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => AppTextStyles.label.copyWith(
          color: _selected(states) ? c.text : c.textSecondary,
          fontWeight: _selected(states) ? FontWeight.w700 : FontWeight.w600,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          size: 22,
          color: _selected(states) ? c.onAccent : c.textSecondary,
        ),
      ),
    );

BottomSheetThemeData _bottomSheetTheme(AppColors c) => BottomSheetThemeData(
  backgroundColor: c.background,
  surfaceTintColor: Colors.transparent,
  dragHandleColor: c.switchOff,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
      top: Radius.circular(AppRadius.heroCard),
    ),
  ),
);

/// Переключатель: включён — цвет вождения, выключен — токен switchOff.
SwitchThemeData _switchTheme(AppColors c) => SwitchThemeData(
  trackColor: WidgetStateProperty.resolveWith(
    (states) => _selected(states) ? c.drive : c.switchOff,
  ),
  thumbColor: WidgetStateProperty.resolveWith(
    (states) => _selected(states) ? c.onAccent : c.textSecondary,
  ),
  trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
);
