/// "Tachograph over Bluetooth" screen (beta, read only): how to connect, the
/// scan, the connection and what the tachograph reports for the driver now.
/// Nothing is saved: the figures live while the screen is open. The developer
/// build also shows the exchange log live, with copy and send.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/buttons.dart';
import 'package:tachogo/core/widgets/detail_scaffold.dart';
import 'package:tachogo/core/widgets/mode_style.dart';
import 'package:tachogo/core/widgets/sections.dart';
import 'package:tachogo/core/widgets/setting_rows.dart';
import 'package:tachogo/core/widgets/status_chip.dart';
import 'package:tachogo/core/widgets/value_row_layout.dart';
import 'package:tachogo/features/more/problem_report.dart';
import 'package:tachogo/features/tachograph/tachograph_controller.dart';
import 'package:tachogo/tachograph/exchange_log.dart';
import 'package:tachogo/tachograph/tachograph_platform.dart';
import 'package:tachogo/tachograph/tachograph_providers.dart';
import 'package:tachogo/tachograph/tachograph_values.dart';

void openTachograph(BuildContext context) => Navigator.of(context)
    .push(MaterialPageRoute<void>(builder: (_) => const TachographScreen()));

/// The "Tachograph over Bluetooth" screen.
class TachographScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final state = ref.watch(tachographControllerProvider);
    final controller = ref.read(tachographControllerProvider.notifier);
    final platform = ref.read(tachographPlatformProvider);
    // В сборке разработчика «Сообщить о проблеме» — в разделе журнала
    final logVisible = ref.watch(tachographLogVisibleProvider);
    final children = switch (state) {
      TachoStart() => const [_Intro()],
      TachoBlocked(:final reason) => [_Banner(_blocked(l, reason))],
      TachoSearching(:final devices, :final showAll) => [
        _Searching(devices: devices, showAll: showAll),
      ],
      TachoConnecting(:final device) => [
        CardGroup(
          children: [_ProgressRow(l.tachoConnecting(_name(l, device)))],
        ),
        _Note(l.tachoPairHint),
      ],
      TachoConnected(:final reading?) => [
        _Readings(reading, report: !logVisible),
      ],
      TachoConnected() => [
        CardGroup(children: [_ProgressRow(l.tachoWaiting)]),
      ],
      TachoFailed(:final problem) => [
        _Banner(_problem(l, problem), tone: Tone.violation),
        if (!logVisible) const _ReportRow(),
      ],
    };
    final bottom = switch (state) {
      TachoStart() => PrimaryButton(
        label: l.tachoFind,
        icon: Icons.bluetooth_searching,
        onPressed: () => unawaited(controller.search()),
      ),
      TachoBlocked(:final reason) => _BlockedButtons(
        reason: reason,
        retry: () => unawaited(controller.search()),
        platform: platform,
      ),
      TachoSearching() => SecondaryButton(
        label: l.tachoStop,
        onPressed: () => unawaited(controller.stop()),
      ),
      TachoConnecting() => SecondaryButton(
        label: l.cancel,
        onPressed: () => unawaited(controller.stop()),
      ),
      TachoConnected() => SecondaryButton(
        label: l.tachoDisconnect,
        onPressed: () => unawaited(controller.stop()),
      ),
      TachoFailed(:final problem, :final device) => PrimaryButton(
        label: l.tachoRetry,
        onPressed: () => unawaited(
          device != null && problem != TachoProblem.notTachograph
              ? controller.connect(device)
              : controller.search(),
        ),
      ),
    };
    return DetailScaffold(
      title: l.tachoTitle,
      subtitle: l.tachoBeta,
      bottom: bottom,
      children: [...children, if (logVisible) const _LogPanel()],
    );
  }
}

String _name(AppLocalizations l, FoundDevice device) =>
    device.name.isEmpty ? l.tachoUnnamed : device.name;

String _blocked(AppLocalizations l, BluetoothReadiness reason) =>
    switch (reason) {
      BluetoothReadiness.noPermission => l.tachoNoPermission,
      BluetoothReadiness.off => l.tachoBluetoothOff,
      BluetoothReadiness.locationOff => l.tachoLocationOff,
      BluetoothReadiness.unsupported => l.tachoUnsupported,
      // Сюда не попадает: поиск идёт при ready и unknown
      BluetoothReadiness.ready || BluetoothReadiness.unknown => l.tachoFailScan,
    };

String _problem(AppLocalizations l, TachoProblem problem) => switch (problem) {
  TachoProblem.scan => l.tachoFailScan,
  TachoProblem.connect => l.tachoFailConnect,
  TachoProblem.notTachograph => l.tachoFailNotTacho,
  TachoProblem.noAnswer => l.tachoFailNoAnswer,
  TachoProblem.lost => l.tachoFailLost,
  TachoProblem.refused => l.tachoFailRefused,
};

/// How to connect: what the app does and three steps.
class _Intro extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final steps = [l.tachoStepCard, l.tachoStepConsent, l.tachoStepPair];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Note(l.tachoLead, top: AppSpacing.s12),
        const SizedBox(height: AppSpacing.betweenCardsMax),
        CardGroup(
          children: [
            for (final (i, step) in steps.indexed)
              _StepRow(number: i + 1, text: step),
          ],
        ),
      ],
    );
  }
}

/// A numbered step: "1  Insert the driver card…".
class _StepRow extends StatelessWidget {
  const new({required this.number, required this.text});

  final int number;
  final String text;

  @override
  Widget build(BuildContext context) => MergeSemantics(
    child: CardRow(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '$number',
              style: AppTextStyles.value.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ),
          Expanded(child: Text(text, style: AppTextStyles.body)),
        ],
      ),
    ),
  );
}

/// The scan: progress, the devices found, "all devices" and a hint.
class _Searching extends ConsumerWidget {
  const new({required this.devices, required this.showAll});

  final List<FoundDevice> devices;
  final bool showAll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final controller = ref.read(tachographControllerProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.s12),
        CardGroup(
          children: [
            _ProgressRow(l.tachoSearching),
            for (final device in devices)
              NavRow(
                icon: Icons.bluetooth,
                title: _name(l, device),
                subtitle: device.id,
                onTap: () => unawaited(controller.connect(device)),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.betweenCardsMax),
        CardGroup(
          children: [
            SwitchRow(
              title: l.tachoShowAll,
              value: showAll,
              strong: false,
              onChanged: (value) => controller.showAll(value: value),
            ),
          ],
        ),
        _Note(l.tachoSearchHint),
      ],
    );
  }
}

/// What the tachograph reports: the activity now, today, the week and what
/// is left; a row is shown only if the tachograph gave its value.
class _Readings extends StatelessWidget {
  const new(this.reading, {required this.report});

  final TachographReading reading;

  /// Строка «Сообщить о проблеме» под данными.
  final bool report;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final r = reading;
    final today = [
      (l.rowContinuous, r.continuousDriving),
      (l.rowBreak, r.breakTotal),
      (l.rowDailyDriving, r.dailyDriving),
    ];
    final week = [
      (l.rowWeeklyDriving, r.weeklyDriving),
      (l.rowFortnightDriving, r.fortnightDriving),
    ];
    final left = [
      (l.tachoUntilDailyRest, r.untilDailyRest),
      (l.tachoUntilWeeklyRest, r.untilWeeklyRest),
      (l.tachoShiftLeft, r.shiftDrivingLeft),
      (l.tachoWeekLeft, r.weekDrivingLeft),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (r.consentMissing)
          _Banner(l.tachoNoConsent)
        else if (!r.hasDriverData)
          _Banner(l.tachoNoDriverData, tone: Tone.neutral),
        const SizedBox(height: AppSpacing.s12),
        CardGroup(
          children: [
            _ModeRow(mode: r.driver1Mode, moving: r.moving),
            if (r.currentActivity case final d?)
              _DurationRow(label: l.tachoCurrentActivity, value: d),
            if (r.driver2Mode case final mode?)
              _TextRow(label: l.tachoCoDriver, value: l.modeName(mode)),
          ],
        ),
        ..._section(l.sectionToday, today),
        ..._section(l.sectionWeek, week),
        ..._section(l.tachoLeftSection, left),
        _Note(l.tachoNote),
        if (report) const _ReportRow(),
      ],
    );
  }

  /// Раздел, если тахограф дал хотя бы одно значение.
  static List<Widget> _section(String title, List<(String, Duration?)> rows) {
    final known = [
      for (final (label, value) in rows)
        if (value != null) _DurationRow(label: label, value: value),
    ];
    if (known.isEmpty) return const [];
    return [SectionTitle(title), CardGroup(children: known)];
  }
}

/// The driver's activity as on the tachograph and whether the vehicle moves.
class _ModeRow extends StatelessWidget {
  const new({required this.mode, required this.moving});

  final DriverMode? mode;
  final bool? moving;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final mode = this.mode;
    final moving = this.moving;
    return MergeSemantics(
      child: CardRow(
        vertical: AppSpacing.s14,
        child: Row(
          children: [
            if (mode != null) ...[
              ModeIcon(mode, color: colors.mode(mode)),
              const SizedBox(width: AppSpacing.s12),
            ],
            Expanded(
              child: Text(
                mode == null ? l.tachoModeUnknown : l.modeName(mode),
                style: AppTextStyles.header.copyWith(
                  color: mode == null
                      ? colors.textSecondary
                      : colors.mode(mode),
                ),
              ),
            ),
            if (moving != null)
              StatusChip(moving ? l.tachoMoving : l.tachoStanding),
          ],
        ),
      ),
    );
  }
}

/// "Label — 4:30".
class _DurationRow extends StatelessWidget {
  const new({required this.label, required this.value});

  final String label;
  final Duration value;

  @override
  Widget build(BuildContext context) => MergeSemantics(
    child: CardRow(
      child: ValueRowLayout(
        text: Text(label, style: AppTextStyles.rowTitle),
        value: DurationText(
          formatHm(value),
          spoken: spokenDuration(context.l10n, value),
          style: AppTextStyles.value,
        ),
      ),
    ),
  );
}

/// "Label — text".
class _TextRow extends StatelessWidget {
  const new({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => MergeSemantics(
    child: CardRow(
      child: ValueRowLayout(
        text: Text(label, style: AppTextStyles.rowTitle),
        value: Text(value, style: AppTextStyles.rowTitle),
      ),
    ),
  );
}

/// A row with a spinner: searching, connecting, waiting for data.
class _ProgressRow extends StatelessWidget {
  const new(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => CardRow(
    child: Row(
      children: [
        const SizedBox.square(
          dimension: 22,
          child: CircularProgressIndicator(strokeWidth: 2.5),
        ),
        const SizedBox(width: AppSpacing.s14),
        Expanded(
          child: Semantics(
            liveRegion: true,
            child: Text(text, style: AppTextStyles.rowTitle),
          ),
        ),
      ],
    ),
  );
}

/// A banner with the screen side padding.
class _Banner extends StatelessWidget {
  const new(this.text, {this.tone = Tone.warning});

  final String text;
  final Tone tone;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(
      AppSpacing.screenPadding,
      AppSpacing.s12,
      AppSpacing.screenPadding,
      0,
    ),
    child: Semantics(liveRegion: true, child: StatusBanner(text, tone: tone)),
  );
}

/// A secondary paragraph under the cards.
class _Note extends StatelessWidget {
  const new(this.text, {this.top = AppSpacing.beforeSectionMin});

  final String text;
  final double top;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(
      AppSpacing.textInset,
      top,
      AppSpacing.textInset,
      0,
    ),
    child: Text(
      text,
      style: AppTextStyles.caption.copyWith(
        color: context.colors.textSecondary,
        height: 1.45,
      ),
    ),
  );
}

/// "Report a problem": the report carries the exchange log with the
/// tachograph (beta).
class _ReportRow extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
    padding: const EdgeInsets.only(top: AppSpacing.betweenCardsMax),
    child: CardGroup(
      children: [
        NavRow(
          icon: Icons.bug_report_outlined,
          title: context.l10n.problemTitle,
          onTap: () => unawaited(sendProblemReport(context, ref)),
        ),
      ],
    ),
  );
}

/// The exchange log live, in the developer build: the last lines, "Copy log"
/// and "Report a problem" with the whole log, in every state of the screen.
class _LogPanel extends ConsumerWidget {
  const new();

  /// Сколько последних строк видно; весь журнал — в копии и в отчёте.
  static const _visibleLines = 40;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final log = ref.watch(tachographLogProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(l.tachoLogTitle),
        CardGroup(
          children: [
            CardRow(
              child: ListenableBuilder(
                listenable: log,
                builder: (context, _) => _LogLines(log.lines),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.betweenCardsMax),
        CardGroup(
          children: [
            NavRow(
              icon: Icons.copy_outlined,
              title: l.tachoLogCopy,
              onTap: () => unawaited(_copy(context, log)),
            ),
            NavRow(
              icon: Icons.bug_report_outlined,
              title: l.problemTitle,
              onTap: () => unawaited(sendProblemReport(context, ref)),
            ),
          ],
        ),
      ],
    );
  }

  /// Весь журнал — в буфер обмена: вставить в сообщение разработчику.
  static Future<void> _copy(BuildContext context, ExchangeLog log) async {
    final messenger = ScaffoldMessenger.maybeOf(context);
    final copied = context.l10n.tachoLogCopied;
    await Clipboard.setData(ClipboardData(text: log.format()));
    messenger?.showSnackBar(SnackBar(content: Text(copied)));
  }
}

/// The last lines of the exchange log, newest at the bottom.
class _LogLines extends StatelessWidget {
  const new(this.lines);

  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    if (lines.isEmpty) {
      return Text(
        context.l10n.tachoLogEmpty,
        style: AppTextStyles.caption.copyWith(color: colors.textSecondary),
      );
    }
    final shown = lines.length > _LogPanel._visibleLines
        ? lines.sublist(lines.length - _LogPanel._visibleLines)
        : lines;
    return SelectableText(
      shown.join('\n'),
      style: AppTextStyles.numericCaption.copyWith(
        color: colors.textSecondary,
        height: 1.4,
      ),
    );
  }
}

/// Buttons for a phone that is not ready: the right settings and "Try again".
class _BlockedButtons extends StatelessWidget {
  const new({
    required this.reason,
    required this.retry,
    required this.platform,
  });

  final BluetoothReadiness reason;
  final VoidCallback retry;
  final TachographPlatform platform;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final (label, action) = switch (reason) {
      BluetoothReadiness.noPermission => (
        l.openSystemSettings,
        platform.openAppSettings,
      ),
      BluetoothReadiness.off => (l.tachoTurnOn, platform.openBluetoothSettings),
      BluetoothReadiness.locationOff => (
        l.openSystemSettings,
        platform.openLocationSettings,
      ),
      BluetoothReadiness.unsupported ||
      BluetoothReadiness.ready ||
      BluetoothReadiness.unknown => (null, null),
    };
    final retryButton = reason == BluetoothReadiness.noPermission
        ? PrimaryButton(label: l.tachoAllow, onPressed: retry)
        : SecondaryButton(label: l.tachoRetry, onPressed: retry);
    if (label == null || action == null) return retryButton;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (reason == BluetoothReadiness.noPermission) ...[
          retryButton,
          const SizedBox(height: AppSpacing.s8),
          SecondaryButton(label: label, onPressed: () => unawaited(action())),
        ] else ...[
          PrimaryButton(label: label, onPressed: () => unawaited(action())),
          const SizedBox(height: AppSpacing.s8),
          retryButton,
        ],
      ],
    );
  }
}
