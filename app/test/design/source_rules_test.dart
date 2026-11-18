// Правило из CLAUDE.md: цвета, шрифты, радиусы и отступы берутся только из
// app/lib/core/theme/ (context.colors, AppTextStyles, AppRadius, AppSize,
// AppSpacing), в виджетах ничего не хардкодится. Тест проходит по
// исходникам lib/.

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

/// Отступы, которые остаются числами, и почему: путь от lib/ → значения.
const _spacingExceptions = {
  // Поля внутри нарисованного кольца — от толщины его линии
  'features/home/hero_card.dart': {28},
  'features/onboarding/onboarding_screen.dart': {40},
  // Место под кнопку «+ Смена» над концом списка
  'features/journal/journal_screen.dart': {96},
  // Поле вокруг индикатора загрузки
  'features/violations/violations_screen.dart': {48},
  // Пустая клетка календаря — высотой с клетку дня
  'features/more/working_days_screen.dart': {44},
};

/// PDF-отчёт меряется в пунктах, не в dp: у него своя шкала `_Pt`.
const _spacingSkipped = {'features/export/pdf_report.dart'};

final _number = RegExp(r'(?<![\w.])\d+(?:\.\d+)?(?![\w.])');
final _edgeInsets = RegExp(r'\bEdgeInsets(?:Directional)?\.\w+\(');
// Промежуток — SizedBox только с одной стороной, без содержимого
final _gap = RegExp(
  r'\bSizedBox\(\s*(?:height|width)\s*:\s*(\d+(?:\.\d+)?)\s*,?\s*\)',
);
final _wrapSpacing = RegExp(r'\b(?:spacing|runSpacing)\s*:\s*(\d+(?:\.\d+)?)');

/// Отступы числом в тексте файла: в `EdgeInsets`, в промежутке `SizedBox`,
/// в `spacing` / `runSpacing`. 0, 1 и 2 — можно: «без поля» и волосяные
/// зазоры. `EdgeInsets.fromLTRB` часто занимает несколько строк, поэтому
/// файл разбирается целиком, а не по строкам. Результат — «путь:строка —
/// число», путь — от lib/.
List<String> spacingNumbers(String path, String source) {
  // Комментарии — пробелами, чтобы не сдвинуть номера строк
  final code = source.replaceAllMapped(
    RegExp('//.*'),
    (m) => ' ' * m[0]!.length,
  );
  final allowed = _spacingExceptions[path] ?? const <int>{};
  final found = <String>[];
  void check(int offset, String literal) {
    final value = num.parse(literal);
    if (value <= 2 || allowed.contains(value)) return;
    final line = '\n'.allMatches(code.substring(0, offset)).length + 1;
    found.add('$path:$line — $literal');
  }

  for (final m in _edgeInsets.allMatches(code)) {
    // Аргументы до парной скобки: внутри бывают вызовы со скобками
    var depth = 1;
    var end = m.end;
    while (depth > 0 && end < code.length) {
      depth += switch (code[end]) {
        '(' => 1,
        ')' => -1,
        _ => 0,
      };
      end++;
    }
    for (final n in _number.allMatches(code.substring(m.end, end))) {
      check(m.end + n.start, n[0]!);
    }
  }
  for (final m in [
    ..._gap.allMatches(code),
    ..._wrapSpacing.allMatches(code),
  ]) {
    check(m.start + m[0]!.lastIndexOf(m[1]!), m[1]!);
  }
  return found;
}

String _libPath(File f) => _normalize(f.path).replaceFirst('lib/', '');

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

  test('отступ задан числом — только через AppSpacing', () {
    final found = [
      for (final f in sources)
        if (!_spacingSkipped.contains(_libPath(f)))
          ...spacingNumbers(_libPath(f), f.readAsStringSync()),
    ];
    expect(found, isEmpty, reason: found.join('\n'));
  });

  test('исключения для отступов ещё нужны', () {
    for (final MapEntry(key: path, value: values)
        in _spacingExceptions.entries) {
      // Тот же файл без исключений: каждое число из списка в нём есть
      final found = {
        for (final entry in spacingNumbers(
          'x.dart',
          File('lib/$path').readAsStringSync(),
        ))
          num.parse(entry.split('— ').last),
      };
      for (final value in values) {
        expect(
          found,
          contains(value),
          reason: '$path: отступа $value больше нет — убрать исключение',
        );
      }
    }
  });

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

    test('отступ числом — в любой строке EdgeInsets, промежутка и spacing', () {
      expect(spacingNumbers('x.dart', 'const SizedBox(height: 12),'), [
        'x.dart:1 — 12',
      ]);
      expect(spacingNumbers('x.dart', 'padding: EdgeInsets.all(16),'), [
        'x.dart:1 — 16',
      ]);
      expect(
        spacingNumbers('x.dart', 'Wrap(spacing: 8, runSpacing: 4.5)'),
        unorderedEquals(['x.dart:1 — 8', 'x.dart:1 — 4.5']),
      );
      // Многострочный fromLTRB: номер строки — у самого числа
      const multiline = '''
padding: const EdgeInsets.fromLTRB(
  AppSpacing.screenPadding,
  8,
  AppSpacing.screenPadding,
  0,
),''';
      expect(spacingNumbers('x.dart', multiline), ['x.dart:3 — 8']);
      expect(
        spacingNumbers(
          'x.dart',
          'EdgeInsets.fromLTRB(pad, f(1), pad, 24 + inset.bottom)',
        ),
        ['x.dart:1 — 24'],
      );
    });

    test('отступ токеном, 0–2, размер и комментарий — не нарушение', () {
      const allowed = [
        'const SizedBox(height: AppSpacing.s12),',
        'padding: EdgeInsets.only(top: 2),',
        'padding: EdgeInsets.zero,',
        'EdgeInsets.all(AppSpacing.screenPadding * 2)',
        'EdgeInsets.fromLTRB(pad, 0, pad, AppSpacing.screenBottom)',
        'Wrap(spacing: AppSpacing.s8, runSpacing: AppSpacing.s4)',
        // SizedBox с содержимым или двумя сторонами — размер, не промежуток
        'SizedBox(width: 44, child: Text(day))',
        'SizedBox(width: 48, height: 32)',
        '// const SizedBox(height: 12),',
      ];
      for (final line in allowed) {
        expect(spacingNumbers('x.dart', line), isEmpty, reason: line);
      }
    });

    test('исключение действует только в своём файле', () {
      const line = 'padding: const EdgeInsets.all(28),';
      expect(spacingNumbers('features/home/hero_card.dart', line), isEmpty);
      expect(spacingNumbers('x.dart', line), ['x.dart:1 — 28']);
    });
  });
}
