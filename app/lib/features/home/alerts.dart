import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/infringement_text.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/sections.dart';
import 'package:tachogo/core/widgets/status_chip.dart';
import 'package:tachogo/features/home/snapshot_select.dart';

/// Предупреждения и нарушения из движка: нарушения выше предупреждений,
/// длительности — до минуты, чтобы секундный тик не перестраивал список.
/// «Скоро перерыв» не повторяем: о нём говорит плашка под кольцом.
ValueList<Infringement> _alerts(ComplianceSnapshot s) {
  Duration? trim(Duration? d) =>
      d == null ? null : Duration(minutes: minutes(d));
  final sorted = [
    for (final i in s.infringements)
      if (i.type != InfringementType.breakSoon) i,
  ]..sort((a, b) => b.severity.index.compareTo(a.severity.index));
  return ValueList([
    for (final i in sorted)
      Infringement(
        i.type,
        time: trim(i.time),
        limit: i.limit,
        requiredBreak: i.requiredBreak,
        count: i.count,
        days: i.days,
        article: i.article,
      ),
  ]);
}

class AlertsSection extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alerts = watchSnapshot(ref, _alerts)?.items ?? const [];
    if (alerts.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(context.l10n.sectionAlerts),
        for (final (i, alert) in alerts.indexed)
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              i == 0 ? 0 : AppSpacing.betweenCardsMin,
              AppSpacing.screenPadding,
              0,
            ),
            child: AlertCard(alert),
          ),
      ],
    );
  }
}

/// Плашка нарушения: заголовок, текст и статья — её видит инспектор.
class AlertCard extends StatelessWidget {
  const new(this.infringement, {super.key});

  final Infringement infringement;

  @override
  Widget build(BuildContext context) {
    final severity = infringement.severity;
    final tone = switch (severity) {
      InfringementSeverity.violation => Tone.violation,
      InfringementSeverity.warning => Tone.warning,
      InfringementSeverity.info => Tone.neutral,
    };
    final colors = context.colors;
    final c = tone == Tone.neutral
        ? (background: colors.surface, foreground: colors.text)
        : colors.tone(tone);
    final text = context.l10n.infringement(infringement);
    // Без liveRegion: время в тексте меняется каждую минуту, диктор
    // повторял бы плашку. О нарушении сообщит уведомление (Фаза 3).
    return Semantics(
      container: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.background,
          borderRadius: BorderRadius.circular(AppRadius.badge),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                switch (severity) {
                  InfringementSeverity.violation => Icons.warning_amber_rounded,
                  InfringementSeverity.warning => Icons.error_outline,
                  InfringementSeverity.info => Icons.info_outline,
                },
                size: 20,
                color: c.foreground,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text.title,
                      style: AppTextStyles.body.copyWith(
                        color: c.foreground,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      text.text,
                      style: AppTextStyles.caption.copyWith(
                        color: c.foreground,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      text.article,
                      style: AppTextStyles.small.copyWith(color: c.foreground),
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
