// Общие помощники тестов соответствия интерфейса дизайну.
// flutter test запускается из app/, поэтому документы — на уровень выше.

import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tachogo/core/theme/app_colors.dart';

/// Источник токенов — `docs/design/tokens.json`.
Map<String, Object?> loadTokens() =>
    jsonDecode(File('../docs/design/tokens.json').readAsStringSync())
        as Map<String, Object?>;

/// Раздел токенов как словарь: `section(tokens, 'color')`.
Map<String, Object?> section(Map<String, Object?> tokens, String name) =>
    tokens[name]! as Map<String, Object?>;

/// Цвет из строки `#RRGGBB`.
Color hex(String value) {
  final match = RegExp(r'^#([0-9A-Fa-f]{6})$').firstMatch(value);
  if (match == null) throw FormatException('Не цвет: $value');
  return Color(0xFF000000 | int.parse(match.group(1)!, radix: 16));
}

/// `#RRGGBB` для сообщений об ошибках.
String hexOf(Color c) =>
    '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}'
        .toUpperCase();

/// Контраст по WCAG 2.x: от 1 (нет) до 21 (чёрный на белом).
double contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

/// Токены цветов и поля палитры: ключ — имя в tokens.json.
final Map<String, Color Function(AppColors)> colorFields = {
  'background': (c) => c.background,
  'surface': (c) => c.surface,
  'surface2': (c) => c.surface2,
  'line': (c) => c.line,
  'text': (c) => c.text,
  'textSecondary': (c) => c.textSecondary,
  'drive': (c) => c.drive,
  'rest': (c) => c.rest,
  'work': (c) => c.work,
  'available': (c) => c.available,
  'warningBg': (c) => c.warningBg,
  'warningText': (c) => c.warningText,
  'errorBg': (c) => c.errorBg,
  'errorText': (c) => c.errorText,
  'switchOff': (c) => c.switchOff,
  'scrim': (c) => c.scrim,
  'onAccent': (c) => c.onAccent,
  'chipText': (c) => c.chipText,
  'restBg': (c) => c.restBg,
  'restText': (c) => c.restText,
};

/// Палитры тем по имени из tokens.json.
const Map<String, AppColors> themes = {
  'dark': AppColors.dark,
  'light': AppColors.light,
};

// Известные нарушения, которые ждут решения дизайна. Тесты с ними
// пропускаются с этой причиной; после исправления — удалить skip.

const lightDriveContrastIssue =
    'Светлая тема: вождение #D48A00 на фоне #F4F2EE — 2.5:1, на карточке '
    '#FFFFFF — 2.8:1, нужно ≥ 3:1 (WCAG 1.4.3, 1.4.11). Проходит, '
    'например, #BB7900: 3.2:1 и 3.6:1, тёмная подпись на нём — 5.0:1.';

const lightOnModeIssue =
    'Светлая тема: подпись #15171A на активной кнопке режима — отдых '
    '#1F8A6C 4.2:1, работа #C9562C 4.2:1, готовность #3D64C9 3.3:1, нужно '
    '≥ 4.5:1 (подпись 13 px). Белая подпись тоже не проходит на отдыхе и '
    'работе (4.3:1) — нужны темнее цвета режимов светлой темы.';
