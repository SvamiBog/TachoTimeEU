/// Screen 8 "Break": the Art. 7 break after 4:30 of driving.
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
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/features/home/corrections.dart';
import 'package:tachogo/features/home/snapshot_select.dart';

void openBreakScreen(BuildContext context) =>
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const BreakScreen()));

/// The break as the "Break" screen and its row on the home screen show it, in
/// whole minutes. Every value is the engine's: the UI does not count the break.
typedef BreakView = ({
  bool shift,
  bool resting,
  int taken,
  bool split,
  bool firstDone,
  bool counted,
  int? first,
  DateTime? firstStart,
  int? current,
  int? required,
});

BreakView breakViewOf(ComplianceSnapshot s) {
  final first = s.breakFirstPart;
  final current = s.currentBreak;
  return (
    shift: s.shift != null,
    resting: s.currentMode == DriverMode.rest,
    taken: minutes(s.breakTaken),
    split: s.breakSplit,
    firstDone: s.breakFirstPartDone,
    // Зелёным перерыв становится, когда он уже не нужен: засчитан или с
    // прошлого перерыва не было вождения
    counted: current != null && !current.needed,
    first: first == null ? null : minutes(first.duration),
    firstStart: first?.start,
    current: current == null ? null : minutes(current.duration),
    required: current == null ? null : minutes(current.required),
  );
}

/// Screen 8 "Break": 45 min in one go, or 15 + 30, after 4:30 of driving.
/// Correcting the duration is a journal edit (Premium).
class BreakScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final s = watchSnapshot(ref, breakViewOf);
    final resting = s?.resting ?? false;
    return DetailScaffold(
      title: l.rowBreak,
      bottom: PrimaryButton(
        label: resting ? l.breakOngoing : l.breakStart,
        color: context.colors.rest,
        onPressed: s == null || !s.shift || resting
            ? null
            : () => _start(context, ref),
      ),
      children: s == null
          ? const []
          : [_Summary(s), const _Correction(), const _SplitRule()],
    );
  }

  static Future<void> _start(BuildContext context, WidgetRef ref) async {
    final navigator = Navigator.of(context);
    await ref.read(activityRepositoryProvider).switchMode(DriverMode.rest);
    navigator.pop();
  }
}

/// The ring with the break taken so far and what is still needed.
class _Summary extends StatelessWidget {
  const new(this.s);

  final BreakView s;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final taken = Duration(minutes: s.taken);
    final (current, required) = (s.current, s.required);
    final (first, firstStart) = (s.first, s.firstStart);
    final caption = current != null && required != null
        ? l.breakResting(formatHm(Duration(minutes: current)), required)
        : first != null && firstStart != null
        ? l.breakFirstTaken(
            formatClock(firstStart),
            formatClock(firstStart.add(Duration(minutes: first))),
          )
        : l.breakNone;
    return HeroCard(
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSpacing.s12,
          runSpacing: AppSpacing.s4,
          children: [
            Text(
              l.breakHero(formatHm(EuLimits.continuousDriving)),
              style: AppTextStyles.rowTitle,
            ),
            DurationText(
              '${formatHm(taken)} / ${formatHm(EuLimits.breakFull)}',
              spoken: l.ofLimit(spokenDuration(l, taken)),
              style: AppTextStyles.value.copyWith(
                color: s.counted ? colors.rest : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s14),
        _Parts(firstDone: s.firstDone, counted: s.counted),
        const SizedBox(height: AppSpacing.s14),
        Text(
          caption,
          style: AppTextStyles.caption.copyWith(color: colors.textSecondary),
        ),
      ],
    );
  }
}

/// The two parts of a split break side by side: 15 min and, twice as wide,
/// 30 min.
class _Parts extends StatelessWidget {
  const new({required this.firstDone, required this.counted});

  /// Первые 15 мин набраны.
  final bool firstDone;

  /// Перерыв засчитан целиком.
  final bool counted;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    const splitFirst = EuLimits.breakSplitFirst;
    const splitSecond = EuLimits.breakSplitSecond;
    return Row(
      children: [
        Expanded(
          child: _Part(
            firstDone
                ? l.breakPartDone(splitFirst.inMinutes)
                : l.breakPart(splitFirst.inMinutes),
            done: firstDone,
          ),
        ),
        const SizedBox(width: AppSpacing.s8),
        Expanded(
          flex: 2,
          child: _Part(
            counted
                ? l.breakPartDone(splitSecond.inMinutes)
                : firstDone
                ? l.breakPartLeft(splitSecond.inMinutes)
                : l.breakPart(splitSecond.inMinutes),
            done: counted,
          ),
        ),
      ],
    );
  }
}

/// A part of the break: taken — filled with the rest colour, not yet — dashed.
class _Part extends StatelessWidget {
  const new(this.text, {required this.done});

  final String text;
  final bool done;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = BorderRadius.circular(AppRadius.chip);
    final label = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s8,
        vertical: AppSpacing.s12,
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppTextStyles.rowTitle.copyWith(
            color: done ? colors.onAccent : colors.restText,
          ),
        ),
      ),
    );
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: AppSize.minTouch),
      child: done
          ? DecoratedBox(
              decoration: BoxDecoration(
                color: colors.rest,
                borderRadius: radius,
              ),
              child: label,
            )
          : CustomPaint(
              painter: _DashedBorder(
                color: colors.rest,
                radius: AppRadius.chip,
              ),
              child: label,
            ),
    );
  }
}

/// Paints the dashed outline of a part not taken yet.
class _DashedBorder extends CustomPainter {
  new({required this.color, required this.radius});

  final Color color;
  final double radius;

  static const _dash = 5.0;
  static const _gap = 4.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          (Offset.zero & size).deflate(0.75),
          Radius.circular(radius),
        ),
      );
    for (final metric in path.computeMetrics()) {
      for (var d = 0.0; d < metric.length; d += _dash + _gap) {
        canvas.drawPath(metric.extractPath(d, d + _dash), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorder old) =>
      old.color != color || old.radius != radius;
}

/// "Correction" (screen 8): the duration of the last break, a journal edit.
class _Correction extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final colors = context.colors;
    final at = watchSnapshot(
      ref,
      (s) => (shiftStart: s.shift?.start, now: minuteOf(s.now)),
    );
    final periods = ref.watch(activityPeriodsProvider).value;
    final shiftStart = at?.shiftStart;
    final info = at == null || shiftStart == null || periods == null
        ? null
        : lastBreakInfo(periods, shiftStart, at.now);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(l.breakCorrection),
        CardGroup(
          children: [
            if (info == null)
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.cardPadding),
                  child: Text(
                    l.breakNoBreak,
                    style: AppTextStyles.body.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ),
              )
            else
              _LastBreakRow(
                open: info.open,
                duration: info.duration,
                onTap: () => unawaited(openBreakCorrection(context, ref)),
              ),
          ],
        ),
      ],
    );
  }
}

/// "Last break 0:15 ›" (or the one in progress): a tap opens the correction.
class _LastBreakRow extends StatelessWidget {
  const new({required this.open, required this.duration, required this.onTap});

  /// Перерыв ещё идёт.
  final bool open;
  final Duration duration;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return MergeSemantics(
      child: InkWell(
        onTap: onTap,
        child: CardRow(
          child: Row(
            children: [
              Expanded(
                child: Text(
                  open ? l.breakCurrentDuration : l.breakLastDuration,
                  style: AppTextStyles.rowTitle,
                ),
              ),
              const SizedBox(width: AppSpacing.s8),
              DurationText(
                formatHm(duration),
                spoken: spokenDuration(l, duration),
                style: AppTextStyles.value,
              ),
              const SizedBox(width: AppSpacing.s4),
              Icon(Icons.chevron_right, color: context.colors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

/// Explains the 15 + 30 split rule.
class _SplitRule extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.betweenCardsMax,
        AppSpacing.screenPadding,
        0,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, size: 20, color: colors.textSecondary),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.breakSplitTitle, style: AppTextStyles.rowTitle),
                    const SizedBox(height: AppSpacing.s4),
                    Text(
                      l.breakSplitText,
                      style: AppTextStyles.body.copyWith(
                        color: colors.chipText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
