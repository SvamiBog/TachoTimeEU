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

typedef _Break = ({
  bool shift,
  bool resting,
  int taken,
  int? first,
  DateTime? firstStart,
  int? current,
  int? required,
  bool counted,
});

_Break _break(ComplianceSnapshot s) {
  final first = s.breakFirstPart;
  final current = s.currentBreak;
  final secondPart = current?.required == EuLimits.breakSplitSecond;
  final taken = current == null
      ? first?.duration ?? Duration.zero
      : (secondPart ? first?.duration ?? Duration.zero : Duration.zero) +
            current.duration;
  return (
    shift: s.shift != null,
    resting: s.currentMode == DriverMode.rest,
    taken: minutes(taken),
    first: first == null ? null : minutes(first.duration),
    firstStart: first?.start,
    current: current == null ? null : minutes(current.duration),
    required: current == null ? null : minutes(current.required),
    counted:
        s.shift != null &&
        current != null &&
        s.continuousDriving == Duration.zero,
  );
}

/// Экран 8 «Перерыв»: 45 мин подряд или 15 + 30 после 4:30 вождения.
/// Корректировка длительности — правка журнала (Premium), в журнале.
class BreakScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final s = watchSnapshot(ref, _break);
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

class _Summary extends StatelessWidget {
  const new(this.s);

  final _Break s;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    const splitFirst = EuLimits.breakSplitFirst;
    const splitSecond = EuLimits.breakSplitSecond;
    final firstDone =
        s.first != null ||
        (s.current ?? 0) >= splitFirst.inMinutes && s.required == 45;
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
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12,
                runSpacing: 4,
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
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _Part(
                      firstDone
                          ? l.breakPartDone(splitFirst.inMinutes)
                          : l.breakPart(splitFirst.inMinutes),
                      done: firstDone,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: _Part(
                      s.counted
                          ? l.breakPartDone(splitSecond.inMinutes)
                          : firstDone
                          ? l.breakPartLeft(splitSecond.inMinutes)
                          : l.breakPart(splitSecond.inMinutes),
                      done: s.counted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                caption,
                style: AppTextStyles.caption.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Часть перерыва: взята — заливка цветом отдыха, нет — пунктир.
class _Part extends StatelessWidget {
  const new(this.text, {required this.done});

  final String text;
  final bool done;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = BorderRadius.circular(AppRadius.chip);
    final label = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
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

/// «Корректировка» (экран 8): длительность последнего перерыва — правка
/// журнала.
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
              MergeSemantics(
                child: InkWell(
                  onTap: () => unawaited(openBreakCorrection(context, ref)),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: AppSize.listRow,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.cardPadding,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              info.open
                                  ? l.breakCurrentDuration
                                  : l.breakLastDuration,
                              style: AppTextStyles.rowTitle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          DurationText(
                            formatHm(info.duration),
                            spoken: spokenDuration(l, info.duration),
                            style: AppTextStyles.value,
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.chevron_right,
                            color: colors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

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
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.breakSplitTitle, style: AppTextStyles.rowTitle),
                    const SizedBox(height: 4),
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
