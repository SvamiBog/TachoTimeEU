/// What the app reads from a smart tachograph over ITS: the data identifiers
/// of ISO 16844-7 and how their values are decoded.
///
/// The identifiers come from table 1 of ISO 16844-7; the value formats follow
/// SAE J1939 (the tachograph messages on the vehicle CAN bus) and are checked
/// against a real VDO DTCO 4.1a in the beta (`docs/research/bluetooth-its.md`).
library;

import 'dart:convert';

import 'package:flutter/foundation.dart' show immutable;
import 'package:tacho_engine/tacho_engine.dart';

/// Data identifiers (ISO 16844-7, table 1) the app reads. Personal data
/// leaves the tachograph only with the driver's consent (Annex IC,
/// appendix 13, section 4).
enum TachoDid {
  vehicleIdentificationNumber(0xF190, personal: false),
  timeDate(0xF90B, personal: false),
  driveRecognize(0xF905, personal: false),
  driver1WorkingState(0xF903),
  driver2WorkingState(0xF904),

  /// Карта водителя во 2-м слоте: без неё DTCO 4.1a отдаёт режим водителя
  /// 2 как «отдых» (26.11.2026).
  driver2Card(0xF90A, personal: false),
  driver1ContinuousDrivingTime(0xF923),
  driver1CumulativeBreakTime(0xF925),
  driver1CurrentDurationOfSelectedActivity(0xF927),
  driver1DrivingTimePreviousAndCurrentWeek(0xF938),
  driver1CurrentDailyDrivingTime(0xF99A),
  driver1CurrentWeeklyDrivingTime(0xF99B),
  driver1TimeLeftUntilNewDailyRestPeriod(0xF99C),
  driver1TimeLeftUntilNewWeeklyRestPeriod(0xF9A1),
  driver1RemainingDrivingTimeOnCurrentShift(0xF9AF),
  driver1RemainingDrivingTimeOfCurrentWeek(0xF9B1);

  new(this.id, {this.personal = true});

  /// Номер данных (DID).
  final int id;

  /// Данные водителя: только с его согласия в меню тахографа.
  final bool personal;
}

/// Режим водителя (3 бита, как в J1939): 0 — отдых, 1 — готовность,
/// 2 — работа, 3 — вождение; 6 — ошибка, 7 — нет данных.
DriverMode? decodeWorkingState(List<int> value) {
  if (value.isEmpty) return null;
  return switch (value.last & 0x07) {
    0 => DriverMode.rest,
    1 => DriverMode.availability,
    2 => DriverMode.otherWork,
    3 => DriverMode.driving,
    _ => null,
  };
}

/// Машина едет (2 бита, как в J1939): 1 — да, 0 — нет, остальное — нет
/// данных.
bool? decodeDriveRecognize(List<int> value) {
  if (value.isEmpty) return null;
  return switch (value.last & 0x03) {
    0 => false,
    1 => true,
    _ => null,
  };
}

/// Карта водителя в слоте (2 бита, как в J1939): 1 — вставлена, 0 — нет
/// (или вставлена карта мастерской, контролёра, предприятия), остальное —
/// нет данных.
bool? decodeCardPresent(List<int> value) => decodeDriveRecognize(value);

/// Длительность в минутах — целое без знака, старший байт первым. Значения
/// от FB… и выше — «ошибка» и «нет данных», как в J1939. Единицу (минуты)
/// проверяем на DTCO 4.1a в бете.
Duration? decodeMinutes(List<int> value) {
  if (value.isEmpty || value.length > 4) return null;
  var minutes = 0;
  for (final byte in value) {
    minutes = minutes << 8 | byte;
  }
  final reserved = 0xFB << (8 * (value.length - 1));
  return minutes >= reserved ? null : Duration(minutes: minutes);
}

/// Время тахографа (J1939 «Time/Date», UTC): секунды по 0,25 с, минуты,
/// часы, месяц, день по 0,25 сут, год от 1985; смещения пояса не нужны.
DateTime? decodeTimeDate(List<int> value) {
  if (value.length < 6) return null;
  final second = value[0] ~/ 4;
  final minute = value[1];
  final hour = value[2];
  final month = value[3];
  // День 1 — значения 1…4 (четверти суток)
  final day = (value[4] + 3) ~/ 4;
  final year = 1985 + value[5];
  if (second > 59 || minute > 59 || hour > 23) return null;
  if (month < 1 || month > 12 || day < 1 || day > 31) return null;
  return DateTime.utc(year, month, day, hour, minute, second);
}

/// VIN — ASCII; пустые байты (0, пробел, 0xFF) по краям отброшены.
String? decodeVin(List<int> value) {
  final text = latin1
      .decode(value.where((b) => b != 0xFF).toList())
      .replaceAll('\u0000', ' ')
      .trim();
  return text.isEmpty ? null : text;
}

/// One poll of the tachograph: what it reports for the driver in slot 1 now.
/// A missing value is null: the tachograph does not support it, the driver
/// gave no consent, or the answer did not come.
@immutable
class TachographReading {
  const new({
    required this.at,
    this.vin,
    this.tachographTime,
    this.moving,
    this.driver1Mode,
    this.driver2Mode,
    this.continuousDriving,
    this.breakTotal,
    this.currentActivity,
    this.dailyDriving,
    this.weeklyDriving,
    this.fortnightDriving,
    this.untilDailyRest,
    this.untilWeeklyRest,
    this.shiftDrivingLeft,
    this.weekDrivingLeft,
    this.coDriverCard,
    this.consentMissing = false,
  });

  /// Когда прочитано (UTC, часы телефона).
  final DateTime at;
  final String? vin;
  final DateTime? tachographTime;

  /// Машина едет.
  final bool? moving;
  final DriverMode? driver1Mode;
  final DriverMode? driver2Mode;
  final Duration? continuousDriving;

  /// Сумма перерывов, засчитанных в текущий период вождения.
  final Duration? breakTotal;

  /// Сколько идёт текущий режим.
  final Duration? currentActivity;
  final Duration? dailyDriving;
  final Duration? weeklyDriving;

  /// Вождение за прошлую и текущую неделю.
  final Duration? fortnightDriving;
  final Duration? untilDailyRest;
  final Duration? untilWeeklyRest;
  final Duration? shiftDrivingLeft;
  final Duration? weekDrivingLeft;

  /// Карта водителя во 2-м слоте; null — тахограф не сказал.
  final bool? coDriverCard;

  /// Тахограф не даёт данные водителя: в его меню не включено согласие ITS.
  final bool consentMissing;

  /// Есть хоть что-то о водителе — режим или время.
  bool get hasDriverData =>
      driver1Mode != null ||
      continuousDriving != null ||
      dailyDriving != null ||
      weeklyDriving != null;
}

/// Режим, на который переключить журнал по снимку [r], и с какого момента;
/// null — журнал не трогать. Тахограф главнее журнала (решение 2026-11-26),
/// но только для одного водителя: с картой во 2-м слоте неизвестно, чья
/// карта в 1-м, — в экипаже карты меняют местами при смене за рулём.
({DriverMode mode, DateTime since})? journalModeFrom(TachographReading r) {
  final mode = r.driver1Mode;
  if (mode == null || r.consentMissing || r.coDriverCard == true) return null;
  return (mode: mode, since: r.at.subtract(r.currentActivity ?? Duration.zero));
}

/// Снимок из прочитанных значений [values] — сырые байты по номерам данных.
TachographReading decodeReading({
  required DateTime at,
  required Map<TachoDid, List<int>> values,
  required bool consentMissing,
}) {
  Duration? minutes(TachoDid did) => switch (values[did]) {
    final value? => decodeMinutes(value),
    null => null,
  };
  final vin = values[TachoDid.vehicleIdentificationNumber];
  final time = values[TachoDid.timeDate];
  final moving = values[TachoDid.driveRecognize];
  final driver1 = values[TachoDid.driver1WorkingState];
  // Режим водителя 2 — только когда тахограф подтвердил его карту
  final card2 = values[TachoDid.driver2Card];
  final coDriverCard = card2 == null ? null : decodeCardPresent(card2);
  final driver2 = coDriverCard == true
      ? values[TachoDid.driver2WorkingState]
      : null;
  return TachographReading(
    at: at,
    vin: vin == null ? null : decodeVin(vin),
    tachographTime: time == null ? null : decodeTimeDate(time),
    moving: moving == null ? null : decodeDriveRecognize(moving),
    driver1Mode: driver1 == null ? null : decodeWorkingState(driver1),
    driver2Mode: driver2 == null ? null : decodeWorkingState(driver2),
    continuousDriving: minutes(TachoDid.driver1ContinuousDrivingTime),
    breakTotal: minutes(TachoDid.driver1CumulativeBreakTime),
    currentActivity: minutes(TachoDid.driver1CurrentDurationOfSelectedActivity),
    dailyDriving: minutes(TachoDid.driver1CurrentDailyDrivingTime),
    weeklyDriving: minutes(TachoDid.driver1CurrentWeeklyDrivingTime),
    fortnightDriving: minutes(
      TachoDid.driver1DrivingTimePreviousAndCurrentWeek,
    ),
    untilDailyRest: minutes(TachoDid.driver1TimeLeftUntilNewDailyRestPeriod),
    untilWeeklyRest: minutes(TachoDid.driver1TimeLeftUntilNewWeeklyRestPeriod),
    shiftDrivingLeft: minutes(
      TachoDid.driver1RemainingDrivingTimeOnCurrentShift,
    ),
    weekDrivingLeft: minutes(TachoDid.driver1RemainingDrivingTimeOfCurrentWeek),
    coDriverCard: coDriverCard,
    consentMissing: consentMissing,
  );
}
