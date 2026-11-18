import 'dart:async';

import 'package:drift/native.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/background/auto_tracker.dart';
import 'package:tachogo/data/db/app_database.dart';
import 'package:tachogo/data/journal/activity_repository.dart';
import 'package:tachogo/data/settings/settings_repository.dart';

void main() {
  late AppDatabase db;
  late ActivityRepository journal;
  late SettingsRepository settings;
  late DateTime now;
  late List<bool> rateRequests;
  late StreamController<MotionSample> gps;
  late AutoTracker tracker;

  final t0 = DateTime.utc(2026, 9, 23, 6);

  Stream<MotionSample> source({required bool fast}) {
    rateRequests.add(fast);
    gps = StreamController<MotionSample>();
    return gps.stream;
  }

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    now = t0.subtract(const Duration(hours: 12));
    journal = ActivityRepository(db, clock: () => now);
    settings = SettingsRepository(db);
    rateRequests = [];
    tracker = AutoTracker(
      journal: journal,
      settings: settings,
      source: source,
      clock: () => now,
    );
    await settings.setAutoDetect(const AutoDetectSettings(enabled: true));
  });
  tearDown(() async {
    await tracker.stop();
    await db.close();
  });

  /// Журнал: отдых с [t0] − 12 ч, затем [modes] по часу, последний идёт.
  Future<void> journalWith(List<DriverMode> modes) async {
    await journal.switchMode(DriverMode.rest);
    now = t0.subtract(Duration(hours: modes.length));
    for (final mode in modes) {
      await journal.switchMode(mode);
      now = now.add(const Duration(hours: 1));
    }
    now = t0;
  }

  /// Отметки GPS каждые 10 с начиная с [from].
  Future<void> drive(List<double> speeds, {DateTime? from}) async {
    var t = from ?? now;
    for (final v in speeds) {
      now = t;
      gps.add(MotionSample(time: t, speedKmh: v));
      await pumpEventQueue();
      await tracker.idle;
      t = t.add(const Duration(seconds: 10));
    }
    await pumpEventQueue();
  }

  List<double> repeat(int n, double v) => List.filled(n, v);

  test('поехали во время работы — вождение с начала движения', () async {
    await journalWith([DriverMode.otherWork]);
    await tracker.start();
    await drive([0, 30, 40, 50, 60]);

    final periods = await journal.periods();
    expect(periods.last.mode, DriverMode.driving);
    expect(periods.last.start, t0.add(const Duration(seconds: 10)));
    expect(periods[periods.length - 2].end, periods.last.start);
  });

  test('остановились — другая работа с начала стоянки', () async {
    await journalWith([DriverMode.otherWork]);
    await tracker.start();
    await drive([...repeat(5, 50), ...repeat(20, 0)]);

    final periods = await journal.periods();
    expect(periods.map((p) => p.mode).skip(1), [
      DriverMode.otherWork,
      DriverMode.driving,
      DriverMode.otherWork,
    ]);
    expect(periods.last.start, t0.add(const Duration(seconds: 50)));
  });

  test('на суточном отдыхе — только предложение; согласие пишет вождение '
      'с начала движения', () async {
    await journal.switchMode(DriverMode.rest);
    now = t0;
    await tracker.start();
    await drive(repeat(5, 50));

    expect((await journal.periods()).single.mode, DriverMode.rest);
    expect(tracker.suggestion?.kind, AutoSwitchKind.suggest);
    expect(tracker.suggestion?.at, t0);

    await tracker.acceptSuggestion();
    final periods = await journal.periods();
    expect(periods.last.mode, DriverMode.driving);
    expect(periods.last.start, t0);
    expect(tracker.suggestion, isNull);
  });

  test('отказ от предложения ничего не пишет', () async {
    await journal.switchMode(DriverMode.rest);
    now = t0;
    await tracker.start();
    await drive(repeat(5, 50));
    tracker.dismissSuggestion();

    expect(tracker.suggestion, isNull);
    expect(await journal.periods(), hasLength(1));
  });

  test('машина остановилась — предложение снимается', () async {
    await journal.switchMode(DriverMode.rest);
    now = t0;
    await tracker.start();
    await drive([...repeat(5, 50), ...repeat(20, 0)]);

    expect(tracker.suggestion, isNull);
    expect(await journal.periods(), hasLength(1));
  });

  test('выключенное автоопределение журнал не трогает', () async {
    await settings.setAutoDetect(const AutoDetectSettings());
    await journalWith([DriverMode.otherWork]);
    await tracker.start();
    await drive(repeat(10, 50));

    expect((await journal.periods()).last.mode, DriverMode.otherWork);
  });

  test('ручное переключение: детектор начинает с режима журнала', () async {
    await journalWith([DriverMode.otherWork]);
    await tracker.start();
    // Водитель сам включил вождение, а машина стоит
    await journal.switchMode(DriverMode.driving);
    await pumpEventQueue();
    await drive(repeat(20, 0));

    final periods = await journal.periods();
    expect(periods.last.mode, DriverMode.otherWork);
  });

  test('на стоянке редкие отметки, при движении — частые', () async {
    await journalWith([DriverMode.otherWork]);
    await tracker.start();
    expect(rateRequests, [false]);

    await drive([30]);
    expect(rateRequests, [false, true]);

    await drive([...repeat(5, 40), ...repeat(20, 0)]);
    expect(rateRequests.last, isFalse);
  });

  group('BG-03: ошибки, остановка, экипаж, паром', () {
    test(
      'ошибка GPS уходит в onError, поток бросаем (дальше — BG-11)',
      () async {
        final errors = <Object>[];
        await tracker.stop();
        tracker = AutoTracker(
          journal: journal,
          settings: settings,
          source: source,
          clock: () => now,
          onError: (e, _) => errors.add(e),
        );
        await journalWith([DriverMode.otherWork]);
        await tracker.start();

        final dead = gps..addError(StateError('GPS'));
        await pumpEventQueue();
        expect(errors, [isA<StateError>()]);
        expect(dead.hasListener, isFalse);
      },
    );

    test('stop() дожидается событий и закрывает поток предложений', () async {
      await journal.switchMode(DriverMode.rest);
      now = t0;
      await tracker.start();
      var closed = false;
      tracker.suggestions.listen((_) {}, onDone: () => closed = true);

      await drive(repeat(5, 50));
      await tracker.stop();
      await pumpEventQueue();
      expect(closed, isTrue);
      expect(tracker.suggestion?.reason, AutoSwitchReason.offDuty);
    });

    test('согласие без предложения ничего не пишет', () async {
      await journalWith([DriverMode.otherWork]);
      await tracker.start();
      final before = await journal.periods();
      await tracker.acceptSuggestion();
      expect(await journal.periods(), before);
    });

    test('экипаж — предложение с причиной «экипаж»', () async {
      await settings.setComplianceSettings(
        const ComplianceSettings(crew: CrewMode.team),
      );
      await journalWith([DriverMode.otherWork]);
      await tracker.start();
      await drive(repeat(5, 50));

      expect(tracker.suggestion?.reason, AutoSwitchReason.team);
      expect((await journal.periods()).last.mode, DriverMode.otherWork);
    });

    test('на пароме — ничего', () async {
      await journal.switchMode(DriverMode.rest);
      now = t0.subtract(const Duration(minutes: 30));
      await journal.switchMode(DriverMode.otherWork, ferry: true);
      now = t0;
      await tracker.start();
      await drive(repeat(10, 50));

      expect(tracker.suggestion, isNull);
      final last = (await journal.periods()).last;
      expect(last.mode, DriverMode.otherWork);
      expect(last.ferry, isTrue);
    });

    test('заехал на паром и встал — стоянка тоже на пароме, паром плывёт — '
        'вождение не включается', () async {
      await journalWith([DriverMode.otherWork]);
      await tracker.start();
      await drive(repeat(5, 50));
      // Водитель включил «паром / поезд» за рулём, на палубе остановился
      await journal.setFerryMode(on: true);
      await drive(repeat(20, 0));
      await drive(repeat(30, 20));

      final periods = await journal.periods();
      expect(periods.map((p) => (p.mode, p.ferry)).skip(1), [
        (DriverMode.otherWork, false),
        (DriverMode.driving, true),
        (DriverMode.otherWork, true),
      ]);
      expect(tracker.suggestion, isNull);
    });
  });

  group('BG-04: новые правила — со следующего события, без перезапуска', () {
    test('режим после остановки', () async {
      await journalWith([DriverMode.otherWork]);
      await tracker.start();
      await drive(repeat(5, 50));
      await settings.setAutoDetect(
        const AutoDetectSettings(
          enabled: true,
          rules: AutoSwitchSettings(afterStop: DriverMode.availability),
        ),
      );
      await drive(repeat(20, 0));

      expect((await journal.periods()).last.mode, DriverMode.availability);
    });

    test('вождение сразу и с отдыха', () async {
      await journal.switchMode(DriverMode.rest);
      now = t0;
      await tracker.start();
      await settings.setAutoDetect(
        const AutoDetectSettings(
          enabled: true,
          rules: AutoSwitchSettings(startFromRest: true),
        ),
      );
      await drive(repeat(5, 50));

      expect(tracker.suggestion, isNull);
      expect((await journal.periods()).last.mode, DriverMode.driving);
    });

    test('выключение действует сразу', () async {
      await journalWith([DriverMode.otherWork]);
      await tracker.start();
      await settings.setAutoDetect(const AutoDetectSettings());
      await drive(repeat(5, 50));

      expect((await journal.periods()).last.mode, DriverMode.otherWork);
    });
  });

  group('BG-11: поток GPS восстанавливается сам', () {
    /// Трекер в поддельном времени: пауза перед новой подпиской и сторож
    /// тишины идут по `async.elapse`. Поток — как у geolocator_android:
    /// после ошибки он открыт, но отметок больше не даёт.
    void fake(
      void Function(
        FakeAsync async,
        _Gps gps,
        ActivityRepository journal,
        List<Object> errors,
        void Function(List<double> speeds) feed,
      )
      body,
    ) {
      fakeAsync((async) {
        final db = AppDatabase(NativeDatabase.memory());
        final journal = ActivityRepository(
          db,
          clock: () => t0.add(async.elapsed),
        );
        final settings = SettingsRepository(db);
        final gps = _Gps();
        final errors = <Object>[];
        final tracker = AutoTracker(
          journal: journal,
          settings: settings,
          source: gps.call,
          clock: () => t0.add(async.elapsed),
          onError: (e, _) => errors.add(e),
        );
        unawaited(
          settings.setAutoDetect(const AutoDetectSettings(enabled: true)),
        );
        unawaited(journal.switchMode(DriverMode.otherWork));
        async.flushMicrotasks();
        unawaited(tracker.start());
        async.flushMicrotasks();

        /// Отметки каждые 10 с в текущий поток.
        void feed(List<double> speeds) {
          for (final v in speeds) {
            gps.current.add(
              MotionSample(time: t0.add(async.elapsed), speedKmh: v),
            );
            async
              ..flushMicrotasks()
              ..elapse(const Duration(seconds: 10));
          }
        }

        body(async, gps, journal, errors, feed);

        unawaited(tracker.stop());
        // Нулевой таймер — Drift при отписке от журнала
        async
          ..flushMicrotasks()
          ..elapse(Duration.zero);
        expect(async.pendingTimers, isEmpty, reason: 'stop() снял таймеры');
        unawaited(db.close());
        async.flushMicrotasks();
      }, initialTime: t0);
    }

    DriverMode? lastMode(FakeAsync async, ActivityRepository journal) {
      DriverMode? mode;
      unawaited(journal.periods().then((p) => mode = p.last.mode));
      async.flushMicrotasks();
      return mode;
    }

    test('ошибка — в отчёт, поток бросаем, через паузу подписка заново; '
        'поездка на новом потоке — вождение', () {
      fake((async, gps, journal, errors, feed) {
        gps.current.addError(StateError('GPS'));
        async.flushMicrotasks();
        expect(errors, [isA<StateError>()]);
        expect(gps.listening, 0, reason: 'мёртвый поток отпущен');

        async.elapse(AutoTracker.gpsRetry - const Duration(seconds: 1));
        expect(gps.requests, [false]);
        async.elapse(const Duration(seconds: 1));
        expect(gps.requests, [false, false]);
        expect(gps.listening, 1);

        feed(repeat(5, 50));
        expect(lastMode(async, journal), DriverMode.driving);
      });
    });

    test('поток закрылся — через паузу подписка заново', () {
      fake((async, gps, journal, errors, feed) {
        unawaited(gps.current.close());
        async
          ..flushMicrotasks()
          ..elapse(AutoTracker.gpsRetry);
        expect(gps.requests, [false, false]);
        expect(errors, isEmpty);
      });
    });

    test('ошибки подряд — в отчёте одна, пока не придёт отметка', () {
      fake((async, gps, journal, errors, feed) {
        for (var i = 0; i < 3; i++) {
          gps.current.addError(StateError('GPS $i'));
          async
            ..flushMicrotasks()
            ..elapse(AutoTracker.gpsRetry);
        }
        expect(gps.requests, hasLength(4));
        expect(errors, hasLength(1));

        feed([0]);
        gps.current.addError(StateError('снова'));
        async.flushMicrotasks();
        expect(errors, hasLength(2));
      });
    });

    test('после подписки ни одной отметки — подписка заново', () {
      fake((async, gps, journal, errors, feed) {
        async.elapse(AutoTracker.gpsSilence - const Duration(seconds: 1));
        expect(gps.requests, [false]);
        async.elapse(const Duration(seconds: 1));
        expect(gps.requests, [false, false]);
        expect(gps.listening, 1, reason: 'молчащий поток отпущен');

        feed(repeat(5, 50));
        expect(lastMode(async, journal), DriverMode.driving);
      });
    });

    test('в пути отметки пропали — подписка заново на частые', () {
      fake((async, gps, journal, errors, feed) {
        feed(repeat(5, 50));
        final before = gps.requests.length;
        async.elapse(AutoTracker.gpsSilence);
        expect(gps.requests.skip(before), [true]);

        // Остановка ловится и на новом потоке
        feed(repeat(20, 0));
        expect(lastMode(async, journal), DriverMode.otherWork);
      });
    });

    test('на стоянке после первой отметки тишина — норма, поток тот же', () {
      fake((async, gps, journal, errors, feed) {
        feed([0]);
        async.elapse(AutoTracker.gpsSilence * 5);
        expect(gps.requests, [false]);
      });
    });

    test('водитель сам включил вождение во время паузы — подписка сразу, '
        'без второй после паузы; остановка — другая работа', () {
      fake((async, gps, journal, errors, feed) {
        gps.current.addError(StateError('GPS'));
        async.flushMicrotasks();
        unawaited(journal.switchMode(DriverMode.driving));
        async.flushMicrotasks();
        expect(gps.requests, [false, true]);

        async.elapse(AutoTracker.gpsRetry);
        expect(gps.requests, [false, true]);

        feed(repeat(20, 0));
        expect(lastMode(async, journal), DriverMode.otherWork);
      });
    });
  });
}

/// Отметки GPS, как их отдаёт geolocator_android: каждая подписка — новый
/// поток, после ошибки он открыт, но молчит.
class _Gps {
  final requests = <bool>[];
  final _streams = <StreamController<MotionSample>>[];

  StreamController<MotionSample> get current => _streams.last;

  /// Сколько потоков сейчас слушает трекер.
  int get listening => _streams.where((s) => s.hasListener).length;

  Stream<MotionSample> call({required bool fast}) {
    requests.add(fast);
    final stream = StreamController<MotionSample>();
    _streams.add(stream);
    return stream.stream;
  }
}
