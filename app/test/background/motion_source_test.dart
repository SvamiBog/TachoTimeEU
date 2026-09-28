// Отметка GPS → отметка детектора. План тестов: BG-01 в docs/testing.md.
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tachogo/background/motion_source.dart';

Position position({
  required double speed,
  DateTime? timestamp,
  double accuracy = 8,
  double speedAccuracy = 0,
  bool hasSpeed = true,
  bool hasAccuracy = true,
}) => Position(
  latitude: 52.23,
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

void main() {
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
}
