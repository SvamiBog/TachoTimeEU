// DOC-07 (docs/testing.md): у каждого файла кода — описание модуля на
// английском (`///` и `library;` в начале файла), у каждого класса,
// перечисления, mixin, расширения и typedef — английский doc-комментарий
// (CLAUDE.md, «Комментарии в коде»). Проверяются приложение (lib, tool,
// test_driver) и движок (lib, tool), кроме сгенерированного кода.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Папки с кодом, пути — от `app/`.
const _roots = [
  'lib',
  'tool',
  'test_driver',
  '../packages/tacho_engine/lib',
  '../packages/tacho_engine/tool',
];

/// Сгенерированный код: Drift, gen-l10n.
final _generated = RegExp(
  r'\.g\.dart$|\.steps\.dart$|/l10n/app_localizations[\w_]*\.dart$',
);

/// Объявление типа верхнего уровня.
final _declaration = RegExp(
  r'^(?:(?:abstract|base|final|sealed|interface|mixin)\s+)*'
  r'(class|enum|mixin|extension type|extension|typedef)\s+(\w+)',
);

final _cyrillic = RegExp('[А-Яа-яЁё]');

/// Служебные строки, которые стоят до описания модуля.
bool _preamble(String line) =>
    line.isEmpty ||
    line.startsWith('// ignore_for_file') ||
    line.startsWith('// coverage:');

/// Нарушения правила в тексте файла: «строка: что не так».
List<String> docProblems(String source) {
  final lines = source.split('\n');
  final problems = <String>[];

  var i = 0;
  while (i < lines.length && _preamble(lines[i])) {
    i++;
  }
  var j = i;
  while (j < lines.length && lines[j].startsWith('///')) {
    j++;
  }
  if (j == i || j >= lines.length || lines[j] != 'library;') {
    problems.add('1: нет описания модуля (`/// …` и `library;`)');
  } else if (lines.sublist(i, j).any(_cyrillic.hasMatch)) {
    problems.add('${i + 1}: описание модуля не на английском');
  }

  for (final (k, line) in lines.indexed) {
    final match = _declaration.firstMatch(line);
    if (match == null) continue;
    var a = k;
    while (a > 0 && lines[a - 1].trimLeft().startsWith('@')) {
      a--;
    }
    var d = a;
    while (d > 0 && lines[d - 1].startsWith('///')) {
      d--;
    }
    final name = match[2];
    if (d == a) {
      problems.add('${k + 1}: у $name нет doc-комментария');
    } else if (lines.sublist(d, a).any(_cyrillic.hasMatch)) {
      problems.add('${k + 1}: doc-комментарий $name не на английском');
    }
  }
  return problems;
}

List<File> _sources() => [
  for (final root in _roots)
    for (final f in Directory(root).listSync(recursive: true))
      if (f is File &&
          f.path.endsWith('.dart') &&
          !_generated.hasMatch(f.path.replaceAll(r'\', '/')))
        f,
]..sort((a, b) => a.path.compareTo(b.path));

void main() {
  test('правило срабатывает', () {
    expect(
      docProblems('/// A module.\nlibrary;\n\n/// A class.\nclass A {}'),
      isEmpty,
    );
    expect(docProblems('import "x.dart";\n\nclass A {}'), [
      '1: нет описания модуля (`/// …` и `library;`)',
      '3: у A нет doc-комментария',
    ]);
    expect(
      docProblems(
        '/// Модуль.\nlibrary;\n\n/// Класс.\n@immutable\nclass A {}\n'
        '/// Doc.\nenum B { b }',
      ),
      [
        '1: описание модуля не на английском',
        '6: doc-комментарий A не на английском',
      ],
    );
    expect(
      docProblems(
        '// ignore_for_file: x\n\n/// Types.\nlibrary;\n\n'
        '/// Doc.\nabstract final class A {}\n/// Doc.\ntypedef B = int;\n'
        '/// Doc.\nextension on A {}\n/// Doc.\nextension type C(int i) {}',
      ),
      isEmpty,
    );
  });

  test('код найден', () {
    final paths = _sources().map((f) => f.path.replaceAll(r'\', '/'));
    expect(paths, contains(endsWith('lib/features/home/home_screen.dart')));
    expect(paths, contains(endsWith('tacho_engine/lib/src/compliance.dart')));
    expect(paths, isNot(contains(endsWith('app_database.g.dart'))));
  });

  test('модули и классы описаны по-английски', () {
    final found = [
      for (final f in _sources())
        for (final p in docProblems(f.readAsStringSync())) '${f.path}:$p',
    ];
    expect(found, isEmpty, reason: found.join('\n'));
  });
}
