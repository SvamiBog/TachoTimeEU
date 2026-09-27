import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/mode_style.dart';
import 'package:tachogo/core/widgets/sections.dart';
import 'package:tachogo/core/widgets/status_chip.dart';
import 'package:tachogo/features/home/snapshot_select.dart';

/// Главная карточка: кольцо, плашка о перерыве, текущий режим.
class HeroCard extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(
      AppSpacing.screenPadding,
      8,
      AppSpacing.screenPadding,
      0,
    ),
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.heroCard),
      ),
      child: const Padding(
        padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: Column(
          children: [
            HeroRing(),
            HeroBanner(),
            SizedBox(height: 16),
            CurrentModeRow(),
          ],
        ),
      ),
    ),
  );
}

enum _RingKind { untilBreak, onBreak, dailyRest, weeklyRest }

typedef _Ring = ({
  _RingKind kind,
  int big,
  int continuous,
  int progress,
  int target,
  bool exceeded,
});

_Ring _ring(ComplianceSnapshot s) {
  final continuous = minutes(s.continuousDriving);
  if (s.offDutyRest case final rest?) {
    final target = rest.weekly
        ? EuLimits.weeklyRestRegular
        : EuLimits.dailyRestRegular;
    return (
      kind: rest.weekly ? _RingKind.weeklyRest : _RingKind.dailyRest,
      big: minutes(rest.duration),
      continuous: continuous,
      progress: minutes(rest.duration),
      target: minutes(target),
      exceeded: false,
    );
  }
  if (s.currentBreak case final b? when s.shift != null) {
    return (
      kind: _RingKind.onBreak,
      big: minutes(b.duration),
      continuous: continuous,
      progress: minutes(b.duration),
      target: minutes(b.required),
      exceeded: false,
    );
  }
  final over = s.infringement(InfringementType.continuousExceeded)?.time;
  return (
    kind: _RingKind.untilBreak,
    big: over == null ? minutes(s.drivingUntilBreak) : -minutes(over),
    continuous: continuous,
    progress: continuous,
    target: minutes(EuLimits.continuousDriving),
    exceeded: over != null,
  );
}

/// Кольцо: до перерыва, идущий перерыв или отдых после смены.
class HeroRing extends ConsumerWidget {
  const new({super.key});

  static const size = 240.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ring = watchSnapshot(ref, _ring);
    if (ring == null) return const SizedBox(height: size);
    final l = context.l10n;
    final colors = context.colors;
    final color = switch (ring.kind) {
      _RingKind.untilBreak => ring.exceeded ? colors.errorText : colors.drive,
      _ => colors.rest,
    };
    final label = switch (ring.kind) {
      _RingKind.untilBreak => l.heroUntilBreak,
      _RingKind.onBreak => l.heroBreak,
      _RingKind.dailyRest => l.heroDailyRest,
      _RingKind.weeklyRest => l.heroWeeklyRest,
    };
    final caption = switch (ring.kind) {
      _RingKind.untilBreak || _RingKind.onBreak => l.heroContinuousOf(
        formatHm(Duration(minutes: ring.continuous)),
        formatHm(EuLimits.continuousDriving),
      ),
      _ => l.ofLimit(formatLimit(l, Duration(minutes: ring.target))),
    };
    final big = Duration(minutes: ring.big);
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _RingPainter(
          fraction: ring.target == 0 ? 0 : ring.progress / ring.target,
          track: colors.line,
          color: color,
        ),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Диктор читает подпись вместе с таймером
                ExcludeSemantics(
                  child: Text(
                    label.toUpperCase(),
                    style: AppTextStyles.label.copyWith(
                      color: colors.textSecondary,
                      letterSpacing: AppTextStyles.label.fontSize! * 0.08,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                DurationText(
                  formatHm(big),
                  spoken: '$label, ${spokenDuration(l, big)}',
                  style: AppTextStyles.timer.copyWith(color: color),
                ),
                const SizedBox(height: 4),
                Text(caption, style: AppTextStyles.body),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  new({required this.fraction, required this.track, required this.color});

  static const stroke = 14.0;

  final double fraction;
  final Color track;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - stroke) / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = track;
    canvas.drawCircle(center, radius, paint);
    final sweep = 2 * math.pi * fraction.clamp(0, 1);
    if (sweep <= 0) return;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweep,
      false,
      paint
        ..color = color
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.fraction != fraction || old.track != track || old.color != color;
}

enum _Banner { breakCounted, onBreak, exceeded, need30, need45, offDuty }

typedef _BannerState = ({_Banner? kind, int breakMinutes, int required});

_BannerState _banner(ComplianceSnapshot s) {
  final b = s.currentBreak;
  const none = (kind: null, breakMinutes: 0, required: 0);
  if (s.offDutyRest != null) {
    return (kind: _Banner.offDuty, breakMinutes: 0, required: 0);
  }
  if (b != null && s.shift != null) {
    return s.continuousDriving == Duration.zero
        ? (kind: _Banner.breakCounted, breakMinutes: 0, required: 0)
        : (
            kind: _Banner.onBreak,
            breakMinutes: minutes(b.duration),
            required: minutes(b.required),
          );
  }
  if (s.has(InfringementType.continuousExceeded)) {
    return (kind: _Banner.exceeded, breakMinutes: 0, required: 0);
  }
  final firstPart = s.breakFirstPart != null;
  final started = s.shift != null && s.continuousDriving > Duration.zero;
  if (s.has(InfringementType.breakSoon) || (started && firstPart)) {
    return (
      kind: firstPart ? _Banner.need30 : _Banner.need45,
      breakMinutes: 0,
      required: 0,
    );
  }
  return none;
}

/// Плашка под кольцом — только когда есть что сказать.
class HeroBanner extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = watchSnapshot(ref, _banner);
    final kind = state?.kind;
    if (state == null || kind == null) return const SizedBox.shrink();
    final l = context.l10n;
    final (text, tone) = switch (kind) {
      _Banner.breakCounted => (
        l.bannerBreakCounted(formatHm(EuLimits.continuousDriving)),
        Tone.rest,
      ),
      _Banner.onBreak => (
        l.bannerOnBreak(
          formatHm(Duration(minutes: state.breakMinutes)),
          state.required,
        ),
        Tone.rest,
      ),
      _Banner.exceeded => (l.infrContinuousExceededTitle, Tone.violation),
      _Banner.need30 => (l.bannerBreakNeeded30, Tone.warning),
      _Banner.need45 => (l.bannerBreakNeeded45, Tone.warning),
      _Banner.offDuty => (l.heroOffDutyHint, Tone.rest),
    };
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: StatusBanner(text, tone: tone),
    );
  }
}

typedef _Mode = ({DriverMode? mode, DateTime? since, int duration});

_Mode _mode(ComplianceSnapshot s) => (
  mode: s.currentMode,
  since: s.currentModeStart,
  duration: minutes(s.currentModeDuration),
);

/// Текущий режим: «● Отдых с 11:37      0:00».
class CurrentModeRow extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = watchSnapshot(ref, _mode);
    final l = context.l10n;
    final colors = context.colors;
    final mode = state?.mode;
    if (state == null || mode == null) {
      return Align(
        alignment: AlignmentDirectional.centerStart,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            l.modeNone,
            style: AppTextStyles.body.copyWith(color: colors.textSecondary),
          ),
        ),
      );
    }
    final duration = Duration(minutes: state.duration);
    final name = l.modeName(mode);
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: colors.mode(mode),
              shape: BoxShape.circle,
            ),
            child: const SizedBox.square(dimension: 10),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: name, style: AppTextStyles.rowTitle),
                  if (state.since case final since?)
                    TextSpan(
                      text: ' ${l.modeSince(formatClock(since))}',
                      style: AppTextStyles.body.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          DurationText(
            formatHm(duration),
            spoken: '$name, ${spokenDuration(l, duration)}',
            style: AppTextStyles.modeTimer,
          ),
        ],
      ),
    );
  }
}
