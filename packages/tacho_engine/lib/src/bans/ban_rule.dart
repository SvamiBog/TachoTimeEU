import 'package:meta/meta.dart';
import 'package:tacho_engine/src/bans/holidays.dart';
import 'package:tacho_engine/src/bans/zone_time.dart';

/// Откуда запрет: выходные, праздник, канун праздника, летний период,
/// ночь или отдельный день из годового календаря страны.
enum BanKind { weekend, holiday, holidayEve, summer, night, calendar }

/// Где действует запрет.
enum BanScope {
  /// На всех дорогах страны.
  allRoads,

  /// На автомагистралях и главных дорогах — там, где ездят грузовики.
  mainRoads,

  /// На отдельных дорогах или участках.
  someRoads,

  /// В части регионов: праздник не во всей стране.
  someRegions,

  /// Не для всех машин этого класса: например, ночной запрет в Австрии
  /// не касается малошумных машин с табличкой «L».
  conditional;

  /// Запрет действует по всей сети дорог для машины этого класса.
  bool get definite => this == allRoads || this == mainRoads;
}

/// Момент относительно опорного дня правила: сдвиг в днях и время суток.
/// «С 22:00 субботы до 22:00 воскресенья» — опора суббота, конец —
/// `BanTime(22, dayOffset: 1)`.
@immutable
class BanTime {
  const new(this.hour, {this.minute = 0, this.dayOffset = 0});

  final int hour;
  final int minute;
  final int dayOffset;

  /// Местное время на опорную дату [day] (полночь в `DateTime.utc`).
  DateTime on(DateTime day) =>
      DateTime.utc(day.year, day.month, day.day + dayOffset, hour, minute);
}

/// Опорные дни правила.
@immutable
sealed class BanDays {
  const new();

  /// [date] — местная дата в `DateTime.utc` (полночь).
  bool includes(DateTime date);
}

/// Дни недели: `DateTime.saturday`, `DateTime.sunday`...
final class Weekdays extends BanDays {
  const new(this.days);

  final Set<int> days;

  @override
  bool includes(DateTime date) => days.contains(date.weekday);
}

/// Праздники из списка страны.
final class HolidayDays extends BanDays {
  const new(this.holidays);

  final List<Holiday> holidays;

  @override
  bool includes(DateTime date) =>
      holidays.any((h) => h.dateIn(date.year) == date);
}

/// Каждый день — ночные запреты.
final class EveryDay extends BanDays {
  const new();

  @override
  bool includes(DateTime date) => true;
}

/// Отдельные дни из годового календаря страны.
final class CalendarDays extends BanDays {
  const new(this.dates);

  final List<BanDate> dates;

  @override
  bool includes(DateTime date) => dates.any((d) => d.date == date);
}

/// Дата без времени: годовые календари и даты сверки данных.
@immutable
class BanDate {
  const new(this.year, this.month, this.day);

  final int year;
  final int month;
  final int day;

  DateTime get date => DateTime.utc(year, month, day);
}

/// Часть года, когда действует правило, включая границы: «с 1 июля по
/// 31 августа». [year] — только в этом году: даты сезона страна объявляет
/// каждый год.
@immutable
class BanSeason {
  const new(
    this.fromMonth,
    this.fromDay,
    this.toMonth,
    this.toDay, {
    this.year,
  });

  final int fromMonth;
  final int fromDay;
  final int toMonth;
  final int toDay;
  final int? year;

  bool contains(DateTime date) {
    if (year != null && date.year != year) return false;
    final from = DateTime.utc(date.year, fromMonth, fromDay);
    final to = DateTime.utc(date.year, toMonth, toDay);
    return !date.isBefore(from) && !date.isAfter(to);
  }
}

/// Правило запрета: в какие дни, с какого по какое время (местное),
/// где и для машин тяжелее какого порога.
@immutable
class BanRule {
  const new({
    required this.kind,
    required this.days,
    required this.from,
    required this.to,
    this.scope = BanScope.allRoads,
    this.overTonnes = 7.5,
    this.season,
  });

  final BanKind kind;
  final BanDays days;
  final BanTime from;
  final BanTime to;
  final BanScope scope;

  /// Запрет касается машин тяжелее этого порога, т.
  final double overTonnes;

  /// Только в этой части года; null — круглый год.
  final BanSeason? season;

  /// Правило действует в местный день [date].
  bool appliesOn(DateTime date) =>
      (season?.contains(date) ?? true) && days.includes(date);
}

/// Сколько известно о запретах страны.
enum BanCoverage {
  /// Правила в данных: движок считает время запретов.
  rules,

  /// Запреты только на отдельных дорогах: время не считается, водитель
  /// смотрит официальный источник.
  someRoads,

  /// Общих запретов для грузовиков нет.
  none,
}

/// Запреты движения грузовиков в стране.
@immutable
class CountryBans {
  const new({
    required this.code,
    required this.zone,
    required this.coverage,
    required this.checkedOn,
    this.rules = const [],
    this.calendarUntil,
    this.sources = const [],
    this.needsCheck = false,
  });

  /// Отличительный знак страны, как в тахографе (`TachoCountries`).
  final String code;
  final BanZone zone;
  final BanCoverage coverage;
  final List<BanRule> rules;

  /// Когда данные сверены.
  final BanDate checkedOn;

  /// До какого дня известен годовой календарь страны (летние даты,
  /// отдельные дни). Позже — только постоянные правила, расчёт
  /// предварительный. null — у страны нет годового календаря.
  final BanDate? calendarUntil;

  /// Официальные источники и справки, где проверить.
  final List<String> sources;

  /// Источники расходятся в деталях — сверить с официальным текстом.
  final bool needsCheck;

  /// Самый низкий порог массы, с которого у страны есть запреты; null —
  /// правил нет.
  double? get lowestThreshold => rules.isEmpty
      ? null
      : rules.map((r) => r.overTonnes).reduce((a, b) => a < b ? a : b);
}
