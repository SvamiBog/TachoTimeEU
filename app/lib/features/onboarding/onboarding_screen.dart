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
import 'package:tachogo/features/settings/exact_alarms.dart';
import 'package:tachogo/features/settings/language_sheet.dart';
import 'package:tachogo/notifications/alert_providers.dart';

/// Шаги онбординга. Макеты — 13 (приветствие) и 14 (настройка); режимы,
/// главные правила и автоопределение собраны из компонентов дизайн-системы.
enum OnboardingStep { welcome, modes, rules, setup, autoDetect }

/// Онбординг при первом запуске (UI-13): язык, режимы, главные правила для
/// тех, кто впервые с тахографом, тип тахографа, пакет мобильности,
/// уведомления, согласие на аналитику, автоопределение вождения. Выбор сразу
/// пишется в настройки; «Готово» отмечает онбординг пройденным — больше он
/// не показывается.
class OnboardingScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

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

/// Язык в правом верхнем углу приветствия (экран 13).
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

/// Индикатор шагов: текущий — полоска цвета вождения.
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

/// Заголовок и пояснение шага.
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

/// Кольцо из цветов режимов с «4:30 до перерыва» — картинка, а не таймер:
/// диктору достаточно заголовка.
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

/// Четыре лимита, о которых водитель должен знать с первого дня; остальное
/// — в «Инструкции и правилах».
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

typedef _Option = ({
  IconData icon,
  String label,
  bool selected,
  VoidCallback onTap,
});

/// Варианты карточками в ряд (экран 14): «Грузовик или автобус» /
/// «Фургон 2,5–3,5 т», «Цифровой» / «Аналоговый».
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

/// «Предупредим за 30 минут…», системный запрос уведомлений и точных
/// будильников (Android 14+).
class _NotificationsCard extends ConsumerStatefulWidget {
  const new({required this.lead});

  final Duration lead;

  @override
  ConsumerState<_NotificationsCard> createState() => _NotificationsCardState();
}

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
    final exact = ref.watch(exactAlarmsProvider).value;
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
              if (allowed ?? false) ...[
                DoneMark(l.notifyAllowed),
                if (exact == false) ...[
                  const SizedBox(height: 14),
                  Text(
                    l.notifyExactHint,
                    style: AppTextStyles.caption.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SecondaryButton(
                    label: l.notifyExact,
                    onPressed: () => unawaited(allowExactAlarms(ref)),
                  ),
                ],
              ] else
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

class _AutoDetect extends ConsumerStatefulWidget {
  const new();

  @override
  ConsumerState<_AutoDetect> createState() => _AutoDetectState();
}

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
