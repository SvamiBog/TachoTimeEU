// Вычитка переводов носителями языка (Фаза 4, docs/beta/translation-review.md).
//
//   dart run tool/l10n_review.dart export [--out build/l10n_review] [uk pl …]
//   dart run tool/l10n_review.dart import <tachogo-uk.csv> [--lang uk]
//
// export — таблица CSV на каждый перевод: ключ, раздел, пояснение, русский
// текст, перевод и пустые колонки «Исправление» и «Комментарий». Плюрали и
// select разложены по вариантам: водителю не нужно читать ICU. Фраза вокруг
// числа — отдельной строкой с меткой [[имя]] на месте числа.
//
// import — исправления из заполненной таблицы в app_<lang>.arb. Строка без
// исправления не меняется. Исправление с другими подстановками ({time}) или
// без метки [[имя]] не применяется — об этом пишется в отчёте. Комментарии
// печатаются списком. После импорта: `flutter gen-l10n` и тесты L10N.
//
// CSV — как у отчёта приложения: UTF-8 с BOM, CRLF, каждое значение в
// кавычках. Читается и с запятой, и с точкой с запятой (Excel в польской и
// русской локали сохраняет через «;»).

import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';

const arbDir = 'lib/l10n';
const sourceLanguage = 'ru';

/// Колонки таблицы. Названия — по-английски: таблицу читают носители
/// разных языков.
const columns = [
  'id',
  'section',
  'context',
  'russian',
  'numbers',
  'translation',
  'correction',
  'comment',
];

Future<void> main(List<String> args) async {
  if (args.isEmpty) return _usage();
  switch (args.first) {
    case 'export':
      final out = _option(args, '--out') ?? 'build/l10n_review';
      final langs = _positional(args.skip(1).toList());
      await exportAll(Directory(out), langs.isEmpty ? null : langs);
    case 'import':
      final files = _positional(args.skip(1).toList());
      if (files.length != 1) return _usage();
      final report = await importFile(
        File(files.single),
        lang: _option(args, '--lang'),
      );
      stdout.write(report);
      if (report.rejected.isNotEmpty) exitCode = 1;
    default:
      _usage();
  }
}

void _usage() {
  stderr.writeln(
    'dart run tool/l10n_review.dart export [--out <dir>] [langs…]\n'
    'dart run tool/l10n_review.dart import <file.csv> [--lang <code>]',
  );
  exitCode = 64;
}

String? _option(List<String> args, String name) {
  final i = args.indexOf(name);
  return i >= 0 && i + 1 < args.length ? args[i + 1] : null;
}

/// Аргументы без опций `--имя значение`.
List<String> _positional(List<String> args) {
  final result = <String>[];
  for (var i = 0; i < args.length; i++) {
    if (args[i].startsWith('--')) {
      i++;
    } else {
      result.add(args[i]);
    }
  }
  return result;
}

// ───────────────────────── ARB ─────────────────────────

/// Файл ARB языка [lang].
File arbFile(String lang, {String dir = arbDir}) => File('$dir/app_$lang.arb');

/// ARB как упорядоченная карта: порядок ключей сохраняется при записи.
Map<String, Object?> readArb(File file) =>
    (jsonDecode(file.readAsStringSync()) as Map).cast<String, Object?>();

/// Запись ARB в том же виде, что в репозитории: отступ 2, перевод строки
/// в конце.
void writeArb(File file, Map<String, Object?> arb) => file.writeAsStringSync(
  '${const JsonEncoder.withIndent('  ').convert(arb)}\n',
);

/// Переводы — все ARB, кроме исходного, по коду языка.
List<String> translations({String dir = arbDir}) {
  final langs = [
    for (final f in Directory(dir).listSync().whereType<File>())
      if (RegExp(r'app_(\w+)\.arb$').firstMatch(f.path) case final m?)
        m.group(1)!,
  ]..remove(sourceLanguage);
  return langs..sort();
}

// ───────────────────────── ICU ─────────────────────────

/// Сообщение с одним plural или select: текст до, сама конструкция и текст
/// после. Сообщения без них и с несколькими — целиком одной строкой.
class IcuMessage {
  const new({
    required this.prefix,
    required this.name,
    required this.kind,
    required this.cases,
    required this.suffix,
  });

  final String prefix;
  final String name;

  /// plural или select.
  final String kind;

  /// Вариант → текст, в порядке сообщения.
  final Map<String, String> cases;
  final String suffix;

  /// Метка числа во фразе вокруг него.
  String get marker => '[[$name]]';

  /// Фраза вокруг конструкции; пустая, если сообщение — только она.
  String? get frame =>
      prefix.isEmpty && suffix.isEmpty ? null : '$prefix$marker$suffix';

  String build() {
    final body = [for (final e in cases.entries) '${e.key}{${e.value}}'];
    return '$prefix{$name, $kind, ${body.join(' ')}}$suffix';
  }

  static final _head = RegExp(r'^\s*(\w+)\s*,\s*(plural|select)\s*,');

  /// Разбор [message]; null — в нём нет ровно одной конструкции.
  static IcuMessage? parse(String message) {
    IcuMessage? found;
    var i = 0;
    while (i < message.length) {
      if (message[i] != '{') {
        i++;
        continue;
      }
      final end = _closing(message, i);
      if (end < 0) return null;
      final body = message.substring(i + 1, end);
      final head = _head.firstMatch(body);
      if (head != null) {
        if (found != null) return null;
        final cases = _cases(body.substring(head.end));
        if (cases == null) return null;
        found = IcuMessage(
          prefix: message.substring(0, i),
          name: head.group(1)!,
          kind: head.group(2)!,
          cases: cases,
          suffix: message.substring(end + 1),
        );
      }
      i = end + 1;
    }
    return found;
  }

  /// Индекс закрывающей скобки для открывающей в [open]; −1 — её нет.
  static int _closing(String s, int open) {
    var depth = 0;
    for (var i = open; i < s.length; i++) {
      if (s[i] == '{') depth++;
      if (s[i] == '}' && --depth == 0) return i;
    }
    return -1;
  }

  static Map<String, String>? _cases(String s) {
    final cases = <String, String>{};
    var i = 0;
    while (true) {
      while (i < s.length && s[i].trim().isEmpty) {
        i++;
      }
      if (i >= s.length) break;
      final open = s.indexOf('{', i);
      if (open < 0) return null;
      final key = s.substring(i, open).trim();
      final end = _closing(s, open);
      if (key.isEmpty || end < 0) return null;
      cases[key] = s.substring(open + 1, end);
      i = end + 1;
    }
    return cases.isEmpty ? null : cases;
  }
}

/// Подстановки {имя} в тексте без plural и select.
Set<String> placeholders(String text) => {
  for (final m in RegExp(r'\{(\w+)\}').allMatches(text)) m.group(1)!,
};

/// Скобки не разорваны: водитель мог стереть или добавить одну.
bool bracesBalanced(String text) {
  var depth = 0;
  for (final c in text.split('')) {
    if (c == '{') depth++;
    if (c == '}' && --depth < 0) return false;
  }
  return depth == 0;
}

// ───────────────────────── Строки таблицы ─────────────────────────

/// Строка таблицы вычитки.
typedef ReviewRow = ({
  String id,
  String section,
  String context,
  String russian,
  String numbers,
  String translation,
});

/// Раздел приложения по началу ключа: где искать строку на экране.
String sectionOf(String key) {
  final prefix = RegExp('^[a-z]+').firstMatch(key)?.group(0) ?? key;
  return switch (prefix) {
    'nav' => 'Bottom navigation',
    'home' || 'hero' || 'row' || 'chip' || 'mode' || 'limit' => 'Home (1)',
    'banner' || 'section' || 'status' || 'drive' || 'daily' => 'Home (1)',
    'ferry' || 'left' || 'today' || 'rest' || 'work' || 'switch' => 'Home (1)',
    'card' => 'Home (1): card download',
    'journal' => 'Journal (2)',
    'day' => 'Journal: day details',
    'settings' || 'theme' || 'language' || 'clear' => 'Settings (3)',
    'tachograph' || 'vehicle' || 'lead' || 'unit' => 'Settings (3)',
    'auto' => 'Settings (3): auto-detect driving',
    'more' || 'app' => 'More (4)',
    'workday' => 'Workday (6)',
    'picker' => 'Pickers (7, 12)',
    'break' => 'Break (8)',
    'weekly' => 'Weekly rest (9)',
    'country' => 'Countries (10)',
    'shift' => 'Shift form (11)',
    'onb' => 'Onboarding (13, 14)',
    'export' => 'Export (16)',
    'guide' => 'Guide and rules (17)',
    'infr' => 'Warnings and violations',
    'notify' => 'Notifications',
    'service' => 'Auto-detect notification',
    'report' => 'PDF report',
    'spoken' => 'Screen reader (TalkBack)',
    _ => 'Common',
  };
}

/// Какие числа берут форму [category] в языке [lang]: «1, 21, 31, …».
String pluralNumbers(String lang, String category) {
  if (category.startsWith('=')) return category.substring(1);
  final numbers = [
    for (var n = 0; n <= 111; n++)
      if (Intl.pluralLogic<String>(
            n,
            locale: lang,
            one: 'one',
            two: 'two',
            few: 'few',
            many: 'many',
            other: 'other',
            // Категория CLDR, а не «ровно 2» при заданном two
            useExplicitNumberCases: false,
          ) ==
          category)
        n,
  ];
  if (numbers.isEmpty) return category == 'other' ? '1.5' : '—';
  final shown = numbers.take(6).join(', ');
  return numbers.length > 6 ? '$shown, …' : shown;
}

/// Строки таблицы для языка [lang].
List<ReviewRow> reviewRows(
  String lang,
  Map<String, Object?> source,
  Map<String, Object?> translation,
) {
  final rows = <ReviewRow>[];
  for (final MapEntry(:key, :value) in source.entries) {
    if (key.startsWith('@') || value is! String) continue;
    final text = translation[key];
    if (text is! String) continue;
    final meta = source['@$key'];
    final context = meta is Map ? '${meta['description'] ?? ''}' : '';
    final section = sectionOf(key);
    final ru = IcuMessage.parse(value);
    final tr = IcuMessage.parse(text);
    if (ru == null || tr == null) {
      rows.add((
        id: key,
        section: section,
        context: context,
        russian: value,
        numbers: '',
        translation: text,
      ));
      continue;
    }
    if (tr.frame case final frame?) {
      rows.add((
        id: key,
        section: section,
        context: [
          if (context.isNotEmpty) context,
          '${tr.marker} — keep: the number goes here',
        ].join('. '),
        russian: ru.frame ?? ru.marker,
        numbers: '',
        translation: frame,
      ));
    }
    for (final MapEntry(key: variant, value: caseText) in tr.cases.entries) {
      rows.add((
        id: '$key#$variant',
        section: section,
        context: context,
        russian: ru.cases[variant] ?? ru.cases['other'] ?? '',
        numbers: tr.kind == 'plural' ? pluralNumbers(lang, variant) : '',
        translation: caseText,
      ));
    }
  }
  return rows;
}

// ───────────────────────── CSV ─────────────────────────

String _csvField(String value) => '"${value.replaceAll('"', '""')}"';

/// CSV для Excel и Google Таблиц: BOM, CRLF, значения в кавычках.
String toCsv(List<List<String>> rows) =>
    '﻿${rows.map((r) => r.map(_csvField).join(',')).join('\r\n')}\r\n';

/// Разбор CSV с запятой или точкой с запятой; кавычки и переводы строк
/// внутри значений.
List<List<String>> parseCsv(String text) {
  var s = text.startsWith('﻿') ? text.substring(1) : text;
  s = s.replaceAll('\r\n', '\n');
  final firstLine = s.split('\n').first;
  final delimiter =
      ';'.allMatches(firstLine).length > ','.allMatches(firstLine).length
      ? ';'
      : ',';
  final rows = <List<String>>[];
  var row = <String>[];
  final field = StringBuffer();
  var quoted = false;
  for (var i = 0; i < s.length; i++) {
    final c = s[i];
    if (quoted) {
      if (c == '"') {
        if (i + 1 < s.length && s[i + 1] == '"') {
          field.write('"');
          i++;
        } else {
          quoted = false;
        }
      } else {
        field.write(c);
      }
    } else if (c == '"') {
      quoted = true;
    } else if (c == delimiter) {
      row.add(field.toString());
      field.clear();
    } else if (c == '\n') {
      row.add(field.toString());
      field.clear();
      rows.add(row);
      row = <String>[];
    } else {
      field.write(c);
    }
  }
  if (field.isNotEmpty || row.isNotEmpty) {
    row.add(field.toString());
    rows.add(row);
  }
  return rows.where((r) => r.any((v) => v.trim().isNotEmpty)).toList();
}

// ───────────────────────── Выгрузка ─────────────────────────

/// Таблица вычитки языка [lang].
String exportCsv(String lang, {String dir = arbDir}) {
  final rows = reviewRows(
    lang,
    readArb(arbFile(sourceLanguage, dir: dir)),
    readArb(arbFile(lang, dir: dir)),
  );
  return toCsv([
    columns,
    for (final r in rows)
      [r.id, r.section, r.context, r.russian, r.numbers, r.translation, '', ''],
  ]);
}

/// Таблицы всех переводов (или [langs]) в [out]: `tachogo-<lang>.csv`.
Future<void> exportAll(Directory out, List<String>? langs) async {
  await out.create(recursive: true);
  for (final lang in langs ?? translations()) {
    final file = File('${out.path}/tachogo-$lang.csv');
    await file.writeAsString(exportCsv(lang));
    stdout.writeln(file.path);
  }
}

// ───────────────────────── Загрузка ─────────────────────────

/// Итог загрузки правок.
class ImportReport {
  final applied = <String>[];
  final rejected = <(String id, String reason)>[];
  final comments = <(String id, String comment)>[];

  @override
  String toString() {
    final b = StringBuffer()
      ..writeln('Применено исправлений: ${applied.length}');
    for (final id in applied) {
      b.writeln('  $id');
    }
    if (rejected.isNotEmpty) {
      b.writeln('Не применено: ${rejected.length}');
      for (final (id, reason) in rejected) {
        b.writeln('  $id — $reason');
      }
    }
    if (comments.isNotEmpty) {
      b.writeln('Комментарии: ${comments.length}');
      for (final (id, comment) in comments) {
        b.writeln('  $id: $comment');
      }
    }
    if (applied.isNotEmpty) {
      b.writeln('Дальше: flutter gen-l10n && flutter test test/l10n');
    }
    return b.toString();
  }
}

/// Язык по имени файла таблицы: tachogo-uk.csv → uk.
String? languageOf(String path) =>
    RegExp(r'tachogo-(\w+)(?:\s*\(\d+\))?\.csv$').firstMatch(path)?.group(1);

/// Применяет исправления из таблицы [file] к `app_<lang>.arb`.
Future<ImportReport> importFile(
  File file, {
  String? lang,
  String dir = arbDir,
}) async {
  final code = lang ?? languageOf(file.path);
  if (code == null) {
    throw ArgumentError('Язык не понятен из имени файла — укажите --lang');
  }
  final arb = arbFile(code, dir: dir);
  final translation = readArb(arb);
  final report = applyCorrections(
    translation,
    parseCsv(await file.readAsString()),
  );
  if (report.applied.isNotEmpty) writeArb(arb, translation);
  return report;
}

/// Исправления из строк таблицы [rows] (первая — заголовок) в карту
/// перевода [translation].
ImportReport applyCorrections(
  Map<String, Object?> translation,
  List<List<String>> rows,
) {
  final report = ImportReport();
  if (rows.isEmpty) return report;
  final header = [for (final h in rows.first) h.trim().toLowerCase()];
  int col(String name) => header.indexOf(name);
  final (idCol, fixCol, commentCol) = (
    col('id'),
    col('correction'),
    col('comment'),
  );
  if (idCol < 0 || fixCol < 0) {
    throw const FormatException('В таблице нет колонок id и correction');
  }
  String cell(List<String> row, int i) =>
      i >= 0 && i < row.length ? row[i].trim() : '';

  // Исправления одного сообщения собираются вместе: фраза и варианты.
  final byKey = <String, Map<String?, String>>{};
  for (final row in rows.skip(1)) {
    final id = cell(row, idCol);
    if (id.isEmpty) continue;
    if (cell(row, commentCol) case final comment when comment.isNotEmpty) {
      report.comments.add((id, comment));
    }
    final fix = cell(row, fixCol);
    if (fix.isEmpty) continue;
    final hash = id.indexOf('#');
    final key = hash < 0 ? id : id.substring(0, hash);
    (byKey[key] ??= {})[hash < 0 ? null : id.substring(hash + 1)] = fix;
  }

  for (final MapEntry(:key, value: fixes) in byKey.entries) {
    final current = translation[key];
    if (current is! String) {
      for (final variant in fixes.keys) {
        report.rejected.add((_id(key, variant), 'нет такого ключа'));
      }
      continue;
    }
    final icu = IcuMessage.parse(current);
    if (icu == null) {
      final fix = fixes[null];
      for (final variant in fixes.keys.whereType<String>()) {
        report.rejected.add((_id(key, variant), 'у строки нет вариантов'));
      }
      if (fix == null) continue;
      if (_problem(current, fix) case final problem?) {
        report.rejected.add((key, problem));
        continue;
      }
      translation[key] = fix;
      report.applied.add(key);
      continue;
    }

    var prefix = icu.prefix;
    var suffix = icu.suffix;
    final cases = Map.of(icu.cases);
    final applied = <String>[];
    for (final MapEntry(key: variant, value: fix) in fixes.entries) {
      final id = _id(key, variant);
      if (variant == null) {
        final parts = fix.split(icu.marker);
        if (parts.length != 2) {
          report.rejected.add((id, 'метка ${icu.marker} должна остаться одна'));
          continue;
        }
        if (_problem(icu.prefix + icu.suffix, parts.join()) case final p?) {
          report.rejected.add((id, p));
          continue;
        }
        (prefix, suffix) = (parts[0], parts[1]);
      } else {
        final old = cases[variant];
        if (old == null) {
          report.rejected.add((id, 'нет варианта $variant'));
          continue;
        }
        if (_problem(old, fix) case final p?) {
          report.rejected.add((id, p));
          continue;
        }
        cases[variant] = fix;
      }
      applied.add(id);
    }
    if (applied.isEmpty) continue;
    translation[key] = IcuMessage(
      prefix: prefix,
      name: icu.name,
      kind: icu.kind,
      cases: cases,
      suffix: suffix,
    ).build();
    report.applied.addAll(applied);
  }
  return report;
}

String _id(String key, String? variant) =>
    variant == null ? key : '$key#$variant';

/// Почему исправление [fix] строки [old] нельзя применить; null — можно.
String? _problem(String old, String fix) {
  if (!bracesBalanced(fix)) return 'скобки { } не парные';
  final before = placeholders(old);
  final after = placeholders(fix);
  if (before.length != after.length || !before.containsAll(after)) {
    return 'подстановки ${before.map((p) => '{$p}').join(' ')} '
        'должны остаться как есть';
  }
  return null;
}
