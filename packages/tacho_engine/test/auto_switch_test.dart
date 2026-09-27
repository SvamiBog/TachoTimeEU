// Автоопределение вождения по скорости GPS: детектор «поехали /
// остановились» и правила, когда переключать режим сразу, а когда только
// предложить водителю.

import 'package:tacho_engine/tacho_engine.dart';
import 'package:test/test.dart';

import 'helpers.dart';

final DateTime t0 = utc('2026-09-23 06:00');

/// Отметки каждые [step] с заданными скоростями, начиная с [from].
List<MotionSample> track(
  List<double> speeds, {
  DateTime? from,
  Duration step = const Duration(seconds: 10),
}) => [
  for (final (i, v) in speeds.indexed)
    MotionSample(time: (from ?? t0).add(step * i), speedKmh: v),
];

List<MotionEvent> run(MotionDetector d, List<MotionSample> samples) => [
  for (final s in samples) ?d.add(s),
];

List<double> times(int n, double speed) => List.filled(n, speed);

void main() {
  group('детектор: начало движения', () {
    test('30 с быстрее 15 км/ч — поехали, с первой отметки серии', () {
      final d = MotionDetector();
      final events = run(d, track([0, 0, 20, 30, 40, 50]));
      expect(events, [MotionEvent(MotionEventType.started, t0.add(sec(20)))]);
      expect(d.isMoving, isTrue);
    });

    test('20 с движения — ещё нет', () {
      final d = MotionDetector();
      expect(run(d, track([0, 20, 30, 40])), isEmpty);
      expect(d.pendingStart, t0.add(sec(10)));
    });

    test('ходьба и бег по стоянке — не вождение', () {
      final d = MotionDetector();
      expect(run(d, track(times(60, 12))), isEmpty);
      expect(d.isMoving, isFalse);
    });

    test('разгон через медленную скорость не обрывает серию', () {
      final d = MotionDetector();
      final events = run(d, track([20, 10, 25, 30]));
      expect(events, [MotionEvent(MotionEventType.started, t0)]);
    });

    test('остановка во время разгона обрывает серию', () {
      final d = MotionDetector();
      final events = run(d, track([20, 25, 0, 20, 25, 30, 35]));
      expect(events, [MotionEvent(MotionEventType.started, t0.add(sec(30)))]);
    });

    test('неточные отметки и отметки без скорости не учитываются', () {
      final d = MotionDetector();
      final samples = [
        MotionSample(time: t0, speedKmh: 60, accuracyMeters: 200),
        MotionSample(time: t0.add(sec(10)), speedKmh: -1),
        MotionSample(time: t0.add(sec(20)), speedKmh: 60, accuracyMeters: 200),
      ];
      expect(run(d, samples), isEmpty);
      expect(d.pendingStart, isNull);
    });

    test('отметки из прошлого пропускаются', () {
      final d = MotionDetector();
      final samples = [
        ...track([30, 30]),
        MotionSample(time: t0, speedKmh: 0),
        MotionSample(time: t0.add(sec(30)), speedKmh: 30),
      ];
      expect(run(d, samples), [MotionEvent(MotionEventType.started, t0)]);
    });

    test('разрыв в отметках дольше 2 мин обрывает серию', () {
      final d = MotionDetector();
      final samples = [
        MotionSample(time: t0, speedKmh: 30),
        MotionSample(time: t0.add(const Duration(minutes: 3)), speedKmh: 30),
        MotionSample(
          time: t0.add(const Duration(minutes: 3, seconds: 20)),
          speedKmh: 30,
        ),
      ];
      expect(run(d, samples), isEmpty);
      expect(d.pendingStart, t0.add(const Duration(minutes: 3)));
    });
  });

  group('детектор: остановка', () {
    MotionDetector moving() => MotionDetector()..reset(moving: true);

    test('3 мин стоянки — остановились, с первой отметки стоянки', () {
      final d = moving();
      final events = run(d, track([60, 60, ...times(19, 0)]));
      expect(events, [MotionEvent(MotionEventType.stopped, t0.add(sec(20)))]);
      expect(d.isMoving, isFalse);
    });

    test('светофор 2 мин — остаётся вождением', () {
      final d = moving();
      expect(run(d, track([60, ...times(12, 0), 40, 60])), isEmpty);
      expect(d.isMoving, isTrue);
    });

    test('пробка: движение шагом не считается остановкой', () {
      final d = moving();
      final jam = [
        for (var i = 0; i < 60; i++)
          if (i.isEven) 0.0 else 7.0,
      ];
      expect(run(d, track(jam)), isEmpty);
    });

    test('туннель: после разрыва стоянка считается заново', () {
      final d = moving();
      final samples = [
        MotionSample(time: t0, speedKmh: 0),
        MotionSample(time: t0.add(const Duration(minutes: 4)), speedKmh: 0),
        MotionSample(time: t0.add(const Duration(minutes: 6)), speedKmh: 0),
        MotionSample(time: t0.add(const Duration(minutes: 7)), speedKmh: 0),
      ];
      expect(run(d, samples), [
        MotionEvent(
          MotionEventType.stopped,
          t0.add(const Duration(minutes: 4)),
        ),
      ]);
    });

    test('поехали и остановились — оба события по порядку', () {
      final d = MotionDetector();
      final events = run(d, track([...times(10, 50), ...times(20, 0)]));
      expect(events.map((e) => e.type), [
        MotionEventType.started,
        MotionEventType.stopped,
      ]);
    });
  });

  group('правила переключения', () {
    final now = utc('2026-09-23 12:00');
    final movedAt = now.subtract(const Duration(minutes: 1));
    final started = MotionEvent(MotionEventType.started, movedAt);
    final stopped = MotionEvent(MotionEventType.stopped, movedAt);

    AutoSwitch decide(
      List<Seg> segs,
      MotionEvent event, {
      CrewMode crew = CrewMode.solo,
      AutoSwitchSettings settings = const AutoSwitchSettings(),
    }) => decideAutoSwitch(
      event: event,
      state: calc(logUntil(now, segs), now),
      crew: crew,
      settings: settings,
    );

    test('поехали во время работы — вождение сразу, с начала движения', () {
      expect(
        decide([rest('11:00'), work('0:30')], started),
        AutoSwitch(AutoSwitchKind.apply, mode: DriverMode.driving, at: movedAt),
      );
    });

    test('поехали после перерыва — вождение сразу', () {
      expect(
        decide([rest('11:00'), drive('2:00'), rest('0:45')], started).kind,
        AutoSwitchKind.apply,
      );
    });

    test('уже вождение — ничего', () {
      expect(decide([rest('11:00'), drive('1:00')], started), AutoSwitch.none);
    });

    test('на суточном отдыхе — только предложение', () {
      expect(
        decide([rest('11:00'), drive('4:00'), rest('9:30')], started),
        AutoSwitch(
          AutoSwitchKind.suggest,
          mode: DriverMode.driving,
          at: movedAt,
          reason: AutoSwitchReason.offDuty,
        ),
      );
    });

    test('на отдыхе с настройкой «сразу» — вождение сразу', () {
      expect(
        decide(
          [rest('11:00'), drive('4:00'), rest('9:30')],
          started,
          settings: const AutoSwitchSettings(startFromRest: true),
        ).kind,
        AutoSwitchKind.apply,
      );
    });

    test('смена не начата — только предложение', () {
      expect(decide([rest('0:30')], started).reason, AutoSwitchReason.offDuty);
    });

    test('экипаж — только предложение: неизвестно, кто за рулём', () {
      expect(
        decide(
          [rest('11:00'), poa('1:00')],
          started,
          crew: CrewMode.team,
        ).reason,
        AutoSwitchReason.team,
      );
    });

    test('на пароме — ничего', () {
      expect(
        decide([
          rest('11:00'),
          drive('4:00'),
          work('0:20', ferry: true),
        ], started),
        AutoSwitch.none,
      );
    });

    test('остановились во время вождения — другая работа', () {
      expect(
        decide([rest('11:00'), drive('2:00')], stopped),
        AutoSwitch(
          AutoSwitchKind.apply,
          mode: DriverMode.otherWork,
          at: movedAt,
        ),
      );
    });

    test('режим после остановки настраивается', () {
      expect(
        decide(
          [rest('11:00'), drive('2:00')],
          stopped,
          settings: const AutoSwitchSettings(afterStop: DriverMode.rest),
        ).mode,
        DriverMode.rest,
      );
    });

    test('остановились не во время вождения — ничего', () {
      expect(decide([rest('11:00'), work('2:00')], stopped), AutoSwitch.none);
    });

    test('переключение не раньше начала текущего режима', () {
      // Машина поехала минуту назад, а водитель сам включил работу 20 с назад
      final switchedAt = now.subtract(sec(20));
      final periods = [
        ActivityPeriod(
          mode: DriverMode.rest,
          start: now.subtract(const Duration(hours: 12)),
          end: now.subtract(const Duration(hours: 1)),
        ),
        ActivityPeriod(
          mode: DriverMode.otherWork,
          start: now.subtract(const Duration(hours: 1)),
          end: switchedAt,
        ),
        ActivityPeriod(mode: DriverMode.availability, start: switchedAt),
      ];
      final decision = decideAutoSwitch(
        event: started,
        state: calc(periods, now),
        crew: CrewMode.solo,
      );
      expect(decision.kind, AutoSwitchKind.apply);
      expect(decision.at, switchedAt);
    });
  });
  group('ENG-15: правила переключения полной таблицей', () {
    final now = utc('2026-09-23 12:00');
    final eventAt = now.subtract(const Duration(minutes: 1));

    /// Журнал для каждого статуса; с паромом — последняя запись отмечена.
    List<ActivityPeriod> journalFor(
      DriverStatus status, {
      required bool ferry,
    }) {
      Seg last(Seg s) => Seg(s.mode, s.duration, ferry: ferry);
      final segs = switch (status) {
        DriverStatus.notStarted => [last(rest('0:30'))],
        DriverStatus.driving => [rest('11:00'), last(drive('1:00'))],
        DriverStatus.otherWork => [rest('11:00'), last(work('1:00'))],
        DriverStatus.availability => [rest('11:00'), last(poa('1:00'))],
        DriverStatus.onBreak => [
          rest('11:00'),
          drive('2:00'),
          last(rest('0:45')),
        ],
        DriverStatus.dailyRest => [
          rest('11:00'),
          drive('4:00'),
          last(rest('9:30')),
        ],
        DriverStatus.weeklyRest => [
          rest('11:00'),
          drive('4:00'),
          last(rest('30:00')),
        ],
        // Журнал обрывается за час до расчёта
        DriverStatus.unknown => [
          rest('11:00'),
          last(drive('1:00')),
          rest('1:00'),
        ],
      };
      final periods = logUntil(now, segs);
      return status == DriverStatus.unknown
          ? periods.sublist(0, periods.length - 1)
          : periods;
    }

    /// Ожидание по docs/background.md, «Правила переключения».
    AutoSwitch expected(
      DriverStatus status,
      MotionEventType event, {
      required bool team,
      required bool startFromRest,
      required bool onFerry,
      required DateTime at,
    }) {
      if (event == MotionEventType.stopped) {
        return status == DriverStatus.driving
            ? AutoSwitch(
                AutoSwitchKind.apply,
                mode: DriverMode.otherWork,
                at: at,
              )
            : AutoSwitch.none;
      }
      if (status == DriverStatus.driving || onFerry) return AutoSwitch.none;
      if (team) {
        return AutoSwitch(
          AutoSwitchKind.suggest,
          mode: DriverMode.driving,
          at: at,
          reason: AutoSwitchReason.team,
        );
      }
      const offDuty = {
        DriverStatus.notStarted,
        DriverStatus.dailyRest,
        DriverStatus.weeklyRest,
      };
      if (offDuty.contains(status) && !startFromRest) {
        return AutoSwitch(
          AutoSwitchKind.suggest,
          mode: DriverMode.driving,
          at: at,
          reason: AutoSwitchReason.offDuty,
        );
      }
      return AutoSwitch(AutoSwitchKind.apply, mode: DriverMode.driving, at: at);
    }

    for (final status in DriverStatus.values) {
      for (final ferry in [false, true]) {
        final periods = journalFor(status, ferry: ferry);
        final state = calc(periods, now);

        test('${status.name}${ferry ? ', паром' : ''}: журнал даёт этот '
            'статус', () {
          expect(state.status, status);
        });

        for (final event in MotionEventType.values) {
          for (final team in [false, true]) {
            for (final startFromRest in [false, true]) {
              final name = [
                status.name,
                if (ferry) 'паром',
                event.name,
                if (team) 'экипаж',
                if (startFromRest) 'сразу с отдыха',
              ].join(', ');
              test(name, () {
                // Отметка «паром» действует только на идущую запись
                final onFerry = ferry && status != DriverStatus.unknown;
                final modeStart = state.currentModeStart;
                final at = modeStart != null && modeStart.isAfter(eventAt)
                    ? modeStart
                    : eventAt;
                expect(
                  decideAutoSwitch(
                    event: MotionEvent(event, eventAt),
                    state: state,
                    crew: team ? CrewMode.team : CrewMode.solo,
                    settings: AutoSwitchSettings(startFromRest: startFromRest),
                  ),
                  expected(
                    status,
                    event,
                    team: team,
                    startFromRest: startFromRest,
                    onFerry: onFerry,
                    at: at,
                  ),
                );
              });
            }
          }
        }
      }
    }
  });
}

Duration sec(int n) => Duration(seconds: n);
