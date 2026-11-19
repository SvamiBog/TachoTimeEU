// Ст. 7 Регламента 561/2006: после 4:30 вождения — перерыв 45 мин,
// либо 15 + 30 мин именно в таком порядке. Перерыв — только отдых:
// другая работа и готовность счётчик не обнуляют.

import 'package:tacho_engine/tacho_engine.dart';
import 'package:test/test.dart';

import 'helpers.dart';

final DateTime now = utc('2026-09-23 12:00');

ComplianceSnapshot run(List<Seg> segs, {int? lead}) => calc(
  logUntil(now, [rest('11:00'), ...segs]),
  now,
  settings: lead == null
      ? const ComplianceSettings()
      : ComplianceSettings(warningLead: minutes(lead)),
);

/// Перерыв, каким его показывают экраны: взято, раздельный ли, набраны ли
/// первые 15 мин.
({Duration taken, bool split, bool firstPartDone}) shown(
  ComplianceSnapshot m,
) => (
  taken: m.breakTaken,
  split: m.breakSplit,
  firstPartDone: m.breakFirstPartDone,
);

/// Идущий перерыв: сколько нужно, набран ли и сколько осталось.
({Duration required, bool done, Duration remaining})? going(
  ComplianceSnapshot m,
) => switch (m.currentBreak) {
  final b? => (required: b.required, done: b.done, remaining: b.remaining),
  null => null,
};

/// Сколько перерыва называет нарушение «больше 4:30 без перерыва».
Duration? exceededBreak(ComplianceSnapshot m) =>
    m.infringement(InfringementType.continuousExceeded)?.breakToTake;

void main() {
  group('ст. 7: граница 4:30', () {
    test('ровно 4:30 вождения — ещё не нарушение, до перерыва 0 мин', () {
      final m = run([drive('4:30')]);
      expect(m.continuousDriving, minutes(270));
      expect(m.drivingUntilBreak, Duration.zero);
      expect(keys(m), isNot(contains(InfringementType.continuousExceeded)));
      expect(
        m.infringement(InfringementType.breakSoon),
        Infringement(
          InfringementType.breakSoon,
          time: Duration.zero,
          requiredBreak: minutes(45),
        ),
      );
    });

    test('4:31 — нарушение на 1 мин', () {
      final m = run([drive('4:31')]);
      final i = m.infringement(InfringementType.continuousExceeded);
      expect(i?.severity, InfringementSeverity.violation);
      expect(i?.type.regulation, '561/2006');
      expect(i?.type.article, '7');
      expect(i?.time, minute);
      expect(m.drivingUntilBreak, Duration.zero);
    });

    test('вождение, разбитое другой работой, считается вместе', () {
      final m = run([drive('2:00'), work('1:00'), drive('2:31')]);
      expect(m.continuousDriving, minutes(271));
      expect(keys(m), contains(InfringementType.continuousExceeded));
    });

    test('готовность (POA) — не перерыв', () {
      final m = run([drive('2:00'), poa('0:45'), drive('2:31')]);
      expect(m.continuousDriving, minutes(271));
      expect(keys(m), contains(InfringementType.continuousExceeded));
    });

    test('перерыв до начала вождения не нужен и не мешает', () {
      final m = run([work('1:00'), rest('0:45'), drive('4:30')]);
      expect(m.continuousDriving, minutes(270));
      expect(keys(m), isNot(contains(InfringementType.continuousExceeded)));
    });
  });

  group('ст. 7: перерыв 45 мин', () {
    test('45 мин обнуляют счётчик — можно снова 4:30', () {
      final m = run([drive('4:30'), rest('0:45'), drive('4:30')]);
      expect(m.continuousDriving, minutes(270));
      expect(keys(m), isNot(contains(InfringementType.continuousExceeded)));
    });

    test('44 мин — не перерыв', () {
      final m = run([drive('2:00'), rest('0:44'), drive('2:31')]);
      expect(m.continuousDriving, minutes(271));
      expect(keys(m), contains(InfringementType.continuousExceeded));
    });

    test('отдых, прерванный работой, не непрерывный: 20 + 5 работы + 25 — '
        'только первая часть', () {
      final m = run([
        drive('2:00'),
        rest('0:20'),
        work('0:05'),
        rest('0:25'),
        drive('2:10'),
      ]);
      expect(m.continuousDriving, minutes(250));
      expect(m.breakFirstPart?.duration, minutes(20));
      expect(m.breakRequired, minutes(30));
    });

    test('после 4:40 вождения перерыв 45 мин снимает нарушение', () {
      final m = run([drive('4:40'), rest('0:45'), drive('0:10')]);
      expect(m.continuousDriving, minutes(10));
      expect(keys(m), isNot(contains(InfringementType.continuousExceeded)));
    });
  });

  group('ст. 7: раздельный перерыв 15 + 30', () {
    test('15, работа, затем 30 — полный перерыв', () {
      final m = run([
        drive('1:00'),
        rest('0:15'),
        work('1:00'),
        drive('2:00'),
        rest('0:30'),
        drive('0:10'),
      ]);
      expect(m.continuousDriving, minutes(10));
      expect(m.breakFirstPart, isNull);
      expect(m.breakRequired, minutes(45));
    });

    test('14 + 30 — не перерыв: 14 мин не первая часть, первой становятся '
        '30', () {
      final m = run([
        drive('2:00'),
        rest('0:14'),
        drive('1:00'),
        rest('0:30'),
        drive('1:31'),
      ]);
      expect(m.continuousDriving, minutes(271));
      expect(keys(m), contains(InfringementType.continuousExceeded));
      expect(m.breakFirstPart?.duration, minutes(30));
      expect(m.breakRequired, minutes(30));
    });

    test('15 + 29 — не перерыв', () {
      final m = run([
        drive('2:00'),
        rest('0:15'),
        drive('1:00'),
        rest('0:29'),
        drive('1:31'),
      ]);
      expect(m.continuousDriving, minutes(271));
      expect(m.breakFirstPart?.duration, minutes(15));
      expect(m.breakRequired, minutes(30));
    });

    test('20 + 20 — не перерыв', () {
      final m = run([
        drive('2:00'),
        rest('0:20'),
        drive('2:00'),
        rest('0:20'),
        drive('0:31'),
      ]);
      expect(m.continuousDriving, minutes(271));
    });

    test('первая часть не сбрасывается короткой второй: 15, 20, затем 30 — '
        'перерыв', () {
      final m = run([
        drive('1:00'),
        rest('0:15'),
        drive('1:00'),
        rest('0:20'),
        drive('1:00'),
        rest('0:30'),
        drive('0:05'),
      ]);
      expect(m.continuousDriving, minutes(5));
    });

    test('после первой части 45 мин — тоже полный перерыв', () {
      final m = run([
        drive('2:00'),
        rest('0:15'),
        drive('1:00'),
        rest('0:45'),
        drive('0:10'),
      ]);
      expect(m.continuousDriving, minutes(10));
      expect(m.breakFirstPart, isNull);
    });

    test('30, затем 15 — не перерыв: порядок частей важен', () {
      final m = run([
        drive('1:40'),
        rest('0:30'),
        drive('1:40'),
        rest('0:15'),
        drive('0:10'),
      ]);
      expect(m.continuousDriving, minutes(210));
    });

    test('предупреждение после первой части просит 30 мин', () {
      final m = run([drive('2:00'), rest('0:15'), drive('2:05')]);
      expect(m.continuousDriving, minutes(245));
      expect(
        m.infringement(InfringementType.breakSoon),
        Infringement(
          InfringementType.breakSoon,
          time: minutes(25),
          requiredBreak: minutes(30),
        ),
      );
    });
  });

  group('ст. 7: текущий перерыв', () {
    test('идёт 44 мин — счётчик ещё не обнулён', () {
      final m = run([drive('4:00'), rest('0:44')]);
      expect(m.continuousDriving, minutes(240));
      expect(m.currentBreak?.duration, minutes(44));
      expect(m.currentBreak?.required, minutes(45));
      expect(m.status, DriverStatus.onBreak);
    });

    test('идёт 45 мин — счётчик обнулён, можно ехать 4:30', () {
      final m = run([drive('4:00'), rest('0:45')]);
      expect(m.continuousDriving, Duration.zero);
      expect(m.drivingUntilBreak, minutes(270));
      expect(m.currentBreak?.duration, minutes(45));
      expect(m.currentBreak?.required, minutes(45));
    });

    test('один текущий отдых 30 мин не засчитывается как 15 + 30', () {
      final m = run([drive('4:00'), rest('0:30')]);
      expect(m.continuousDriving, minutes(240));
      expect(m.currentBreak?.required, minutes(45));
    });

    test('после первой части текущему перерыву достаточно 30 мин', () {
      final before = run([
        drive('2:00'),
        rest('0:15'),
        drive('2:00'),
        rest('0:29'),
      ]);
      expect(before.continuousDriving, minutes(240));
      expect(before.currentBreak?.required, minutes(30));

      final after = run([
        drive('2:00'),
        rest('0:15'),
        drive('2:00'),
        rest('0:30'),
      ]);
      expect(after.continuousDriving, Duration.zero);
    });

    test('во время перерыва нет предупреждения «скоро перерыв»', () {
      final m = run([drive('4:20'), rest('0:10')]);
      expect(m.continuousDriving, minutes(260));
      expect(keys(m), isNot(contains(InfringementType.breakSoon)));
    });

    test('повторное нажатие «Отдых» не дробит перерыв: 20 + 25 = 45', () {
      final m = run([drive('4:00'), rest('0:20'), rest('0:25'), drive('0:05')]);
      expect(m.continuousDriving, minutes(5));
    });
  });

  group('ст. 7: отдых вместо перерыва', () {
    test('суточный отдых обнуляет счётчик', () {
      final m = run([drive('4:00'), rest('9:00'), drive('1:00')]);
      expect(m.continuousDriving, minutes(60));
    });

    test('первая часть раздельного суточного отдыха (3 ч) — тоже перерыв', () {
      final m = run([drive('4:00'), rest('3:00'), drive('1:00')]);
      expect(m.continuousDriving, minutes(60));
      expect(m.dailyDriving, minutes(300));
    });

    test('первая часть перерыва не переходит в следующую смену', () {
      final m = run([
        drive('2:00'),
        rest('0:15'),
        drive('1:00'),
        rest('9:00'),
        drive('2:00'),
        rest('0:30'),
        drive('0:10'),
      ]);
      // 30 мин в новой смене — только первая часть, а не вторая к 15 мин
      // вчерашней смены
      expect(m.continuousDriving, minutes(130));
      expect(m.breakFirstPart?.duration, minutes(30));
    });
  });

  group('ст. 7: предупреждение заранее', () {
    for (final (lead, driven, expected) in [
      (15, '4:14', false),
      (15, '4:15', true),
      (30, '3:59', false),
      (30, '4:00', true),
      (60, '3:29', false),
      (60, '3:30', true),
    ]) {
      test('за $lead мин: после $driven вождения предупреждение — '
          '$expected', () {
        final m = run([drive(driven)], lead: lead);
        expect(keys(m).contains(InfringementType.breakSoon), expected);
      });
    }

    test('без вождения предупреждения нет', () {
      final m = run([work('10:00')]);
      expect(m.continuousDriving, Duration.zero);
      expect(keys(m), isNot(contains(InfringementType.breakSoon)));
    });
  });

  // Экраны и уведомление берут перерыв из движка и ничего не считают сами.
  group('ENG-32: перерыв для экранов — взято, раздельный, нужен, остаток', () {
    const zero = Duration.zero;

    test('ENG-32: без перерыва ничего не взято', () {
      final m = run([drive('2:00')]);
      expect(shown(m), (taken: zero, split: false, firstPartDone: false));
      expect(going(m), isNull);
    });

    test('ENG-32: 45 мин одним куском — засчитан и не раздельный', () {
      final m = run([drive('2:00'), rest('0:45')]);
      expect(shown(m), (taken: minutes(45), split: false, firstPartDone: true));
      expect(going(m), (required: minutes(45), done: true, remaining: zero));
      expect(m.continuousDriving, zero);
    });

    test('ENG-32: идёт 44 мин — уже первая часть, до 45 мин осталась 1', () {
      final m = run([drive('2:00'), rest('0:44')]);
      expect(shown(m), (taken: minutes(44), split: true, firstPartDone: true));
      expect(going(m), (
        required: minutes(45),
        done: false,
        remaining: minutes(1),
      ));
    });

    test('ENG-32: идёт 14 мин — ещё не первая часть, 15 мин — уже она', () {
      final short = run([drive('2:00'), rest('0:14')]);
      expect(shown(short), (
        taken: minutes(14),
        split: false,
        firstPartDone: false,
      ));
      expect(going(short)?.remaining, minutes(31));

      final first = run([drive('2:00'), rest('0:15')]);
      expect(shown(first), (
        taken: minutes(15),
        split: true,
        firstPartDone: true,
      ));
      expect(going(first), (
        required: minutes(45),
        done: false,
        remaining: minutes(30),
      ));
    });

    test('ENG-32: первая часть взята, водитель едет — в счёт 15 мин', () {
      final m = run([drive('2:00'), rest('0:15'), drive('1:00')]);
      expect(shown(m), (taken: minutes(15), split: true, firstPartDone: true));
      expect(m.breakRequired, minutes(30));
      expect(going(m), isNull);
    });

    test('ENG-32: вторая часть идёт — в счёт первая и текущая', () {
      final m = run([drive('2:00'), rest('0:15'), drive('1:00'), rest('0:29')]);
      expect(shown(m), (taken: minutes(44), split: true, firstPartDone: true));
      expect(going(m), (
        required: minutes(30),
        done: false,
        remaining: minutes(1),
      ));
      expect(m.continuousDriving, minutes(180));
    });

    test('ENG-32: вторая часть 30 мин — перерыв засчитан и сбросил '
        'непрерывное вождение', () {
      final m = run([drive('2:00'), rest('0:15'), drive('1:00'), rest('0:30')]);
      expect(m.continuousDriving, zero);
      expect(m.drivingUntilBreak, minutes(270));
      expect(going(m), (required: minutes(30), done: true, remaining: zero));
      expect(m.breakSplit, isTrue);
    });

    test('ENG-32: засчитанный 15 + 30 — в счёт обе части', () {
      final m = run([drive('2:00'), rest('0:15'), drive('1:00'), rest('0:30')]);
      expect(shown(m), (taken: minutes(45), split: true, firstPartDone: true));
    });

    test('ENG-32: 15, потом 30 и снова вождение — счёт перерыва заново', () {
      final m = run([
        drive('2:00'),
        rest('0:15'),
        drive('1:00'),
        rest('0:30'),
        drive('0:10'),
      ]);
      expect(m.continuousDriving, minutes(10));
      expect(shown(m), (taken: zero, split: false, firstPartDone: false));
      expect(m.breakRequired, minutes(45));
    });

    test('ENG-32: первая часть короче 15 мин — не часть', () {
      final after = run([drive('2:00'), rest('0:14'), drive('1:00')]);
      expect(shown(after), (taken: zero, split: false, firstPartDone: false));
      expect(after.breakRequired, minutes(45));

      // 14 мин в счёт не идут: текущий отдых сам становится первой частью,
      // одним куском ему нужно 45 мин
      final m = run([drive('2:00'), rest('0:14'), drive('1:00'), rest('0:30')]);
      expect(shown(m), (taken: minutes(30), split: true, firstPartDone: true));
      expect(going(m), (
        required: minutes(45),
        done: false,
        remaining: minutes(15),
      ));
    });

    test('ENG-32: 30, потом 15 — вторая часть не засчитана', () {
      final m = run([drive('2:00'), rest('0:30'), drive('1:00'), rest('0:15')]);
      // 30 мин — первая часть; второй нужно 30, 15 мин перерыв не засчитывают
      expect(m.continuousDriving, minutes(180));
      expect(going(m), (
        required: minutes(30),
        done: false,
        remaining: minutes(15),
      ));
      // В счёт обе части — 0:45 из 45, хотя перерыв не засчитан: так
      // показывал и прежний расчёт в UI
      expect(shown(m), (taken: minutes(45), split: true, firstPartDone: true));
    });

    test('ENG-32: после первой части отдых 45 мин — засчитан как вторая', () {
      final m = run([drive('2:00'), rest('0:15'), drive('1:00'), rest('0:45')]);
      expect(m.continuousDriving, zero);
      expect(going(m), (required: minutes(30), done: true, remaining: zero));
    });

    test('ENG-32: пауза после ручной смены — первая часть, вторая идёт по '
        'записям', () {
      final start = utc('2026-09-23 06:00');
      final manual = ManualShift(
        start: start,
        end: start.add(dur('5:00')),
        driving: dur('4:00'),
        continuousDrivingAtEnd: dur('3:00'),
        restKind: RestKind.daily,
      );
      // 20 мин после смены, 1:00 вождения, отдых идёт 10 мин
      final next = logFrom(manual.end!.add(minutes(20)), [
        drive('1:00'),
        rest('0:10'),
      ]);
      final m = calc(next.periods, next.now, manual: [manual]);
      expect(m.continuousDriving, dur('4:00'));
      expect(shown(m), (taken: minutes(30), split: true, firstPartDone: true));
      expect(going(m), (
        required: minutes(30),
        done: false,
        remaining: minutes(20),
      ));
    });

    test('ENG-32: остаток не уходит ниже нуля', () {
      final full = run([drive('2:00'), rest('1:00')]);
      expect(going(full)?.remaining, zero);

      final second = run([
        drive('2:00'),
        rest('0:15'),
        drive('1:00'),
        rest('0:40'),
      ]);
      expect(going(second)?.remaining, zero);
    });
  });

  group('ENG-35: перерыв набран — одно понятие для главной, уведомления и '
      'прогноза', () {
    const zero = Duration.zero;

    test('ENG-35: начало смены, 1:00 другой работы, 20 мин отдыха — перерыв '
        'набран: вождения не было, можно ехать 4:30', () {
      final m = run([work('1:00'), rest('0:20')]);
      expect(m.status, DriverStatus.onBreak);
      expect(m.continuousDriving, zero);
      expect(m.drivingUntilBreak, dur('4:30'));
      // Раньше остаток был 25 мин: уведомление звало «до полного перерыва»,
      // а главная уже писала «Перерыв засчитан»
      expect(going(m), (required: minutes(45), done: true, remaining: zero));
    });

    test('ENG-35: отдых без вождения с прошлого засчитанного перерыва — '
        'набран с первой минуты', () {
      final m = run([drive('2:00'), rest('0:45'), work('0:30'), rest('0:01')]);
      expect(m.continuousDriving, zero);
      expect(going(m), (required: minutes(45), done: true, remaining: zero));
    });

    test('ENG-35: 2:00 вождения, 20 мин отдыха — не набран, ещё 25 мин', () {
      final m = run([drive('2:00'), rest('0:20')]);
      expect(going(m), (
        required: minutes(45),
        done: false,
        remaining: minutes(25),
      ));
    });

    test('ENG-35: набран ровно тогда, когда остатка нет и непрерывное '
        'вождение обнулено', () {
      final cases = <(List<Seg>, bool)>[
        ([drive('2:00'), rest('0:44')], false),
        ([drive('2:00'), rest('0:45')], true),
        ([drive('2:00'), rest('0:15'), drive('1:00'), rest('0:29')], false),
        ([drive('2:00'), rest('0:15'), drive('1:00'), rest('0:30')], true),
        ([drive('2:00'), rest('0:30'), drive('1:00'), rest('0:15')], false),
        ([drive('4:31'), rest('0:20')], false),
        ([work('0:30'), rest('0:01')], true),
      ];
      for (final (segs, done) in cases) {
        final m = run(segs);
        final b = m.currentBreak!;
        expect(b.done, done, reason: '$segs');
        expect(b.remaining == zero, done, reason: '$segs');
        expect(m.continuousDriving == zero, done, reason: '$segs');
      }
    });

    test('ENG-35: больше 4:30 без перерыва — перерыв 45 мин', () {
      expect(exceededBreak(run([drive('4:31')])), minutes(45));
    });

    test('ENG-35: превышение после первой части 15 мин — перерыв 30 мин, как '
        'считает движок', () {
      final m = run([drive('2:00'), rest('0:15'), drive('2:31')]);
      expect(m.infringement(InfringementType.continuousExceeded)?.time, minute);
      expect(m.breakRequired, minutes(30));
      expect(exceededBreak(m), minutes(30));

      // 30 мин после этого и правда снимают превышение
      final after = run([
        drive('2:00'),
        rest('0:15'),
        drive('2:31'),
        rest('0:30'),
      ]);
      expect(after.continuousDriving, zero);
      expect(keys(after), isNot(contains(InfringementType.continuousExceeded)));
    });

    test('ENG-35: после первой части и превышения идёт вторая часть — '
        'перерыв 30 мин', () {
      final m = run([drive('2:00'), rest('0:15'), drive('2:31'), rest('0:10')]);
      expect(exceededBreak(m), minutes(30));
      expect(going(m)?.remaining, minutes(20));
    });

    test('ENG-35: после превышения без первой части идёт отдых 20 мин — '
        'перерыв 45 мин: этому отдыху нужно 45 одним куском', () {
      final m = run([drive('4:31'), rest('0:20')]);
      expect(exceededBreak(m), minutes(45));
      expect(going(m)?.remaining, minutes(25));
    });

    test('ENG-35: после превышения 20 мин отдыха и снова вождение — они стали '
        'первой частью, перерыв 30 мин', () {
      final m = run([drive('4:31'), rest('0:20'), drive('0:10')]);
      expect(
        m.infringement(InfringementType.continuousExceeded)?.time,
        minutes(11),
      );
      expect(m.breakRequired, minutes(30));
      expect(exceededBreak(m), minutes(30));
    });

    test('ENG-35: нарушение без перерыва в данных — 45 мин', () {
      const exceeded = Infringement(InfringementType.continuousExceeded);
      expect(exceeded.breakToTake, minutes(45));
    });

    test('ENG-35: в журнале нарушений — тот же перерыв, что на главной', () {
      final start = utc('2026-09-21 06:00');
      final periods = closedLog(start, [
        drive('2:00'),
        rest('0:15'),
        drive('2:31'),
        rest('0:30'),
        drive('1:00'),
        rest('11:00'),
      ]);
      final found = violationLog(
        periods: periods,
        from: start,
        now: periods.last.end!,
      );
      expect(found.map((v) => v.type), [InfringementType.continuousExceeded]);
      expect(found.single.infringement.breakToTake, minutes(30));
    });
  });
}
