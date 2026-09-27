import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/features/journal/pickers.dart';

// Корректировки текущей смены с главной и экранов лимитов: суточное
// вождение (экран 7), перерыв (экран 8), начало смены (экран 6). Это правки
// журнала (Premium, docs/premium.md): пишутся через слой ручных правок,
// время берётся у соседней записи (`adjustDriving`, `setLastBreakDuration`,
// `moveStart`), пределы — из движка.

/// Текущая смена и записи для правки; null — смены нет.
({Shift shift, List<ActivityPeriod> periods, DateTime now, Duration daily})?
_current(WidgetRef ref) {
  final s = ref.read(complianceProvider).value;
  final periods = ref.read(activityPeriodsProvider).value;
  final shift = s?.shift;
  if (s == null || shift == null || periods == null) return null;
  return (
    shift: shift,
    periods: periods,
    now: ref.read(clockProvider),
    daily: s.dailyDriving,
  );
}

/// «Суточное вождение» (экран 7): водитель переключил режим не вовремя —
/// поправка берёт время у соседнего отрезка.
Future<void> openDrivingCorrection(BuildContext context, WidgetRef ref) async {
  final l = context.l10n;
  final c = _current(ref);
  if (c == null) return;
  final bounds = drivingAdjustmentBounds(c.periods, c.shift.start, c.now);
  final messenger = ScaffoldMessenger.of(context);
  if (bounds == null) {
    messenger.showSnackBar(SnackBar(content: Text(l.driveEditNoDrive)));
    return;
  }
  final computed = floorToMinute(c.daily);
  final picked = await showDurationSheet(
    context,
    title: l.rowDailyDriving,
    subtitle: l.driveEditSubtitle(formatWeekdayDay(c.now, context.localeTag)),
    initial: computed,
    min: computed + bounds.min,
    max: computed + bounds.max,
    computed: computed,
    hint: (v) {
      final diff = v - computed;
      final head = diff == Duration.zero
          ? l.driveEditNoChange
          : l.driveEditDiff('${diff.isNegative ? '' : '+'}${formatHm(diff)}');
      return '$head ${l.driveEditHint}';
    },
  );
  if (picked == null) return;
  await ref
      .read(journalEditRepositoryProvider)
      .applyLiveEdit(
        LiveShiftEdit(
          shiftStart: c.shift.start,
          drivingDelta: picked - computed,
        ),
      );
}

/// Последний перерыв смены для корректировки (экран 8); null — перерывов
/// нет или смены нет.
({DateTime shiftStart, Duration duration, Duration max, bool open})?
lastBreakOf(ComplianceSnapshot? s, List<ActivityPeriod>? periods) {
  final shift = s?.shift;
  if (s == null || shift == null || periods == null) return null;
  final info = lastBreakInfo(periods, shift.start, s.now);
  if (info == null) return null;
  return (
    shiftStart: shift.start,
    duration: info.duration,
    max: info.max,
    open: info.open,
  );
}

/// Длительность последнего перерыва (экран 8): не меньше минуты, не больше,
/// чем даёт соседний отрезок.
Future<void> openBreakCorrection(BuildContext context, WidgetRef ref) async {
  final l = context.l10n;
  final info = lastBreakOf(
    ref.read(complianceProvider).value,
    ref.read(activityPeriodsProvider).value,
  );
  if (info == null) return;
  final picked = await showDurationSheet(
    context,
    title: info.open ? l.breakCurrentDuration : l.breakLastDuration,
    initial: info.duration,
    min: const Duration(minutes: 1),
    max: info.max,
    hint: (_) => l.breakEditHint,
  );
  if (picked == null) return;
  await ref
      .read(journalEditRepositoryProvider)
      .setLastBreak(info.shiftStart, picked);
}

/// «Изменить начало смены» (экран 6): начало раньше — за счёт отдыха перед
/// сменой, но не дальше предыдущей записи.
Future<void> openShiftStartCorrection(
  BuildContext context,
  WidgetRef ref,
) async {
  final c = _current(ref);
  if (c == null) return;
  final picked = await showDateTimeSheet(
    context,
    start: floorTimeToMinute(c.shift.start),
    end: null,
    max: c.now,
  );
  if (picked == null || picked.start == floorTimeToMinute(c.shift.start)) {
    return;
  }
  await ref
      .read(journalEditRepositoryProvider)
      .applyLiveEdit(
        LiveShiftEdit(shiftStart: c.shift.start, newStart: picked.start),
      );
}
