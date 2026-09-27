import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/background/tracking_providers.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/choice_pill.dart';
import 'package:tachogo/core/widgets/confirm_sheet.dart';
import 'package:tachogo/core/widgets/sections.dart';
import 'package:tachogo/core/widgets/segmented_tabs.dart';
import 'package:tachogo/core/widgets/setting_rows.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/data/settings/settings_providers.dart';
import 'package:tachogo/data/settings/settings_repository.dart';
import 'package:tachogo/features/export/export_sheet.dart';
import 'package:tachogo/features/settings/auto_detect.dart';
import 'package:tachogo/features/settings/exact_alarms.dart';
import 'package:tachogo/features/settings/language_sheet.dart';
import 'package:tachogo/notifications/alert_providers.dart';

/// Пороги предупреждения о лимитах (экран 3).
const warningLeads = [
  Duration(minutes: 15),
  Duration(minutes: 30),
  Duration(hours: 1),
];

/// За сколько дней напоминать о считывании карты.
const cardAlertDays = [3, 7, 14];

/// «15 мин», «1 час».
String leadLabel(AppLocalizations l, Duration lead) => lead.inMinutes % 60 == 0
    ? l.leadHours(lead.inHours)
    : l.leadMinutes(lead.inMinutes);

/// Настройки (экран 3). Каждое изменение сразу пишется в БД: расчёт, тема
/// и язык перестраиваются по потокам настроек, кнопки «Сохранить» нет.
class SettingsScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 64),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding + 4,
                  vertical: 8,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Semantics(
                    header: true,
                    child: Text(l.navSettings, style: AppTextStyles.header),
                  ),
                ),
              ),
            ),
            SectionTitle(l.settingsGeneral, top: 12),
            const _GeneralCard(),
            SectionTitle(l.settingsRules, top: AppSpacing.beforeSectionMin),
            const _RulesCard(),
            SectionTitle(
              l.settingsNotifications,
              top: AppSpacing.beforeSectionMin,
            ),
            const _NotificationsCard(),
            SectionTitle(l.autoTitle, top: AppSpacing.beforeSectionMin),
            const AutoDetectCard(),
            SectionTitle(l.settingsData, top: AppSpacing.beforeSectionMin),
            const _DataCard(),
          ],
        ),
      ),
    );
  }
}

/// Язык и оформление.
class _GeneralCard extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme =
        ref.watch(preferencesProvider).value?.theme ?? ThemeChoice.dark;
    return CardGroup(
      children: [
        NavRow(
          title: l.settingsLanguage,
          value: currentLanguageName(context),
          onTap: () => unawaited(showLanguageSheet(context)),
        ),
        ChoiceBlock(
          title: l.settingsTheme,
          child: SegmentedTabs<ThemeChoice>(
            options: [
              (value: ThemeChoice.system, label: l.themeSystem, detail: null),
              (value: ThemeChoice.light, label: l.themeLight, detail: null),
              (value: ThemeChoice.dark, label: l.themeDark, detail: null),
            ],
            value: theme,
            onChanged: (t) =>
                unawaited(ref.read(settingsRepositoryProvider).setTheme(t)),
          ),
        ),
      ],
    );
  }
}

/// Тахограф, пакет мобильности, экипаж — от последних двух зависит расчёт.
class _RulesCard extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final repo = ref.read(settingsRepositoryProvider);
    final tachograph =
        ref.watch(preferencesProvider).value?.tachograph ??
        TachographType.digital;
    final rules =
        ref.watch(complianceSettingsProvider).value ??
        const ComplianceSettings();
    return CardGroup(
      children: [
        ChoiceBlock(
          title: l.settingsTachograph,
          child: TachographTabs(
            value: tachograph,
            onChanged: (t) => unawaited(repo.setTachograph(t)),
          ),
        ),
        SwitchRow(
          title: l.settingsMobility,
          subtitle: l.settingsMobilityHint,
          value: rules.mobilityPackage,
          onChanged: (on) =>
              unawaited(repo.updateComplianceSettings(mobilityPackage: on)),
        ),
        SwitchRow(
          title: l.settingsCrew,
          subtitle: l.settingsCrewHint,
          value: rules.crew == CrewMode.team,
          onChanged: (on) => unawaited(
            repo.updateComplianceSettings(
              crew: on ? CrewMode.team : CrewMode.solo,
            ),
          ),
        ),
      ],
    );
  }
}

/// «Цифровой / Аналоговый» — в настройках и онбординге.
class TachographTabs extends StatelessWidget {
  const new({required this.value, required this.onChanged, super.key});

  final TachographType value;
  final ValueChanged<TachographType> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return SegmentedTabs<TachographType>(
      options: [
        (
          value: TachographType.digital,
          label: l.tachographDigital,
          detail: null,
        ),
        (value: TachographType.analog, label: l.tachographAnalog, detail: null),
      ],
      value: value,
      onChanged: onChanged,
    );
  }
}

/// Порог предупреждений и категории уведомлений. Порог сразу меняет
/// плашки «скоро» на экранах и момент уведомлений; расписание
/// пересчитывается само (`AlertScheduler`).
class _NotificationsCard extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final repo = ref.read(settingsRepositoryProvider);
    final rules =
        ref.watch(complianceSettingsProvider).value ??
        const ComplianceSettings();
    final notify =
        ref.watch(notificationSettingsProvider).value ??
        const NotificationSettings();
    final allowed = ref.watch(trackingHealthProvider).value?.notifications;
    final exact = ref.watch(exactAlarmsProvider).value;
    void save(NotificationSettings s) => unawaited(repo.setNotifications(s));
    return CardGroup(
      children: [
        if (allowed == false) const NotificationPermissionRow(),
        if (exact == false) const ExactAlarmsRow(),
        ChoiceBlock(
          title: l.settingsWarnLead,
          subtitle: l.settingsWarnLeadHint,
          child: Semantics(
            container: true,
            label: l.settingsWarnLeadGroup,
            child: PillWrap(
              children: [
                for (final lead in warningLeads)
                  ChoicePill(
                    leadLabel(l, lead),
                    selected: rules.warningLead == lead,
                    onTap: () => unawaited(
                      repo.updateComplianceSettings(warningLead: lead),
                    ),
                  ),
              ],
            ),
          ),
        ),
        SwitchRow(
          title: l.notifyBreak,
          strong: false,
          value: notify.breaks,
          onChanged: (on) => save(notify.copyWith(breaks: on)),
        ),
        SwitchRow(
          title: l.notifyShiftEnd,
          subtitle: l.notifyShiftEndHint,
          strong: false,
          value: notify.shiftEnd,
          onChanged: (on) => save(notify.copyWith(shiftEnd: on)),
        ),
        SwitchRow(
          title: l.notifyDriving,
          strong: false,
          value: notify.driving,
          onChanged: (on) => save(notify.copyWith(driving: on)),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SwitchRow(
              title: l.notifyCard,
              subtitle: l.notifyCardHint,
              strong: false,
              value: notify.card,
              onChanged: (on) => save(notify.copyWith(card: on)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.cardPadding,
                0,
                AppSpacing.cardPadding,
                AppSpacing.cardPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.notifyCardLead,
                    style: AppTextStyles.caption.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Semantics(
                    container: true,
                    label: l.notifyCardLeadGroup,
                    child: PillWrap(
                      children: [
                        for (final days in cardAlertDays)
                          ChoicePill(
                            l.leadDays(days),
                            selected: rules.cardAlertDays == days,
                            onTap: () => unawaited(
                              repo.updateComplianceSettings(
                                cardAlertDays: days,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// «Разрешить уведомления», пока они запрещены в телефоне. Первый раз —
/// системный запрос; если телефон больше не спрашивает (отказ навсегда), —
/// настройки приложения в системе.
class NotificationPermissionRow extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<NotificationPermissionRow> createState() =>
      _NotificationPermissionRowState();
}

class _NotificationPermissionRowState
    extends ConsumerState<NotificationPermissionRow> {
  bool _asked = false;

  Future<void> _allow() async {
    final service = ref.read(trackingServiceProvider);
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
    return NavRow(
      icon: Icons.notifications_off_outlined,
      title: _asked ? l.openSystemSettings : l.notifyAllow,
      subtitle: l.notifyDenied,
      onTap: () => unawaited(_allow()),
    );
  }
}

/// Экспорт, согласие на аналитику, очистка данных.
class _DataCard extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final consent = ref.watch(analyticsConsentProvider).value ?? false;
    return CardGroup(
      children: [
        NavRow(
          title: l.settingsExport,
          value: l.settingsExportFormats,
          onTap: () => unawaited(showExportSheet(context)),
        ),
        SwitchRow(
          title: l.settingsAnalytics,
          subtitle: l.settingsAnalyticsHint,
          value: consent,
          onChanged: (on) => unawaited(
            ref
                .read(settingsRepositoryProvider)
                .setAnalyticsConsent(granted: on),
          ),
        ),
        const _ClearDataRow(),
      ],
    );
  }
}

/// «Очистить все данные» — только после подтверждения (UI-16).
class _ClearDataRow extends ConsumerWidget {
  const new();

  Future<void> _clear(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final ok = await showConfirmSheet(
      context,
      title: l.clearTitle,
      text: l.clearText,
      confirm: l.clearConfirm,
      cancel: l.cancel,
      danger: true,
    );
    if (ok != true) return;
    await ref.read(journalCleanerProvider).clearAll();
    messenger.showSnackBar(SnackBar(content: Text(l.clearDone)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = context.colors.errorText;
    return Semantics(
      button: true,
      child: InkWell(
        onTap: () => unawaited(_clear(context, ref)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppSize.listRow),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.cardPadding,
              vertical: 10,
            ),
            child: Row(
              children: [
                Icon(Icons.delete_outline, size: 22, color: color),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    context.l10n.settingsClear,
                    style: AppTextStyles.rowTitle.copyWith(color: color),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
