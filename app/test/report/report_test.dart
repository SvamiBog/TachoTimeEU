// Отчёт за период: границы, CSV. План тестов: EXP-01…03 в docs/testing.md.

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/data/journal/shift_meta.dart';
import 'package:tachogo/data/report/report.dart';

import '../support/journal_fixtures.dart';

Duration h(int hours, [int minutes = 0]) =>
    Duration(hours: hours, minutes: minutes);

/// Журнал для отчёта без провайдеров.
Journal journalOf(
  List<ActivityPeriod> periods,
  DateTime now, {
  List<ManualShiftRecord> manual = const [],
  Map<DateTime, ShiftMeta> meta = const {},
}) {
  final timeline = analyzeTimeline(periods, now);
  return Journal(
    now: now,
    periods: periods,
    timeline: timeline,
    weeks: buildJournal(
      timeline: timeline,
      now: now,
      manualShifts: [for (final r in manual) r.shift],
    ),
    recordedMeta: meta,
    manualMeta: {for (final r in manual) ?r.shift.id: r.meta},
  );
}

/// Строки CSV без BOM.
List<String> lines(String csv) {
  expect(csv.startsWith('﻿'), isTrue, reason: 'BOM для Excel');
  expect(csv.endsWith('\r\n'), isTrue);
  expect(csv.replaceAll('\r\n', '').contains('\n'), isFalse, reason: 'CRLF');
  return csv.substring(1).trimRight().split('\r\n');
}

void main() {
  group('EXP-01: ячейка CSV', () {
    test('всегда в кавычках, кавычки удваиваются', () {
      expect(csvCell('PL'), '"PL"');
      expect(csvCell(42), '"42"');
      expect(csvCell('паром "Стена"'), '"паром ""Стена"""');
      expect(csvCell(''), '""');
      expect(csvCell('a,b\nc'), '"a,b\nc"');
    });

    test('текст, похожий на формулу, — с апострофом', () {
      for (final s in ['=1+1', '+7', '-3', '@SUM(A1)', '\tx', '\rx']) {
        expect(csvCell(s), startsWith('"\''), reason: s);
      }
      expect(csvCell('=HYPERLINK("x")'), '"\'=HYPERLINK(""x"")"');
      expect(csvCell('ожидание=1'), '"ожидание=1"');
      expect(csvCell(-3), '"-3"', reason: 'число — не формула');
    });

    test('BOM, CRLF, UTF-8', () {
      final now = DateTime.utc(2026, 9, 23, 12);
      final csv = buildCsv(journalOf(const [], now), (
        start: now.subtract(const Duration(days: 1)),
        end: now,
      ), includeNotes: true);
      expect(lines(csv).single, startsWith('"activity","start_utc"'));
      final bytes = csvBytes(csv);
      expect(utf8.decode(bytes.skip(3).toList()), csv.substring(1));
      expect(csvBytes(csv).take(3), [0xEF, 0xBB, 0xBF]);
    });
  });

  group('EXP-02: записи периода', () {
    final now = DateTime.utc(2026, 9, 23, 12);
    final periods = consecutive(DateTime.utc(2026, 9, 21, 20), [
      (DriverMode.rest, h(10)),
      (DriverMode.driving, h(4, 30)),
      (DriverMode.rest, h(0, 45)),
      (DriverMode.otherWork, h(3, 45)),
      (DriverMode.rest, h(17)),
      (DriverMode.driving, h(2)),
    ], open: true);
    final shiftStart = DateTime.utc(2026, 9, 22, 6);

    test('обрезаны по границам, идущая запись — ACTIVE', () {
      final csv = buildCsv(journalOf(periods, now), (
        start: DateTime.utc(2026, 9, 22),
        end: now,
      ), includeNotes: false);
      final rows = lines(csv);
      expect(
        rows.first,
        '"activity","start_utc","end_utc","duration_min",'
        '"driving_min","ferry"',
      );
      // Время, длительность, вождение, паром
      String row(String mode, String from, String to, int min, int drive) =>
          '"$mode","2026-09-$from","$to","$min","$drive","0"';
      expect(rows.skip(1).toList(), [
        row('REST', '22T00:00:00Z', '2026-09-22T06:00:00Z', 360, 0),
        row('DRIVING', '22T06:00:00Z', '2026-09-22T10:30:00Z', 270, 270),
        row('REST', '22T10:30:00Z', '2026-09-22T11:15:00Z', 45, 0),
        row('OTHER_WORK', '22T11:15:00Z', '2026-09-22T15:00:00Z', 225, 0),
        row('REST', '22T15:00:00Z', '2026-09-23T08:00:00Z', 1020, 0),
        row('DRIVING', '23T08:00:00Z', 'ACTIVE', 240, 240),
      ]);
    });

    test('период в прошлом — идущая запись обрезана, не ACTIVE', () {
      final csv = buildCsv(journalOf(periods, now), (
        start: DateTime.utc(2026, 9, 22, 10),
        end: DateTime.utc(2026, 9, 23, 9),
      ), includeNotes: false);
      final rows = lines(csv);
      expect(rows[1], startsWith('"DRIVING","2026-09-22T10:00:00Z"'));
      expect(
        rows.last,
        '"DRIVING","2026-09-23T08:00:00Z","2026-09-23T09:00:00Z","60","60","0"',
      );
    });

    test('записи вне периода не выгружаются', () {
      final csv = buildCsv(journalOf(periods, now), (
        start: DateTime.utc(2026, 9, 25),
        end: DateTime.utc(2026, 9, 26),
      ), includeNotes: false);
      expect(lines(csv), hasLength(1));
    });

    test('страны и заметка — колонками, заметка в первой строке смены', () {
      final csv = buildCsv(
        journalOf(
          periods,
          now,
          meta: {
            shiftStart: const ShiftMeta(
              startCountry: 'PL',
              endCountry: 'D',
              note: '=ожидание',
            ),
          },
        ),
        (start: shiftStart, end: DateTime.utc(2026, 9, 22, 16)),
        includeNotes: true,
      );
      final rows = lines(csv);
      expect(rows.first, endsWith('"country_start","country_end","note"'));
      expect(rows[1], endsWith('"PL","D","\'=ожидание"'));
      expect(rows[2], endsWith('"PL","D",""'));
      expect(rows, hasLength(5));
    });

    test('без «стран и заметок» колонок нет', () {
      final csv = buildCsv(
        journalOf(
          periods,
          now,
          meta: {shiftStart: const ShiftMeta(startCountry: 'PL', note: 'x')},
        ),
        (start: shiftStart, end: now),
        includeNotes: false,
      );
      expect(csv, isNot(contains('PL')));
      expect(csv, isNot(contains('country')));
      for (final row in lines(csv)) {
        expect(','.allMatches(row), hasLength(5), reason: row);
      }
    });

    test('паром — отметкой, ручная смена — строкой с вождением', () {
      final ferry = [
        ActivityPeriod(
          mode: DriverMode.rest,
          start: DateTime.utc(2026, 9, 22, 20),
          end: DateTime.utc(2026, 9, 22, 22),
          ferry: true,
        ),
      ];
      final manual = ManualShiftRecord(
        ManualShift(
          id: 3,
          start: DateTime.utc(2026, 9, 22, 6),
          end: DateTime.utc(2026, 9, 22, 16),
          driving: h(8, 20),
          restKind: RestKind.daily,
        ),
        const ShiftMeta(
          startCountry: 'CZ',
          endCountry: 'SK',
          note:
              'до '
              'установки',
        ),
      );
      final csv = buildCsv(journalOf(ferry, now, manual: [manual]), (
        start: DateTime.utc(2026, 9, 22),
        end: now,
      ), includeNotes: true);
      final rows = lines(csv);
      expect(
        rows[1],
        '"MANUAL_SHIFT","2026-09-22T06:00:00Z","2026-09-22T16:00:00Z",'
        '"600","500","0","CZ","SK","до установки"',
      );
      expect(rows[2], startsWith('"REST","2026-09-22T20:00:00Z"'));
      expect(rows[2], contains('"120","0","1"'));
    });
  });

  group('EXP-03: период отчёта — границы в UTC', () {
    // Ср 23.09.2026 12:00 UTC
    final now = DateTime.utc(2026, 9, 23, 12);

    test('«Эта неделя» — с понедельника 00:00 UTC', () {
      expect(reportRange(ReportPeriod.week, now), (
        start: DateTime.utc(2026, 9, 21),
        end: now,
      ));
    });

    test('«2 недели» — с понедельника прошлой недели', () {
      expect(reportRange(ReportPeriod.twoWeeks, now), (
        start: DateTime.utc(2026, 9, 14),
        end: now,
      ));
    });

    test('«28 дней» — 28 суток с сегодняшними, с 00:00 UTC', () {
      final r = reportRange(ReportPeriod.days28, now);
      expect(r.start, DateTime.utc(2026, 8, 27));
      expect(r.end, now);
      expect(
        DateTime.utc(now.year, now.month, now.day + 1).difference(r.start),
        const Duration(days: 28),
      );
    });

    test('«56 дней» — 56 суток с сегодняшними, с 00:00 UTC', () {
      final r = reportRange(ReportPeriod.days56, now);
      expect(r.start, DateTime.utc(2026, 7, 30));
      expect(r.end, now);
      expect(
        DateTime.utc(now.year, now.month, now.day + 1).difference(r.start),
        const Duration(days: 56),
      );
    });

    test('в понедельник 00:00 неделя только началась', () {
      final monday = DateTime.utc(2026, 9, 21);
      expect(reportRange(ReportPeriod.week, monday).start, monday);
    });

    test('свой период — с начала первого дня до конца последнего', () {
      expect(
        reportRange(
          ReportPeriod.custom,
          now,
          first: DateTime(2026, 9, 1, 23, 30),
          last: DateTime(2026, 9, 10),
        ),
        (start: DateTime.utc(2026, 9), end: DateTime.utc(2026, 9, 11)),
      );
    });

    test('свой период по сегодня — не дальше сейчас', () {
      expect(
        reportRange(
          ReportPeriod.custom,
          now,
          first: DateTime(2026, 9, 20),
          last: DateTime(2026, 9, 23),
        ).end,
        now,
      );
      expect(
        reportRange(ReportPeriod.custom, now).start,
        DateTime.utc(2026, 9, 23),
      );
    });

    test('смены периода — по началу смены, по возрастанию', () {
      final j = designJournal();
      final journal = journalOf(j.periods, j.now);
      final week = shiftsInRange(
        journal.shifts,
        reportRange(ReportPeriod.week, j.now),
      );
      expect(week.map((s) => s.start.day), [21, 22, 23]);
      final two = shiftsInRange(
        journal.shifts,
        reportRange(ReportPeriod.twoWeeks, j.now),
      );
      expect(two, hasLength(8));
    });

    test('имя файла — первый и последний день периода', () {
      expect(
        reportFileName(reportRange(ReportPeriod.days28, now), 'pdf'),
        'tachogo_2026-08-27_2026-09-23.pdf',
      );
      expect(
        reportFileName((
          start: DateTime.utc(2026, 9),
          end: DateTime.utc(2026, 9, 11),
        ), 'csv'),
        'tachogo_2026-09-01_2026-09-10.csv',
      );
    });

    test('страны смены', () {
      expect(routeText(ShiftMeta.empty), '—');
      expect(routeText(const ShiftMeta(startCountry: 'PL')), 'PL → …');
      expect(
        routeText(const ShiftMeta(startCountry: 'PL', endCountry: 'D')),
        'PL → D',
      );
    });
  });
}
