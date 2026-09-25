// Ст. 6 Регламента 561/2006: суточное вождение 9 ч (дважды в неделю 10 ч),
// недельное 56 ч, за две недели подряд 90 ч. Неделя — с понедельника
// 00:00 UTC.

import 'package:tacho_engine/tacho_engine.dart';
import 'package:test/test.dart';

import 'helpers.dart';

void main() {
  group('ст. 6(1): суточное вождение', () {
    test('считается между суточными отдыхами, а не за календарные сутки', () {
      // Смена со вторника 19:00 до среды 03:45
      final log = logFrom(utc('2026-09-22 08:00'), [
        rest('11:00'),
        drive('4:30'),
        rest('0:45'),
        drive('3:30'),
      ]);
      final m = calc(log.periods, log.now);
      expect(m.shift?.start, utc('2026-09-22 19:00'));
      expect(m.dailyDriving, minutes(480));
    });

    test('ровно 9:00 не тратит продление', () {
      final now = utc('2026-09-23 12:00');
      final m = calc(
        logUntil(now, [
          rest('11:00'),
          ...drivingDay('9:00'),
          rest('11:00'),
          drive('0:10'),
        ]),
        now,
      );
      expect(m.extensionsUsed, 0);
      expect(m.extensionsLeft, 2);
      expect(m.dailyDrivingLimit, minutes(600));
    });

    test('9:01 — продление использовано', () {
      final now = utc('2026-09-23 12:00');
      final m = calc(
        logUntil(now, [
          rest('11:00'),
          ...drivingDay('9:01'),
          rest('11:00'),
          drive('0:10'),
        ]),
        now,
      );
      expect(m.extensionsUsed, 1);
      expect(m.extensionsLeft, 1);
    });

    test('10:00 при доступном продлении — без нарушения, с отметкой', () {
      final now = utc('2026-09-23 12:00');
      final m = calc(
        logUntil(now, [rest('11:00'), ...drivingDay('10:00')]),
        now,
      );
      expect(m.dailyDriving, minutes(600));
      expect(keys(m), isNot(contains(InfringementType.dailyDriveExceeded)));
      expect(
        m.infringement(InfringementType.extensionInUse),
        const Infringement(InfringementType.extensionInUse, count: 1),
      );
      expect(
        m.infringement(InfringementType.dailyDriveSoon),
        Infringement(
          InfringementType.dailyDriveSoon,
          time: Duration.zero,
          limit: minutes(600),
        ),
      );
    });

    test('10:01 — нарушение на 1 мин', () {
      final now = utc('2026-09-23 12:00');
      final m = calc(
        logUntil(now, [rest('11:00'), ...drivingDay('10:01')]),
        now,
      );
      final i = m.infringement(InfringementType.dailyDriveExceeded);
      expect(i?.severity, InfringementSeverity.violation);
      expect(i?.type.article, '6(1)');
      expect(i?.time, minute);
      expect(i?.limit, minutes(600));
      expect(keys(m), isNot(contains(InfringementType.extensionInUse)));
    });

    test('после двух продлений на неделе лимит 9 ч: 9:01 — нарушение', () {
      final log = logFrom(utc('2026-09-21 05:00'), [
        ...drivingDay('10:00'),
        rest('11:00'),
        ...drivingDay('10:00'),
        rest('11:00'),
        ...drivingDay('9:01'),
      ]);
      final m = calc(log.periods, log.now);
      expect(m.extensionsUsed, 2);
      expect(m.extensionsLeft, 0);
      expect(m.dailyDrivingLimit, minutes(540));
      expect(
        m.infringement(InfringementType.dailyDriveExceeded),
        Infringement(
          InfringementType.dailyDriveExceeded,
          time: minute,
          limit: minutes(540),
        ),
      );
      expect(keys(m), isNot(contains(InfringementType.extensionInUse)));
    });

    test('продления прошлой недели в понедельник не считаются', () {
      // Чт и пт — по 10 ч, недельный отдых, в понедельник снова можно 10 ч
      final log = logFrom(utc('2026-09-17 05:00'), [
        ...drivingDay('10:00'),
        rest('11:00'),
        ...drivingDay('10:00'),
        rest('62:00'),
        ...drivingDay('9:30'),
      ]);
      final m = calc(log.periods, log.now);
      expect(m.shift?.start, utc('2026-09-21 05:00'));
      expect(m.extensionsUsed, 0);
      expect(m.dailyDrivingLimit, minutes(600));
      expect(m.infringement(InfringementType.extensionInUse)?.count, 1);
    });
  });

  group('ст. 6(2): недельное вождение 56 ч', () {
    // Пн–сб: 10 + 10 + 9 + 9 + 9 + 9 = 56 ч, между днями по 11 ч отдыха
    ({List<ActivityPeriod> periods, DateTime now}) week56(String lastDay) =>
        logFrom(utc('2026-09-21 05:00'), [
          ...drivingDay('10:00'),
          rest('11:00'),
          ...drivingDay('10:00'),
          rest('11:00'),
          ...drivingDay('9:00'),
          rest('11:00'),
          ...drivingDay('9:00'),
          rest('11:00'),
          ...drivingDay('9:00'),
          rest('11:00'),
          ...drivingDay(lastDay),
        ]);

    test('складывается по всем сменам недели', () {
      final log = week56('9:00');
      final m = calc(log.periods, log.now);
      expect(m.weeklyDriving, const Duration(hours: 56));
      expect(m.weeklyDrivingRemaining, Duration.zero);
    });

    test('ровно 56:00 — не нарушение, но предупреждение при вождении', () {
      final log = week56('9:00');
      final m = calc(log.periods, log.now);
      expect(keys(m), isNot(contains(InfringementType.weeklyDriveExceeded)));
      expect(
        m.infringement(InfringementType.weeklyDriveSoon)?.time,
        Duration.zero,
      );
    });

    test('56:01 — нарушение на 1 мин', () {
      final log = week56('9:01');
      final m = calc(log.periods, log.now);
      final i = m.infringement(InfringementType.weeklyDriveExceeded);
      expect(i?.severity, InfringementSeverity.violation);
      expect(i?.type.article, '6(2)');
      expect(i?.time, minute);
    });

    test('вождение через полночь понедельника делится между неделями', () {
      // Вождение с воскресенья 22:00 до понедельника 02:00
      final log = logFrom(utc('2026-09-20 11:00'), [
        rest('11:00'),
        drive('4:00'),
      ]);
      final m = calc(log.periods, log.now);
      expect(m.weekStart, utc('2026-09-21 00:00'));
      expect(m.dailyDriving, minutes(240));
      expect(m.weeklyDriving, minutes(120));
      expect(m.fortnightDriving, minutes(240));
    });

    test('предупреждение, когда до 56 ч осталось меньше порога', () {
      final now = utc('2026-09-27 20:00');
      final manual = [
        manualShift(utc('2026-09-21 06:00'), drive: '10:00'),
        manualShift(utc('2026-09-22 06:00'), drive: '10:00'),
        manualShift(utc('2026-09-23 06:00')),
        manualShift(utc('2026-09-24 06:00')),
        manualShift(utc('2026-09-25 06:00')),
        manualShift(utc('2026-09-26 06:00'), drive: '8:00'),
      ];
      final m = calc(
        logUntil(now, [rest('11:00'), drive('0:40')]),
        now,
        manual: manual,
      );
      expect(m.weeklyDriving, const Duration(hours: 55, minutes: 40));
      expect(
        m.infringement(InfringementType.weeklyDriveSoon)?.time,
        minutes(20),
      );
      expect(keys(m), isNot(contains(InfringementType.fortnightDriveSoon)));
    });
  });

  group('ст. 6(3): 90 ч за две недели подряд', () {
    final now = utc('2026-09-25 20:00'); // пятница
    // Прошлая неделя (пн 14.09 – сб 19.09): 56 ч
    final lastWeek = [
      for (final (i, h) in [10, 10, 9, 9, 9, 9].indexed)
        manualShift(utc('2026-09-${14 + i} 06:00'), drive: h * 60, id: 100 + i),
    ];
    // Эта неделя до пятницы: 9 + 9 + 9 + 3 = 30 ч
    final thisWeek = [
      for (final (i, h) in [9, 9, 9, 3].indexed)
        manualShift(utc('2026-09-${21 + i} 06:00'), drive: h * 60, id: 200 + i),
    ];
    ComplianceSnapshot run(String driving, [List<ManualShift>? manual]) => calc(
      logUntil(now, [rest('11:00'), drive(driving)]),
      now,
      manual: manual ?? [...lastWeek, ...thisWeek],
    );

    test('остаток на неделю ограничен суммой за две недели', () {
      final m = run('1:00');
      expect(m.weeklyDriving, const Duration(hours: 31));
      expect(m.fortnightDriving, const Duration(hours: 87));
      expect(m.weeklyDrivingRemaining, const Duration(hours: 3));
      expect(m.fortnightLimiting, isTrue);
    });

    test('ровно 90 ч — не нарушение, остаток 0', () {
      final m = run('4:00');
      expect(m.fortnightDriving, const Duration(hours: 90));
      expect(m.weeklyDrivingRemaining, Duration.zero);
      expect(m.fortnightDrivingRemaining, Duration.zero);
      expect(keys(m), isNot(contains(InfringementType.fortnightDriveExceeded)));
    });

    test('90:01 — нарушение на 1 мин', () {
      final m = run('4:01');
      final i = m.infringement(InfringementType.fortnightDriveExceeded);
      expect(i?.severity, InfringementSeverity.violation);
      expect(i?.type.article, '6(3)');
      expect(i?.time, minute);
      expect(keys(m), isNot(contains(InfringementType.weeklyDriveExceeded)));
    });

    test('предупреждение о 90 ч, а не о 56 ч, когда раньше кончается '
        'двухнедельный лимит', () {
      final m = run('3:40');
      expect(
        m.infringement(InfringementType.fortnightDriveSoon)?.time,
        minutes(20),
      );
      expect(keys(m), isNot(contains(InfringementType.weeklyDriveSoon)));
    });

    test('позапрошлая неделя в сумму не входит', () {
      final twoWeeksAgo = [
        for (final (i, h) in [10, 10, 9, 9, 9, 9].indexed)
          manualShift(
            utc('2026-09-07 06:00').add(day * i),
            drive: h * 60,
            id: 300 + i,
          ),
      ];
      final m = run('1:00', [...twoWeeksAgo, ...thisWeek]);
      expect(m.fortnightDriving, m.weeklyDriving);
      expect(m.fortnightLimiting, isFalse);
    });
  });
}
