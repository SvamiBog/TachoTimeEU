import 'package:drift/drift.dart';

/// Приводит даты к UTC при записи и чтении.
///
/// Даты хранятся ISO-текстом (`store_date_time_values_as_text`), и SQL
/// сравнивает их как строки: локальное «09:30+02:00» оказалось бы позже
/// «08:00Z», хотя это 07:30Z. Конвертер гарантирует, что в колонку попадает
/// только UTC. Он не действует на значения в `where` (`isBiggerThanValue`
/// и т.п.) — туда передавать `.toUtc()`.
class UtcDateTimeConverter extends TypeConverter<DateTime, DateTime> {
  const new();

  @override
  DateTime fromSql(DateTime fromDb) => fromDb.toUtc();

  @override
  DateTime toSql(DateTime value) => value.toUtc();
}
