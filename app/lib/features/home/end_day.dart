/// "End day": the driver enters the day's driving as a total.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/widgets/buttons.dart';
import 'package:tachogo/core/widgets/journal_save.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/features/home/snapshot_select.dart';
import 'package:tachogo/features/journal/pickers.dart';

/// «Завершить день»: водитель вводит вождение за день. Журнал режимов по
/// времени ему не нужен — только итог (отзыв водителей, 28.09.2026). В поле
/// — вождение по записям, если режимы переключали; разошлось с ними — смена
/// становится ручной с этим итогом (`endDayWithDriving`). Смены нет — день
/// завершается сразу. true — день завершён, false — водитель передумал или
/// запись не удалась: тогда он видит сообщение ([journalSaver]).
///
/// [weekly] — «Начать недельный отдых» (экран 9): отдых сразу недельный, а
/// без смены идущий отдых становится недельным (`declareWeeklyRest`).
Future<bool> finishDay(
  BuildContext context,
  WidgetRef ref, {
  bool weekly = false,
}) async {
  final s = ref.read(complianceProvider).value;
  final save = journalSaver(context);
  final shift = s?.shift;
  final dayStart = s?.shiftStart;
  if (s == null || shift == null || dayStart == null) {
    return await save(
      () => weekly
          ? ref.read(journalEditRepositoryProvider).startWeeklyRest()
          : ref.read(activityRepositoryProvider).endDay(),
    );
  }
  // День может продолжать смену, уже внесённую итогом (отдых после неё был
  // короче 9 ч, ENG-29): водитель вводит вождение за весь день, а
  // записывается оно у текущей смены — за вычетом уже внесённого. Меньше
  // внесённого и больше, чем длится текущая смена, ввести нельзя.
  final before = s.dailyDriving - shift.driving;
  final current = s.shiftDuration - shift.start.difference(dayStart);
  final l = context.l10n;
  final title = weekly ? l.weeklyStartRest : l.workdayEndDay;
  final recorded = floorToMinute(s.dailyDriving);
  final driving = await showDurationSheet(
    context,
    title: title,
    subtitle: l.endDayDrivingHint,
    label: l.endDayDriving,
    initial: recorded,
    min: before,
    max: before + floorToMinute(current),
    computed: recorded > Duration.zero ? recorded : null,
    action: title,
  );
  if (driving == null) return false;
  return await save(
    () => ref
        .read(journalEditRepositoryProvider)
        .endDay(driving: driving - before, weekly: weekly),
  );
}

/// The "End day" button in the "Today" section of the home screen, while a
/// shift is on.
class EndDayButton extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shift = watchSnapshot(ref, (s) => s.shift != null) ?? false;
    if (!shift) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        12,
        AppSpacing.screenPadding,
        0,
      ),
      child: SecondaryButton(
        label: context.l10n.workdayEndDay,
        onPressed: () => unawaited(finishDay(context, ref)),
      ),
    );
  }
}
