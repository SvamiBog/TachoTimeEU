/// "Driving" screen: every driving limit in one place, opened from the driving
/// rows of the home screen.
library;

import 'dart:async';

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

/// Section of the "Driving" screen — from the home row that opened it.
enum DrivingSection { continuous, daily, week }

/// What will stop driving first.
enum DrivingStop { breakDue, workday, daily, weekly, fortnight }

/// Driving limits for the screen in whole minutes: the one-second tick does not
/// rebuild it.
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

  /// Сегодня можно ехать до 10 ч.
  bool extendable,
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
  shiftStart: s.shiftStart,
  atWheel: s.currentMode == DriverMode.driving,
  continuous: minutes(s.continuousDriving),
  untilBreak: minutes(s.drivingUntilBreak),
  // Рабочий день — от начала смены до сейчас, а не до начала перерыва, как
  // в строке «Рабочий день»: здесь — сколько можно ехать, если тронуться
  // сейчас.
  shiftLeft: switch (s.shiftRemainingFromNow) {
    final left? => minutes(left),
    null => null,
  },
  daily: minutes(s.dailyDriving),
  dailyLimit: minutes(s.dailyDrivingLimit),
  extensionsLeft: s.extensionsLeft,
  extendable: s.dailyDrivingExtendable,
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

/// Вождение экрана в целых минутах — остатки лимитов считает по нему движок.
DrivingTimes _times(_Driving s) => DrivingTimes(
  daily: Duration(minutes: s.daily),
  dailyLimit: Duration(minutes: s.dailyLimit),
  weekly: Duration(minutes: s.weekly),
  fortnight: Duration(minutes: s.fortnight),
);

/// Сколько ещё можно ехать и что остановит раньше: перерыв после 4:30,
/// конец рабочего дня, лимит смены (9/10 ч), недели или двух недель. При
/// равенстве — первое по порядку [DrivingStop].
(Duration, DrivingStop) _nextStop(_Driving s) {
  final times = _times(s);
  final candidates = [
    (Duration(minutes: s.untilBreak), DrivingStop.breakDue),
    if (s.shiftLeft case final left?)
      (Duration(minutes: left), DrivingStop.workday),
    (times.untilDailyLimit, DrivingStop.daily),
    (times.untilWeeklyLimit, DrivingStop.weekly),
    (times.untilFortnightLimit, DrivingStop.fortnight),
  ];
  var next = candidates.first;
  for (final c in candidates.skip(1)) {
    if (c.$1 < next.$1) next = c;
  }
  return (atLeastZero(next.$1), next.$2);
}

void openDrivingScreen(
  BuildContext context, [
  DrivingSection section = DrivingSection.continuous,
]) => Navigator.of(context).push(
  MaterialPageRoute<void>(builder: (_) => DrivingScreen(section: section)),
);

/// "Driving" — every driving limit on one screen (driver feedback 02.10.2026):
/// how much longer one may drive and what stops it, continuous (4:30, link to
/// the break), daily (9 / 10 h, extensions in the week), weekly and fortnightly
/// (56 / 90 h), the shifts of the week and the rules; at the bottom —
/// correcting the day's driving (screen 7). Opened from the driving rows of the
/// home screen and scrolled to the row's section. There is no mockup — built
/// from the limit screen components.
class DrivingScreen extends ConsumerStatefulWidget {
  const new({this.section = DrivingSection.continuous, super.key});

  final DrivingSection section;

  @override
  ConsumerState<DrivingScreen> createState() => _DrivingScreenState();
}

/// Scrolls once to the section the screen was opened for.
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

/// "You may drive 2:40 more — until the break → 14:20".
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
    return HeroCard(
      children: [
        Text(l.drivingCanDrive.toUpperCase(), style: label),
        const SizedBox(height: AppSpacing.s4),
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
  required Duration left,
  String? hint,
  bool muted = false,
  Tone tone = Tone.neutral,
}) {
  final l = context.l10n;
  final usedUp = left <= Duration.zero;
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
                  ? l.leftUntil(formatHm(left), formatClock(s.now.add(left)))
                  : l.left(formatHm(left))),
    value: formatHm(atLeastZero(left)),
    muted: muted,
    valueColor: tone == Tone.violation ? context.colors.errorText : null,
  );
}

/// 4:30 without a break and the link to the break screen.
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
          left: Duration(minutes: s.untilBreak),
          tone: s.continuousTone,
        ),
        NavRow(title: l.rowBreak, onTap: () => openBreakScreen(context)),
      ],
    );
  }
}

/// Driving in the shift: 9 h, twice a week 10 h.
class _Daily extends StatelessWidget {
  const new(this.s);

  final _Driving s;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final start = s.shiftStart;
    final times = _times(s);
    final extended = s.extendable;
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
          left: times.untilRegularDay,
        ),
        _ahead(
          context,
          s,
          title: l.workdayExtended(EuLimits.dailyDrivingExtended.inHours),
          left: times.untilExtendedDay,
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

/// The week from Monday: 56 h, and 90 h together with the previous week.
class _Week extends StatelessWidget {
  const new(this.s);

  final _Driving s;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final times = _times(s);
    final weekLeft = times.untilWeeklyLimit;
    final fortnightLeft = times.untilFortnightLimit;
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
          hint: weekLeft > Duration.zero ? l.left(formatHm(weekLeft)) : null,
          tone: s.weeklyTone,
        ),
        MilestoneRow(
          dot: fortnightLeft <= Duration.zero
              ? MilestoneDot.solid
              : MilestoneDot.ring,
          title: l.drivingFortnightLimit(EuLimits.fortnightDriving.inHours),
          subtitle: l.drivingFortnightHint(
            formatHm(times.previousWeek),
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
