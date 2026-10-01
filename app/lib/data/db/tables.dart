import 'package:drift/drift.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/db/utc_date_time_converter.dart';

/// Откуда взялась запись журнала.
enum EntrySource {
  /// Водитель переключил режим в приложении.
  live,

  /// Добавлено или исправлено вручную задним числом.
  manual,
}

/// Отрезки времени в одном режиме — основа журнала и расчётов движка.
/// Все даты — UTC (приводятся [UtcDateTimeConverter]).
@DataClassName('ActivityPeriodRow')
class ActivityPeriods extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get mode => textEnum<DriverMode>()();
  DateTimeColumn get startUtc => dateTime().map(const UtcDateTimeConverter())();

  /// null — текущий, ещё не закрытый период.
  DateTimeColumn get endUtc =>
      dateTime().map(const UtcDateTimeConverter()).nullable()();

  /// Смещение часового пояса устройства в момент начала, минуты.
  /// Нужно для отображения при смене часового пояса в пути.
  IntColumn get utcOffsetMinutes => integer()();
  TextColumn get source => textEnum<EntrySource>()();
  TextColumn get note => text().nullable()();

  /// Отрезок записан в режиме «паром / поезд» (ст. 9 Регламента 561/2006).
  BoolColumn get ferry => boolean().withDefault(const Constant(false))();

  /// Отдых начат как конец рабочего дня («Завершить день»).
  BoolColumn get dayEnd => boolean().withDefault(const Constant(false))();

  /// Отдых объявлен недельным: «Начать недельный отдых» или недельный
  /// отдых после смены в журнале (`ActivityPeriod.weeklyRest`).
  BoolColumn get weeklyRest => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt =>
      dateTime().map(const UtcDateTimeConverter())();
  DateTimeColumn get updatedAt =>
      dateTime().map(const UtcDateTimeConverter())();
}

/// Смены: начало/конец и страны по кодам тахографа (PL, D, …).
@DataClassName('ShiftRow')
class Shifts extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get startUtc => dateTime().map(const UtcDateTimeConverter())();
  DateTimeColumn get endUtc =>
      dateTime().map(const UtcDateTimeConverter()).nullable()();
  TextColumn get startCountry => text().withLength(min: 1, max: 3)();
  TextColumn get endCountry => text().withLength(min: 1, max: 3).nullable()();
  IntColumn get utcOffsetMinutes => integer()();

  /// Заметка водителя к смене (экран 11): «паром, ожидание загрузки».
  TextColumn get note => text().nullable()();
}

/// Смены, внесённые вручную итогами — например, за дни до установки
/// приложения (`ManualShift` движка). Записей режимов у них нет, только
/// суммы; страны и заметка — здесь же. Длительности — в минутах.
@DataClassName('ManualShiftRow')
class ManualShifts extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get startUtc => dateTime().map(const UtcDateTimeConverter())();

  /// null — смена ещё идёт, отдых не начат.
  DateTimeColumn get endUtc =>
      dateTime().map(const UtcDateTimeConverter()).nullable()();
  IntColumn get drivingMinutes => integer()();
  IntColumn get continuousDrivingMinutes =>
      integer().withDefault(const Constant(0))();
  TextColumn get restKind => textEnum<RestKind>()();

  /// Не используется: длительность отдыха движок считает до начала
  /// следующей смены (решение по отзывам водителей, 28.09.2026). Колонка
  /// осталась из схемы v1, новые строки пишут 0.
  IntColumn get restMinutes => integer().withDefault(const Constant(0))();

  /// Раздельный суточный отдых 3 + 9.
  BoolColumn get splitRest => boolean().withDefault(const Constant(false))();
  TextColumn get startCountry => text().withLength(min: 1, max: 3).nullable()();
  TextColumn get endCountry => text().withLength(min: 1, max: 3).nullable()();
  TextColumn get note => text().nullable()();
  IntColumn get utcOffsetMinutes => integer()();
  DateTimeColumn get createdAt =>
      dateTime().map(const UtcDateTimeConverter())();
  DateTimeColumn get updatedAt =>
      dateTime().map(const UtcDateTimeConverter())();
}

/// Считывания карты водителя (лимит 28 дней).
@DataClassName('CardDownloadRow')
class CardDownloads extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get downloadedAtUtc =>
      dateTime().map(const UtcDateTimeConverter())();
}

/// Настройки «ключ — значение» (язык, тема, пакет мобильности, пороги…).
@DataClassName('SettingRow')
class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
