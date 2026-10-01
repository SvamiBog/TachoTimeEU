// BAN-01…09 (docs/testing.md): запреты движения грузовиков. Время запретов
// по местным правилам стран на настоящих датах 2026–2027 — праздники,
// Пасха, переход на зимнее время, склейка выходных с праздниками и ночами.
// Ожидания — в UTC, местное время — в комментариях.

import 'package:tacho_engine/driving_bans.dart';
import 'package:test/test.dart';

DateTime z(
  int month,
  int day, [
  int hour = 0,
  int minute = 0,
  int year = 2026,
]) => DateTime.utc(year, month, day, hour, minute);

List<(DateTime, DateTime)> spans(
  CountryBans c,
  DateTime from,
  DateTime to, {
  VehicleMass mass = VehicleMass.over12,
  bool definite = true,
}) => [
  for (final w in banWindows(c, mass, from, to))
    if (w.scope.definite == definite) (w.start, w.end),
];

void main() {
  group('BAN-01: Пасха и праздники от неё', () {
    test('западная и православная Пасха', () {
      expect(westernEaster(2025), DateTime.utc(2025, 4, 20));
      expect(westernEaster(2026), DateTime.utc(2026, 4, 5));
      expect(westernEaster(2027), DateTime.utc(2027, 3, 28));
      expect(westernEaster(2028), DateTime.utc(2028, 4, 16));
      expect(orthodoxEaster(2025), DateTime.utc(2025, 4, 20));
      expect(orthodoxEaster(2026), DateTime.utc(2026, 4, 12));
      expect(orthodoxEaster(2027), DateTime.utc(2027, 5, 2));
    });

    test('сдвиги от Пасхи 2026: Вознесение, Духов день, Тело Христово', () {
      expect(const EasterHoliday(-2).dateIn(2026), DateTime.utc(2026, 4, 3));
      expect(const EasterHoliday(39).dateIn(2026), DateTime.utc(2026, 5, 14));
      expect(const EasterHoliday(50).dateIn(2026), DateTime.utc(2026, 5, 25));
      expect(const EasterHoliday(60).dateIn(2026), DateTime.utc(2026, 6, 4));
      expect(
        const EasterHoliday(1, orthodox: true).dateIn(2026),
        DateTime.utc(2026, 4, 13),
      );
    });
  });

  group('BAN-02: местное время стран', () {
    test('летнее время ЕС 2026: 29 марта и 25 октября в 01:00 UTC', () {
      expect(isEuSummerTime(z(3, 29, 0, 59)), isFalse);
      expect(isEuSummerTime(z(3, 29, 1)), isTrue);
      expect(isEuSummerTime(z(10, 25, 0, 59)), isTrue);
      expect(isEuSummerTime(z(10, 25, 1)), isFalse);
    });

    test('местное ↔ UTC в поясах WET, CET, EET', () {
      expect(BanZone.cet.toUtc(z(7, 1, 22)), z(7, 1, 20));
      expect(BanZone.cet.toUtc(z(12, 1, 22)), z(12, 1, 21));
      expect(BanZone.eet.toUtc(z(7, 1, 22)), z(7, 1, 19));
      expect(BanZone.wet.toUtc(z(12, 1, 22)), z(12, 1, 22));
      expect(BanZone.cet.toLocal(z(7, 1, 20)), z(7, 1, 22));
      expect(BanZone.eet.toLocal(z(12, 1, 20)), z(12, 1, 22));
    });
  });

  group('BAN-03: масса машины', () {
    test('Швейцария — с 3,5 т, Германия — с 7,5 т, Польша — с 12 т', () {
      // Воскресенье 4 октября 2026, полдень по Центральной Европе
      final noon = z(10, 4, 10);
      expect(
        banStatus(switzerland, VehicleMass.upTo3_5, noon).level,
        BanLevel.none,
      );
      expect(
        banStatus(switzerland, VehicleMass.upTo7_5, noon).level,
        BanLevel.active,
      );
      expect(
        banStatus(germany, VehicleMass.upTo7_5, noon).level,
        BanLevel.none,
      );
      expect(
        banStatus(germany, VehicleMass.upTo12, noon).level,
        BanLevel.active,
      );
      // 1 ноября — праздник в Польше
      final allSaints = z(11, 1, 10);
      expect(
        banStatus(poland, VehicleMass.upTo12, allSaints).level,
        BanLevel.none,
      );
      expect(
        banStatus(poland, VehicleMass.over12, allSaints).level,
        BanLevel.active,
      );
    });
  });

  group('BAN-04: Германия', () {
    test('3 октября (суббота, праздник) и воскресенье — два запрета с '
        'перерывом 22:00–24:00', () {
      expect(spans(germany, z(10, 2), z(10, 5)), [
        (z(10, 2, 22), z(10, 3, 20)), // сб 00:00–22:00 CEST
        (z(10, 3, 22), z(10, 4, 20)), // вс 00:00–22:00 CEST
      ]);
      final gap = banStatus(germany, VehicleMass.over12, z(10, 3, 21));
      expect(gap.level, BanLevel.soon, reason: 'запрет с 00:00 — через час');
      expect(gap.next?.start, z(10, 3, 22));
      final during = banStatus(germany, VehicleMass.over12, z(10, 3, 12));
      expect(during.level, BanLevel.active);
      expect(during.current?.end, z(10, 3, 20));
      expect(during.current?.kinds, {BanKind.holiday});
    });

    test('День Реформации 31 октября — только в части земель; 1 ноября — '
        'воскресенье, запрет по всей стране, уже по зимнему времени', () {
      expect(spans(germany, z(10, 31), z(11, 2)), [
        (z(10, 31, 23), z(11, 1, 21)),
      ]);
      expect(spans(germany, z(10, 30), z(11, 1), definite: false), [
        (z(10, 30, 23), z(10, 31, 21)),
      ]);
      final saturday = banStatus(germany, VehicleMass.over12, z(10, 31, 10));
      expect(saturday.level, BanLevel.partial);
      expect(saturday.partial?.scope, BanScope.someRegions);
    });
  });

  group('BAN-05: Австрия', () {
    test('с 15:00 субботы до 22:00 воскресенья — один запрет; ночью — '
        'кроме машин «L»', () {
      expect(spans(austria, z(10, 10), z(10, 12)), [
        (z(10, 10, 13), z(10, 11, 20)),
      ]);
      final night = banStatus(austria, VehicleMass.over12, z(10, 12, 1));
      expect(night.level, BanLevel.partial);
      expect(night.partial?.scope, BanScope.conditional);
      expect(night.partial?.kinds, {BanKind.night});
      final saturday = banStatus(austria, VehicleMass.over12, z(10, 10, 14));
      expect(saturday.current?.kinds, {BanKind.weekend});
      expect(saturday.current?.end, z(10, 11, 20));
    });

    test('26 октября — национальный праздник, понедельник', () {
      expect(spans(austria, z(10, 26), z(10, 27)), [
        (z(10, 25, 23), z(10, 26, 21)),
      ]);
    });
  });

  group('BAN-06: Швейцария', () {
    test('Рождество в пятницу: от 22:00 четверга до 05:00 понедельника '
        '— праздники, выходные и ночи склеены', () {
      final w = banWindows(
        switzerland,
        VehicleMass.upTo7_5,
        z(12, 24, 12),
        z(12, 28, 12),
      );
      expect(w, hasLength(1));
      expect(w.single.start, z(12, 24, 21));
      expect(w.single.end, z(12, 28, 4));
      expect(w.single.kinds, {BanKind.night, BanKind.holiday, BanKind.weekend});
    });
  });

  group('BAN-07: Франция', () {
    test('11 ноября (среда): с 22:00 накануне до 22:00', () {
      expect(spans(france, z(11, 10), z(11, 12)), [
        (z(11, 10, 21), z(11, 11, 21)),
      ]);
    });

    test('после известного календаря — предварительно', () {
      final windows = banWindows(
        france,
        VehicleMass.over12,
        z(12, 26),
        z(1, 4, 0, 0, 2027),
      );
      expect(windows.first.provisional, isFalse); // сб 26 → вс 27 декабря
      expect(windows.last.provisional, isTrue); // сб 2 → вс 3 января 2027
    });
  });

  group('BAN-08: Венгрия', () {
    test('ночь перевода часов: с 22:00 субботы до 22:00 воскресенья — '
        '25 ч', () {
      final w = banWindows(hungary, VehicleMass.over12, z(10, 24), z(10, 26));
      expect(w.map((w) => (w.start, w.end)), [(z(10, 24, 20), z(10, 25, 21))]);
      expect(w.single.duration, const Duration(hours: 25));
    });

    test('23 октября (пятница): с 22:00 четверга', () {
      expect(spans(hungary, z(10, 22), z(10, 24)), [
        (z(10, 22, 20), z(10, 23, 20)),
      ]);
    });
  });

  group('BAN-09: Польша, Италия, Чехия, Словения', () {
    test('Польша: 11 ноября 8:00–22:00 и канун 18:00–22:00; перед '
        'Рождеством кануна нет', () {
      expect(spans(poland, z(11, 10), z(11, 12)), [
        (z(11, 10, 17), z(11, 10, 21)),
        (z(11, 11, 7), z(11, 11, 21)),
      ]);
      expect(spans(poland, z(12, 24), z(12, 25)), isEmpty);
    });

    test('Италия: воскресенье в октябре с 9:00, в сентябре с 7:00; 23 '
        'декабря 8:00–14:00 по календарю 2026', () {
      expect(spans(italy, z(10, 4), z(10, 5)), [(z(10, 4, 7), z(10, 4, 20))]);
      expect(spans(italy, z(9, 6), z(9, 7)), [(z(9, 6, 5), z(9, 6, 20))]);
      final calendar = banWindows(
        italy,
        VehicleMass.over12,
        z(12, 23),
        z(12, 24),
      );
      expect(calendar.single.start, z(12, 23, 7));
      expect(calendar.single.end, z(12, 23, 13));
      expect(calendar.single.kinds, {BanKind.calendar});
    });

    test('Чехия: 28 октября 13:00–22:00 на магистралях', () {
      final w = banWindows(czechia, VehicleMass.over12, z(10, 28), z(10, 29));
      expect(w.single.start, z(10, 28, 12));
      expect(w.single.end, z(10, 28, 21));
      expect(w.single.scope, BanScope.mainRoads);
    });

    test('Словения: Страстная пятница 2027 14:00–22:00, предварительно', () {
      final w = banWindows(
        slovenia,
        VehicleMass.over12,
        z(3, 26, 0, 0, 2027),
        z(3, 27, 0, 0, 2027),
      );
      expect(w.single.start, z(3, 26, 13, 0, 2027));
      expect(w.single.end, z(3, 26, 21, 0, 2027));
      expect(w.single.provisional, isTrue);
    });
  });

  group('BAN-10: страны без расчёта и данные', () {
    test('запреты на отдельных дорогах и страны без общих запретов', () {
      expect(
        banStatus(europeBans['E']!, VehicleMass.over12, z(10, 4, 10)).level,
        BanLevel.someRoads,
      );
      expect(
        banStatus(europeBans['NL']!, VehicleMass.over12, z(10, 4, 10)).level,
        BanLevel.none,
      );
      expect(
        banWindows(europeBans['NL']!, VehicleMass.over12, z(10, 1), z(11, 1)),
        isEmpty,
      );
    });

    test('Люксембург — запрет не для всех рейсов', () {
      final s = banStatus(luxembourg, VehicleMass.over12, z(10, 4, 10));
      expect(s.level, BanLevel.partial);
      expect(s.partial?.scope, BanScope.conditional);
    });

    test('у каждой страны с правилами — источники, запреты на год вперёд '
        'и ни одного длиннее 4 суток', () {
      for (final c in europeBans.values) {
        expect(c.checkedOn.date.isAfter(DateTime.utc(2026, 10, 2)), isFalse);
        if (c.coverage == BanCoverage.none) {
          expect(c.rules, isEmpty, reason: c.code);
          continue;
        }
        expect(c.sources, isNotEmpty, reason: c.code);
        if (c.coverage == BanCoverage.someRoads) continue;
        final year = banWindows(
          c,
          VehicleMass.over12,
          z(10, 1),
          z(10, 1, 0, 0, 2027),
        );
        expect(year, isNotEmpty, reason: c.code);
        for (final w in year) {
          expect(w.end.isAfter(w.start), isTrue, reason: '${c.code} $w');
          expect(
            w.duration <= const Duration(days: 4),
            isTrue,
            reason: '${c.code} $w',
          );
        }
        expect(c.lowestThreshold, isNotNull, reason: c.code);
      }
    });

    test('окно пустое или наоборот — запретов нет', () {
      expect(
        banWindows(germany, VehicleMass.over12, z(10, 4), z(10, 4)),
        isEmpty,
      );
      expect(
        banWindows(germany, VehicleMass.over12, z(10, 5), z(10, 4)),
        isEmpty,
      );
    });

    test('без запретов неделю — «можно ехать», ближайшего нет', () {
      final s = banStatus(
        slovenia,
        VehicleMass.over12,
        z(10, 5, 10),
        soon: Duration.zero,
      );
      expect(s.level, BanLevel.clear);
      expect(s.next?.start, z(10, 11, 6));
    });

    test('равенство и описание запрета', () {
      final a = banWindows(czechia, VehicleMass.over12, z(10, 28), z(10, 29));
      final b = banWindows(czechia, VehicleMass.over12, z(10, 28), z(10, 29));
      expect(a, b);
      expect(a.single.hashCode, b.single.hashCode);
      expect(a.single.toString(), contains('mainRoads'));
      expect(a.single.contains(z(10, 28, 12)), isTrue);
      expect(a.single.contains(z(10, 28, 21)), isFalse);
    });
  });
}
