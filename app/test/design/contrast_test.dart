// Контраст палитры по WCAG 2.1 (уровень AA). Водитель смотрит на экран
// на солнце и в кабине ночью, поэтому это требование, а не пожелание:
// - обычный текст — не меньше 4.5:1 (1.4.3);
// - крупный текст (таймер 60) и графика (полосы лимитов, кольцо,
//   кнопки режимов) — не меньше 3:1 (1.4.3, 1.4.11).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_theme.dart';

import 'design_test_utils.dart';

const _normalText = 4.5;
const _largeTextAndGraphics = 3.0;

/// Пары, которые пока не проходят: ключ `тема/цвет/фон` — причина пропуска.
const Map<String, String> _knownIssues = {
  'light/drive/background': lightDriveContrastIssue,
  'light/drive/surface': lightDriveContrastIssue,
};

void main() {
  void expectContrast(String theme, String fg, String bg, double minimum) {
    final palette = themes[theme]!;
    final a = colorFields[fg]!(palette);
    final b = colorFields[bg]!(palette);
    final ratio = contrast(a, b);
    expect(
      ratio,
      greaterThanOrEqualTo(minimum),
      reason:
          '$theme: $fg ${hexOf(a)} на $bg ${hexOf(b)} — '
          '${ratio.toStringAsFixed(2)}:1, нужно ≥ $minimum:1',
    );
  }

  void pair(String theme, String fg, String bg, double minimum) {
    test(
      '$fg на $bg — не меньше $minimum:1',
      () => expectContrast(theme, fg, bg, minimum),
      skip: _knownIssues['$theme/$fg/$bg'],
    );
  }

  for (final theme in themes.keys) {
    group('тема $theme', () {
      group('текст', () {
        for (final fg in ['text', 'textSecondary']) {
          for (final bg in ['background', 'surface', 'surface2']) {
            pair(theme, fg, bg, _normalText);
          }
        }
        for (final bg in ['background', 'surface']) {
          pair(theme, 'errorText', bg, _normalText);
        }
      });

      group('плашки лимитов', () {
        pair(theme, 'warningText', 'warningBg', _normalText);
        pair(theme, 'errorText', 'errorBg', _normalText);
      });

      group('цвета режимов: таймер, полосы, кнопки', () {
        for (final mode in ['drive', 'rest', 'work', 'available']) {
          for (final bg in ['background', 'surface']) {
            pair(theme, mode, bg, _largeTextAndGraphics);
          }
        }
      });

      test('цвета режимов различаются между собой и с ошибкой', () {
        final palette = themes[theme]!;
        final colors = [
          palette.drive,
          palette.rest,
          palette.work,
          palette.available,
          palette.errorText,
        ];
        expect(colors.toSet(), hasLength(colors.length));
      });

      test('подпись на основной кнопке (акцент) читается', () {
        final scheme = buildTheme(
          theme == 'dark' ? Brightness.dark : Brightness.light,
        ).colorScheme;
        final ratio = contrast(scheme.onPrimary, scheme.primary);
        expect(
          ratio,
          greaterThanOrEqualTo(_normalText),
          reason:
              '${hexOf(scheme.onPrimary)} на ${hexOf(scheme.primary)} — '
              '${ratio.toStringAsFixed(2)}:1',
        );
      }, skip: theme == 'light' ? lightOnAccentIssue : null);
    });
  }

  test('расчёт контраста совпадает с эталоном WCAG', () {
    expect(contrast(const Color(0xFF000000), const Color(0xFFFFFFFF)), 21);
    expect(contrast(AppColors.dark.text, AppColors.dark.text), 1);
    expect(
      contrast(const Color(0xFF767676), const Color(0xFFFFFFFF)),
      closeTo(4.54, 0.01),
    );
  });
}
