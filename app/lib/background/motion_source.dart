import 'dart:io' show Platform;

import 'package:geolocator/geolocator.dart';
import 'package:tacho_engine/tacho_engine.dart';

/// Отметки GPS для автоопределения вождения.
///
/// [fast] — машина едет или только что тронулась: отметки каждые 5 с.
/// Иначе — только после смещения на 50 м: на стоянке GPS почти не будит
/// телефон, а первая отметка в пути уже переключает на частые.
///
/// Поток geolocator открывается не сразу, а после паузы. Пока на прежний
/// поток кто-то подписан, geolocator отдаёт его же — с прежними
/// настройками. `AutoTracker` меняет частоту прямо в обработчике отметки, а
/// отписка во время рассылки откладывается до её конца: без паузы трекер
/// остался бы на редких отметках с фильтром 50 м, и на стоянке их нет
/// совсем — остановка не определилась бы никогда (INT-03).
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
  Position? previous;
  return Stream<void>.fromFuture(Future<void>.delayed(Duration.zero))
      .asyncExpand(
        (_) => Geolocator.getPositionStream(locationSettings: settings),
      )
      .map((p) {
        final sample = sampleOf(p, previous: previous);
        previous = p;
        return sample;
      });
}

/// Скорость по смещению — только между близкими по времени отметками:
/// за долгий перерыв машина могла и ехать, и стоять.
const _maxEstimateGap = Duration(minutes: 2);

/// Скорость в м/с → км/ч. Скорость неизвестна (−1), если система её не
/// сообщила: тогда плагин подставляет 0, и отметка без скорости выглядела
/// бы стоянкой — через 3 мин вождение сменилось бы другой работой.
///
/// На Android флаги `hasSpeed` и `hasAccuracy` всегда false:
/// `AndroidPosition.fromMap` (geolocator_android 5.0.3) не переносит их
/// из отметки платформы — так INT-03 на эмуляторе не видел ни одной
/// скорости. Поэтому значение считается сообщённым и по нему самому: без
/// скорости плагин подставляет 0 и в скорость, и в её точность, а без
/// точности — 0 в точность.
///
/// Скорость не сообщена, но есть [previous] — отметка незадолго до этой:
/// скорость считается по смещению между ними. На стоянке часть приёмников
/// GPS (и эмулятор) скорость 0 не сообщает, и стоянка иначе не
/// определилась бы никогда (INT-03). Смещение в пределах точности — шум,
/// скорость 0.
MotionSample sampleOf(Position p, {Position? previous}) {
  final hasSpeed = p.hasSpeed || p.speed > 0 || p.speedAccuracy > 0;
  final hasAccuracy = p.hasAccuracy || p.accuracy > 0;
  final accuracy = hasAccuracy ? p.accuracy : null;
  var speedKmh = !hasSpeed || p.speed < 0 ? -1.0 : p.speed * 3.6;
  if (speedKmh < 0 && previous != null && accuracy != null) {
    speedKmh = _speedBetween(previous, p) ?? -1;
  }
  return MotionSample(
    time: p.timestamp.toUtc(),
    speedKmh: speedKmh,
    accuracyMeters: accuracy,
  );
}

/// Средняя скорость между отметками, км/ч; null — отметки слишком далеко по
/// времени или не по порядку.
double? _speedBetween(Position from, Position to) {
  final gap = to.timestamp.difference(from.timestamp);
  if (gap < const Duration(seconds: 1) || gap > _maxEstimateGap) return null;
  final meters = Geolocator.distanceBetween(
    from.latitude,
    from.longitude,
    to.latitude,
    to.longitude,
  );
  final noise = from.accuracy > to.accuracy ? from.accuracy : to.accuracy;
  if (meters <= noise) return 0;
  return meters / gap.inMilliseconds * 1000 * 3.6;
}
