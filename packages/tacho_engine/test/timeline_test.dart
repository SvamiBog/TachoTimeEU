// Построение шкалы из записей режимов: сортировка, наложения, склейка
// соседних записей одного режима, разрывы в данных.

import 'package:tacho_engine/tacho_engine.dart';
import 'package:test/test.dart';

import 'helpers.dart';

final DateTime now = utc('2026-09-23 12:00');

DateTime at(String hm) => utc('2026-09-23 $hm');

ActivityPeriod entry(int id, DriverMode mode, String from, String? to) =>
    ActivityPeriod(
      id: id,
      mode: mode,
      start: at(from),
      end: to == null ? null : at(to),
    );

String _hm(DateTime t) => t.toIso8601String().substring(11, 16);

List<String> shape(List<ActivityPeriod> periods) => [
  for (final b in buildBlocks(periods, now))
    '${b.mode.name} ${_hm(b.start)}–${_hm(b.end)}',
];

void main() {
  group('шкала: блоки', () {
    test('порядок записей во входе не важен', () {
      final periods = [
        entry(3, DriverMode.driving, '10:00', null),
        entry(1, DriverMode.rest, '06:00', '08:00'),
        entry(2, DriverMode.otherWork, '08:00', '10:00'),
      ];
      expect(shape(periods), [
        'rest 06:00–08:00',
        'otherWork 08:00–10:00',
        'driving 10:00–12:00',
      ]);
    });

    test('наложение: приоритет у более ранней записи', () {
      final periods = [
        entry(1, DriverMode.driving, '08:00', '10:00'),
        entry(2, DriverMode.otherWork, '09:00', '11:00'),
        entry(3, DriverMode.rest, '11:00', null),
      ];
      expect(shape(periods), [
        'driving 08:00–10:00',
        'otherWork 10:00–11:00',
        'rest 11:00–12:00',
      ]);
    });

    test('запись целиком внутри предыдущей отбрасывается', () {
      final periods = [
        entry(1, DriverMode.driving, '08:00', '11:00'),
        entry(2, DriverMode.rest, '09:00', '10:00'),
        entry(3, DriverMode.otherWork, '11:00', null),
      ];
      expect(shape(periods), ['driving 08:00–11:00', 'otherWork 11:00–12:00']);
    });

    test('соседние записи одного режима склеиваются', () {
      final blocks = buildBlocks([
        entry(1, DriverMode.rest, '10:00', '10:20'),
        entry(2, DriverMode.rest, '10:20', '10:45'),
        entry(3, DriverMode.driving, '10:45', null),
      ], now);
      expect(blocks, hasLength(2));
      expect(blocks.first.duration, minutes(45));
    });

    test('зазор до 1 с склеивается, больше — нет', () {
      final base = at('10:00');
      List<ActivityPeriod> make(Duration gap) => [
        ActivityPeriod(
          mode: DriverMode.rest,
          start: base,
          end: base.add(minutes(20)),
        ),
        ActivityPeriod(
          mode: DriverMode.rest,
          start: base.add(minutes(20)).add(gap),
          end: base.add(minutes(45)),
        ),
        ActivityPeriod(mode: DriverMode.driving, start: base.add(minutes(45))),
      ];
      expect(buildBlocks(make(const Duration(seconds: 1)), now), hasLength(2));
      expect(
        buildBlocks(make(const Duration(seconds: 1, milliseconds: 1)), now),
        hasLength(3),
      );
    });

    test('закрытая запись, заходящая в будущее, обрезается моментом '
        'расчёта', () {
      final blocks = buildBlocks([
        entry(1, DriverMode.driving, '10:00', '14:00'),
      ], now);
      expect(blocks.first.end, now);
    });

    test('пустые закрытые записи игнорируются', () {
      final periods = [
        entry(1, DriverMode.driving, '10:00', '10:00'),
        entry(2, DriverMode.rest, '11:00', null),
      ];
      expect(shape(periods), ['rest 11:00–12:00']);
    });

    test('текущий режим открыт и идёт до момента расчёта', () {
      final blocks = buildBlocks([
        entry(1, DriverMode.driving, '10:00', null),
      ], now);
      expect(blocks.first.open, isTrue);
      expect(blocks.first.end, now);
    });
  });

  group('шкала: смены', () {
    test('короткий отдых в начале данных — не часть смены', () {
      final t = analyzeTimeline([
        entry(1, DriverMode.rest, '08:00', '09:00'),
        entry(2, DriverMode.driving, '09:00', null),
      ], now);
      expect(t.shifts, hasLength(1));
      expect(t.shifts.first.start, at('09:00'));
      expect(t.shifts.first.breaks, Duration.zero);
    });

    test('только отдых — смены нет', () {
      final t = analyzeTimeline([
        entry(1, DriverMode.rest, '08:00', null),
      ], now);
      expect(t.shifts, isEmpty);
      expect(t.current, isNull);
      final m = calc([entry(1, DriverMode.rest, '08:00', null)], now);
      expect(m.status, DriverStatus.notStarted);
    });

    test('смена = вождение + работа + готовность + перерывы', () {
      final m = calc(
        logUntil(now, [
          rest('11:00'),
          drive('2:00'),
          work('0:30'),
          rest('0:45'),
          poa('0:20'),
          drive('1:00'),
        ]),
        now,
      );
      expect(m.shift?.driving, minutes(180));
      expect(m.shift?.otherWork, minutes(30));
      expect(m.shift?.availability, minutes(20));
      expect(m.shift?.breaks, minutes(45));
      expect(m.shiftDuration, minutes(180 + 30 + 45 + 20));
      expect(m.status, DriverStatus.driving);
    });

    test('разрыв в данных — не отдых: перерыв не засчитывается', () {
      // Приложение не писало режим 2 ч (например, запись удалили)
      final periods = [
        entry(1, DriverMode.rest, '00:00', '06:00'),
        entry(2, DriverMode.driving, '06:00', '08:00'),
        entry(3, DriverMode.driving, '10:00', null),
      ];
      final m = calc(periods, at('12:31'));
      expect(m.continuousDriving, minutes(120 + 151));
      expect(m.shiftDuration, minutes(6 * 60 + 31));
    });

    test('журнал обрывается разрывом — режим неизвестен', () {
      final periods = [
        entry(1, DriverMode.rest, '00:00', '06:00'),
        entry(2, DriverMode.driving, '06:00', '08:00'),
      ];
      final m = calc(periods, at('09:00'));
      expect(m.currentMode, isNull);
      expect(m.status, DriverStatus.unknown);
      expect(m.shiftDuration, minutes(180));
    });

    test('отдых, собранный из нескольких записей, — один период', () {
      final periods = logUntil(now, [
        drive('4:00'),
        rest('5:00'),
        rest('4:00'),
        drive('0:10'),
      ]);
      final rests = findRestPeriods(buildBlocks(periods, now));
      expect(rests, hasLength(1));
      expect(rests.first.rest, minutes(540));
      expect(calc(periods, now).timeline.shifts, hasLength(2));
    });
  });
}
