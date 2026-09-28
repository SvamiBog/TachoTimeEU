// Файл карты водителя (.DDD) для проверок Фазы 4 — docs/testing.md,
// ENG-20 и DEV-03, как собрать фикстуру — test/fixtures/real/README.md.
//
//   dart run tool/ddd.dart summary <карта.ddd>
//       сутки, режимы по суткам, особые условия, нарушения по движку
//   dart run tool/ddd.dart fixture <карта.ddd> --name <имя>
//       [--from 2026-09-01] [--to 2026-09-29] [--unknown rest|gap] [--crew]
//       фикстура ENG-20 в stdout: журнал без персональных данных, пустой
//       список expected — заполнить по отчёту программы анализа
//   dart run tool/ddd.dart compare <карта.ddd> <tachogo.csv>
//       [--from …] [--to …]
//       DEV-03: журнал приложения против карты, расхождения больше минуты
//
// Даты --from / --to — сутки UTC, --to не включается.

import 'dart:io';

import 'package:tacho_engine/tacho_engine.dart';

import 'src/compare.dart';
import 'src/ddd.dart';
import 'src/fixture.dart';
import 'src/violations.dart';

void main(List<String> args) {
  if (args.length < 2) return _usage();
  final options = _options(args);
  final card = DriverCard.parse(File(args[1]).readAsBytesSync());
  final from = _date(options['from']);
  final to = _date(options['to']);
  final unknownAsRest = options['unknown'] != 'gap';
  switch (args.first) {
    case 'summary':
      stdout.write(summary(card, unknownAsRest: unknownAsRest));
    case 'fixture':
      final name = options['name'];
      if (name == null) return _usage();
      stdout.write(
        fixtureOf(
          card,
          name: name,
          from: from,
          to: to,
          unknownAsRest: unknownAsRest,
          crew: options.containsKey('crew'),
        ).encode(),
      );
    case 'compare':
      if (args.length < 3) return _usage();
      final app = readAppCsv(File(args[2]).readAsStringSync());
      final result = compareJournals(
        app,
        cardPeriods(card.days),
        now: DateTime.now().toUtc(),
        from: from,
        to: to,
      );
      stdout.write(comparisonReport(result));
      if (!result.passed) exitCode = 1;
    default:
      _usage();
  }
}

void _usage() {
  stderr.writeln(
    'dart run tool/ddd.dart summary <card.ddd>\n'
    'dart run tool/ddd.dart fixture <card.ddd> --name <name> '
    '[--from YYYY-MM-DD] [--to YYYY-MM-DD] [--unknown rest|gap] [--crew]\n'
    'dart run tool/ddd.dart compare <card.ddd> <tachogo.csv> '
    '[--from YYYY-MM-DD] [--to YYYY-MM-DD]',
  );
  exitCode = 64;
}

Map<String, String> _options(List<String> args) {
  final result = <String, String>{};
  for (var i = 0; i < args.length; i++) {
    if (!args[i].startsWith('--')) continue;
    final name = args[i].substring(2);
    final hasValue = i + 1 < args.length && !args[i + 1].startsWith('--');
    result[name] = hasValue ? args[++i] : '';
  }
  return result;
}

DateTime? _date(String? s) =>
    s == null || s.isEmpty ? null : DateTime.parse('${s}T00:00:00Z');

String _hm(Duration d) =>
    '${d.inHours}:${(d.inMinutes % 60).toString().padLeft(2, '0')}';

/// Сводка по карте: поколение, сутки с суммами режимов, особые условия и
/// нарушения, которые видит движок.
String summary(DriverCard card, {bool unknownAsRest = true}) {
  final b = StringBuffer()
    ..writeln('Карта: поколение ${card.generation}, суток ${card.days.length}')
    ..writeln(
      'Последнее считывание по карте: '
      '${card.lastDownload?.toIso8601String() ?? '—'}',
    )
    ..writeln(
      'Сутки (UTC): вождение / работа / готовность / отдых / нет данных',
    );
  final periods = cardPeriods(card.days);
  for (final day in card.days) {
    final next = day.date.add(const Duration(days: 1));
    final sums = <DriverMode?, Duration>{};
    var crew = false;
    for (final p in periods) {
      final start = p.start.isAfter(day.date) ? p.start : day.date;
      final end = p.end.isBefore(next) ? p.end : next;
      if (!end.isAfter(start)) continue;
      sums[p.mode] = (sums[p.mode] ?? Duration.zero) + end.difference(start);
      crew |= p.crew;
    }
    String of(DriverMode? m) => _hm(sums[m] ?? Duration.zero);
    b.writeln(
      '  ${isoDate(day.date)}  ${of(DriverMode.driving)} / '
      '${of(DriverMode.otherWork)} / ${of(DriverMode.availability)} / '
      '${of(DriverMode.rest)} / ${of(null)}'
      '${crew ? '  экипаж' : ''}  ${day.distanceKm} км',
    );
  }
  if (card.conditions.isNotEmpty) {
    b.writeln('Особые условия:');
    for (final c in card.conditions) {
      b.writeln('  ${c.at.toIso8601String()} ${c.type.name}');
    }
  }
  final violations = journalViolations(
    toEnginePeriods(
      periods,
      unknownAsRest: unknownAsRest,
      conditions: card.conditions,
    ),
  );
  b.writeln('Нарушения по движку (${violations.length}):');
  for (final v in violations) {
    b.writeln(
      '  ${v.at.toIso8601String()} ${v.type.name} '
      '(${v.type.regulation}, ст. ${v.article})',
    );
  }
  return b.toString();
}

/// Фикстура ENG-20 из карты: только режимы, без персональных данных.
RealJournalFixture fixtureOf(
  DriverCard card, {
  required String name,
  DateTime? from,
  DateTime? to,
  bool unknownAsRest = true,
  bool crew = false,
}) => RealJournalFixture(
  name: name,
  source:
      'карта водителя .DDD, поколение ${card.generation}; неизвестное — '
      '${unknownAsRest ? 'отдых' : 'разрыв'}',
  settings: ComplianceSettings(crew: crew ? CrewMode.team : CrewMode.solo),
  periods: toEnginePeriods(
    cardPeriods(card.days),
    unknownAsRest: unknownAsRest,
    conditions: card.conditions,
    from: from,
    to: to,
  ),
);

/// Отчёт DEV-03 по сравнению.
String comparisonReport(JournalComparison r) {
  final b = StringBuffer()
    ..writeln(
      'Сравнение ${r.from.toIso8601String()} — ${r.to.toIso8601String()}: '
      'расхождений ${r.mismatches.length}, ${r.mismatchMinutes} мин',
    );
  for (final m in r.mismatches) {
    final minutes = m.end.difference(m.start).inMinutes;
    b.writeln(
      '  ${m.start.toIso8601String()} +$minutes мин: '
      'приложение ${m.app?.name ?? '—'}, '
      'карта ${m.card?.name ?? 'нет данных'}'
      '${m.card != null && minutes > 1 ? '  ← больше минуты' : ''}',
    );
  }
  b.writeln(
    r.passed
        ? 'DEV-03: пройдено — расхождения не больше минуты'
        : 'DEV-03: не пройдено — есть расхождения больше минуты',
  );
  return b.toString();
}
