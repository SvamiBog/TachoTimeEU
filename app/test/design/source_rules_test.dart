// Правило из CLAUDE.md: цвета, шрифты и радиусы берутся только из
// app/lib/core/theme/ (context.colors, AppTextStyles, AppRadius, AppSize),
// в виджетах ничего не хардкодится. Тест проходит по исходникам lib/.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Запрещённый приём и подсказка, чем его заменить.
typedef _Rule = ({String name, RegExp pattern, String instead});

final _rules = <_Rule>[
  (
    name: 'цвет задан кодом',
    pattern: RegExp(r'\bColor\(\s*0x|Color\.from(ARGB|RGBO)\('),
    instead: 'context.colors',
  ),
  (
    name: 'цвет из палитры Material',
    pattern: RegExp(r'\bColors\.(?!transparent\b)\w+'),
    instead: 'context.colors',
  ),
  (
    name: 'шрифт задан строкой',
    pattern: RegExp(r'\bfontFamily\s*:'),
    instead: 'AppTextStyles',
  ),
  (
    name: 'размер шрифта задан числом',
    pattern: RegExp(r'\bfontSize\s*:\s*\d'),
    instead: 'AppTextStyles',
  ),
  (
    name: 'радиус задан числом',
    pattern: RegExp(r'\b(Border)?Radius\.circular\(\s*\d'),
    instead: 'AppRadius',
  ),
];

String _normalize(String path) => path.replaceAll(r'\', '/');

/// Исходники приложения, кроме темы и сгенерированного кода.
List<File> _sources() =>
    Directory('lib').listSync(recursive: true).whereType<File>().where((f) {
      final path = _normalize(f.path);
      return path.endsWith('.dart') &&
          !path.contains('lib/core/theme/') &&
          !path.endsWith('.g.dart') &&
          !path.endsWith('.steps.dart');
    }).toList()..sort((a, b) => a.path.compareTo(b.path));

/// Нарушения правила в тексте файла: «путь:строка — код».
List<String> _violations(String path, String source, _Rule rule) {
  final found = <String>[];
  final lines = source.split('\n');
  for (var i = 0; i < lines.length; i++) {
    final code = lines[i].split('//').first;
    if (rule.pattern.hasMatch(code)) {
      found.add('$path:${i + 1} — ${code.trim()}');
    }
  }
  return found;
}

void main() {
  final sources = _sources();

  test('исходники найдены', () {
    expect(sources, isNotEmpty);
    expect(
      sources.map((f) => _normalize(f.path)),
      contains(endsWith('features/home/home_screen.dart')),
    );
  });

  for (final rule in _rules) {
    test('${rule.name} — только через ${rule.instead}', () {
      final found = [
        for (final f in sources)
          ..._violations(_normalize(f.path), f.readAsStringSync(), rule),
      ];
      expect(found, isEmpty, reason: found.join('\n'));
    });
  }

  group('правила срабатывают', () {
    final samples = {
      'цвет задан кодом': [
        'color: Color(0xFFF3B33D),',
        'Color.fromARGB(255, 0, 0, 0)',
      ],
      'цвет из палитры Material': ['color: Colors.amber,'],
      'шрифт задан строкой': ["fontFamily: 'Onest',"],
      'размер шрифта задан числом': ['fontSize: 14,'],
      'радиус задан числом': [
        'BorderRadius.circular(24)',
        'Radius.circular(8)',
      ],
    };
    for (final rule in _rules) {
      test(rule.name, () {
        for (final line in samples[rule.name]!) {
          expect(_violations('x.dart', line, rule), hasLength(1), reason: line);
        }
      });
    }

    test('разрешённое не считается нарушением', () {
      const allowed = [
        'color: context.colors.drive,',
        'color: Colors.transparent,',
        'BorderRadius.circular(AppRadius.card)',
        'style: AppTextStyles.timer.copyWith(color: colors.drive),',
        '// пример: Color(0xFF000000)',
      ];
      for (final rule in _rules) {
        for (final line in allowed) {
          expect(_violations('x.dart', line, rule), isEmpty, reason: line);
        }
      }
    });
  });
}
