import 'package:drift/drift.dart';
import 'package:tacho_engine/tacho_engine.dart';

/// Откуда взялась запись журнала.
enum EntrySource {
  /// Водитель переключил режим в приложении.
  live,

  /// Добавлено или исправлено вручную задним числом.
  manual,
}

/// Отрезки времени в одном режиме — основа журнала и расчётов движка.
/// Все даты — UTC.
@DataClassName('ActivityPeriodRow')
class ActivityPeriods extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get mode => textEnum<DriverMode>()();
  DateTimeColumn get startUtc => dateTime()();

  /// null — текущий, ещё не закрытый период.
  DateTimeColumn get endUtc => dateTime().nullable()();

  /// Смещение часового пояса устройства в момент начала, минуты.
  /// Нужно для отображения при смене часового пояса в пути.
  IntColumn get utcOffsetMinutes => integer()();
  TextColumn get source => textEnum<EntrySource>()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

/// Смены: начало/конец и страны по кодам тахографа (PL, D, …).
@DataClassName('ShiftRow')
class Shifts extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get startUtc => dateTime()();
  DateTimeColumn get endUtc => dateTime().nullable()();
  TextColumn get startCountry => text().withLength(min: 1, max: 3)();
  TextColumn get endCountry => text().withLength(min: 1, max: 3).nullable()();
  IntColumn get utcOffsetMinutes => integer()();
}

/// Считывания карты водителя (лимит 28 дней).
@DataClassName('CardDownloadRow')
class CardDownloads extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get downloadedAtUtc => dateTime()();
}

/// Настройки «ключ — значение» (язык, тема, пакет мобильности, пороги…).
@DataClassName('SettingRow')
class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
