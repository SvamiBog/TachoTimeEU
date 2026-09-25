// Токены приложения совпадают с docs/design/tokens.json, а документы
// дизайна и правил — с токенами. Новый токен в tokens.json без поля
// в app/lib/core/theme/ (и наоборот) роняет тест.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_theme.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';

import 'design_test_utils.dart';

void main() {
  final tokens = loadTokens();

  group('цвета', () {
    final colors = section(tokens, 'color');

    test('в палитре ровно те цвета, что в tokens.json', () {
      expect(colorFields.keys.toSet(), colors.keys.toSet());
    });

    for (final MapEntry(key: theme, value: palette) in themes.entries) {
      test('тема $theme: значения совпадают', () {
        for (final MapEntry(:key, :value) in colorFields.entries) {
          final expected = (colors[key]! as Map<String, Object?>)[theme]!;
          expect(
            hexOf(value(palette)),
            (expected as String).toUpperCase(),
            reason: '$theme.$key',
          );
        }
      });
    }
  });

  group('типографика', () {
    final fonts = section(tokens, 'font');
    final styles = {
      'timer': AppTextStyles.timer,
      'screenTitle': AppTextStyles.screenTitle,
      'header': AppTextStyles.header,
      'rowTitle': AppTextStyles.rowTitle,
      'value': AppTextStyles.value,
      'body': AppTextStyles.body,
      'caption': AppTextStyles.caption,
      'section': AppTextStyles.section,
    };

    test('шрифты: Onest для интерфейса, JetBrains Mono для цифр', () {
      expect(AppFonts.ui, fonts['ui']);
      expect(AppFonts.numeric, fonts['numeric']);
    });

    test('в коде ровно те стили, что в tokens.json', () {
      expect(styles.keys.toSet(), section(tokens, 'typography').keys.toSet());
    });

    for (final MapEntry(key: name, value: style) in styles.entries) {
      test('стиль $name', () {
        final spec =
            section(tokens, 'typography')[name]! as Map<String, Object?>;
        final size = (spec['size']! as num).toDouble();
        expect(style.fontFamily, fonts[spec['family']]);
        expect(style.fontSize, size);
        expect(style.fontWeight?.value, spec['weight']);

        final spacing = spec['letterSpacing'] as String?;
        if (spacing != null) {
          final em = double.parse(spacing.replaceFirst('em', ''));
          expect(style.letterSpacing, closeTo(size * em, 1e-9));
        }
        // Цифры одинаковой ширины: тикающий таймер не должен «прыгать»
        if (spec['family'] == 'numeric') {
          expect(
            style.fontFeatures,
            contains(const FontFeature.tabularFigures()),
          );
        }
      });
    }
  });

  group('радиусы, отступы, размеры', () {
    test('радиусы', () {
      expect(section(tokens, 'radius'), {
        'heroCard': AppRadius.heroCard,
        'card': AppRadius.card,
        'modeButton': AppRadius.modeButton,
        'button': AppRadius.button,
        'badge': AppRadius.badge,
        'icon': AppRadius.icon,
        'chip': AppRadius.chip,
      });
    });

    test('отступы', () {
      expect(section(tokens, 'spacing'), {
        'screenPadding': AppSpacing.screenPadding,
        'betweenCards': [
          AppSpacing.betweenCardsMin,
          AppSpacing.betweenCardsMax,
        ],
        'beforeSection': [
          AppSpacing.beforeSectionMin,
          AppSpacing.beforeSectionMax,
        ],
        'cardPadding': AppSpacing.cardPadding,
      });
    });

    test('размеры', () {
      expect(section(tokens, 'size'), {
        'minTouch': AppSize.minTouch,
        'listRow': AppSize.listRow,
        'button': AppSize.button,
        'modeButton': AppSize.modeButton,
        'progressBar': AppSize.progressBar,
        'progressTick': [AppSize.progressTickWidth, AppSize.progressTickHeight],
      });
    });

    test('касание не меньше 44 dp, кнопки режимов 88 dp — для перчаток', () {
      for (final size in [
        AppSize.listRow,
        AppSize.button,
        AppSize.modeButton,
      ]) {
        expect(size, greaterThanOrEqualTo(AppSize.minTouch));
      }
      expect(AppSize.minTouch, greaterThanOrEqualTo(44));
      expect(AppSize.modeButton, 88);
    });
  });

  group('тема', () {
    for (final MapEntry(key: name, value: palette) in themes.entries) {
      test('$name: построена из токенов', () {
        final theme = buildTheme(
          name == 'dark' ? Brightness.dark : Brightness.light,
        );
        expect(theme.extension<AppColors>(), same(palette));
        expect(theme.scaffoldBackgroundColor, palette.background);
        expect(theme.colorScheme.primary, palette.drive);
        expect(theme.colorScheme.surface, palette.surface);
        expect(theme.colorScheme.onSurface, palette.text);
        expect(theme.colorScheme.error, palette.errorText);
        expect(theme.textTheme.bodyMedium?.fontFamily, AppFonts.ui);
        expect(theme.textTheme.bodyMedium?.color, palette.text);
      });
    }
  });

  group('состояния лимита', () {
    test('жёлтая плашка — меньше чем за 30 мин до лимита, как в движке', () {
      final spec = section(tokens, 'limitStates')['warning']! as String;
      final minutes = int.parse(RegExp(r'< (\d+) мин').firstMatch(spec)![1]!);
      expect(EuLimits.warningThreshold, Duration(minutes: minutes));
      expect(const ComplianceSettings().warningLead, EuLimits.warningThreshold);
    });
  });

  group('документы согласованы с токенами', () {
    final readme = File('../docs/design/README.md').readAsStringSync();
    final colors = section(tokens, 'color');
    String tokenHex(String key, String theme) =>
        ((colors[key]! as Map<String, Object?>)[theme]! as String)
            .toUpperCase();

    /// Строки markdown-таблицы под заголовком: ячейки без краёв.
    List<List<String>> tableRows(String markdown, String heading) {
      final start = markdown.indexOf(heading);
      expect(start, isNot(-1), reason: 'нет раздела «$heading»');
      final rows = <List<String>>[];
      for (final line in markdown.substring(start).split('\n').skip(1)) {
        if (line.startsWith('## ')) break;
        if (!line.startsWith('|') || line.startsWith('|---')) continue;
        final cells = line.split('|').map((c) => c.trim()).toList();
        rows.add(cells.sublist(1, cells.length - 1));
      }
      return rows.skip(1).toList(); // без шапки
    }

    List<String> hexes(String cell) =>
        RegExp('#[0-9A-Fa-f]{6}')
            .allMatches(cell)
            .map((m) => m[0]!.toUpperCase())
            .toList();

    test('таблица цветов в docs/design/README.md', () {
      const labels = {
        'Фон': ['background'],
        'Поверхность': ['surface'],
        'Поверхность 2': ['surface2'],
        'Линия': ['line'],
        'Текст': ['text'],
        'Текст вторичный': ['textSecondary'],
        'Вождение · акцент': ['drive'],
        'Отдых': ['rest'],
        'Работа': ['work'],
        'Готовность': ['available'],
        'Предупреждение фон / текст': ['warningBg', 'warningText'],
        'Ошибка фон / текст': ['errorBg', 'errorText'],
        'Выкл. переключатель': ['switchOff'],
        'Затемнение шторки': ['scrim'],
      };
      final rows = tableRows(readme, '## Токены');
      expect(rows.map((r) => r[0]).toSet(), labels.keys.toSet());
      expect(labels.values.expand((k) => k).toSet(), colors.keys.toSet());
      for (final row in rows) {
        final keys = labels[row[0]]!;
        expect(hexes(row[1]), [for (final k in keys) tokenHex(k, 'dark')]);
        expect(hexes(row[2]), [for (final k in keys) tokenHex(k, 'light')]);
      }
    });

    test('таблица типографики в docs/design/README.md', () {
      const roles = {
        'Таймер': 'timer',
        'Заголовок экрана': 'screenTitle',
        'Шапка': 'header',
        'Название строки': 'rowTitle',
        'Значение': 'value',
        'Основной текст': 'body',
        'Подпись под значением': 'caption',
        'Раздел': 'section',
      };
      final fonts = section(tokens, 'font');
      final rows = tableRows(readme, '## Типографика');
      expect(rows.map((r) => r[0]).toSet(), roles.keys.toSet());
      for (final [role, font, sizeWeight] in rows) {
        final spec =
            section(tokens, 'typography')[roles[role]]! as Map<String, Object?>;
        expect(font, fonts[spec['family']], reason: role);
        expect(sizeWeight, startsWith('${spec['size']} / ${spec['weight']}'));
      }
    });

    test('сетка и размеры в docs/design/README.md', () {
      List<num> numbersOf(String prefix) {
        final line = readme.split('\n').firstWhere((l) => l.startsWith(prefix));
        return RegExp(r'\d+')
            .allMatches(line)
            .map((m) => int.parse(m[0]!))
            .toList();
      }

      /// Значения токенов по порядку; пары вида [8, 16] разворачиваются.
      List<num> tokensOf(String name, List<String> keys) => [
        for (final key in keys)
          ...switch (section(tokens, name)[key]) {
            final num n => [n],
            final List<Object?> pair => pair.cast<num>(),
            final other => throw StateError('$name.$key: $other'),
          },
      ];

      expect(
        numbersOf('- Радиусы:'),
        tokensOf('radius', [
          'heroCard',
          'card',
          'modeButton',
          'button',
          'badge',
          'icon',
          'chip',
        ]),
      );
      expect(
        numbersOf('- Отступы:'),
        tokensOf('spacing', [
          'screenPadding',
          'betweenCards',
          'beforeSection',
          'cardPadding',
        ]),
      );
      expect(
        numbersOf('- Касание:'),
        tokensOf('size', ['minTouch', 'listRow', 'button', 'modeButton']),
      );
      expect(
        numbersOf('- Строка лимита:'),
        tokensOf('size', ['progressBar', 'progressTick']),
      );
    });

    test('цвета режимов в docs/domain/eu-561-rules.md — тёмная тема', () {
      final rules = File('../docs/domain/eu-561-rules.md').readAsStringSync();
      final byLabel = {
        for (final row in tableRows(rules, '## Режимы водителя'))
          row[0]: hexes(row[1]).single,
      };
      // Каждый режим движка описан в правилах своим цветом
      for (final mode in DriverMode.values) {
        final (label, key) = switch (mode) {
          DriverMode.driving => ('Вождение', 'drive'),
          DriverMode.rest => ('Отдых', 'rest'),
          DriverMode.otherWork => ('Другая работа', 'work'),
          DriverMode.availability => ('Готовность', 'available'),
        };
        expect(byLabel[label], tokenHex(key, 'dark'), reason: label);
      }
    });
  });
}
