/// The right to a reduced weekly rest (Art. 8(6) as amended by Regulation
/// 2020/1054): whether the next weekly rest may be reduced, and which reduced
/// weekly rests of the log were taken without that right.
library;

import 'package:tacho_engine/src/compliance.dart';
import 'package:tacho_engine/src/shift_route.dart';
import 'package:tacho_engine/src/shifts.dart';

/// Whether a weekly rest may be reduced, and if not, why.
enum ReducedWeeklyRestRight {
  /// Можно.
  allowed,

  /// Нельзя только из-за страны фирмы: это второй сокращённый подряд, а
  /// пакет мобильности позволяет его, только если оба отдыха — вне страны
  /// фирмы.
  atBase,

  /// Нельзя: прошлый недельный был сокращённым, а пакета мобильности нет,
  /// или из четырёх недельных отдыхов подряд полных было бы меньше двух — в
  /// том числе третий сокращённый подряд.
  denied,
}

/// Сколько недельных отдыхов подряд проверяет правило пакета мобильности:
/// из любых четырёх не меньше двух полных.
const _window = 4;
const _fullInWindow = 2;

/// Право на сокращённый недельный отдых, начатый в [restStart] (идущий или
/// будущий — сейчас), если перед ним — законченные недельные отдыхи
/// [before] по порядку, последний — предыдущий. [atBase] — в стране ли
/// фирмы водитель в момент.
///
/// Без пакета мобильности за две недели подряд нужен хотя бы один полный:
/// после сокращённого — только полный. С пакетом можно два сокращённых
/// подряд — оба вне страны фирмы, — если из любых четырёх недельных
/// отдыхов подряд не меньше двух полных (ст. 8(6)): после двух сокращённых —
/// два полных. Отдыхи до начала журнала считаем полными: о них нет данных.
ReducedWeeklyRestRight reducedWeeklyRestRight(
  List<WeeklyRest> before, {
  required DateTime restStart,
  required bool mobilityPackage,
  required bool Function(DateTime t) atBase,
}) {
  final previous = before.lastOrNull;
  if (previous == null) return ReducedWeeklyRestRight.allowed;
  final secondInRow = previous.status != RestStatus.full;
  if (!mobilityPackage) {
    return secondInRow
        ? ReducedWeeklyRestRight.denied
        : ReducedWeeklyRestRight.allowed;
  }
  // Окно — три отдыха перед этим и он сам, сокращённый
  final recent = before.length < _window
      ? before
      : before.sublist(before.length - (_window - 1));
  final full =
      recent.where((r) => r.status == RestStatus.full).length +
      (_window - 1 - recent.length);
  if (full < _fullInWindow) return ReducedWeeklyRestRight.denied;
  if (secondInRow && (atBase(previous.start) || atBase(restStart))) {
    return ReducedWeeklyRestRight.atBase;
  }
  return ReducedWeeklyRestRight.allowed;
}

/// Сокращённые недельные отдыхи из [rests] — законченных недельных по
/// началу, — взятые без права на них ([reducedWeeklyRestRight]).
List<WeeklyRest> reducedWeeklyRestsWithoutRight(
  List<WeeklyRest> rests, {
  required bool mobilityPackage,
  required bool Function(DateTime t) atBase,
}) => [
  for (final (i, r) in rests.indexed)
    if (r.status == RestStatus.reduced &&
        reducedWeeklyRestRight(
              rests.sublist(i < _window ? 0 : i - (_window - 1), i),
              restStart: r.start,
              mobilityPackage: mobilityPackage,
              atBase: atBase,
            ) !=
            ReducedWeeklyRestRight.allowed)
      r,
];

/// В стране ли фирмы [baseCountry] водитель в момент: там, где кончилась
/// смена, начатая последней к этому моменту (пока страны конца нет — где
/// началась). Смены — по началу [shiftStarts], их страны — [routes]. Страна
/// фирмы или смены не выбрана — нет: страну не проверяем.
bool Function(DateTime t) atBaseCountry({
  required String? baseCountry,
  required Iterable<DateTime> shiftStarts,
  required Map<DateTime, ShiftRoute> routes,
}) {
  if (baseCountry == null) return (_) => false;
  final starts = shiftStarts.toList();
  return (t) {
    DateTime? last;
    for (final start in starts) {
      if (!start.isAfter(t) && (last == null || start.isAfter(last))) {
        last = start;
      }
    }
    return last != null && routes[last]?.last == baseCountry;
  };
}
