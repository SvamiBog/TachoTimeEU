/// Drift converter that keeps every stored date in UTC.
library;

import 'package:drift/drift.dart';

/// Converts dates to UTC on write and read.
///
/// Dates are stored as ISO text (`store_date_time_values_as_text`), and SQL
/// compares them as strings: a local "09:30+02:00" would sort after "08:00Z",
/// although it is 07:30Z. The converter guarantees only UTC reaches the column.
/// It does not apply to values in `where` (`isBiggerThanValue` and the like) —
/// pass `.toUtc()` there.
class UtcDateTimeConverter extends TypeConverter<DateTime, DateTime> {
  const new();

  @override
  DateTime fromSql(DateTime fromDb) => fromDb.toUtc();

  @override
  DateTime toSql(DateTime value) => value.toUtc();
}

/// Дата из колонки с [UtcDateTimeConverter], прочитанная из базы текстом.
///
/// Конвертер пишет только UTC, а Drift хранит такую дату как
/// `2026-09-21T06:00:00.000Z` (с микросекундами — `…00.000123Z`). Эту форму
/// разбираем сами: `DateTime.parse` у Drift идёт через регулярное выражение
/// и на журнале за 2 года занимал больше половины времени чтения. Любую
/// другую строку отдаём [fallback] — разбору Drift.
DateTime parseStoredUtc(String raw, DateTime Function(String raw) fallback) =>
    _parseIsoUtc(raw) ?? fallback(raw);

const _dash = 0x2D;
const _colon = 0x3A;
const _dot = 0x2E;
const _zero = 0x30;
const _letterT = 0x54;
const _letterZ = 0x5A;

/// `YYYY-MM-DDTHH:MM:SS.mmmZ` или `YYYY-MM-DDTHH:MM:SS.mmmuuuZ`; null —
/// строка другой формы или с невозможным значением.
DateTime? _parseIsoUtc(String s) {
  final length = s.length;
  if (length != 24 && length != 27) return null;
  if (s.codeUnitAt(4) != _dash ||
      s.codeUnitAt(7) != _dash ||
      s.codeUnitAt(10) != _letterT ||
      s.codeUnitAt(13) != _colon ||
      s.codeUnitAt(16) != _colon ||
      s.codeUnitAt(19) != _dot ||
      s.codeUnitAt(length - 1) != _letterZ) {
    return null;
  }
  final year = _digits(s, 0, 4);
  final month = _digits(s, 5, 7);
  final day = _digits(s, 8, 10);
  final hour = _digits(s, 11, 13);
  final minute = _digits(s, 14, 16);
  final second = _digits(s, 17, 19);
  final millisecond = _digits(s, 20, 23);
  final microsecond = length == 27 ? _digits(s, 23, 26) : 0;
  if (year < 0 ||
      month < 1 ||
      month > 12 ||
      day < 1 ||
      day > 31 ||
      hour < 0 ||
      hour > 23 ||
      minute < 0 ||
      minute > 59 ||
      second < 0 ||
      second > 59 ||
      millisecond < 0 ||
      microsecond < 0) {
    return null;
  }
  return DateTime.utc(
    year,
    month,
    day,
    hour,
    minute,
    second,
    millisecond,
    microsecond,
  );
}

/// Число из цифр [s] с [from] до [to]; -1 — там не только цифры.
int _digits(String s, int from, int to) {
  var value = 0;
  for (var i = from; i < to; i++) {
    final digit = s.codeUnitAt(i) - _zero;
    if (digit < 0 || digit > 9) return -1;
    value = value * 10 + digit;
  }
  return value;
}
