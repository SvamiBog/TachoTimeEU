import 'dart:io' show Platform;

import 'package:geolocator/geolocator.dart';
import 'package:tacho_engine/tacho_engine.dart';

/// Отметки GPS для автоопределения вождения.
///
/// [fast] — машина едет или только что тронулась: отметки каждые 5 с.
/// Иначе — только после смещения на 50 м: на стоянке GPS почти не будит
/// телефон, а первая отметка в пути уже переключает на частые.
Stream<MotionSample> gpsSamples({required bool fast}) {
  final distanceFilter = fast ? 0 : 50;
  // iOS не приостанавливает обновления на стоянке (по умолчанию в
  // geolocator): иначе приложение не проснётся, когда машина поедет.
  final settings = Platform.isAndroid
      ? AndroidSettings(
          distanceFilter: distanceFilter,
          intervalDuration: fast
              ? const Duration(seconds: 5)
              : const Duration(seconds: 30),
        )
      : AppleSettings(
          accuracy: LocationAccuracy.bestForNavigation,
          activityType: ActivityType.automotiveNavigation,
          distanceFilter: distanceFilter,
          showBackgroundLocationIndicator: true,
        );
  return Geolocator.getPositionStream(locationSettings: settings).map(sampleOf);
}

/// Скорость в м/с → км/ч; отрицательная — неизвестна.
MotionSample sampleOf(Position p) => MotionSample(
  time: p.timestamp.toUtc(),
  speedKmh: p.speed < 0 ? -1 : p.speed * 3.6,
  accuracyMeters: p.accuracy,
);
