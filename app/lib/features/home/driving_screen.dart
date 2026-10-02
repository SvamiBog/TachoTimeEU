import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/buttons.dart';
import 'package:tachogo/core/widgets/detail_scaffold.dart';
import 'package:tachogo/core/widgets/sections.dart';
import 'package:tachogo/core/widgets/setting_rows.dart';
import 'package:tachogo/core/widgets/status_chip.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/features/home/break_screen.dart';
import 'package:tachogo/features/home/corrections.dart';
import 'package:tachogo/features/home/detail_rows.dart';
import 'package:tachogo/features/home/shift_rows.dart';
import 'package:tachogo/features/home/snapshot_select.dart';

/// Раздел экрана «Вождение» — по строке главной, с которой его открыли.
enum DrivingSection { continuous, daily, week }

/// Что раньше всего остановит вождение.
enum DrivingStop { breakDue, workday, daily, weekly, fortnight }

typedef _Driving = ({
  DateTime now,
  DateTime? shiftStart,
  bool atWheel,
  int continuous,
  int untilBreak,
  int? shiftLeft,
  int daily,
  int dailyLimit,
  int extensionsLeft,
  DateTime weekStart,
  int weekly,
  int fortnight,
  int weekLeft,
  bool fortnightLimiting,
  Tone continuousTone,
  Tone dailyTone,
  Tone weeklyTone,
  Tone fortnightTone,
});

_Driving _driving(ComplianceSnapshot s) => (
  now: minuteOf(s.now),
  shiftStart: s.shift?.start,
  atWheel: s.currentMode == DriverMode.driving,
  continuous: minutes(s.continuousDriving),
  untilBreak: minutes(s.drivingUntilBreak),
  // Рабочий день — от начала смены до сейчас, а не до начала перерыва, как
  // в строке «Рабочий день»: здесь — сколько можно ехать, если тронуться
  // сейчас.
  shiftLeft: switch (s.shift) {
    final shift? => minutes(
      atLeastZero(s.shiftLimit - s.now.difference(shift.start)),
    ),
    null => null,
  },
  daily: minutes(s.dailyDriving),
  dailyLimit: minutes(s.dailyDrivingLimit),
  extensionsLeft: s.extensionsLeft,
  weekStart: s.weekStart,
  weekly: minutes(s.weeklyDriving),
  fortnight: minutes(s.fortnightDriving),
  weekLeft: minutes(s.weeklyDrivingRemaining),
  fortnightLimiting: s.fortnightLimiting,
  continuousTone: toneOf(
    s,
    violation: InfringementType.continuousExceeded,
    warning: InfringementType.breakSoon,
  ),
  dailyTone: toneOf(
    s,
    violation: InfringementType.dailyDriveExceeded,
    warning: InfringementType.dailyDriveSoon,
  ),
  weeklyTone: toneOf(
    s,
    violation: InfringementType.weeklyDriveExceeded,
    warning: InfringementType.weeklyDriveSoon,
  ),
  fortnightTone: toneOf(
    s,
    violation: InfringementType.fortnightDriveExceeded,
    warning: InfringementType.fortnightDriveSoon,
  ),
);

/// Сколько ещё можно ехать и что остановит раньше: перерыв после 4:30,
/// конец рабочего дня, лимит смены (9/10 ч), недели или двух недель. При
/// равенстве — первое по порядку [DrivingStop].
(Duration, DrivingStop) _nextStop(_Driving s) {
  final candidates = [
    (s.untilBreak, DrivingStop.breakDue),
    if (s.shiftLeft case final left?) (left, DrivingStop.workday),
    (s.dailyLimit - s.daily, DrivingStop.daily),
    (EuLimits.weeklyDriving.inMinutes - s.weekly, DrivingStop.weekly),
    (EuLimits.fortnightDriving.inMinutes - s.fortnight, DrivingStop.fortnight),
  ];
  var next = candidates.first;
  for (final c in candidates.skip(1)) {
    if (c.$1 < next.$1) next = c;
  }
  return (Duration(minutes: math.max(0, next.$1)), next.$2);
}

void openDrivingScreen(
  BuildContext context, [
  DrivingSection section = DrivingSection.continuous,
]) => Navigator.of(context).push(
  MaterialPageRoute<void>(builder: (_) => DrivingScreen(section: section)),
);

/// «Вождение» — все лимиты вождения на одном экране (отзыв водителя
/// 02.10.2026): сколько ещё можно ехать и что остановит, непрерывное
/// (4:30, переход к перерыву), суточное (9 / 10 ч, удлинения на неделе),
/// недельное и двухнедельное (56 / 90 ч), смены недели и правила; внизу —
/// правка вождения за день (экран 7). Открывается со строк вождения главной
/// и прокручивается к разделу строки. Макета нет — из компонентов экранов
/// лимитов.
class DrivingScreen extends ConsumerStatefulWidget {
  const new({this.section = DrivingSection.continuous, super.key});

  final DrivingSection section;

  @override
  ConsumerState<DrivingScreen> createState() => _DrivingScreenState();
}

class _DrivingScreenState extends ConsumerState<DrivingScreen> {
  final Map<DrivingSection, GlobalKey> _sections = {
    for (final s in DrivingSection.values) s: GlobalKey(),
  };
  var _scrolled = false;

  /// Раздел строки — наверх экрана, один раз, когда он построен.
  void _scrollToSection() {
    if (_scrolled) return;
    _scrolled = true;
    if (widget.section == DrivingSection.continuous) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _sections[widget.section]!.currentContext;
      if (context == null || !context.mounted) return;
      Scrollable.ensureVisible(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = watchSnapshot(ref, _driving);
    final shifts = ref.watch(
      journalProvider.select(
        (a) => ValueList(
          [
            for (final w in a.value?.weeks ?? const <JournalWeek>[])
              if (w.isCurrent) ...w.shifts,
          ]..sort((a, b) => a.start.compareTo(b.start)),
        ),
      ),
    );
    if (s != null) _scrollToSection();
    return DetailScaffold(
      title: l.modeDriving,
      bottom: s?.shiftStart == null
          ? null
          : SecondaryButton(
              label: l.drivingCorrect,
              onPressed: () => unawaited(openDrivingCorrection(context, ref)),
            ),
      children: s == null
          ? const []
          : [
              _Summary(s),
              SectionTitle(
                l.rowContinuous,
                key: _sections[DrivingSection.continuous],
              ),
              _Continuous(s),
              SectionTitle(
                l.rowDailyDriving,
                key: _sections[DrivingSection.daily],
              ),
              _Daily(s),
              SectionTitle(
                l.rowWeeklyDriving,
                key: _sections[DrivingSection.week],
              ),
              _Week(s),
              if (s.fortnightLimiting)
                InfoNote(
                  l.drivingFortnightLimits(
                    formatHm(Duration(minutes: s.weekLeft)),
                  ),
                ),
              SectionTitle(l.drivingWeekShifts),
              ShiftRows(shifts.items, empty: l.drivingNoShifts),
              InfoNote('${l.drivingDailyRule}\n\n${l.drivingWeekRule}'),
            ],
    );
  }
}

/// «Можно ехать ещё 2:40 — до перерыва → 14:20».
class _Summary extends StatelessWidget {
  const new(this.s);

  final _Driving s;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final (left, stop) = _nextStop(s);
    final stopped = left <= Duration.zero;
    final reason = stopped
        ? l.drivingStopped(stop.name)
        : l.drivingStop(stop.name);
    final label = AppTextStyles.label.copyWith(
      color: colors.textSecondary,
      letterSpacing: AppTextStyles.label.fontSize! * 0.08,
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        8,
        AppSpacing.screenPadding,
        0,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.heroCard),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l.drivingCanDrive.toUpperCase(), style: label),
              const SizedBox(height: 4),
              DurationText(
                formatHm(left),
                spoken: spokenDuration(l, left),
                style: AppTextStyles.timer.copyWith(
                  color: stopped ? colors.errorText : colors.drive,
                ),
              ),
              Text(
                !stopped && s.atWheel
                    ? '$reason → ${formatClock(s.now.add(left))}'
                    : reason,
                style: AppTextStyles.body.copyWith(
                  color: stopped ? colors.errorText : colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Сколько уже за рулём: точка «уже было».
MilestoneRow _used(
  BuildContext context, {
  required String title,
  required int minutes,
  required Tone tone,
  String? subtitle,
}) => MilestoneRow(
  dot: MilestoneDot.solid,
  title: title,
  subtitle: subtitle,
  value: formatHm(Duration(minutes: minutes)),
  valueColor: tone == Tone.violation ? context.colors.errorText : null,
);

/// Веха впереди: сколько осталось; за рулём — во сколько кончится.
MilestoneRow _ahead(
  BuildContext context,
  _Driving s, {
  required String title,
  required int left,
  String? hint,
  bool muted = false,
  Tone tone = Tone.neutral,
}) {
  final l = context.l10n;
  final rest = Duration(minutes: left);
  final usedUp = rest <= Duration.zero;
  return MilestoneRow(
    dot: usedUp
        ? MilestoneDot.solid
        : muted
        ? MilestoneDot.muted
        : MilestoneDot.ring,
    title: title,
    subtitle: usedUp
        ? l.drivingUsedUp
        : hint ??
              (s.atWheel
                  ? l.leftUntil(formatHm(rest), formatClock(s.now.add(rest)))
                  : l.left(formatHm(rest))),
    value: formatHm(atLeastZero(rest)),
    muted: muted,
    valueColor: tone == Tone.violation ? context.colors.errorText : null,
  );
}

/// 4:30 без перерыва и переход к экрану перерыва.
class _Continuous extends StatelessWidget {
  const new(this.s);

  final _Driving s;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return CardGroup(
      children: [
        _used(
          context,
          title: l.drivingContinuousNow,
          minutes: s.continuous,
          tone: s.continuousTone,
        ),
        _ahead(
          context,
          s,
          title: l.drivingBreakDue(formatHm(EuLimits.continuousDriving)),
          left: s.untilBreak,
          tone: s.continuousTone,
        ),
        NavRow(title: l.rowBreak, onTap: () => openBreakScreen(context)),
      ],
    );
  }
}

/// Вождение смены: 9 ч, дважды в неделю — 10 ч.
class _Daily extends StatelessWidget {
  const new(this.s);

  final _Driving s;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final start = s.shiftStart;
    final extended =
        s.extensionsLeft > 0 ||
        Duration(minutes: s.dailyLimit) > EuLimits.dailyDriving;
    return CardGroup(
      children: [
        _used(
          context,
          title: l.drivingThisShift,
          subtitle: start == null
              ? l.workdayNoShift
              : l.modeSince(formatClock(start)),
          minutes: s.daily,
          tone: s.dailyTone,
        ),
        _ahead(
          context,
          s,
          title: l.workdayRegular(EuLimits.dailyDriving.inHours),
          left: EuLimits.dailyDriving.inMinutes - s.daily,
        ),
        _ahead(
          context,
          s,
          title: l.workdayExtended(EuLimits.dailyDrivingExtended.inHours),
          left: EuLimits.dailyDrivingExtended.inMinutes - s.daily,
          hint: extended
              ? l.drivingExtensionsLeft(s.extensionsLeft)
              : l.drivingNoExtensions,
          muted: !extended,
          tone: s.dailyTone,
        ),
      ],
    );
  }
}

/// Неделя с понедельника: 56 ч и 90 ч вместе с прошлой неделей.
class _Week extends StatelessWidget {
  const new(this.s);

  final _Driving s;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final weekLeft = EuLimits.weeklyDriving.inMinutes - s.weekly;
    final fortnightLeft = Duration(
      minutes: EuLimits.fortnightDriving.inMinutes - s.fortnight,
    );
    return CardGroup(
      children: [
        _used(
          context,
          title: l.drivingThisWeek,
          subtitle: l.drivingWeekSince(
            formatWeekdayDayClock(s.weekStart, context.localeTag),
          ),
          minutes: s.weekly,
          tone: s.weeklyTone,
        ),
        _ahead(
          context,
          s,
          title: l.drivingWeekLimit(EuLimits.weeklyDriving.inHours),
          left: weekLeft,
          hint: weekLeft > 0
              ? l.left(formatHm(Duration(minutes: weekLeft)))
              : null,
          tone: s.weeklyTone,
        ),
        MilestoneRow(
          dot: fortnightLeft <= Duration.zero
              ? MilestoneDot.solid
              : MilestoneDot.ring,
          title: l.drivingFortnightLimit(EuLimits.fortnightDriving.inHours),
          subtitle: l.drivingFortnightHint(
            formatHm(Duration(minutes: s.fortnight - s.weekly)),
            formatHm(atLeastZero(fortnightLeft)),
          ),
          value: formatHm(atLeastZero(fortnightLeft)),
          valueColor: s.fortnightTone == Tone.violation
              ? colors.errorText
              : null,
        ),
      ],
    );
  }
}
