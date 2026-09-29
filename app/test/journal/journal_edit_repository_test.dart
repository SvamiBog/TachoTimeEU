// Слой ручных правок журнала: записи, ручные смены, страны и заметки в БД.
// План тестов: REP-01, JRN-04, JRN-05 в docs/testing.md. Логика правок —
// в движке (shift_edits_test.dart), здесь — что и как сохраняется.

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/data/db/app_database.dart';
import 'package:tachogo/data/db/tables.dart';
import 'package:tachogo/data/journal/activity_repository.dart';
import 'package:tachogo/data/journal/journal_edit_repository.dart';
import 'package:tachogo/data/journal/period_store.dart';
import 'package:tachogo/data/journal/shift_meta.dart';
import 'package:tachogo/data/settings/settings_repository.dart';

Duration h(int hours, [int minutes = 0]) =>
    Duration(hours: hours, minutes: minutes);

void main() {
  late AppDatabase db;
  late DateTime now;
  late ActivityRepository live;
  late JournalEditRepository edits;
  late SettingsRepository settings;
  late int changes;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    now = DateTime.utc(2026, 9, 23, 6);
    changes = 0;
    settings = SettingsRepository(db);
    live = ActivityRepository(db, clock: () => now);
    edits = JournalEditRepository(
      db,
      settings,
      clock: () => now,
      onChanged: () => changes++,
    );
  });
  tearDown(() => db.close());

  /// Смена по записям: отдых до 06:00, вождение с 06:00 длительностью
  /// [drive], сейчас — её конец. Возвращает начало смены.
  Future<DateTime> liveShift({
    Duration drive = const Duration(hours: 2),
  }) async {
    now = DateTime.utc(2026, 9, 22, 19);
    await live.switchMode(DriverMode.rest);
    now = DateTime.utc(2026, 9, 23, 6);
    await live.switchMode(DriverMode.driving);
    now = now.add(drive);
    return DateTime.utc(2026, 9, 23, 6);
  }

  Future<List<ActivityPeriodRow>> rows() => orderedPeriods(db).get();

  Future<List<JournalShift>> shifts() async {
    final periods = await live.periods();
    final manual = await edits.manualShifts();
    return [
      for (final w in buildJournal(
        timeline: analyzeTimeline(periods, now),
        now: now,
        manualShifts: manual,
      ))
        ...w.shifts,
    ]..sort((a, b) => a.start.compareTo(b.start));
  }

  group('REP-01: правка живой смены', () {
    test(
      'новые записи — с источником manual, изменённые — с updatedAt',
      () async {
        final start = await liveShift();
        final before = await rows();
        await edits.applyLiveEdit(
          LiveShiftEdit(shiftStart: start, endAt: now.subtract(h(0, 30))),
        );
        final after = await rows();
        expect(after, hasLength(3));
        expect(after[0], before[0], reason: 'отдых до смены не менялся');
        expect(after[1].id, before[1].id);
        expect(after[1].endUtc, now.subtract(h(0, 30)));
        expect(after[1].source, EntrySource.live);
        expect(after[1].updatedAt, now);
        expect(after[2].source, EntrySource.manual);
        expect(after[2].dayEnd, isTrue);
        expect(after[2].createdAt, now);
        expect(changes, 1);
      },
    );

    test('пропавшие записи удаляются', () async {
      final start = await liveShift();
      await live.switchMode(DriverMode.rest);
      await edits.applyLiveEdit(
        LiveShiftEdit(shiftStart: start, restStart: now, resume: true),
      );
      final after = await rows();
      expect(after.map((r) => r.mode), [DriverMode.rest, DriverMode.driving]);
      expect(after.last.endUtc, isNull);
    });

    test('сбой посередине — откат всей правки', () async {
      final start = await liveShift();
      final before = await rows();
      // Страна начала обязательна — ошибка уже после записи режимов
      await expectLater(
        edits.applyLiveEdit(
          LiveShiftEdit(shiftStart: start, endAt: now),
          meta: const ShiftMeta(note: 'без страны'),
        ),
        throwsArgumentError,
      );
      expect(await rows(), before);
      expect(changes, 0);
    });

    test('страны и заметка переезжают вместе с началом смены', () async {
      final start = await liveShift();
      await edits.setShiftMeta(
        start,
        const ShiftMeta(startCountry: 'PL', note: 'загрузка'),
      );
      await edits.applyLiveEdit(
        LiveShiftEdit(shiftStart: start, newStart: start.subtract(h(0, 30))),
      );
      final meta = await edits.watchShiftMeta().first;
      expect(meta.keys, [start.subtract(h(0, 30))]);
      expect(meta.values.single.note, 'загрузка');
    });

    test(
      'новые страны пишутся к смене и становятся страной по умолчанию',
      () async {
        final start = await liveShift();
        await edits.applyLiveEdit(
          LiveShiftEdit(shiftStart: start, endAt: now),
          meta: const ShiftMeta(startCountry: 'PL', endCountry: 'D'),
        );
        final meta = await edits.watchShiftMeta().first;
        expect(
          meta[start],
          const ShiftMeta(startCountry: 'PL', endCountry: 'D'),
        );
        expect(await settings.defaultCountry(), 'D');
      },
    );

    test('смена слилась с прошлой — остаются страны прошлой', () async {
      // Смена вчера, отдых 9:30, смена сегодня
      now = DateTime.utc(2026, 9, 22, 12);
      await live.switchMode(DriverMode.driving);
      now = DateTime.utc(2026, 9, 22, 20, 30);
      await live.switchMode(DriverMode.rest);
      now = DateTime.utc(2026, 9, 23, 6);
      await live.switchMode(DriverMode.driving);
      now = now.add(h(1));
      final yesterday = DateTime.utc(2026, 9, 22, 12);
      final today = DateTime.utc(2026, 9, 23, 6);
      await edits.setShiftMeta(yesterday, const ShiftMeta(startCountry: 'D'));
      await edits.setShiftMeta(today, const ShiftMeta(startCountry: 'PL'));
      // Начало на час раньше — отдых короче 9 ч, смены слились
      await edits.applyLiveEdit(
        LiveShiftEdit(shiftStart: today, newStart: today.subtract(h(1))),
      );
      final meta = await edits.watchShiftMeta().first;
      expect(meta, {yesterday: const ShiftMeta(startCountry: 'D')});
    });

    test('смена пропала после правки — её страны тоже', () async {
      now = DateTime.utc(2026, 9, 22, 19);
      await live.switchMode(DriverMode.rest);
      now = DateTime.utc(2026, 9, 23, 6);
      await live.switchMode(DriverMode.driving);
      await edits.setShiftMeta(now, const ShiftMeta(startCountry: 'PL'));
      // Вождение нулевой длины: завершение смены оставляет только отдых
      await edits.applyLiveEdit(LiveShiftEdit(shiftStart: now, endAt: now));
      expect(await shifts(), isEmpty);
      expect(await edits.watchShiftMeta().first, isEmpty);
    });

    test('смена в минуту остаётся со своими странами', () async {
      now = DateTime.utc(2026, 9, 23, 6);
      await live.switchMode(DriverMode.driving);
      final start = now;
      now = now.add(h(0, 30));
      await edits.setShiftMeta(start, const ShiftMeta(startCountry: 'PL'));
      await edits.applyLiveEdit(LiveShiftEdit(shiftStart: start, endAt: start));
      expect((await shifts()).single.driving, h(0, 1));
      expect((await edits.watchShiftMeta().first).keys, [start]);
    });

    test('перерыв и вождение с главной — тоже правки', () async {
      final start = await liveShift(drive: h(1));
      await live.switchMode(DriverMode.rest);
      now = now.add(h(0, 20));
      await edits.setLastBreak(start, h(0, 45));
      final periods = await live.periods();
      expect(periods.last.start, now.subtract(h(0, 45)));
      expect((await rows()).last.source, EntrySource.live);
      await edits.applyLiveEdit(
        LiveShiftEdit(shiftStart: start, drivingDelta: h(0, 10)),
      );
      final m = calculateCompliance(periods: await live.periods(), now: now);
      expect(m.dailyDriving, h(0, 45));
    });

    test('вождение итогом: смена становится ручной, страны — с ней', () async {
      now = DateTime.utc(2026, 9, 22, 19);
      await live.switchMode(DriverMode.rest);
      now = DateTime.utc(2026, 9, 23, 6);
      await live.switchMode(DriverMode.otherWork);
      now = DateTime.utc(2026, 9, 23, 16);
      await live.endDay();
      final start = DateTime.utc(2026, 9, 23, 6);
      await edits.setShiftMeta(
        start,
        const ShiftMeta(startCountry: 'PL', endCountry: 'D'),
      );
      now = now.add(h(0, 45));
      changes = 0;

      await edits.applyLiveEdit(
        LiveShiftEdit(
          shiftStart: start,
          restStart: DateTime.utc(2026, 9, 23, 16),
          manualDriving: h(8, 30),
        ),
      );
      final shift = (await shifts()).last;
      expect(shift.manual?.driving, h(8, 30));
      expect(shift.manual?.end, DateTime.utc(2026, 9, 23, 16));
      expect(shift.rest.ongoing, isTrue);
      final saved = (await edits.watchManualShifts().first).single;
      expect(saved.meta, const ShiftMeta(startCountry: 'PL', endCountry: 'D'));
      expect(await edits.watchShiftMeta().first, isEmpty);
      expect((await rows()).last.dayEnd, isTrue);
      expect(changes, 1);
    });
  });

  group('JRN-04: ручные смены в БД', () {
    final start = DateTime.utc(2026, 9, 14, 6);
    final shift = ManualShift(
      start: start,
      end: start.add(h(10)),
      driving: h(8, 30),
      continuousDrivingAtEnd: h(2),
      restKind: RestKind.daily,
      splitRest: true,
    );

    test('сохраняются итоги, страны и заметка', () async {
      final id = await edits.saveManualShift(
        shift,
        const ShiftMeta(startCountry: 'PL', endCountry: 'D', note: ' паром '),
      );
      final record = (await edits.watchManualShifts().first).single;
      expect(record.shift.id, id);
      expect(record.shift.start, start);
      expect(record.shift.start.isUtc, isTrue);
      expect(record.shift.end, start.add(h(10)));
      expect(record.shift.driving, h(8, 30));
      expect(record.shift.continuousDrivingAtEnd, h(2));
      expect(record.shift.restKind, RestKind.daily);
      expect(record.shift.splitRest, isTrue);
      expect(
        record.meta,
        const ShiftMeta(startCountry: 'PL', endCountry: 'D', note: 'паром'),
      );
      final row = await db.select(db.manualShifts).getSingle();
      expect(row.createdAt, now);
      expect(row.utcOffsetMinutes, start.toLocal().timeZoneOffset.inMinutes);
      expect(changes, 1);
    });

    test('изменённая смена обновляется по id', () async {
      final id = await edits.saveManualShift(shift, ShiftMeta.empty);
      now = now.add(h(1));
      final again = await edits.saveManualShift(
        ManualShift(
          id: id,
          start: start,
          end: start.add(h(9)),
          driving: h(7),
          restKind: RestKind.weekly,
        ),
        const ShiftMeta(note: ''),
      );
      expect(again, id);
      final row = await db.select(db.manualShifts).getSingle();
      expect(row.drivingMinutes, 7 * 60);
      expect(row.restKind, RestKind.weekly);
      expect(row.note, isNull, reason: 'пустая заметка не хранится');
      expect(row.updatedAt, now);
      expect(row.createdAt, now.subtract(h(1)));
    });

    test('смена с неизвестным id добавляется заново', () async {
      final id = await edits.saveManualShift(
        ManualShift(id: 99, start: start, end: start.add(h(9)), driving: h(7)),
        ShiftMeta.empty,
      );
      expect(id, isNot(99));
      expect(await db.select(db.manualShifts).get(), hasLength(1));
    });

    test('код страны — только код тахографа', () async {
      for (final code in ['', 'POL1', 'XX']) {
        await expectLater(
          edits.saveManualShift(shift, ShiftMeta(startCountry: code)),
          throwsArgumentError,
          reason: code,
        );
        await expectLater(
          edits.saveManualShift(shift, ShiftMeta(endCountry: code)),
          throwsArgumentError,
          reason: code,
        );
      }
      expect(await db.select(db.manualShifts).get(), isEmpty);
    });

    test('столбец страны принимает 1–3 символа', () async {
      Future<void> insert(String code) => db
          .into(db.manualShifts)
          .insert(
            ManualShiftsCompanion.insert(
              startUtc: start,
              drivingMinutes: 0,
              restKind: RestKind.none,
              utcOffsetMinutes: 0,
              createdAt: now,
              updatedAt: now,
              startCountry: Value(code),
            ),
          );
      await insert('D');
      await insert('BIH');
      await expectLater(insert(''), throwsA(anything));
      await expectLater(insert('ABCD'), throwsA(anything));
    });

    test('ручная смена в расчёте: вождение в неделе её начала', () async {
      await edits.saveManualShift(shift, ShiftMeta.empty);
      final m = calculateCompliance(
        periods: const [],
        now: DateTime.utc(2026, 9, 16),
        manualShifts: await edits.manualShifts(),
      );
      expect(m.weeklyDriving, h(8, 30));
    });

    test('ручная смена внутри записанного отдыха вырезает его', () async {
      now = DateTime.utc(2026, 9, 20, 18);
      await live.switchMode(DriverMode.rest);
      now = DateTime.utc(2026, 9, 23, 6);
      await edits.saveManualShift(
        ManualShift(
          start: DateTime.utc(2026, 9, 21, 6),
          end: DateTime.utc(2026, 9, 21, 16),
          driving: h(8),
          restKind: RestKind.daily,
        ),
        const ShiftMeta(startCountry: 'PL'),
      );
      final after = await rows();
      expect(after, hasLength(2));
      expect(after[0].endUtc, DateTime.utc(2026, 9, 21, 6));
      expect(after[1].startUtc, DateTime.utc(2026, 9, 21, 16));
      expect(after[1].endUtc, isNull);
      expect(after[1].source, EntrySource.manual);
      final journal = await shifts();
      expect(journal.single.manual, isNotNull);
    });
  });

  group('смена из записей становится ручной', () {
    test('записи смены и отдыха после неё заменяются итогами', () async {
      now = DateTime.utc(2026, 9, 20, 18);
      await live.switchMode(DriverMode.rest);
      now = DateTime.utc(2026, 9, 21, 6);
      await live.switchMode(DriverMode.driving);
      now = DateTime.utc(2026, 9, 21, 15);
      await live.switchMode(DriverMode.rest);
      now = DateTime.utc(2026, 9, 22, 6);
      await live.switchMode(DriverMode.driving);
      now = DateTime.utc(2026, 9, 22, 8);
      final recorded = (await shifts()).first;
      await edits.setShiftMeta(
        recorded.start,
        const ShiftMeta(startCountry: 'PL'),
      );

      await edits.convertToManual(
        recorded,
        ManualShift(
          id: 5,
          start: DateTime.utc(2026, 9, 21, 7),
          end: DateTime.utc(2026, 9, 21, 16),
          driving: h(7),
          restKind: RestKind.daily,
        ),
        const ShiftMeta(startCountry: 'D', note: 'поправил'),
      );
      final after = await rows();
      expect(after.map((r) => r.mode), [DriverMode.rest, DriverMode.driving]);
      expect(after.first.endUtc, DateTime.utc(2026, 9, 21, 6));
      final manual = (await edits.watchManualShifts().first).single;
      expect(manual.shift.id, isNot(5), reason: 'новая запись');
      expect(manual.meta.note, 'поправил');
      expect(await edits.watchShiftMeta().first, isEmpty);
      final journal = await shifts();
      expect(journal.map((s) => s.manual != null), [true, false]);
    });
  });

  group('идущая смена из журнала становится текущей', () {
    test('записи режимов с её начала, страны — к смене', () async {
      now = DateTime.utc(2026, 9, 22, 16);
      await live.switchMode(DriverMode.rest);
      now = DateTime.utc(2026, 9, 23, 12);
      await edits.startOngoingShift(
        ManualShift(
          start: DateTime.utc(2026, 9, 23, 8),
          end: null,
          driving: h(1),
        ),
        const ShiftMeta(startCountry: 'CZ'),
      );
      final periods = await live.periods();
      final m = calculateCompliance(periods: periods, now: now);
      expect(m.shift?.start, DateTime.utc(2026, 9, 23, 8));
      expect(m.currentMode, DriverMode.driving);
      expect(m.dailyDriving, h(1));
      expect(
        (await edits.watchShiftMeta().first)[DateTime.utc(2026, 9, 23, 8)],
        const ShiftMeta(startCountry: 'CZ'),
      );
      expect(await settings.defaultCountry(), 'CZ');
    });

    test('заменяет ручную смену', () async {
      now = DateTime.utc(2026, 9, 23, 12);
      final id = await edits.saveManualShift(
        ManualShift(
          start: DateTime.utc(2026, 9, 23, 8),
          end: DateTime.utc(2026, 9, 23, 10),
          driving: h(1),
          restKind: RestKind.daily,
        ),
        ShiftMeta.empty,
      );
      final replacing = (await shifts()).single;
      expect(replacing.manual?.id, id);
      await edits.startOngoingShift(
        ManualShift(
          start: DateTime.utc(2026, 9, 23, 8),
          end: null,
          driving: h(1),
        ),
        const ShiftMeta(startCountry: 'PL'),
        replacing: replacing,
      );
      expect(await edits.manualShifts(), isEmpty);
      expect((await shifts()).single.manual, isNull);
    });

    test('заменяет смену из записей', () async {
      now = DateTime.utc(2026, 9, 22, 16);
      await live.switchMode(DriverMode.rest);
      now = DateTime.utc(2026, 9, 23, 7);
      await live.switchMode(DriverMode.otherWork);
      now = DateTime.utc(2026, 9, 23, 7, 30);
      await live.switchMode(DriverMode.rest);
      now = DateTime.utc(2026, 9, 23, 12);
      final replacing = (await shifts()).single;
      await edits.setShiftMeta(
        replacing.start,
        const ShiftMeta(startCountry: 'D'),
      );
      await edits.startOngoingShift(
        ManualShift(
          start: DateTime.utc(2026, 9, 23, 6),
          end: null,
          driving: h(0),
        ),
        const ShiftMeta(startCountry: 'PL'),
        replacing: replacing,
      );
      final m = calculateCompliance(periods: await live.periods(), now: now);
      expect(m.shift?.start, DateTime.utc(2026, 9, 23, 6));
      expect(m.currentMode, DriverMode.otherWork);
      expect((await edits.watchShiftMeta().first).keys, [
        DateTime.utc(2026, 9, 23, 6),
      ]);
    });

    test('продолжение прошлой смены — её страны не трогаем', () async {
      now = DateTime.utc(2026, 9, 23, 5);
      await live.switchMode(DriverMode.driving);
      now = DateTime.utc(2026, 9, 23, 6);
      await live.switchMode(DriverMode.rest);
      await edits.setShiftMeta(
        DateTime.utc(2026, 9, 23, 5),
        const ShiftMeta(startCountry: 'D'),
      );
      now = DateTime.utc(2026, 9, 23, 9);
      await edits.startOngoingShift(
        ManualShift(
          start: DateTime.utc(2026, 9, 23, 8),
          end: null,
          driving: h(1),
        ),
        const ShiftMeta(startCountry: 'PL'),
      );
      expect((await edits.watchShiftMeta().first).values, [
        const ShiftMeta(startCountry: 'D'),
      ]);
      expect(await settings.defaultCountry(), isNull);
    });
  });

  group('JRN-05: удаление смены', () {
    test('ручная — строка удаляется', () async {
      await edits.saveManualShift(
        ManualShift(
          start: DateTime.utc(2026, 9, 14, 6),
          end: DateTime.utc(2026, 9, 14, 16),
          driving: h(8),
        ),
        ShiftMeta.empty,
      );
      await edits.deleteShift((await shifts()).single);
      expect(await edits.manualShifts(), isEmpty);
    });

    test('из записей — записи и страны, отдых после неё остаётся', () async {
      now = DateTime.utc(2026, 9, 21, 18);
      await live.switchMode(DriverMode.rest);
      now = DateTime.utc(2026, 9, 22, 6);
      await live.switchMode(DriverMode.driving);
      now = DateTime.utc(2026, 9, 22, 15);
      await live.switchMode(DriverMode.rest);
      now = DateTime.utc(2026, 9, 23, 5);
      final shift = (await shifts()).single;
      await edits.setShiftMeta(
        shift.start,
        const ShiftMeta(startCountry: 'PL'),
      );
      await edits.deleteShift(shift);
      final after = await rows();
      expect(after.map((r) => r.mode), [DriverMode.rest, DriverMode.rest]);
      expect(after.last.endUtc, isNull);
      expect(await shifts(), isEmpty);
      expect(await edits.watchShiftMeta().first, isEmpty);
    });

    test('идущая — отдых перед ней снова идёт', () async {
      await liveShift();
      await edits.deleteShift((await shifts()).single);
      final after = await rows();
      expect(after.single.mode, DriverMode.rest);
      expect(after.single.endUtc, isNull);
      expect(after.single.updatedAt, now);
    });
  });
}
