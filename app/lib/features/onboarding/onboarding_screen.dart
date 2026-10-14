/// First-launch onboarding (screens 13 and 14).
library;

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/background/tracking_providers.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/buttons.dart';
import 'package:tachogo/core/widgets/mode_style.dart';
import 'package:tachogo/core/widgets/sections.dart';
import 'package:tachogo/core/widgets/setting_rows.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/data/settings/settings_providers.dart';
import 'package:tachogo/data/settings/settings_repository.dart';
import 'package:tachogo/features/guide/guide_screen.dart';
import 'package:tachogo/features/settings/auto_detect.dart';
import 'package:tachogo/features/settings/language_sheet.dart';

/// Onboarding steps. The mockups are 13 (welcome) and 14 (setup); the
/// activities, the main rules and automatic detection are built from the design
/// system components.
enum OnboardingStep { welcome, modes, rules, setup, autoDetect }

/// First-launch onboarding (UI-13): language, activities, the main rules for
/// those new to the tachograph, tachograph type, Mobility Package,
/// notifications, analytics consent, automatic driving detection. Each choice
/// is written to settings at once; "Done" marks onboarding as finished and it
/// never shows again.
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
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 64),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4, 8, 24, 8),
                  child: Row(
                    children: [
                      if (!first)
                        IconButton(
                          onPressed: _back,
                          tooltip: l.back,
                          icon: const Icon(Icons.arrow_back_ios_new, size: 22),
                        ),
                      const Spacer(),
                      if (first) const _LanguageButton(),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: switch (_step) {
                  OnboardingStep.welcome => const _Welcome(),
                  OnboardingStep.modes => const _Modes(),
                  OnboardingStep.rules => const _Rules(),
                  OnboardingStep.setup => const _Setup(),
                  OnboardingStep.autoDetect => const _AutoDetect(),
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                child: _StepDots(step: _step.index),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  0,
                  AppSpacing.screenPadding,
                  24,
                ),
                child: PrimaryButton(
                  label: switch (_step) {
                    OnboardingStep.welcome => l.onbStart,
                    _ when _last => l.onbDone,
                    _ => l.onbNext,
                  },
                  onPressed: _next,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
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
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.language, size: 20),
                  const SizedBox(width: 8),
                  Text(name, style: AppTextStyles.rowTitle),
                  const SizedBox(width: 6),
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
            if (i > 0) const SizedBox(width: 6),
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

/// Title and explanation of a step.
class _Intro extends StatelessWidget {
  const new({required this.title, required this.text});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(title, style: AppTextStyles.screenTitle),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: AppTextStyles.body.copyWith(
            color: context.colors.textSecondary,
            height: 1.45,
          ),
        ),
      ],
    ),
  );
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
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: _ModesRing(size: math.min(260, box.maxWidth - 48)),
                    ),
                  ),
                ),
                _Intro(title: l.onbWelcomeTitle, text: l.onbWelcomeText),
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

// ───────────────────────── 2. Режимы и таймеры ─────────────────────────

/// Activities step: the four activities with their symbols and what each means.
class _Modes extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    String about(DriverMode mode) => switch (mode) {
      DriverMode.driving => l.onbModeDriving,
      DriverMode.otherWork => l.onbModeWork,
      DriverMode.availability => l.onbModeAvailability,
      DriverMode.rest => l.onbModeRest,
    };
    return ListView(
      padding: const EdgeInsets.only(bottom: 8),
      children: [
        _Intro(title: l.onbModesTitle, text: l.onbModesText),
        const SizedBox(height: AppSpacing.beforeSectionMin),
        CardGroup(
          children: [
            for (final mode in const [
              DriverMode.driving,
              DriverMode.otherWork,
              DriverMode.availability,
              DriverMode.rest,
            ])
              MergeSemantics(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.cardPadding),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: AppSize.minTouch,
                        height: AppSize.minTouch,
                        decoration: BoxDecoration(
                          color: colors.surface2,
                          borderRadius: BorderRadius.circular(AppRadius.icon),
                        ),
                        alignment: Alignment.center,
                        child: IconTheme(
                          data: IconThemeData(color: colors.mode(mode)),
                          child: ModeIcon(mode, size: 24),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l.modeName(mode),
                              style: AppTextStyles.rowTitle,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              about(mode),
                              style: AppTextStyles.caption.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

// ───────────────────────── 3. Главные правила ─────────────────────────

/// The four limits a driver must know from day one; the rest is in "Guide and
/// rules".
class _Rules extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return ListView(
      padding: const EdgeInsets.only(bottom: 8),
      children: [
        _Intro(title: l.onbRulesTitle, text: l.onbRulesText),
        const SizedBox(height: AppSpacing.beforeSectionMin),
        const CardGroup(
          children: [
            RuleRow(GuideRule.continuous),
            RuleRow(GuideRule.dailyDriving),
            RuleRow(GuideRule.dailyRest),
            RuleRow(GuideRule.weeklyRest),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding + 4,
            12,
            AppSpacing.screenPadding + 4,
            0,
          ),
          child: Text(
            l.onbRulesMore,
            style: AppTextStyles.caption.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

// ───────────────────────── 4. Настройка ─────────────────────────

/// Setup step (screen 14): tachograph type, Mobility Package, notifications,
/// analytics consent.
class _Setup extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final repo = ref.read(settingsRepositoryProvider);
    final prefs =
        ref.watch(preferencesProvider).value ?? const AppPreferences();
    final rules =
        ref.watch(complianceSettingsProvider).value ??
        const ComplianceSettings();
    final consent = ref.watch(analyticsConsentProvider).value ?? false;
    return ListView(
      padding: const EdgeInsets.only(bottom: 8),
      children: [
        _Intro(title: l.onbSetupTitle, text: l.onbSetupText),
        SectionTitle(l.settingsTachograph, top: AppSpacing.beforeSectionMin),
        _Options(
          options: [
            (
              icon: Icons.credit_card,
              label: l.tachographDigital,
              selected: prefs.tachograph == TachographType.digital,
              onTap: () =>
                  unawaited(repo.setTachograph(TachographType.digital)),
            ),
            (
              icon: Icons.album_outlined,
              label: l.tachographAnalog,
              selected: prefs.tachograph == TachographType.analog,
              onTap: () => unawaited(repo.setTachograph(TachographType.analog)),
            ),
          ],
        ),
        SectionTitle(l.settingsRules, top: AppSpacing.beforeSectionMin),
        CardGroup(
          children: [
            SwitchRow(
              title: l.settingsMobility,
              subtitle: l.onbMobilityHint,
              value: rules.mobilityPackage,
              onChanged: (on) =>
                  unawaited(repo.updateComplianceSettings(mobilityPackage: on)),
            ),
          ],
        ),
        SectionTitle(l.settingsNotifications, top: AppSpacing.beforeSectionMin),
        _NotificationsCard(lead: rules.warningLead),
        SectionTitle(l.settingsData, top: AppSpacing.beforeSectionMin),
        CardGroup(
          children: [
            SwitchRow(
              title: l.settingsAnalytics,
              subtitle: l.settingsAnalyticsHint,
              value: consent,
              onChanged: (on) =>
                  unawaited(repo.setAnalyticsConsent(granted: on)),
            ),
          ],
        ),
      ],
    );
  }
}

/// One option card: icon, label, whether it is selected and what a tap does.
typedef _Option = ({
  IconData icon,
  String label,
  bool selected,
  VoidCallback onTap,
});

/// Options as cards in a row (screen 14): "Digital" / "Analogue" tachograph.
class _Options extends StatelessWidget {
  const new({required this.options});

  final List<_Option> options;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
    child: IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (i, option) in options.indexed) ...[
            if (i > 0) const SizedBox(width: 8),
            Expanded(child: _OptionCard(option)),
          ],
        ],
      ),
    ),
  );
}

/// One option card, outlined in the driving colour when selected.
class _OptionCard extends StatelessWidget {
  const new(this.option);

  final _Option option;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      selected: option.selected,
      inMutuallyExclusiveGroup: true,
      button: true,
      child: Material(
        color: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.modeButton),
          side: BorderSide(
            color: option.selected ? colors.drive : colors.line,
            width: 2,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: option.onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 112),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(option.icon, size: 28),
                  const SizedBox(height: 16),
                  Text(option.label, style: AppTextStyles.header),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// "We will warn you 30 minutes before…" and the system notification permission
/// request. Exact alarms are not requested (decision 2026-10-13).
class _NotificationsCard extends ConsumerStatefulWidget {
  const new({required this.lead});

  final Duration lead;

  @override
  ConsumerState<_NotificationsCard> createState() => _NotificationsCardState();
}

/// Whether the system request was already shown: after that, the button opens
/// the app's system settings.
class _NotificationsCardState extends ConsumerState<_NotificationsCard> {
  bool _asked = false;

  Future<void> _allow() async {
    final service = ref.read(trackingServiceProvider);
    // Телефон больше не показывает запрос — только настройки системы
    if (_asked) {
      await service.openAppSettings();
    } else {
      await service.requestNotifications();
      if (mounted) setState(() => _asked = true);
    }
    if (mounted) ref.invalidate(trackingHealthProvider);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final allowed = ref.watch(trackingHealthProvider).value?.notifications;
    return CardGroup(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: AppSize.minTouch,
                    height: AppSize.minTouch,
                    decoration: BoxDecoration(
                      color: colors.surface2,
                      borderRadius: BorderRadius.circular(AppRadius.icon),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.notifications_none_outlined,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      l.onbNotifyText(widget.lead.inMinutes),
                      style: AppTextStyles.body.copyWith(
                        color: colors.chipText,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              if (allowed ?? false)
                DoneMark(l.notifyAllowed)
              else
                SecondaryButton(
                  label: _asked ? l.openSystemSettings : l.notifyAllow,
                  onPressed: () => unawaited(_allow()),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

// ───────────────────────── 5. Автоопределение ─────────────────────────

/// Automatic detection step: what it does, the permissions it needs and the
/// switch.
class _AutoDetect extends ConsumerStatefulWidget {
  const new();

  @override
  ConsumerState<_AutoDetect> createState() => _AutoDetectState();
}

/// Turns automatic detection on through [AutoDetectEnabling].
class _AutoDetectState extends ConsumerState<_AutoDetect>
    with AutoDetectEnabling {
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final enabled = ref.watch(autoDetectSettingsProvider).value?.enabled;
    final blocker = this.blocker;
    final hints = enabled ?? false
        ? backgroundHints(context, ref)
        : const <Widget>[];
    return ListView(
      padding: const EdgeInsets.only(bottom: 8),
      children: [
        _Intro(title: l.autoTitle, text: l.onbAutoText),
        const SizedBox(height: AppSpacing.beforeSectionMin),
        CardGroup(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              child: enabled ?? false
                  ? DoneMark(l.autoEnabled)
                  : SecondaryButton(
                      label: l.autoEnable,
                      onPressed: busy
                          ? null
                          : () => unawaited(enableAutoDetect()),
                    ),
            ),
            if (blocker != null) BlockerNotice(blocker),
          ],
        ),
        if (hints.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.betweenCardsMin),
          CardGroup(children: hints),
        ],
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding + 4,
            12,
            AppSpacing.screenPadding + 4,
            0,
          ),
          child: Text(
            l.onbAutoLater,
            style: AppTextStyles.caption.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
