import 'dart:convert';

import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/data/journal/shift_meta.dart';

// Отчёт за период (экран 16): границы периода и CSV. PDF собирается из тех
// же данных в features/export. Выгрузка — Premium (docs/premium.md).

/// Период отчёта.
enum ReportPeriod { week, twoWeeks, days28, days56, custom }

/// Границы отчёта [start, end). Все границы — UTC, как неделя тахографа
/// (ст. 4(i)): время на экране местное, а сутки и недели отчёта от пояса
/// не зависят.
///
/// - «Эта неделя» — с понедельника 00:00 UTC до сейчас.
/// - «2 недели» — с понедельника прошлой недели.
/// - «28 дней» — 28 суток вместе с сегодняшними: с 00:00 UTC 27 дней назад.
/// - «56 дней» — так же 56 суток: с 31.12.2024 при проверке предъявляют
///   записи за 56 дней (ст. 36 Регламента 165/2014).
/// - Свой период — с 00:00 UTC дня [first] до конца дня [last], не позже
///   сейчас. Берутся только год, месяц и день выбранных дат.
TimeRange reportRange(
  ReportPeriod period,
  DateTime now, {
  DateTime? first,
  DateTime? last,
}) {
  final today = DateTime.utc(now.year, now.month, now.day);
  final week = weekStartUtc(now);
  switch (period) {
    case ReportPeriod.week:
      return (start: week, end: now);
    case ReportPeriod.twoWeeks:
      return (start: week.subtract(const Duration(days: 7)), end: now);
    case ReportPeriod.days28:
      return (start: today.subtract(const Duration(days: 27)), end: now);
    case ReportPeriod.days56:
      return (start: today.subtract(const Duration(days: 55)), end: now);
    case ReportPeriod.custom:
      final a = first ?? today;
      final b = last ?? today;
      final start = DateTime.utc(a.year, a.month, a.day);
      final end = DateTime.utc(b.year, b.month, b.day + 1);
      return (start: start, end: end.isAfter(now) ? now : end);
  }
}

/// Смены, начатые в периоде, по возрастанию начала.
List<JournalShift> shiftsInRange(
  Iterable<JournalShift> shifts,
  TimeRange range,
) => [
  for (final s in shifts)
    if (!s.start.isBefore(range.start) && s.start.isBefore(range.end)) s,
]..sort((a, b) => a.start.compareTo(b.start));

/// Ячейка CSV: всегда в кавычках, кавычки удваиваются. Текст, который
/// Excel принял бы за формулу (`=`, `+`, `-`, `@`, таб, CR), экранируется
/// апострофом — иначе заметка «=HYPERLINK(…)» выполнится у инспектора.
String csvCell(Object value) {
  var s = '$value';
  if (value is String && RegExp('^[=+\\-@\t\r]').hasMatch(s)) s = "'$s";
  return '"${s.replaceAll('"', '""')}"';
}

/// Момент в CSV: «2026-09-22T06:30:00Z».
String csvTime(DateTime t) {
  final u = t.toUtc();
  String two(int n) => n.toString().padLeft(2, '0');
  return '${u.year}-${two(u.month)}-${two(u.day)}T'
      '${two(u.hour)}:${two(u.minute)}:${two(u.second)}Z';
}

const Map<DriverMode, String> _activity = {
  DriverMode.driving: 'DRIVING',
  DriverMode.otherWork: 'OTHER_WORK',
  DriverMode.availability: 'AVAILABILITY',
  DriverMode.rest: 'REST',
};

/// Строка CSV до сортировки.
typedef _Row = ({DateTime start, List<Object> cells});

/// CSV за период для таблиц и программ учёта: по строке на запись режима,
/// записи обрезаны по границам периода, идущая запись — `ACTIVE`. Смены,
/// внесённые итогами, — строкой `MANUAL_SHIFT` с вождением за смену.
/// [includeNotes] — колонки стран и заметки смены (заметка — в первой
/// строке смены). UTF-8 с BOM и CRLF — чтобы Excel открыл кириллицу.
String buildCsv(
  Journal journal,
  TimeRange range, {
  required bool includeNotes,
}) {
  final from = range.start;
  final to = range.end;
  final header = [
    'activity',
    'start_utc',
    'end_utc',
    'duration_min',
    'driving_min',
    'ferry',
    if (includeNotes) ...['country_start', 'country_end', 'note'],
  ];

  // Смена, к которой относится запись: последняя начатая до неё
  final recorded = [
    for (final s in journal.shifts)
      if (s.recorded != null) s,
  ]..sort((a, b) => a.start.compareTo(b.start));
  JournalShift? shiftOf(DateTime t) {
    JournalShift? found;
    for (final s in recorded) {
      if (s.start.isAfter(t)) break;
      found = s;
    }
    return found;
  }

  final noted = <JournalShift>{};
  List<Object> notes(JournalShift? shift) {
    if (!includeNotes) return const [];
    if (shift == null) return const ['', '', ''];
    final meta = journal.metaOf(shift);
    final first = noted.add(shift);
    return [
      meta.startCountry ?? '',
      meta.endCountry ?? '',
      if (first) meta.note ?? '' else '',
    ];
  }

  final rows = <_Row>[];
  for (final p in sortedByStart(journal.periods)) {
    final end = p.end ?? journal.now;
    if (!end.isAfter(from) || !p.start.isBefore(to)) continue;
    final start = p.start.isBefore(from) ? from : p.start;
    final clipped = end.isAfter(to) ? to : end;
    final minutes = durationBetween(start, clipped).inMinutes;
    rows.add((
      start: start,
      cells: [
        _activity[p.mode]!,
        csvTime(start),
        if (p.isOpen && !end.isAfter(to)) 'ACTIVE' else csvTime(clipped),
        minutes,
        if (p.mode == DriverMode.driving) minutes else 0,
        if (p.ferry) 1 else 0,
        ...notes(shiftOf(p.start)),
      ],
    ));
  }
  for (final s in journal.shifts) {
    if (s.manual == null || s.start.isBefore(from) || !s.start.isBefore(to)) {
      continue;
    }
    final end = s.end;
    rows.add((
      start: s.start,
      cells: [
        'MANUAL_SHIFT',
        csvTime(s.start),
        if (end == null) 'ACTIVE' else csvTime(end),
        s.span.inMinutes,
        s.driving.inMinutes,
        0,
        ...notes(s),
      ],
    ));
  }
  rows.sort((a, b) => a.start.compareTo(b.start));

  final lines = [
    header.map(csvCell).join(','),
    for (final r in rows) r.cells.map(csvCell).join(','),
  ];
  // BOM — чтобы Excel открыл кириллицу в UTF-8
  return '﻿${lines.join('\r\n')}\r\n';
}

/// CSV в байтах UTF-8 для файла.
List<int> csvBytes(String csv) => utf8.encode(csv);

/// Имя файла отчёта: «tachogo_2026-08-27_2026-09-23.pdf» — первый и
/// последний день периода (UTC).
String reportFileName(TimeRange range, String extension) {
  String day(DateTime t) => csvTime(t).substring(0, 10);
  return 'tachogo_${day(range.start)}_${day(lastDayOf(range))}.$extension';
}

/// Последний день периода [start, end).
DateTime lastDayOf(TimeRange range) =>
    range.end.subtract(const Duration(microseconds: 1));

/// День периода по UTC: «27.08», с годом — «27.08.2026». Границы отчёта —
/// UTC, поэтому и подписи — UTC, в любом часовом поясе.
String utcDay(DateTime t, {bool year = false}) {
  final u = t.toUtc();
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(u.day)}.${two(u.month)}${year ? '.${u.year}' : ''}';
}

/// Страны смены для отчёта: «PL → D».
String routeText(ShiftMeta meta) {
  final start = meta.startCountry;
  if (start == null) return '—';
  return '$start → ${meta.endCountry ?? '…'}';
}
