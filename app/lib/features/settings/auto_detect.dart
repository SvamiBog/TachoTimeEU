import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/background/tracking_providers.dart';
import 'package:tachogo/background/tracking_service.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/buttons.dart';
import 'package:tachogo/core/widgets/mode_style.dart';
import 'package:tachogo/core/widgets/sections.dart';
import 'package:tachogo/core/widgets/segmented_tabs.dart';
import 'package:tachogo/core/widgets/setting_rows.dart';
import 'package:tachogo/core/widgets/status_chip.dart';
import 'package:tachogo/data/settings/settings_providers.dart';
import 'package:tachogo/data/settings/settings_repository.dart';

/// Включение автоопределения с экрана (онбординг и настройки, UI-14):
/// системные запросы доступа, причина отказа, проверка причины, когда
/// водитель вернулся из настроек телефона.
mixin AutoDetectEnabling<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  /// Почему автоопределение не включилось в последний раз.
  TrackingBlocker? blocker;

  /// Идёт системный запрос — переключатель не нажимается повторно.
  bool busy = false;

  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onResume: _onResume);
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  /// Водитель вернулся — возможно, из настроек телефона: разрешения и
  /// экономию батареи проверяем заново, ничего не запрашивая.
  Future<void> _onResume() async {
    ref.invalidate(trackingHealthProvider);
    if (blocker == null) return;
    final now = await ref.read(trackingServiceProvider).locationBlocker();
    if (mounted) setState(() => blocker = now);
  }

  Future<void> enableAutoDetect() async {
    setState(() {
      busy = true;
      blocker = null;
    });
    try {
      final result = await ref.read(trackingServiceProvider).enable();
      if (mounted) setState(() => blocker = result);
    } finally {
      if (mounted) {
        setState(() => busy = false);
        ref.invalidate(trackingHealthProvider);
      }
    }
  }

  Future<void> disableAutoDetect() async {
    setState(() => blocker = null);
    await ref.read(trackingServiceProvider).disable();
  }
}

/// Плашка-предупреждение и, если причину можно исправить в настройках
/// телефона, кнопка туда.
class SystemSettingsNotice extends StatelessWidget {
  const new({required this.text, this.onOpen, super.key});

  final String text;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final onOpen = this.onOpen;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StatusBanner(text, tone: Tone.warning),
          if (onOpen != null) ...[
            const SizedBox(height: 8),
            SecondaryButton(
              label: context.l10n.openSystemSettings,
              onPressed: onOpen,
            ),
          ],
        ],
      ),
    );
  }
}

/// Почему автоопределение не включилось. Отказ навсегда и выключенная
/// геолокация исправляются только в настройках телефона — туда кнопка.
class BlockerNotice extends ConsumerWidget {
  const new(this.blocker, {super.key});

  final TrackingBlocker blocker;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final service = ref.watch(trackingServiceProvider);
    return switch (blocker) {
      TrackingBlocker.locationServiceDisabled => SystemSettingsNotice(
        text: l.autoBlockedService,
        onOpen: () => unawaited(service.openLocationSettings()),
      ),
      TrackingBlocker.locationDenied => SystemSettingsNotice(
        text: l.autoBlockedDenied,
      ),
      TrackingBlocker.locationDeniedForever => SystemSettingsNotice(
        text: l.autoBlockedForever,
        onOpen: () => unawaited(service.openAppSettings()),
      ),
    };
  }
}

/// Android: экономия батареи и автозапуск оболочки производителя — без них
/// телефон останавливает сервис автоопределения (`docs/background.md`).
/// На iOS таких настроек нет — пустой список.
List<Widget> backgroundHints(BuildContext context, WidgetRef ref) {
  final service = ref.watch(trackingServiceProvider);
  if (!service.hasBackgroundRestrictions) return const [];
  final l = context.l10n;
  final battery = ref.watch(trackingHealthProvider).value?.battery;
  return [
    NavRow(
      icon: battery == false ? Icons.battery_alert : Icons.battery_full,
      title: l.autoBattery,
      subtitle: switch (battery) {
        false => l.autoBatteryLimited,
        true => l.autoBatteryOk,
        null => null,
      },
      onTap: () => unawaited(service.openBatteryOptimizationSettings()),
    ),
    NavRow(
      icon: Icons.restart_alt,
      title: l.autoAutostart,
      subtitle: l.autoAutostartHint,
      onTap: () => unawaited(service.openVendorBackgroundSettings()),
    ),
  ];
}

/// Раздел «Автоопределение вождения» в настройках: включение, режим после
/// остановки, вождение сразу после отдыха, подсказки про фон.
class AutoDetectCard extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<AutoDetectCard> createState() => _AutoDetectCardState();
}

class _AutoDetectCardState extends ConsumerState<AutoDetectCard>
    with AutoDetectEnabling {
  /// Режимы после остановки: вождением стоянка не бывает.
  static const List<DriverMode> _afterStop = [
    DriverMode.otherWork,
    DriverMode.availability,
    DriverMode.rest,
  ];

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final auto =
        ref.watch(autoDetectSettingsProvider).value ??
        const AutoDetectSettings();
    final health = ref.watch(trackingHealthProvider).value;
    final rules = auto.rules;
    final blocker = this.blocker;
    void setRules(AutoSwitchSettings rules) => unawaited(
      ref.read(settingsRepositoryProvider).setAutoDetectRules(rules),
    );
    return CardGroup(
      children: [
        SwitchRow(
          title: l.autoSwitch,
          subtitle: l.autoSwitchHint,
          value: auto.enabled,
          onChanged: busy
              ? null
              : (on) =>
                    unawaited(on ? enableAutoDetect() : disableAutoDetect()),
        ),
        if (blocker != null)
          BlockerNotice(blocker)
        else if (auto.enabled && health?.location == false)
          SystemSettingsNotice(
            text: l.autoNoAccess,
            onOpen: () =>
                unawaited(ref.read(trackingServiceProvider).openAppSettings()),
          ),
        if (auto.enabled) ...[
          ChoiceBlock(
            title: l.autoAfterStop,
            subtitle: l.autoAfterStopHint,
            child: SegmentedTabs<DriverMode>(
              options: [
                for (final m in _afterStop)
                  (value: m, label: l.modeButton(m), detail: null),
              ],
              value: rules.afterStop,
              onChanged: (m) => setRules(
                AutoSwitchSettings(
                  afterStop: m,
                  startFromRest: rules.startFromRest,
                ),
              ),
            ),
          ),
          SwitchRow(
            title: l.autoStartFromRest,
            subtitle: l.autoStartFromRestHint,
            value: rules.startFromRest,
            onChanged: (on) => setRules(
              AutoSwitchSettings(afterStop: rules.afterStop, startFromRest: on),
            ),
          ),
          ...backgroundHints(context, ref),
        ],
      ],
    );
  }
}

/// Иконка состояния «включено» / «разрешено» в онбординге.
class DoneMark extends StatelessWidget {
  const new(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      container: true,
      child: Row(
        children: [
          Icon(Icons.check_circle, size: 22, color: colors.rest),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: AppTextStyles.rowTitle)),
        ],
      ),
    );
  }
}
