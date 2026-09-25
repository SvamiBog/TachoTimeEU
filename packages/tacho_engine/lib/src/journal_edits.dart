import 'package:tacho_engine/src/activity_period.dart';
import 'package:tacho_engine/src/driver_mode.dart';
import 'package:tacho_engine/src/time.dart';
import 'package:tacho_engine/src/timeline.dart';

// Операции над журналом. Все функции чистые: принимают записи и возвращают
// новый список. Новые записи создаются с id == null, удалённые просто
// пропадают из списка — хранилище сохраняет разницу.
//
// Правки задним числом берут время у соседней записи, поэтому записи не
// накладываются, не появляются дыры и общее время журнала сохраняется.

/// Переключает режим в момент [now]: открытая запись закрывается, начинается
/// новая. Переходы между любыми режимами разрешены, как на тахографе.
///
/// Нажатие на уже активный режим ничего не меняет (возвращается тот же
/// список): иначе текущий отдых дробился бы на части и перерыв не
/// засчитывался. Исключение — «Завершить день» ([dayEnd]) во время
/// перерыва: текущий отдых становится концом рабочего дня.
List<ActivityPeriod> changeMode(
  List<ActivityPeriod> periods,
  DriverMode mode,
  DateTime now, {
  bool ferry = false,
  bool dayEnd = false,
}) {
  final open = periods.where((p) => p.isOpen).lastOrNull;
  if (open != null && open.mode == mode) {
    if (dayEnd && !open.dayEnd) {
      return [
        for (final p in periods)
          if (identical(p, open)) p.withDayEnd(dayEnd: true) else p,
      ];
    }
    return periods;
  }

  return [
    for (final p in periods)
      if (p.isOpen) p.close(later(p.start, now)) else p,
    ActivityPeriod(mode: mode, start: now, ferry: ferry, dayEnd: dayEnd),
  ];
}

/// «Завершить день»: отдых, который считается концом смены, даже пока он
/// короче 9 ч.
List<ActivityPeriod> endDay(List<ActivityPeriod> periods, DateTime now) =>
    changeMode(periods, DriverMode.rest, now, dayEnd: true);

/// Переносит начало записи [target]. Если начало сдвигается раньше,
/// предыдущие записи укорачиваются или удаляются; если позже — предыдущая
/// стыкующаяся запись продлевается до нового начала.
List<ActivityPeriod> moveStart(
  List<ActivityPeriod> periods,
  ActivityPeriod target,
  DateTime newStart,
  DateTime now,
) {
  final sorted = sortedByStart(periods);
  final idx = sorted.indexOf(target);
  if (idx < 0) return periods;
  final entry = sorted[idx];
  final start = earlier(newStart, entry.end ?? now);
  final removed = <int>{};

  if (start.isBefore(entry.start)) {
    for (var j = idx - 1; j >= 0; j--) {
      final prev = sorted[j];
      if (!prev.start.isBefore(start)) {
        removed.add(j);
        continue;
      }
      if ((prev.end ?? now).isAfter(start)) sorted[j] = prev.withEnd(start);
      break;
    }
  } else if (start.isAfter(entry.start) && idx > 0) {
    final prev = sorted[idx - 1];
    if (prev.end == entry.start) sorted[idx - 1] = prev.withEnd(start);
  }
  sorted[idx] = entry.withStart(start);
  return [
    for (final (i, p) in sorted.indexed)
      if (!removed.contains(i)) p,
  ];
}

/// Переносит конец закрытой записи [target]. Следующие записи укорачиваются
/// или удаляются; текущую (открытую) запись удалить нельзя — конец
/// упирается в неё.
List<ActivityPeriod> moveEnd(
  List<ActivityPeriod> periods,
  ActivityPeriod target,
  DateTime newEnd,
  DateTime now,
) {
  final sorted = sortedByStart(periods);
  final idx = sorted.indexOf(target);
  if (idx < 0) return periods;
  final entry = sorted[idx];
  final oldEnd = entry.end;
  if (oldEnd == null) return periods;
  var end = later(newEnd, entry.start);
  final removed = <int>{};

  if (end.isAfter(oldEnd)) {
    for (var j = idx + 1; j < sorted.length; j++) {
      final next = sorted[j];
      final nextEnd = next.end;
      if (nextEnd == null) {
        end = earlier(end, now);
        sorted[j] = next.withStart(later(next.start, end));
        break;
      }
      if (!nextEnd.isAfter(end)) {
        removed.add(j);
        continue;
      }
      if (next.start.isBefore(end)) sorted[j] = next.withStart(end);
      break;
    }
  } else if (end.isBefore(oldEnd) && idx + 1 < sorted.length) {
    final next = sorted[idx + 1];
    if (next.start == oldEnd) sorted[idx + 1] = next.withStart(end);
  }
  sorted[idx] = entry.withEnd(end);
  return [
    for (final (i, p) in sorted.indexed)
      if (!removed.contains(i) && !_isEmptyClosed(p)) p,
  ];
}

/// Ручная корректировка суточного вождения на [delta]: двигаем начало
/// последнего отрезка вождения смены за счёт соседнего предыдущего отрезка
/// («режим переключили не вовремя»). Возвращает фактически применённую
/// поправку — она может быть меньше запрошенной.
({List<ActivityPeriod> periods, Duration applied}) adjustDriving(
  List<ActivityPeriod> periods,
  DateTime shiftStart,
  Duration delta,
  DateTime now,
) {
  final sorted = sortedByStart(periods);
  final driveIdx = _lastDrivingIndex(sorted, shiftStart);
  if (driveIdx < 0 || delta == Duration.zero) {
    return (periods: periods, applied: Duration.zero);
  }
  final drive = sorted[driveIdx];

  final DateTime newStart;
  if (delta > Duration.zero) {
    final wanted = drive.start.subtract(delta);
    newStart = driveIdx > 0
        ? later(sorted[driveIdx - 1].start, wanted)
        : wanted;
  } else {
    newStart = earlier(drive.end ?? now, drive.start.subtract(delta));
  }
  final applied = drive.start.difference(newStart);
  if (applied == Duration.zero) {
    return (periods: periods, applied: Duration.zero);
  }

  final updated = moveStart(periods, drive, newStart, now);
  // Закрытый отрезок, сжатый до нуля, убираем.
  return (
    periods: [
      for (final p in updated)
        if (!_isEmptyClosed(p)) p,
    ],
    applied: applied,
  );
}

/// Пределы корректировки вождения относительно расчёта, в целых минутах;
/// null — в смене нет вождения.
({Duration min, Duration max})? drivingAdjustmentBounds(
  List<ActivityPeriod> periods,
  DateTime shiftStart,
  DateTime now,
) {
  final sorted = sortedByStart(periods);
  final idx = _lastDrivingIndex(sorted, shiftStart);
  if (idx < 0) return null;
  final drive = sorted[idx];
  return (
    min: -floorToMinute(drive.durationAt(now)),
    max: idx > 0
        ? floorToMinute(drive.start.difference(sorted[idx - 1].start))
        : Duration.zero,
  );
}

/// Последний перерыв смены и пределы его длительности (за счёт соседнего
/// отрезка), в целых минутах; null — перерывов нет.
({Duration duration, Duration max, bool open})? lastBreakInfo(
  List<ActivityPeriod> periods,
  DateTime shiftStart,
  DateTime now,
) {
  final sorted = sortedByStart(periods);
  final idx = _lastRestIndex(sorted, shiftStart);
  if (idx < 0) return null;
  final rest = sorted[idx];
  final duration = floorToMinute(rest.durationAt(now));
  if (rest.isOpen) {
    final prev = idx > 0 ? sorted[idx - 1] : null;
    final room = prev != null && !prev.start.isBefore(shiftStart)
        ? floorToMinute(rest.start.difference(prev.start))
        : Duration.zero;
    return (duration: duration, max: duration + room, open: true);
  }
  final next = idx + 1 < sorted.length ? sorted[idx + 1] : null;
  final room = next != null
      ? floorToMinute(next.durationAt(now))
      : Duration.zero;
  return (duration: duration, max: duration + room, open: false);
}

/// Задаёт длительность последнего перерыва смены: текущего (сдвигаем его
/// начало) или последнего завершённого (сдвигаем конец).
List<ActivityPeriod> setLastBreakDuration(
  List<ActivityPeriod> periods,
  DateTime shiftStart,
  Duration duration,
  DateTime now,
) {
  final sorted = sortedByStart(periods);
  final idx = _lastRestIndex(sorted, shiftStart);
  if (idx < 0) return periods;
  final rest = sorted[idx];
  return rest.isOpen
      ? moveStart(periods, rest, now.subtract(duration), now)
      : moveEnd(periods, rest, rest.start.add(duration), now);
}

/// Завершает смену в момент [at]: всё после [at] удаляется, с [at]
/// начинается отдых — конец дня.
List<ActivityPeriod> endShiftAt(
  List<ActivityPeriod> periods,
  DateTime at,
  DateTime now,
) {
  final kept = sortedByStart(periods)
      .where((p) => p.start.isBefore(at))
      .toList();
  final last = kept.isEmpty ? null : kept.last;
  if (last != null && last.mode.isRest && !(last.end ?? now).isBefore(at)) {
    // Смену завершили во время перерыва — перерыв и становится суточным
    // отдыхом.
    kept.last = last.withEnd(null).withDayEnd(dayEnd: true);
    return kept;
  }
  if (last != null && (last.end == null || last.end!.isAfter(at))) {
    kept.last = last.withEnd(at);
  }
  return [
    ...kept,
    ActivityPeriod(mode: DriverMode.rest, start: at, dayEnd: true),
  ];
}

/// Отменяет завершение смены: отдых с [restStart] удаляется, последняя
/// запись снова идёт.
List<ActivityPeriod> resumeShift(
  List<ActivityPeriod> periods,
  DateTime restStart,
) {
  final kept = sortedByStart(periods)
      .where((p) => p.start.isBefore(restStart))
      .toList();
  if (kept.isNotEmpty) kept.last = kept.last.withEnd(null);
  return kept;
}

/// Смена, добавленная из журнала как идущая («отдых не начат»), становится
/// текущей: с её начала идут записи режимов — работа, а последние
/// [driving] — вождение. Всё, что было записано после начала, заменяется.
List<ActivityPeriod> startShiftAt(
  List<ActivityPeriod> periods,
  DateTime start,
  Duration driving,
  DateTime now,
) {
  final kept = [
    for (final p in sortedByStart(periods))
      if (p.start.isBefore(start))
        if (p.end == null || p.end!.isAfter(start)) p.withEnd(start) else p,
  ];
  final span = floorToMinute(durationBetween(start, now));
  final drive = shorter(floorToMinute(clampToZero(driving)), span);
  if (drive == Duration.zero || drive == span) {
    return [
      ...kept,
      ActivityPeriod(
        mode: drive == Duration.zero
            ? DriverMode.otherWork
            : DriverMode.driving,
        start: start,
      ),
    ];
  }
  // По целым минутам, чтобы сразу после сохранения не показывалось «1:59»
  // вместо «2:00».
  final driveFrom = floorTimeToMinute(now.subtract(drive));
  return [
    ...kept,
    ActivityPeriod(mode: DriverMode.otherWork, start: start, end: driveFrom),
    ActivityPeriod(mode: DriverMode.driving, start: driveFrom),
  ];
}

bool _isEmptyClosed(ActivityPeriod p) {
  final end = p.end;
  return end != null && !end.isAfter(p.start);
}

int _lastDrivingIndex(List<ActivityPeriod> sorted, DateTime shiftStart) =>
    sorted.lastIndexWhere(
      (p) => p.mode == DriverMode.driving && !p.start.isBefore(shiftStart),
    );

int _lastRestIndex(List<ActivityPeriod> sorted, DateTime shiftStart) => sorted
    .lastIndexWhere((p) => p.mode.isRest && !p.start.isBefore(shiftStart));
