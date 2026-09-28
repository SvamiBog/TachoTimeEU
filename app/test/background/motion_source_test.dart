// Отметка GPS → отметка детектора. План тестов: BG-01 в docs/testing.md.
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/background/motion_source.dart';

Position position({
  required double speed,
  DateTime? timestamp,
  double accuracy = 8,
  double speedAccuracy = 0,
  bool hasSpeed = true,
  bool hasAccuracy = true,
  double latitude = 52.23,
}) => Position(
  latitude: latitude,
  longitude: 21.01,
  timestamp: timestamp ?? DateTime.utc(2026, 9, 23, 6),
  accuracy: accuracy,
  altitude: 0,
  altitudeAccuracy: 0,
  heading: 0,
  headingAccuracy: 0,
  speed: speed,
  speedAccuracy: speedAccuracy,
  hasSpeed: hasSpeed,
  hasAccuracy: hasAccuracy,
);

/// Геолокация как geolocator_android: пока на поток подписан хоть кто-то,
/// новый запрос получает его же, с прежними настройками.
class _CachingGeolocator extends GeolocatorPlatform {
  final requested = <LocationSettings?>[];
  final sources = <StreamController<Position>>[];
  Stream<Position>? _open;

  @override
  Stream<Position> getPositionStream({LocationSettings? locationSettings}) {
    if (_open case final open?) return open;
    requested.add(locationSettings);
    final source = StreamController<Position>();
    sources.add(source);
    return _open = source.stream.asBroadcastStream(
      onCancel: (s) {
        unawaited(s.cancel());
        _open = null;
      },
    );
  }
}

void main() {
  test('частота меняется и из обработчика отметки: у geolocator — новый '
      'поток, а не прежний (INT-03)', () async {
    final original = GeolocatorPlatform.instance;
    addTearDown(() => GeolocatorPlatform.instance = original);
    final platform = _CachingGeolocator();
    GeolocatorPlatform.instance = platform;

    final seen = <bool>[];
    late StreamSubscription<MotionSample> samples;
    samples = gpsSamples(fast: false).listen((_) {
      // Как AutoTracker: машина тронулась — частые отметки
      seen.add(false);
      unawaited(samples.cancel());
      samples = gpsSamples(fast: true).listen((_) => seen.add(true));
    });
    addTearDown(() => samples.cancel());
    await pumpEventQueue();
    platform.sources.last.add(position(speed: 10));
    await pumpEventQueue();

    expect(platform.requested.map((s) => s?.distanceFilter), [
      50,
      0,
    ], reason: 'частые отметки — без фильтра по смещению');
    platform.sources.last.add(position(speed: 0));
    await pumpEventQueue();
    expect(seen, [false, true]);
  });

  test('скорость в м/с переводится в км/ч', () {
    expect(sampleOf(position(speed: 10)).speedKmh, closeTo(36, 1e-9));
    expect(sampleOf(position(speed: 0)).speedKmh, 0);
  });

  test('отрицательная скорость — неизвестна', () {
    expect(sampleOf(position(speed: -1)).speedKmh, isNegative);
  });

  test('скорость не сообщена — неизвестна, а не стоянка', () {
    // Плагин подставляет 0, если у отметки нет скорости
    expect(sampleOf(position(speed: 0, hasSpeed: false)).speedKmh, isNegative);
  });

  test('время — в UTC', () {
    final local = DateTime.utc(2026, 9, 23, 6).toLocal();
    final sample = sampleOf(position(speed: 5, timestamp: local));
    expect(sample.time, DateTime.utc(2026, 9, 23, 6));
    expect(sample.time.isUtc, isTrue);
  });

  test('точность передаётся детектору', () {
    expect(sampleOf(position(speed: 5, accuracy: 65)).accuracyMeters, 65);
  });

  test('точность не сообщена — неизвестна', () {
    // Без точности плагин подставляет 0
    expect(
      sampleOf(position(speed: 5, accuracy: 0, hasAccuracy: false))
          .accuracyMeters,
      isNull,
    );
  });

  test('Android: флаги не переданы, но скорость и точность есть '
      '(INT-03)', () {
    // AndroidPosition.fromMap теряет hasSpeed и hasAccuracy
    final sample = sampleOf(
      position(
        speed: 16.667,
        accuracy: 5,
        speedAccuracy: 0.5,
        hasSpeed: false,
        hasAccuracy: false,
      ),
    );
    expect(sample.speedKmh, closeTo(60, 0.01));
    expect(sample.accuracyMeters, 5);
    final stopped = sampleOf(
      position(speed: 0, speedAccuracy: 0.5, hasSpeed: false),
    );
    expect(stopped.speedKmh, 0, reason: 'стоянка с оценкой точности');
  });

  group(
    'скорость не сообщена — по смещению от предыдущей отметки (INT-03)',
    () {
      final t = DateTime.utc(2026, 9, 23, 6);
      Position at(Duration after, {double latitude = 52.23}) => position(
        speed: 0,
        hasSpeed: false,
        timestamp: t.add(after),
        latitude: latitude,
      );

      test('на месте — 0 км/ч: смещение в пределах точности', () {
        final sample = sampleOf(
          at(const Duration(seconds: 5), latitude: 52.23003),
          previous: at(Duration.zero),
        );
        expect(sample.speedKmh, 0);
      });

      test('100 м за 5 с — около 72 км/ч', () {
        // 0,0009° широты ≈ 100 м
        final sample = sampleOf(
          at(const Duration(seconds: 5), latitude: 52.2309),
          previous: at(Duration.zero),
        );
        expect(sample.speedKmh, closeTo(72, 1));
      });

      test(
        'без предыдущей отметки или после долгого перерыва — неизвестна',
        () {
          expect(sampleOf(at(Duration.zero)).speedKmh, isNegative);
          expect(
            sampleOf(
              at(const Duration(minutes: 3)),
              previous: at(Duration.zero),
            ).speedKmh,
            isNegative,
          );
        },
      );
    },
  );
}
