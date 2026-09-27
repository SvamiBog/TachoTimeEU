// Устойчивость к плохим данным: часы телефона переведены назад, испорченный
// журнал. План тестов: ENG-10…12 в docs/testing.md.

import 'package:tacho_engine/tacho_engine.dart';
import 'package:test/test.dart';

import 'helpers.dart';

final DateTime now = utc('2026-09-23 12:00');

/// Ни одна длительность и ни один остаток не отрицательны.
void expectNoNegative(ComplianceSnapshot m, List<JournalWeek> weeks) {
  final durations = <String, Duration?>{
    'currentModeDuration': m.currentModeDuration,
    'shiftDuration': m.shiftDuration,
    'shiftRemaining': m.shiftRemaining,
    'continuousDriving': m.continuousDriving,
    'drivingUntilBreak': m.drivingUntilBreak,
    'dailyDriving': m.dailyDriving,
    'dailyDrivingRemaining': m.dailyDrivingRemaining,
    'weeklyDriving': m.weeklyDriving,
    'weeklyDrivingRemaining': m.weeklyDrivingRemaining,
    'fortnightDriving': m.fortnightDriving,
    'fortnightDrivingRemaining': m.fortnightDrivingRemaining,
    'dailyRestRemaining': m.dailyRestRemaining,
    'weeklyRestRemaining': m.weeklyRestRemaining,
    'workWeekDuration': m.workWeekDuration,
    'workWeekRemaining': m.workWeekRemaining,
    'offDutyRest': m.offDutyRest?.duration,
    'currentBreak': m.currentBreak?.duration,
    'compensation': m.compensation?.debt,
    for (final (i, s) in m.timeline.shifts.indexed) ...{
      'shift $i driving': s.driving,
      'shift $i otherWork': s.otherWork,
      'shift $i availability': s.availability,
      'shift $i breaks': s.breaks,
    },
    for (final w in weeks) ...{
      'week ${w.start} driving': w.driving,
      'week ${w.start} fortnight': w.fortnightDriving,
      for (final (i, s) in w.shifts.indexed) ...{
        'week ${w.start} shift $i span': s.span,
        'week ${w.start} shift $i rest': s.rest.duration,
      },
    },
    for (final i in m.infringements) 'infringement ${i.type.name}': i.time,
  };
  for (final MapEntry(:key, :value) in durations.entries) {
    expect(value?.isNegative ?? false, isFalse, reason: '$key = $value');
  }
  final cardDaysLeft = m.cardDaysLeft;
  if (cardDaysLeft != null) {
    expect(cardDaysLeft, lessThanOrEqualTo(28));
  }
  for (final i in m.infringements) {
    expect(i.days ?? 0, greaterThanOrEqualTo(0), reason: '$i');
  }
}

List<JournalWeek> journalOf(ComplianceSnapshot m) =>
    buildJournal(timeline: m.timeline, now: m.now);

void main() {
  group('ENG-10: часы телефона переведены назад', () {
    // Журнал записан до 12:00, затем часы перевели на 2 ч назад: часть
    // записей — «из будущего».
    final recorded = logUntil(now, [
      rest('11:00'),
      drive('3:00'),
      work('1:00'),
    ]);
    final clock = now.subtract(const Duration(hours: 2));

    test('длительности и остатки не отрицательные', () {
      final m = calc(
        recorded,
        clock,
        lastCardDownload: now.subtract(minutes(30)),
      );
      expectNoNegative(m, journalOf(m));
      expect(m.dailyDriving, dur('2:00'));
    });

    test('считывание карты «из будущего» — осталось ровно 28 дней', () {
      final m = calc(recorded, clock, lastCardDownload: now);
      expect(m.cardDaysLeft, 28);
      expect(m.has(InfringementType.cardSoon), isFalse);
    });

    test('весь журнал «из будущего» — расчёт как без записей', () {
      final future = logFrom(now.add(hour), [rest('11:00'), drive('2:00')]);
      final m = calc(future.periods, now);
      expectNoNegative(m, journalOf(m));
      expect(m.dailyDriving, Duration.zero);
      expect(m.weeklyDriving, Duration.zero);
    });
  });

  group('ENG-11: испорченный журнал', () {
    final t = now.subtract(const Duration(hours: 3));

    // Две открытые записи: например, приложение и фоновый сервис
    // переключили режим одновременно.
    List<ActivityPeriod> twoOpen() => [
      ActivityPeriod(
        id: 1,
        mode: DriverMode.rest,
        start: t.subtract(const Duration(hours: 11)),
        end: t,
      ),
      ActivityPeriod(id: 2, mode: DriverMode.driving, start: t),
      ActivityPeriod(id: 3, mode: DriverMode.rest, start: t.add(hour * 2)),
    ];

    test('две открытые записи: первая заканчивается началом второй', () {
      final m = calc(twoOpen(), now);
      expectNoNegative(m, journalOf(m));
      expect(m.currentMode, DriverMode.rest);
      expect(m.currentModeDuration, hour);
      expect(m.dailyDriving, dur('2:00'));
    });

    test('переключение режима закрывает все открытые записи', () {
      final updated = changeMode(twoOpen(), DriverMode.otherWork, now);
      expect(updated.where((p) => p.isOpen), hasLength(1));
      final byId = {for (final p in updated) p.id: p};
      expect(byId[2]!.end, t.add(hour * 2));
      expect(byId[3]!.end, now);
      expect(updated.last.mode, DriverMode.otherWork);
    });

    test('нажатие на текущий режим тоже чинит журнал', () {
      final updated = changeMode(twoOpen(), DriverMode.rest, now);
      expect(updated.where((p) => p.isOpen).single.id, 3);
      expect(updated.firstWhere((p) => p.id == 2).end, t.add(hour * 2));
    });

    test('записи нулевой длины и с одинаковым началом не ломают '
        'расчёт', () {
      final periods = [
        ActivityPeriod(
          mode: DriverMode.rest,
          start: t.subtract(const Duration(hours: 11)),
          end: t,
        ),
        ActivityPeriod(mode: DriverMode.driving, start: t, end: t),
        ActivityPeriod(mode: DriverMode.driving, start: t, end: t.add(hour)),
        ActivityPeriod(
          mode: DriverMode.otherWork,
          start: t,
          end: t.add(hour * 2),
        ),
        ActivityPeriod(
          mode: DriverMode.rest,
          start: t.add(hour),
          end: t.add(hour),
        ),
        ActivityPeriod(mode: DriverMode.availability, start: t.add(hour * 2)),
        ActivityPeriod(mode: DriverMode.availability, start: t.add(hour * 2)),
      ];
      final m = calc(periods, now);
      expectNoNegative(m, journalOf(m));
      // При наложении приоритет у более ранней записи хранилища
      expect(m.dailyDriving, hour);
      expect(m.shift?.otherWork, hour);
      expect(m.currentMode, DriverMode.availability);
      expect(m.currentModeDuration, hour);

      final updated = changeMode(periods, DriverMode.rest, now);
      expect(updated.where((p) => p.isOpen), hasLength(1));
      expect(() => calc(updated, now), returnsNormally);
    });
  });
  group('ENG-12: случайный испорченный журнал', () {
    const modes = DriverMode.values;

    test('расчёт и журнал не падают, остатки не отрицательные', () {
      for (var seed = 1; seed <= 300; seed++) {
        final r = Rng(seed);
        final base = utc('2026-09-01 00:00');
        final now = base.add(minutes(r.nextInt(0, 30 * 24 * 60)));
        DateTime anyTime() => base.add(minutes(r.nextInt(0, 32 * 24 * 60)));
        final periods = [
          for (var i = r.nextInt(0, 40); i > 0; i--)
            () {
              final start = anyTime();
              // Каждая пятая запись открыта — и в середине журнала тоже
              final end = r.next() < 0.2
                  ? null
                  : start.add(minutes(r.nextInt(0, 3000)));
              return ActivityPeriod(
                mode: r.pick(modes),
                start: start,
                end: end,
                ferry: r.next() < 0.1,
                dayEnd: r.next() < 0.1,
              );
            }(),
        ];
        final manual = [
          for (var i = r.nextInt(0, 4); i > 0; i--)
            () {
              final start = anyTime();
              return ManualShift(
                start: start,
                end: r.next() < 0.2
                    ? null
                    : start.add(minutes(r.nextInt(0, 1200))),
                driving: minutes(r.nextInt(0, 900)),
                restKind: r.pick(RestKind.values),
                rest: minutes(r.nextInt(0, 4000)),
                splitRest: r.next() < 0.2,
              );
            }(),
        ];
        final crew = r.pick(CrewMode.values);
        final label = 'seed $seed';

        late ComplianceSnapshot m;
        expect(
          () => m = calculateCompliance(
            periods: periods,
            now: now,
            manualShifts: manual,
            settings: ComplianceSettings(crew: crew),
            lastCardDownload: r.next() < 0.5 ? anyTime() : null,
          ),
          returnsNormally,
          reason: label,
        );
        late List<JournalWeek> weeks;
        expect(
          () => weeks = buildJournal(
            timeline: m.timeline,
            now: now,
            manualShifts: manual,
            crew: crew,
          ),
          returnsNormally,
          reason: label,
        );
        expectNoNegative(m, weeks);
        expect(
          () => changeMode(periods, r.pick(modes), now),
          returnsNormally,
          reason: label,
        );
      }
    });
  });
}
