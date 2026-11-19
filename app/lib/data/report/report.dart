/// Report for a period (screen 16): the period bounds and the CSV. The PDF is
/// built from the same data in `features/export`. Export is Premium
/// (`docs/premium.md`).
library;

import 'dart:convert';

import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/data/journal/shift_meta.dart';

/// Report period.
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

/// A CSV row before sorting.
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
  final notes = _CsvNotes(journal, includeNotes: includeNotes);
  // Записи режимов — раньше ручных смен: заметка смены — в первой строке
  final rows = [
    ..._periodRows(journal, range, notes),
    ..._manualShiftRows(journal, range, notes),
  ]..sort((a, b) => a.start.compareTo(b.start));

  final lines = [
    _csvHeader(includeNotes: includeNotes).map(csvCell).join(','),
    for (final r in rows) r.cells.map(csvCell).join(','),
  ];
  // BOM — чтобы Excel открыл кириллицу в UTF-8
  return '﻿${lines.join('\r\n')}\r\n';
}

/// Заголовки колонок CSV.
List<String> _csvHeader({required bool includeNotes}) => [
  'activity',
  'start_utc',
  'end_utc',
  'duration_min',
  'driving_min',
  'ferry',
  if (includeNotes) ...['country_start', 'country_end', 'note'],
];

/// Строки записей режимов, обрезанных по границам периода; идущая запись —
/// `ACTIVE`.
List<_Row> _periodRows(Journal journal, TimeRange range, _CsvNotes notes) {
  final from = range.start;
  final to = range.end;
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
        ...notes.cells(notes.shiftOf(p.start)),
      ],
    ));
  }
  return rows;
}

/// Строки смен, внесённых итогами и начатых в периоде: `MANUAL_SHIFT` с
/// вождением за смену.
List<_Row> _manualShiftRows(Journal journal, TimeRange range, _CsvNotes notes) {
  final rows = <_Row>[];
  for (final s in journal.shifts) {
    if (s.manual == null ||
        s.start.isBefore(range.start) ||
        !s.start.isBefore(range.end)) {
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
        ...notes.cells(s),
      ],
    ));
  }
  return rows;
}

/// The country and note columns of one CSV: which shift a record belongs to,
/// and the shift's note only in its first row. Lives for one [buildCsv] call.
final class _CsvNotes {
  new(this._journal, {required this.includeNotes})
    : _recorded = [
        for (final s in _journal.shifts)
          if (s.recorded != null) s,
      ]..sort((a, b) => a.start.compareTo(b.start));

  final Journal _journal;
  final bool includeNotes;

  /// Смены из записей режимов по возрастанию начала.
  final List<JournalShift> _recorded;

  /// Смены, чья заметка уже выведена.
  final _noted = <JournalShift>{};

  /// Смена, к которой относится запись [t]: последняя начатая до неё.
  JournalShift? shiftOf(DateTime t) {
    JournalShift? found;
    for (final s in _recorded) {
      if (s.start.isAfter(t)) break;
      found = s;
    }
    return found;
  }

  /// Страны и заметка смены [shift] для очередной строки; без колонок
  /// заметок — ничего.
  List<Object> cells(JournalShift? shift) {
    if (!includeNotes) return const [];
    if (shift == null) return const ['', '', ''];
    final meta = _journal.metaOf(shift);
    final first = _noted.add(shift);
    return [
      meta.startCountry ?? '',
      meta.endCountry ?? '',
      if (first) meta.note ?? '' else '',
    ];
  }
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
