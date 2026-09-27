// Документы не расходятся с кодом: таблица лимитов, пороги детектора
// движения, статусы водителя. План тестов: DOC-01…03 в docs/testing.md.

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
}
