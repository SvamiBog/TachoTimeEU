// Дизайн-токены TachoGo (вариант A «Кокпит»).
// Источник: docs/design/tokens.json. При изменении токенов обновлять оба файла.
// Радиусы и размеры — app_tokens.dart, типографика — app_typography.dart.

import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const new({
    required this.background,
    required this.surface,
    required this.surface2,
    required this.line,
    required this.text,
    required this.textSecondary,
    required this.drive,
    required this.rest,
    required this.work,
    required this.available,
    required this.warningBg,
    required this.warningText,
    required this.errorBg,
    required this.errorText,
    required this.switchOff,
    required this.scrim,
  });

  final Color background;
  final Color surface;
  final Color surface2;
  final Color line;
  final Color text;
  final Color textSecondary;

  /// Вождение — основной акцент.
  final Color drive;
  final Color rest;
  final Color work;

  /// Готовность.
  final Color available;
  final Color warningBg;
  final Color warningText;
  final Color errorBg;
  final Color errorText;
  final Color switchOff;

  /// Фон под шторкой (bottom sheet).
  final Color scrim;

  static const dark = AppColors(
    background: Color(0xFF111315),
    surface: Color(0xFF1A1D20),
    surface2: Color(0xFF262A2F),
    line: Color(0xFF2A2E33),
    text: Color(0xFFEDEBE6),
    textSecondary: Color(0xFFA3A8AE),
    drive: Color(0xFFF3B33D),
    rest: Color(0xFF4FBF9F),
    work: Color(0xFFEE8B5A),
    available: Color(0xFF86A8F0),
    warningBg: Color(0xFF2B2415),
    warningText: Color(0xFFF7D38A),
    errorBg: Color(0xFF2E1818),
    errorText: Color(0xFFFF9C94),
    switchOff: Color(0xFF3A3F45),
    scrim: Color(0xFF070808),
  );

  static const light = AppColors(
    background: Color(0xFFF4F2EE),
    surface: Color(0xFFFFFFFF),
    surface2: Color(0xFFECE9E3),
    line: Color(0xFFE4E0D8),
    text: Color(0xFF15171A),
    textSecondary: Color(0xFF5E636A),
    drive: Color(0xFFD48A00),
    rest: Color(0xFF1F8A6C),
    work: Color(0xFFC9562C),
    available: Color(0xFF3D64C9),
    warningBg: Color(0xFFFFF1D1),
    warningText: Color(0xFF7A4B00),
    errorBg: Color(0xFFFDE4E1),
    errorText: Color(0xFFA8261C),
    switchOff: Color(0xFFD6D2C9),
    scrim: Color(0xFF8A8680),
  );

  @override
  AppColors copyWith({
    Color? background,
    Color? surface,
    Color? surface2,
    Color? line,
    Color? text,
    Color? textSecondary,
    Color? drive,
    Color? rest,
    Color? work,
    Color? available,
    Color? warningBg,
    Color? warningText,
    Color? errorBg,
    Color? errorText,
    Color? switchOff,
    Color? scrim,
  }) => AppColors(
    background: background ?? this.background,
    surface: surface ?? this.surface,
    surface2: surface2 ?? this.surface2,
    line: line ?? this.line,
    text: text ?? this.text,
    textSecondary: textSecondary ?? this.textSecondary,
    drive: drive ?? this.drive,
    rest: rest ?? this.rest,
    work: work ?? this.work,
    available: available ?? this.available,
    warningBg: warningBg ?? this.warningBg,
    warningText: warningText ?? this.warningText,
    errorBg: errorBg ?? this.errorBg,
    errorText: errorText ?? this.errorText,
    switchOff: switchOff ?? this.switchOff,
    scrim: scrim ?? this.scrim,
  );

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColors(
      background: l(background, other.background),
      surface: l(surface, other.surface),
      surface2: l(surface2, other.surface2),
      line: l(line, other.line),
      text: l(text, other.text),
      textSecondary: l(textSecondary, other.textSecondary),
      drive: l(drive, other.drive),
      rest: l(rest, other.rest),
      work: l(work, other.work),
      available: l(available, other.available),
      warningBg: l(warningBg, other.warningBg),
      warningText: l(warningText, other.warningText),
      errorBg: l(errorBg, other.errorBg),
      errorText: l(errorText, other.errorText),
      switchOff: l(switchOff, other.switchOff),
      scrim: l(scrim, other.scrim),
    );
  }
}

extension AppColorsX on BuildContext {
  /// Палитра текущей темы: `context.colors.drive`.
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
