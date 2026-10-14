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
