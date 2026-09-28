// Фургоны 2,5–3,5 т: когда действуют правила 561/2006 (ст. 2(1)(aa)
// в ред. 2020/1054) и какие исключения ст. 3 их касаются. План тестов:
// ENG-21 в docs/testing.md, решения — docs/domain/eu-561-rules.md.

import 'package:tacho_engine/tacho_engine.dart';
import 'package:test/test.dart';

import 'helpers.dart';

final DateTime july = utc('2026-07-01 00:00');

VanRules rulesFor({
  DateTime? at,
  bool crossBorder = true,
  VanCarriage carriage = VanCarriage.hireOrReward,
  bool drivingMainActivity = true,
}) => vanRules(
  at: at ?? utc('2026-09-23 12:00'),
  crossBorder: crossBorder,
  carriage: carriage,
  drivingMainActivity: drivingMainActivity,
);

void main() {
  group('ст. 2(1)(aa): с 01.07.2026, международная перевозка и каботаж', () {
    test('правила действуют ровно с 01.07.2026 00:00 UTC', () {
      expect(vanRulesFrom, july);
      expect(rulesFor(at: july), VanRules.applies);
      expect(rulesFor(at: july.subtract(minute)), VanRules.notYet);
    });

    test('до 01.07.2026 не действуют ни в каком рейсе', () {
      for (final carriage in VanCarriage.values) {
        for (final crossBorder in [true, false]) {
          expect(
            rulesFor(
              at: utc('2026-06-30 23:59'),
              crossBorder: crossBorder,
              carriage: carriage,
            ),
            VanRules.notYet,
          );
        }
      }
    });

    test('внутри одной страны, не каботаж, — не действуют', () {
      for (final carriage in VanCarriage.values) {
        for (final main in [true, false]) {
          expect(
            rulesFor(
              crossBorder: false,
              carriage: carriage,
              drivingMainActivity: main,
            ),
            VanRules.domestic,
          );
        }
      }
    });

    test('по найму — действуют, даже если вождение не основная работа', () {
      expect(rulesFor(), VanRules.applies);
      expect(rulesFor(drivingMainActivity: false), VanRules.applies);
    });
  });

  group('исключения ст. 3', () {
    test('3(ha): своя перевозка, вождение — не основная работа', () {
      expect(
        rulesFor(carriage: VanCarriage.ownAccount, drivingMainActivity: false),
        VanRules.ownAccountExempt,
      );
    });

    test('своя перевозка, вождение — основная работа: правила действуют', () {
      expect(rulesFor(carriage: VanCarriage.ownAccount), VanRules.applies);
    });

    test('3(h): некоммерческая перевозка — исключение в любом случае', () {
      for (final main in [true, false]) {
        expect(
          rulesFor(
            carriage: VanCarriage.nonCommercial,
            drivingMainActivity: main,
          ),
          VanRules.nonCommercialExempt,
        );
      }
    });
  });

  test('статьи итогов', () {
    expect(
      {for (final r in VanRules.values) r: r.article},
      {
        VanRules.applies: '2(1)(aa)',
        VanRules.notYet: '2(1)(aa)',
        VanRules.domestic: '2(1)(aa)',
        VanRules.ownAccountExempt: '3(ha)',
        VanRules.nonCommercialExempt: '3(h)',
      },
    );
  });

  test('момент не в UTC — ArgumentError', () {
    expect(() => rulesFor(at: DateTime(2026, 9, 23, 12)), throwsArgumentError);
  });
}
