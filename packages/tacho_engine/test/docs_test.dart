// Документы не расходятся с кодом: таблица лимитов, пороги детектора
// движения, статусы водителя, правила для фургонов. План тестов: DOC-01…03
// и DOC-06 в docs/testing.md.

import 'dart:io';

import 'package:tacho_engine/tacho_engine.dart';
import 'package:test/test.dart';

/// Файл из корня репозитория; тесты запускаются из packages/tacho_engine.
String repoFile(String path) => File('../../$path').readAsStringSync();

/// Строки таблицы под заголовком [heading]: ячейки без крайних «|».
List<List<String>> tableRows(String markdown, String heading) {
  final lines = markdown.split(RegExp(r'\r?\n'));
  final start = lines.indexOf(heading);
  if (start < 0) throw StateError('нет раздела «$heading»');
  final rows = <List<String>>[];
  for (final line in lines.skip(start + 1)) {
    if (line.startsWith('#')) break;
    if (!line.startsWith('|')) {
      if (rows.isNotEmpty) break;
      continue;
    }
    final cells = line.split('|');
    rows.add([for (final c in cells.sublist(1, cells.length - 1)) c.trim()]);
  }
  // Заголовок и разделитель
  return rows.sublist(2);
}

/// «4:30», «9 ч», «45 мин», «28 дн» — как в документах.
String hours(Duration d) => '${d.inHours} ч';

void main() {
  group('DOC-01: таблица лимитов совпадает с EuLimits', () {
    final rows = {
      for (final row in tableRows(
        repoFile('docs/domain/eu-561-rules.md'),
        '## Лимиты',
      ))
        row[0]: row.join(' | '),
    };
    String min(Duration d) => '${d.inMinutes} мин';
    String pair(Duration a, Duration b) => '${a.inHours}/${b.inHours} ч';
    const continuous = EuLimits.continuousDriving;
    const team = EuLimits.teamWorkdayWindow;
    final split =
        '${hours(EuLimits.dailyRestSplitFirst)} + '
        '${hours(EuLimits.dailyRestSplitSecond)}';
    final expected = <String, List<String>>{
      '${continuous.inHours}:${continuous.inMinutes % 60}': [
        min(EuLimits.breakFull),
        min(EuLimits.breakSplitFirst),
        min(EuLimits.breakSplitSecond),
      ],
      hours(EuLimits.dailyDriving): [
        'Дважды',
        'до ${hours(EuLimits.dailyDrivingExtended)}',
      ],
      hours(EuLimits.weeklyDriving): [hours(EuLimits.fortnightDriving)],
      hours(EuLimits.dailyRestRegular): [
        'трёх',
        hours(EuLimits.dailyRestReduced),
        split,
      ],
      pair(EuLimits.workdayWithRegularRest, EuLimits.workdayWithReducedRest): [
        hours(EuLimits.workdayWindow),
        hours(EuLimits.workdayWithRegularRest),
        hours(EuLimits.workdayWithReducedRest),
      ],
      pair(team - EuLimits.dailyRestRegular, team - EuLimits.teamDailyRest): [
        hours(EuLimits.teamDailyRest),
        hours(EuLimits.teamWorkdayWindow),
        hours(EuLimits.dailyRestRegular),
      ],
      hours(EuLimits.weeklyRestRegular): [
        hours(EuLimits.weeklyRestReduced),
        'третьей недели',
      ],
      hours(EuLimits.maxBetweenWeeklyRests): [
        'шесть периодов по ${hours(EuLimits.workdayWindow)}',
      ],
      '${EuLimits.cardDownloadInterval.inDays} дн': [],
    };

    test('строки таблицы — ровно лимиты движка', () {
      expect(rows.keys.toSet(), expected.keys.toSet());
    });

    for (final MapEntry(key: limit, value: details) in expected.entries) {
      test('$limit: ${details.join(', ')}', () {
        final row = rows[limit];
        expect(row, isNotNull, reason: 'нет строки «$limit»');
        for (final d in details) {
          expect(row, contains(d));
        }
      });
    }

    test('сокращений и продлений столько, сколько в движке', () {
      expect(EuLimits.dailyRestReductionsBetweenWeeklyRests, 3);
      expect(EuLimits.dailyDrivingExtensionsPerWeek, 2);
      expect(EuLimits.compensationWeeks, 3);
      expect(EuLimits.maxBetweenWeeklyRests, EuLimits.workdayWindow * 6);
    });
  });

  group('DOC-02: пороги детектора в docs/background.md', () {
    final rows = {
      for (final row in tableRows(
        repoFile('docs/background.md'),
        '**Детектор движения** (`MotionDetector`):',
      ))
        row[0]: row[1],
    };
    const t = MotionThresholds();
    String kmh(double v) => '${v.round()} км/ч';

    test('строки таблицы', () {
      expect(rows.keys, [
        'Машина едет',
        'Машина стоит',
        'Между порогами',
        'Разрыв отметок',
        'Точность',
      ]);
    });

    test('значения совпадают с MotionThresholds()', () {
      expect(
        rows['Машина едет'],
        '≥ ${kmh(t.movingSpeedKmh)} в течение ${t.startAfter.inSeconds} с',
      );
      expect(
        rows['Машина стоит'],
        '< ${kmh(t.stoppedSpeedKmh)} в течение ${t.stopAfter.inMinutes} мин',
      );
      expect(
        rows['Между порогами'],
        '${t.stoppedSpeedKmh.round()}–${kmh(t.movingSpeedKmh)}',
      );
      expect(rows['Разрыв отметок'], '> ${t.maxGap.inMinutes} мин');
      expect(rows['Точность'], 'хуже ${t.maxAccuracyMeters.round()} м');
    });
  });

  group('DOC-03: статусы в packages/tacho_engine/README.md', () {
    test('ровно DriverStatus.values', () {
      final rows = tableRows(
        repoFile('packages/tacho_engine/README.md'),
        '## Модель состояний',
      );
      final names = {
        for (final row in rows)
          for (final m in RegExp(r'`(\w+)`').allMatches(row[0])) m[1]!,
      };
      expect(names, {for (final s in DriverStatus.values) s.name});
    });
  });

  group('DOC-06: таблица фургонов совпадает с vanRules', () {
    final rows = {
      for (final row in tableRows(
        repoFile('docs/domain/eu-561-rules.md'),
        '## Фургоны 2,5–3,5 т',
      ))
        row[0]: (result: row[1], article: row[2]),
    };
    final from = vanRulesFrom;
    String two(int n) => n.toString().padLeft(2, '0');
    final date = '${two(from.day)}.${two(from.month)}.${from.year}';
    VanRules rules({
      bool before = false,
      bool crossBorder = true,
      VanCarriage carriage = VanCarriage.hireOrReward,
      bool main = true,
    }) => vanRules(
      at: before ? from.subtract(const Duration(minutes: 1)) : from,
      crossBorder: crossBorder,
      carriage: carriage,
      drivingMainActivity: main,
    );
    final expected = {
      'До $date': rules(before: true),
      'Внутри одной страны, не каботаж': rules(crossBorder: false),
      'Некоммерческая перевозка': rules(carriage: VanCarriage.nonCommercial),
      'Своя перевозка, вождение — не основная работа': rules(
        carriage: VanCarriage.ownAccount,
        main: false,
      ),
      'Своя перевозка, вождение — основная работа': rules(
        carriage: VanCarriage.ownAccount,
      ),
      'По найму': rules(main: false),
    };

    test('строки таблицы — ровно случаи vanRules', () {
      expect(rows.keys.toList(), expected.keys.toList());
      expect(expected.values.toSet(), VanRules.values.toSet());
    });

    for (final MapEntry(key: trip, value: result) in expected.entries) {
      test('$trip — ${result.name}, ст. ${result.article}', () {
        final row = rows[trip]!;
        expect(row.article, result.article);
        expect(
          row.result,
          startsWith(switch (result) {
            VanRules.applies => 'Действуют',
            VanRules.notYet || VanRules.domestic => 'Не действуют',
            VanRules.ownAccountExempt ||
            VanRules.nonCommercialExempt => 'Исключение',
          }),
        );
      });
    }
  });
}
