import 'package:meta/meta.dart';
import 'package:tacho_engine/src/activity_period.dart';
import 'package:tacho_engine/src/driver_mode.dart';
import 'package:tacho_engine/src/eu_limits.dart';
import 'package:tacho_engine/src/time.dart';

/// Непрерывный отрезок одного режима: соседние записи одного режима склеены.
@immutable
class Block {
  const new({
    required this.mode,
    required this.start,
    required this.end,
    required this.open,
    required this.ferry,
    required this.dayEnd,
  });

  final DriverMode mode;
  final DateTime start;

  /// Для текущего режима — момент расчёта.
  final DateTime end;
  final bool open;

  /// Все записи блока сделаны в режиме «паром / поезд».
  final bool ferry;

  /// Водитель завершил этим отдыхом рабочий день.
  final bool dayEnd;

  Duration get duration => durationBetween(start, end);

  @override
  String toString() => 'Block($mode, $start → $end${open ? ', open' : ''})';
}

/// Записи, созданные переключением режима, стыкуются точно; допуск — на
/// округление.
const contiguityTolerance = Duration(seconds: 1);

bool _contiguous(DateTime previousEnd, DateTime nextStart) =>
    nextStart.difference(previousEnd) <= contiguityTolerance;

/// Приводит журнал к последовательности блоков: сортирует, обрезает
/// наложения (приоритет у более ранней записи) и склеивает соседние записи
/// одного режима. Повторное нажатие на тот же режим или ручная правка не
/// должны дробить перерыв: 20 + 25 мин отдыха подряд — это 45 мин.
///
/// Открытая запись, после которой начата другая (испорченный журнал),
/// заканчивается началом следующей: текущий режим — последний начатый.
List<Block> buildBlocks(Iterable<ActivityPeriod> periods, DateTime now) {
  final sorted = sortedByStart(periods);
  final blocks = <Block>[];

  for (final (i, p) in sorted.indexed) {
    final next = i + 1 < sorted.length ? sorted[i + 1].start : null;
    final stale = p.isOpen && next != null && next.isAfter(p.start);
    final open = p.isOpen && !stale;
    final end = earlier(stale ? next : p.end ?? now, now);
    final prev = blocks.isEmpty ? null : blocks.last;
    final start = prev == null
        ? p.start
        : later(p.start, earlier(prev.end, end));
    if (!end.isAfter(start) && !open) continue;

    if (prev != null && prev.mode == p.mode && _contiguous(prev.end, start)) {
      blocks.last = Block(
        mode: prev.mode,
        start: prev.start,
        end: later(prev.end, end),
        open: prev.open || open,
        ferry: prev.ferry && p.ferry,
        dayEnd: prev.dayEnd || p.dayEnd,
      );
      continue;
    }
    blocks.add(
      Block(
        mode: p.mode,
        start: start,
        end: later(start, end),
        open: open,
        ferry: p.ferry,
        dayEnd: p.dayEnd,
      ),
    );
  }
  return blocks;
}

/// Записи по возрастанию начала. Сортировка устойчивая: при равном начале
/// сохраняется порядок хранилища, как в прототипе.
List<ActivityPeriod> sortedByStart(Iterable<ActivityPeriod> periods) {
  final indexed = periods.indexed.toList()
    ..sort((a, b) {
      final byStart = a.$2.start.compareTo(b.$2.start);
      return byStart != 0 ? byStart : a.$1.compareTo(b.$1);
    });
  return [for (final (_, p) in indexed) p];
}

/// Период отдыха: один блок или несколько, прерванных на пароме / поезде.
@immutable
class RestPeriod {
  const new({
    required this.start,
    required this.end,
    required this.rest,
    required this.open,
    required this.dayEnd,
    required this.firstBlock,
    required this.lastBlock,
  });

  final DateTime start;
  final DateTime end;

  /// Чистое время отдыха без прерываний.
  final Duration rest;
  final bool open;

  /// Отдых объявлен концом рабочего дня.
  final bool dayEnd;

  /// Индексы первого и последнего блока периода в шкале.
  final int firstBlock;
  final int lastBlock;

  /// Отдых, который завершает смену: суточный (≥ 9 ч) или недельный, а также
  /// идущий отдых, которым водитель завершил день.
  bool get endsShift => rest >= EuLimits.dailyRestReduced || (open && dayEnd);

  /// Недельный отдых: не меньше сокращённого (24 ч).
  bool get isWeekly => rest >= EuLimits.weeklyRestReduced;

  @override
  String toString() =>
      'RestPeriod($start → $end, ${rest.inMinutes} мин'
      '${open ? ', open' : ''})';
}

/// Находит периоды отдыха. Блоки отдыха объединяются через прерывания на
/// пароме / поезде (ст. 9: не больше двух, суммарно до 1 ч), только если
/// в сумме получается не меньше полного суточного отдыха (11 ч) — иначе
/// исключение не применяется. Регулярный недельный отдых (45 ч) через
/// прерывания — только при рейсе от 8 ч: рейс — от первого до последнего
/// блока с отметкой «паром» внутри периода. Каюту движок не проверяет.
List<RestPeriod> findRestPeriods(List<Block> blocks) {
  final periods = <RestPeriod>[];
  var i = 0;
  while (i < blocks.length) {
    if (!blocks[i].mode.isRest) {
      i++;
      continue;
    }
    var best = _periodOf(blocks, i, i);
    var interruptions = 0;
    var interruptionTotal = Duration.zero;
    var last = i;

    while (true) {
      var j = last + 1;
      var run = Duration.zero;
      var ferryRun = true;
      var contiguous = true;
      while (j < blocks.length && !blocks[j].mode.isRest) {
        ferryRun = ferryRun && blocks[j].ferry;
        contiguous =
            contiguous && _contiguous(blocks[j - 1].end, blocks[j].start);
        run += blocks[j].duration;
        j++;
      }
      if (j >= blocks.length || j == last + 1 || !ferryRun || !contiguous) {
        break;
      }
      if (!_contiguous(blocks[j - 1].end, blocks[j].start)) break;
      interruptions++;
      interruptionTotal += run;
      if (interruptions > EuLimits.ferryMaxInterruptions ||
          interruptionTotal > EuLimits.ferryMaxInterruptionTotal) {
        break;
      }
      last = j;
      final merged = _periodOf(blocks, i, last);
      if (merged.rest >= EuLimits.dailyRestRegular &&
          (merged.rest < EuLimits.weeklyRestRegular ||
              _crossing(blocks, i, last) >=
                  EuLimits.ferryRegularWeeklyRestCrossing)) {
        best = merged;
      }
    }

    periods.add(best);
    i = best.lastBlock + 1;
  }
  return periods;
}

/// Рейс парома / поезда внутри периода: от начала первого блока с отметкой
/// до конца последнего.
Duration _crossing(List<Block> blocks, int first, int last) {
  DateTime? from;
  var to = blocks[first].start;
  for (var k = first; k <= last; k++) {
    if (!blocks[k].ferry) continue;
    from ??= blocks[k].start;
    to = blocks[k].end;
  }
  return from == null ? Duration.zero : durationBetween(from, to);
}

RestPeriod _periodOf(List<Block> blocks, int first, int last) {
  var rest = Duration.zero;
  var dayEnd = false;
  for (var k = first; k <= last; k++) {
    if (!blocks[k].mode.isRest) continue;
    rest += blocks[k].duration;
    dayEnd = dayEnd || blocks[k].dayEnd;
  }
  return RestPeriod(
    start: blocks[first].start,
    end: blocks[last].end,
    rest: rest,
    open: blocks[last].open,
    dayEnd: dayEnd,
    firstBlock: first,
    lastBlock: last,
  );
}
