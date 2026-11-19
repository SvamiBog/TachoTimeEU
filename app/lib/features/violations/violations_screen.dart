/// "Infringements" (More): the infringements of the last 56 days — the period
/// a driver presents at a roadside check — each with the driver's explanation.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/core/l10n/infringement_text.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/detail_scaffold.dart';
import 'package:tachogo/core/widgets/sections.dart';
import 'package:tachogo/core/widgets/status_chip.dart';
import 'package:tachogo/data/report/report.dart';
import 'package:tachogo/data/violations/violation_providers.dart';
import 'package:tachogo/features/home/detail_rows.dart';
import 'package:tachogo/features/violations/violation_note_sheet.dart';

void openViolations(BuildContext context) => Navigator.of(context)
    .push(MaterialPageRoute<void>(builder: (_) => const ViolationsScreen()));

/// Что показать под названием нарушения: наибольшее превышение, опоздание
/// или сколько отдыха не хватило. Предупреждений и считывания карты в
/// журнале нарушений нет — у них подписи нет.
String? violationDetail(AppLocalizations l, Infringement i) {
  final time = formatHm(i.time ?? Duration.zero);
  return switch (i.type) {
    InfringementType.continuousExceeded ||
    InfringementType.dailyDriveExceeded ||
    InfringementType.shiftExceeded ||
    InfringementType.weeklyDriveExceeded ||
    InfringementType.fortnightDriveExceeded => l.violationsOver(time),
    InfringementType.weeklyRestOverdue => l.violationsLate(time),
    InfringementType.compensationOverdue ||
    InfringementType.reducedWeeklyRestWithoutRight => l.violationsShort(time),
    InfringementType.reducedRestsExceeded => l.infringement(i).text,
    InfringementType.breakSoon ||
    InfringementType.dailyDriveSoon ||
    InfringementType.extensionInUse ||
    InfringementType.shiftSoon ||
    InfringementType.weeklyDriveSoon ||
    InfringementType.fortnightDriveSoon ||
    InfringementType.weeklyRestSoon ||
    InfringementType.weeklyRestContinue ||
    InfringementType.compensationSoon ||
    InfringementType.cardOverdue ||
    InfringementType.cardSoon ||
    InfringementType.fullWeeklyRestRequired => null,
  };
}

/// "Infringements": how many there are in the last 56 days and how many of
/// them have no explanation yet, then the list from the newest — what was
/// exceeded and by how much, when, the article, how long it stays in the
/// inspection period, and the driver's explanation. A tap opens the
/// explanation. The engine works the list out from the journal
/// (`violationLog`); the screen repeats no rule.
class ViolationsScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final colors = context.colors;
    return DetailScaffold(
      title: l.violationsTitle,
      children: switch (ref.watch(violationListProvider)) {
        AsyncData(:final value) => [
          _Summary(value),
          if (value.entries.isEmpty)
            _Empty()
          else
            for (final entry in value.entries) ...[
              const SizedBox(height: AppSpacing.betweenCardsMin),
              _ViolationCard(entry),
            ],
          InfoNote(l.violationsRule),
        ],
        AsyncError() => [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.textInset),
            child: Text(
              l.journalLoadError,
              style: AppTextStyles.body.copyWith(color: colors.errorText),
            ),
          ),
        ],
        AsyncLoading() => const [
          Padding(
            padding: EdgeInsets.all(48),
            child: Center(child: CircularProgressIndicator()),
          ),
        ],
      },
    );
  }
}

/// The number of infringements in the inspection period, its dates and how
/// many infringements have no explanation.
class _Summary extends StatelessWidget {
  const new(this.list);

  final ViolationList list;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final count = list.entries.length;
    final unexplained = list.unexplained;
    return CardGroup(
      children: [
        CountRow(
          count: count,
          label: l.violationsCount(count),
          color: count > 0 ? colors.errorText : null,
        ),
        _ValueRow(
          title: l.violationsPeriod,
          // Период — сутки UTC, как в отчёте; тире между датами — не фраза
          value: '${utcDay(list.from)} – ${utcDay(list.now)}',
        ),
        if (count > 0)
          _ValueRow(
            title: l.violationsUnexplained,
            value: '$unexplained',
            valueColor: unexplained > 0 ? colors.warningText : null,
          ),
      ],
    );
  }
}

/// A summary row: the title on the left, digits on the right.
class _ValueRow extends StatelessWidget {
  const new({required this.title, required this.value, this.valueColor});

  final String title;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) => MergeSemantics(
    child: CardRow(
      child: Row(
        children: [
          Expanded(child: Text(title, style: AppTextStyles.rowTitle)),
          const SizedBox(width: AppSpacing.s12),
          Text(
            value,
            style: AppTextStyles.valueSmall.copyWith(
              color: valueColor ?? context.colors.textSecondary,
            ),
          ),
        ],
      ),
    ),
  );
}

/// No infringements in the inspection period.
class _Empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.textInset,
        AppSpacing.beforeSectionMin,
        AppSpacing.textInset,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle_outline, size: 22, color: colors.rest),
              const SizedBox(width: AppSpacing.s10),
              Expanded(
                child: Text(l.violationsEmpty, style: AppTextStyles.rowTitle),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s6),
          Text(
            l.violationsEmptyText,
            style: AppTextStyles.body.copyWith(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}

/// An infringement: the title, when it began, by how much the limit was
/// exceeded, the article, how many days it stays in the inspection period and
/// the driver's explanation. A tap opens the explanation.
class _ViolationCard extends StatelessWidget {
  const new(this.entry);

  final ViolationEntry entry;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final violation = entry.violation;
    final text = l.infringement(violation.infringement);
    final detail = violationDetail(l, violation.infringement);
    final note = entry.note;
    final secondary = AppTextStyles.small.copyWith(color: colors.textSecondary);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Material(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        clipBehavior: Clip.antiAlias,
        child: Semantics(
          button: true,
          child: InkWell(
            onTap: () => unawaited(showViolationNoteSheet(context, entry)),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ViolationTitle(text.title),
                  const SizedBox(height: AppSpacing.s6),
                  _ViolationTime(violation.at, active: violation.active),
                  if (detail != null) ...[
                    const SizedBox(height: AppSpacing.s6),
                    Text(detail, style: AppTextStyles.body),
                  ],
                  const SizedBox(height: AppSpacing.s4),
                  Text(text.article, style: secondary),
                  Text(l.violationsDaysLeft(entry.daysLeft), style: secondary),
                  const SizedBox(height: AppSpacing.s12),
                  Divider(height: 1, thickness: 1, color: colors.surface2),
                  const SizedBox(height: AppSpacing.s12),
                  if (note == null)
                    const _NoNote()
                  else ...[
                    Text(l.violationsNote, style: secondary),
                    const SizedBox(height: 2),
                    Text(note.text, style: AppTextStyles.body),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The warning sign and what was exceeded.
class _ViolationTitle extends StatelessWidget {
  const new(this.title);

  final String title;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 1),
        child: Icon(
          Icons.warning_amber_rounded,
          size: 20,
          color: context.colors.errorText,
        ),
      ),
      const SizedBox(width: AppSpacing.s10),
      Expanded(child: Text(title, style: AppTextStyles.rowTitle)),
    ],
  );
}

/// When the infringement began; one still going on is marked "now".
class _ViolationTime extends StatelessWidget {
  const new(this.at, {required this.active});

  final DateTime at;

  /// Нарушение ещё идёт.
  final bool active;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: AppSpacing.s8,
    runSpacing: AppSpacing.s4,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      Text(
        formatDeadline(at, context.localeTag),
        style: AppTextStyles.numericCaption.copyWith(
          color: context.colors.text,
        ),
      ),
      if (active)
        StatusChip(context.l10n.violationsActive, tone: Tone.violation),
    ],
  );
}

/// No explanation yet: the chip and "Add an explanation".
class _NoNote extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Wrap(
      spacing: AppSpacing.s12,
      runSpacing: AppSpacing.s8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        StatusChip(l.violationsNoNote, tone: Tone.warning),
        Text(
          l.violationsNoteAdd,
          style: AppTextStyles.label.copyWith(
            color: context.colors.text,
            decoration: TextDecoration.underline,
          ),
        ),
      ],
    );
  }
}
