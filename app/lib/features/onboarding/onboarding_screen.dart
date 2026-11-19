/// First-launch onboarding (screens 13 and 14).
library;

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
import 'package:tachogo/data/countries/country_providers.dart';
import 'package:tachogo/data/settings/settings_providers.dart';
import 'package:tachogo/features/onboarding/onboarding_setup.dart';
import 'package:tachogo/features/onboarding/onboarding_steps.dart';
import 'package:tachogo/features/settings/language_sheet.dart';

/// Onboarding steps. The mockups are 13 (welcome) and 14 (setup); the
/// activities, the main rules and automatic detection are built from the design
/// system components.
enum OnboardingStep { welcome, modes, rules, setup, autoDetect }

/// First-launch onboarding (UI-13): language, activities, the main rules for
/// those new to the tachograph, tachograph type, company country (required),
/// Mobility Package, notifications, analytics consent, automatic driving
/// detection. Each choice is written to settings at once; "Done" marks
/// onboarding as finished and it never shows again.
class OnboardingScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

/// The current step and the moves between steps.
class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  OnboardingStep _step = OnboardingStep.welcome;

  bool get _last => _step == OnboardingStep.values.last;

  void _back() =>
      setState(() => _step = OnboardingStep.values[_step.index - 1]);

  void _next() {
    if (_last) {
      unawaited(ref.read(settingsRepositoryProvider).setOnboardingDone());
    } else {
      setState(() => _step = OnboardingStep.values[_step.index + 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final first = _step == OnboardingStep.welcome;
    // Без страны фирмы с настройки дальше не идём: от неё зависит расчёт
    final blocked =
        _step == OnboardingStep.setup && ref.watch(baseCountryProvider) == null;
    return PopScope(
      // Системное «назад» — на прошлый шаг, с первого — выход
      canPop: first,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back();
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _TopBar(onBack: first ? null : _back),
              Expanded(
                child: switch (_step) {
                  OnboardingStep.welcome => const _Welcome(),
                  OnboardingStep.modes => const ModesStep(),
                  OnboardingStep.rules => const RulesStep(),
                  OnboardingStep.setup => const SetupStep(),
                  OnboardingStep.autoDetect => const AutoDetectStep(),
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.s24,
                  AppSpacing.s20,
                  AppSpacing.s24,
                  AppSpacing.s20,
                ),
                child: _StepDots(step: _step.index),
              ),
              if (blocked) const _CountryRequired(),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  0,
                  AppSpacing.screenPadding,
                  AppSpacing.screenBottom,
                ),
                child: PrimaryButton(
                  label: switch (_step) {
                    OnboardingStep.welcome => l.onbStart,
                    _ when _last => l.onbDone,
                    _ => l.onbNext,
                  },
                  onPressed: blocked ? null : _next,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The top bar: "‹" back from the second step on, the language on the first.
class _TopBar extends StatelessWidget {
  const new({required this.onBack});

  /// «Назад»; null — первый шаг: вместо стрелки язык.
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final onBack = this.onBack;
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: AppSize.header),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.s4,
          AppSpacing.s8,
          AppSpacing.s24,
          AppSpacing.s8,
        ),
        child: Row(
          children: [
            if (onBack != null)
              IconButton(
                onPressed: onBack,
                tooltip: context.l10n.back,
                icon: const Icon(Icons.arrow_back_ios_new, size: 22),
              ),
            const Spacer(),
            if (onBack == null) const _LanguageButton(),
          ],
        ),
      ),
    );
  }
}

/// "Choose the company country to go on" over the disabled "Next".
class _CountryRequired extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(
      AppSpacing.s24,
      0,
      AppSpacing.s24,
      AppSpacing.s12,
    ),
    child: Text(
      context.l10n.onbBaseCountryRequired,
      textAlign: TextAlign.center,
      style: AppTextStyles.caption.copyWith(
        color: context.colors.textSecondary,
      ),
    ),
  );
}

/// The language in the top right corner of the welcome step (screen 13).
class _LanguageButton extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final name = currentLanguageName(context);
    return Semantics(
      button: true,
      label: context.l10n.languageButton(name),
      excludeSemantics: true,
      child: Material(
        color: colors.surface,
        shape: StadiumBorder(side: BorderSide(color: colors.line)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => unawaited(showLanguageSheet(context)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppSize.minTouch),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.language, size: 20),
                  const SizedBox(width: AppSpacing.s8),
                  Text(name, style: AppTextStyles.rowTitle),
                  const SizedBox(width: AppSpacing.s6),
                  Icon(
                    Icons.expand_more,
                    size: 20,
                    color: colors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Step indicator: the current step is a bar in the driving colour.
class _StepDots extends StatelessWidget {
  const new({required this.step});

  final int step;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final count = OnboardingStep.values.length;
    return Semantics(
      label: context.l10n.onbStep(step + 1, count),
      child: Row(
        children: [
          for (var i = 0; i < count; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.s6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: i == step ? 24 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: i == step ? colors.drive : colors.switchOff,
                borderRadius: BorderRadius.circular(AppSize.progressBar / 2),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ───────────────────────── 1. Приветствие ─────────────────────────

/// Welcome step: the activities ring picture, the title and what the app does.
class _Welcome extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return LayoutBuilder(
      builder: (context, box) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: box.maxHeight),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.s16,
                    ),
                    child: Center(
                      child: _ModesRing(size: math.min(260, box.maxWidth - 48)),
                    ),
                  ),
                ),
                StepIntro(title: l.onbWelcomeTitle, text: l.onbWelcomeText),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A ring of the activity colours with "4:30 until break" — a picture, not a
/// timer: the title is enough for the screen reader.
class _ModesRing extends StatelessWidget {
  const new({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: size,
        child: CustomPaint(
          painter: _ModesRingPainter(colors),
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    formatHm(EuLimits.continuousDriving),
                    style: AppTextStyles.timer,
                  ),
                  Text(
                    context.l10n.heroUntilBreak.toLowerCase(),
                    style: AppTextStyles.caption.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Paints the four activity arcs of the picture.
class _ModesRingPainter extends CustomPainter {
  new(this.colors);

  static const _stroke = 18.0;

  final AppColors colors;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - _stroke) / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _stroke
      ..color = colors.line;
    canvas.drawCircle(center, radius, paint);
    paint.strokeCap = StrokeCap.round;
    final rect = Rect.fromCircle(center: center, radius: radius);
    // Доли круга, как на макете: вождение, отдых, работа, готовность
    for (final (from, to, color) in [
      (0.0, 0.426, colors.drive),
      (0.469, 0.639, colors.rest),
      (0.682, 0.767, colors.work),
      (0.810, 0.867, colors.available),
    ]) {
      canvas.drawArc(
        rect,
        -math.pi / 2 + 2 * math.pi * from,
        2 * math.pi * (to - from),
        false,
        paint..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(_ModesRingPainter old) => old.colors != colors;
}
