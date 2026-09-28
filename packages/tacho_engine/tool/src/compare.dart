// DEV-03 (docs/testing.md): журнал приложения против карты того же
// водителя. Журнал приложения — CSV экспорта (экран 16, время UTC), карта —
// файл выгрузки .DDD. Сравнение поминутно, по середине минуты: тахограф
// пишет режим целыми минутами, приложение — с точностью до секунды, поэтому
// сдвиг границы внутри минуты даёт расхождение не больше минуты.

import 'package:tacho_engine/tacho_engine.dart';

import 'ddd.dart';

/// Запись журнала из CSV приложения; `end` null — запись идёт (ACTIVE).
typedef AppRecord = ({DriverMode mode, DateTime start, DateTime? end});

const Map<String, DriverMode> _modes = {
  'DRIVING': DriverMode.driving,
  'OTHER_WORK': DriverMode.otherWork,
  'AVAILABILITY': DriverMode.availability,
  'REST': DriverMode.rest,
};

/// Разбор CSV экспорта приложения (`app/lib/data/report/report.dart`):
/// BOM, кавычки, запятая или точка с запятой после пересохранения в Excel.
List<AppRecord> readAppCsv(String text) {
  final rows = _parseCsv(text);
  if (rows.isEmpty) return const [];
  final header = rows.first;
  final activity = header.indexOf('activity');
  final start = header.indexOf('start_utc');
  final end = header.indexOf('end_utc');
  if (activity < 0 || start < 0 || end < 0) {
    throw const FormatException(
      'Это не CSV TachoGo: нет колонок activity, start_utc, end_utc',
    );
  }
  return [
    for (final r in rows.skip(1))
      (
        mode:
            _modes[r[activity]] ??
            (throw FormatException('Неизвестный режим ${r[activity]}')),
        start: DateTime.parse(r[start]),
        end: r[end] == 'ACTIVE' ? null : DateTime.parse(r[end]),
      ),
  ];
}

List<List<String>> _parseCsv(String text) {
  var s = text.startsWith('﻿') ? text.substring(1) : text;
  s = s.replaceAll('\r\n', '\n');
  final first = s.split('\n').first;
  final delimiter = ';'.allMatches(first).length > ','.allMatches(first).length
      ? ';'
      : ',';
  final rows = <List<String>>[];
  var row = <String>[];
  final field = StringBuffer();
  var quoted = false;
  for (var i = 0; i < s.length; i++) {
    final c = s[i];
    if (quoted) {
      if (c == '"' && i + 1 < s.length && s[i + 1] == '"') {
        field.write('"');
        i++;
      } else if (c == '"') {
        quoted = false;
      } else {
        field.write(c);
      }
    } else if (c == '"') {
      quoted = true;
    } else if (c == delimiter) {
      row.add(field.toString());
      field.clear();
    } else if (c == '\n') {
      rows.add([...row, field.toString()]);
      row = [];
      field.clear();
    } else {
      field.write(c);
    }
  }
  if (field.isNotEmpty || row.isNotEmpty) rows.add([...row, field.toString()]);
  return [
    for (final r in rows)
      if (r.any((v) => v.isNotEmpty)) r,
  ];
}

/// Отрезок, где журналы не совпали. `card` null — на карте «неизвестно»
/// (карта не вставлена, вручную не введено).
typedef Mismatch = ({
  DateTime start,
  DateTime end,
  DriverMode? app,
  DriverMode? card,
});

class JournalComparison {
  const new({required this.from, required this.to, required this.mismatches});

  final DateTime from;
  final DateTime to;
  final List<Mismatch> mismatches;

  /// Расхождения, где на карте режим известен.
  Iterable<Mismatch> get known => mismatches.where((m) => m.card != null);

  /// Критерий DEV-03: каждое расхождение с известным режимом карты — не
  /// больше минуты.
  bool get passed => known.every((m) => m.end.difference(m.start) <= _minute);

  int get mismatchMinutes =>
      mismatches.fold(0, (sum, m) => sum + m.end.difference(m.start).inMinutes);
}

const _minute = Duration(minutes: 1);

/// Поминутное сравнение на общем отрезке журналов, или на [from]–[to].
/// Идущая запись приложения тянется до [now].
JournalComparison compareJournals(
  List<AppRecord> app,
  List<CardPeriod> card, {
  required DateTime now,
  DateTime? from,
  DateTime? to,
}) {
  if (app.isEmpty || card.isEmpty) {
    throw ArgumentError('Нечего сравнивать: один из журналов пуст');
  }
  DateTime minute(DateTime t) =>
      DateTime.utc(t.year, t.month, t.day, t.hour, t.minute);
  final appStart = app.map((r) => r.start).reduce(_earlier);
  final appEnd = app.map((r) => r.end ?? now).reduce(_later);
  var start = minute(_later(appStart, card.first.start));
  var end = minute(_earlier(appEnd, card.last.end));
  if (from != null && from.isAfter(start)) start = minute(from);
  if (to != null && to.isBefore(end)) end = minute(to);

  DriverMode? appAt(DateTime t) {
    for (final r in app) {
      if (!r.start.isAfter(t) && (r.end ?? now).isAfter(t)) return r.mode;
    }
    return null;
  }

  var cardIndex = 0;
  (bool, DriverMode?) cardAt(DateTime t) {
    while (cardIndex < card.length && !card[cardIndex].end.isAfter(t)) {
      cardIndex++;
    }
    if (cardIndex == card.length || card[cardIndex].start.isAfter(t)) {
      return (false, null);
    }
    return (true, card[cardIndex].mode);
  }

  final mismatches = <Mismatch>[];
  for (var m = start; m.isBefore(end); m = m.add(_minute)) {
    final middle = m.add(const Duration(seconds: 30));
    final a = appAt(middle);
    final (covered, c) = cardAt(middle);
    if (!covered || a == c) continue;
    final last = mismatches.isEmpty ? null : mismatches.last;
    if (last != null && last.end == m && last.app == a && last.card == c) {
      mismatches.last = (
        start: last.start,
        end: m.add(_minute),
        app: a,
        card: c,
      );
    } else {
      mismatches.add((start: m, end: m.add(_minute), app: a, card: c));
    }
  }
  return JournalComparison(from: start, to: end, mismatches: mismatches);
}

DateTime _earlier(DateTime a, DateTime b) => a.isBefore(b) ? a : b;
DateTime _later(DateTime a, DateTime b) => a.isAfter(b) ? a : b;
