/// DEV-03 (`docs/testing.md`): reading the app's log from its export CSV
/// (screen 16, UTC times) to compare it with the card of the same driver; the
/// comparison itself is `compareJournals` in `package:tacho_engine/card.dart`.
library;

import 'package:tacho_engine/card.dart';
import 'package:tacho_engine/tacho_engine.dart';

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
