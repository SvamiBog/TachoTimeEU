/// Onboarding steps that set the app up: tachograph, company country,
/// Mobility Package, notifications, analytics consent and automatic driving
/// detection. Each choice is written to settings at once.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/background/tracking_providers.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/buttons.dart';
import 'package:tachogo/core/widgets/sections.dart';
import 'package:tachogo/core/widgets/setting_rows.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/data/settings/settings_providers.dart';
import 'package:tachogo/data/settings/settings_repository.dart';
import 'package:tachogo/features/onboarding/onboarding_steps.dart';
import 'package:tachogo/features/settings/auto_detect.dart';
import 'package:tachogo/features/settings/base_country.dart';

// ───────────────────────── 4. Настройка ─────────────────────────

/// Setup step (screen 14): tachograph type, company country (required — "Next"
/// waits for it), Mobility Package, notifications, analytics consent.
class SetupStep extends ConsumerWidget {
  const new({super.key});

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
      padding: const EdgeInsets.only(bottom: AppSpacing.s8),
      children: [
        StepIntro(title: l.onbSetupTitle, text: l.onbSetupText),
        SectionTitle(l.settingsTachograph, top: AppSpacing.beforeSectionMin),
        _TachographChoice(
          value: prefs.tachograph,
          onChanged: (t) => unawaited(repo.setTachograph(t)),
        ),
        SectionTitle(l.settingsRules, top: AppSpacing.beforeSectionMin),
        CardGroup(
          children: [
            const BaseCountryRow(),
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

/// "Digital" / "Analogue" tachograph as two option cards.
class _TachographChoice extends StatelessWidget {
  const new({required this.value, required this.onChanged});

  final TachographType value;
  final ValueChanged<TachographType> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return _Options(
      options: [
        (
          icon: Icons.credit_card,
          label: l.tachographDigital,
          selected: value == TachographType.digital,
          onTap: () => onChanged(TachographType.digital),
        ),
        (
          icon: Icons.album_outlined,
          label: l.tachographAnalog,
          selected: value == TachographType.analog,
          onTap: () => onChanged(TachographType.analog),
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
            if (i > 0) const SizedBox(width: AppSpacing.s8),
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
                  const SizedBox(height: AppSpacing.s16),
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

/// Asks for the permission through [NotificationPermissionAsking].
class _NotificationsCardState extends ConsumerState<_NotificationsCard>
    with NotificationPermissionAsking {
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
                  const SizedBox(width: AppSpacing.s14),
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
              const SizedBox(height: AppSpacing.s14),
              if (allowed ?? false)
                DoneMark(l.notifyAllowed)
              else
                SecondaryButton(
                  label: notificationsAsked
                      ? l.openSystemSettings
                      : l.notifyAllow,
                  onPressed: () => unawaited(allowNotifications()),
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
class AutoDetectStep extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<AutoDetectStep> createState() => _AutoDetectStepState();
}

/// Turns automatic detection on through [AutoDetectEnabling].
class _AutoDetectStepState extends ConsumerState<AutoDetectStep>
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
      padding: const EdgeInsets.only(bottom: AppSpacing.s8),
      children: [
        StepIntro(title: l.autoTitle, text: l.onbAutoText),
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
            AppSpacing.textInset,
            AppSpacing.s12,
            AppSpacing.textInset,
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
