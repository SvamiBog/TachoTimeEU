import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/tachograph/tachograph_values.dart';

void main() {
  group('BT-04: значения тахографа (ISO 16844-7)', () {
    test('номера данных — из таблицы 1 ISO 16844-7', () {
      expect(TachoDid.vehicleIdentificationNumber.id, 0xF190);
      expect(TachoDid.timeDate.id, 0xF90B);
      expect(TachoDid.driveRecognize.id, 0xF905);
      expect(TachoDid.driver1WorkingState.id, 0xF903);
      expect(TachoDid.driver2WorkingState.id, 0xF904);
      expect(TachoDid.driver1ContinuousDrivingTime.id, 0xF923);
      expect(TachoDid.driver1CumulativeBreakTime.id, 0xF925);
      expect(TachoDid.driver1CurrentDurationOfSelectedActivity.id, 0xF927);
      expect(TachoDid.driver1DrivingTimePreviousAndCurrentWeek.id, 0xF938);
      expect(TachoDid.driver1CurrentDailyDrivingTime.id, 0xF99A);
      expect(TachoDid.driver1CurrentWeeklyDrivingTime.id, 0xF99B);
      expect(TachoDid.driver1TimeLeftUntilNewDailyRestPeriod.id, 0xF99C);
      expect(TachoDid.driver1TimeLeftUntilNewWeeklyRestPeriod.id, 0xF9A1);
      expect(TachoDid.driver1RemainingDrivingTimeOnCurrentShift.id, 0xF9AF);
      expect(TachoDid.driver1RemainingDrivingTimeOfCurrentWeek.id, 0xF9B1);
      expect({
        for (final d in TachoDid.values) d.id,
      }, hasLength(TachoDid.values.length));
    });

    test('без согласия водителя — только данные машины', () {
      expect(TachoDid.vehicleIdentificationNumber.personal, isFalse);
      expect(TachoDid.timeDate.personal, isFalse);
      expect(TachoDid.driveRecognize.personal, isFalse);
      expect(TachoDid.driver1WorkingState.personal, isTrue);
      expect(TachoDid.driver1ContinuousDrivingTime.personal, isTrue);
    });

    test('режим водителя: 0 отдых, 1 готовность, 2 работа, 3 вождение', () {
      expect(decodeWorkingState([0]), DriverMode.rest);
      expect(decodeWorkingState([1]), DriverMode.availability);
      expect(decodeWorkingState([2]), DriverMode.otherWork);
      expect(decodeWorkingState([3]), DriverMode.driving);
      // Старшие биты не мешают: в байте только 3 бита режима
      expect(decodeWorkingState([0xF8 | 3]), DriverMode.driving);
      // 6 — ошибка, 7 — нет данных
      expect(decodeWorkingState([6]), isNull);
      expect(decodeWorkingState([7]), isNull);
      expect(decodeWorkingState([]), isNull);
    });

    test('движение: 1 — едет, 0 — стоит, остальное — нет данных', () {
      expect(decodeDriveRecognize([1]), isTrue);
      expect(decodeDriveRecognize([0]), isFalse);
      expect(decodeDriveRecognize([3]), isNull);
      expect(decodeDriveRecognize([]), isNull);
    });

    test('длительность — минуты, старшие значения — «нет данных»', () {
      expect(decodeMinutes([0x01, 0x0E]), const Duration(minutes: 270));
      expect(decodeMinutes([45]), const Duration(minutes: 45));
      expect(decodeMinutes([0, 0, 0x02, 0x1C]), const Duration(minutes: 540));
      expect(decodeMinutes([0xFB, 0x00]), isNull);
      expect(decodeMinutes([0xFF, 0xFF]), isNull);
      expect(decodeMinutes([0xFE]), isNull);
      expect(decodeMinutes([]), isNull);
      expect(decodeMinutes([1, 2, 3, 4, 5]), isNull);
    });

    test('время тахографа: формат J1939, UTC', () {
      // 22.09.2026 14:05:30: секунды ×4, день ×4, год от 1985,
      // смещения пояса +125
      final t = decodeTimeDate([120, 5, 14, 9, 88, 41, 125, 127]);
      expect(t, DateTime.utc(2026, 9, 22, 14, 5, 30));
      expect(decodeTimeDate([120, 5, 14, 13, 88, 41, 125, 125]), isNull);
      expect(decodeTimeDate([120, 5, 14]), isNull);
    });

    test('VIN — ASCII без пустых байтов по краям', () {
      expect(
        decodeVin([...'WDB9634031L123456'.codeUnits, 0, 0x20]),
        'WDB9634031L123456',
      );
      expect(decodeVin([0xFF, 0xFF]), isNull);
    });

    test('снимок: значения разобраны, нет значения — null', () {
      final at = DateTime.utc(2026, 9, 22, 12);
      final reading = decodeReading(
        at: at,
        values: {
          TachoDid.driveRecognize: [1],
          TachoDid.driver1WorkingState: [3],
          TachoDid.driver2WorkingState: [1],
          TachoDid.driver1ContinuousDrivingTime: [0x00, 0x5A],
          TachoDid.driver1CumulativeBreakTime: [0x00, 0x0F],
          TachoDid.driver1CurrentDurationOfSelectedActivity: [0x00, 0x5A],
          TachoDid.driver1CurrentDailyDrivingTime: [0x01, 0x2C],
          TachoDid.driver1CurrentWeeklyDrivingTime: [0x07, 0x08],
          TachoDid.driver1DrivingTimePreviousAndCurrentWeek: [0x0E, 0x10],
          TachoDid.driver1TimeLeftUntilNewDailyRestPeriod: [0x01, 0x68],
          TachoDid.vehicleIdentificationNumber: 'VIN1'.codeUnits,
        },
        consentMissing: false,
      );
      expect(reading.at, at);
      expect(reading.moving, isTrue);
      expect(reading.driver1Mode, DriverMode.driving);
      expect(reading.driver2Mode, DriverMode.availability);
      expect(reading.continuousDriving, const Duration(minutes: 90));
      expect(reading.breakTotal, const Duration(minutes: 15));
      expect(reading.currentActivity, const Duration(minutes: 90));
      expect(reading.dailyDriving, const Duration(hours: 5));
      expect(reading.weeklyDriving, const Duration(hours: 30));
      expect(reading.fortnightDriving, const Duration(hours: 60));
      expect(reading.untilDailyRest, const Duration(hours: 6));
      expect(reading.untilWeeklyRest, isNull);
      expect(reading.shiftDrivingLeft, isNull);
      expect(reading.weekDrivingLeft, isNull);
      expect(reading.vin, 'VIN1');
      expect(reading.tachographTime, isNull);
      expect(reading.consentMissing, isFalse);
      expect(reading.hasDriverData, isTrue);
    });

    test('без согласия данных водителя нет', () {
      final reading = decodeReading(
        at: DateTime.utc(2026),
        values: {
          TachoDid.driveRecognize: [0],
        },
        consentMissing: true,
      );
      expect(reading.consentMissing, isTrue);
      expect(reading.moving, isFalse);
      expect(reading.hasDriverData, isFalse);
    });
  });
}
