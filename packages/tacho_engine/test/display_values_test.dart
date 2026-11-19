// ENG-33, ENG-34 (docs/testing.md): готовые значения движка для экранов,
// уведомления и отчёта — лимит и перерыв в тексте предупреждения, рабочий
// день и его статья, статья отдыха и подсветка недели в журнале, полный
// отдых после смены и набор компенсации в идущем отдыхе. Приложение их
// показывает и правил не повторяет.

import 'package:tacho_engine/tacho_engine.dart';
import 'package:test/test.dart';

import 'helpers.dart';

final DateTime now = utc('2026-09-23 12:00');

// Смена 13 ч (9 ч вождения) и суточный отдых 11 ч — ровно сутки
final List<Seg> day13 = [...drivingDay('9:00'), work('3:15')];
final List<Seg> cycle = [...day13, rest('11:00')];

ComplianceSnapshot at(List<Seg> segs, {CrewMode crew = CrewMode.solo}) =>
    calc(logUntil(now, segs), now, settings: ComplianceSettings(crew: crew));

JournalWeek weekWith(String driving, String fortnight) => JournalWeek(
  start: utc('2026-09-21 00:00'),
  isCurrent: true,
  driving: dur(driving),
  fortnightDriving: dur(fortnight),
  shifts: const [],
  weeklyRests: const [],
);

JournalRest restOf(RestKind kind, String duration) => JournalRest(
  kind: kind,
  duration: dur(duration),
  ongoing: false,
  split: false,
  status: null,
);

void main() {
  group('ENG-33: лимиты и статьи для текстов и отчёта', () {
    group('лимит вида по регламенту', () {
      final limits = {
        InfringementType.continuousExceeded: '4:30',
        InfringementType.breakSoon: '4:30',
        InfringementType.dailyDriveExceeded: '9:00',
        InfringementType.dailyDriveSoon: '9:00',
        InfringementType.shiftExceeded: '13:00',
        InfringementType.weeklyDriveExceeded: '56:00',
        InfringementType.weeklyDriveSoon: '56:00',
        InfringementType.fortnightDriveExceeded: '90:00',
        InfringementType.fortnightDriveSoon: '90:00',
      };
      for (final MapEntry(key: type, value: limit) in limits.entries) {
        test('${type.name} — $limit', () {
          expect(type.limit, dur(limit));
          expect(Infringement(type).effectiveLimit, dur(limit));
        });
      }

      test('у остальных видов лимита нет', () {
        for (final type in InfringementType.values) {
          if (limits.containsKey(type)) continue;
          expect(type.limit, isNull, reason: type.name);
          expect(Infringement(type).effectiveLimit, isNull, reason: type.name);
        }
      });
    });

    test('4:31 без перерыва — превышение: лимит 4:30, перерыв 45 мин', () {
      final i = at([drive('4:31')])
          .infringement(InfringementType.continuousExceeded)!;
      expect(i.time, minute);
      // Лимит один на вид — у самого нарушения его нет
      expect(i.limit, isNull);
      expect(i.effectiveLimit, EuLimits.continuousDriving);
      expect(i.breakToTake, minutes(45));
    });

    test('за 25 мин до 4:30 после первой части 15 мин — перерыв 30 мин', () {
      final i = at([drive('2:00'), rest('0:15'), drive('2:05')])
          .infringement(InfringementType.breakSoon)!;
      expect(i.effectiveLimit, dur('4:30'));
      expect(i.breakToTake, minutes(30));
    });

    test('за 10 мин до 4:30 без первой части — перерыв 45 мин', () {
      final i = at([drive('4:20')]).infringement(InfringementType.breakSoon)!;
      expect(i.breakToTake, minutes(45));
    });

    test('у других видов перерыва нет', () {
      expect(
        const Infringement(InfringementType.dailyDriveSoon).breakToTake,
        isNull,
      );
    });

    test('10:01 за день, продления есть — лимит действующий, 10 ч', () {
      final i = at(drivingDay('10:01'))
          .infringement(InfringementType.dailyDriveExceeded)!;
      expect(i.time, minute);
      expect(i.limit, dur('10:00'));
      expect(i.effectiveLimit, dur('10:00'));
    });
  });
}
