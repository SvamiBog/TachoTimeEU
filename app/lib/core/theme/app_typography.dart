// Типографика из docs/design/tokens.json.
// Цвет не задаётся: берётся из темы (DefaultTextStyle / context.colors).

import 'package:flutter/painting.dart';

/// Шрифты: Onest — интерфейс, JetBrains Mono — время и цифры.
abstract final class AppFonts {
  static const ui = 'Onest';
  static const numeric = 'JetBrains Mono';
}

abstract final class AppTextStyles {
  // Цифры одинаковой ширины, чтобы тикающий таймер не «прыгал».
  static const _tabular = [FontFeature.tabularFigures()];

  static const timer = TextStyle(
    fontFamily: AppFonts.numeric,
    fontSize: 60,
    fontWeight: FontWeight.w700,
    fontFeatures: _tabular,
  );

  static const screenTitle = TextStyle(
    fontFamily: AppFonts.ui,
    fontSize: 28,
    fontWeight: FontWeight.w700,
  );

  static const header = TextStyle(
    fontFamily: AppFonts.ui,
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );

  static const rowTitle = TextStyle(
    fontFamily: AppFonts.ui,
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  static const value = TextStyle(
    fontFamily: AppFonts.numeric,
    fontSize: 17,
    fontWeight: FontWeight.w700,
    fontFeatures: _tabular,
  );

  static const body = TextStyle(
    fontFamily: AppFonts.ui,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const caption = TextStyle(
    fontFamily: AppFonts.ui,
    fontSize: 13,
    fontWeight: FontWeight.w400,
  );

  /// Заголовок раздела. Текст передавать в верхнем регистре (`.toUpperCase()`).
  static const section = TextStyle(
    fontFamily: AppFonts.ui,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 13 * 0.08,
  );
}
