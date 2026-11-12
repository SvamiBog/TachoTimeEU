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
            padding: const EdgeInsets.all(AppSpacing.screenPadding + 4),
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
        MergeSemantics(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '$count',
                  style: AppTextStyles.valueLarge.copyWith(
                    color: count > 0 ? colors.errorText : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l.violationsCount(count),
                    style: AppTextStyles.rowTitle,
                  ),
                ),
              ],
            ),
          ),
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
    child: ConstrainedBox(
      constraints: const BoxConstraints(minHeight: AppSize.listRow),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.cardPadding,
          vertical: 10,
        ),
        child: Row(
          children: [
            Expanded(child: Text(title, style: AppTextStyles.rowTitle)),
            const SizedBox(width: 12),
            Text(
              value,
              style: AppTextStyles.valueSmall.copyWith(
                color: valueColor ?? context.colors.textSecondary,
              ),
            ),
          ],
        ),
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
        AppSpacing.screenPadding + 4,
        AppSpacing.beforeSectionMin,
        AppSpacing.screenPadding + 4,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle_outline, size: 22, color: colors.rest),
              const SizedBox(width: 10),
              Expanded(
                child: Text(l.violationsEmpty, style: AppTextStyles.rowTitle),
              ),
            ],
          ),
          const SizedBox(height: 6),
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 1),
                        child: Icon(
                          Icons.warning_amber_rounded,
                          size: 20,
                          color: colors.errorText,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(text.title, style: AppTextStyles.rowTitle),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        formatDeadline(violation.at, context.localeTag),
                        style: AppTextStyles.numericCaption.copyWith(
                          color: colors.text,
                        ),
                      ),
                      if (violation.active)
                        StatusChip(l.violationsActive, tone: Tone.violation),
                    ],
                  ),
                  if (detail != null) ...[
                    const SizedBox(height: 6),
                    Text(detail, style: AppTextStyles.body),
                  ],
                  const SizedBox(height: 4),
                  Text(text.article, style: secondary),
                  Text(l.violationsDaysLeft(entry.daysLeft), style: secondary),
                  const SizedBox(height: 12),
                  Divider(height: 1, thickness: 1, color: colors.surface2),
                  const SizedBox(height: 12),
                  if (note == null)
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        StatusChip(l.violationsNoNote, tone: Tone.warning),
                        Text(
                          l.violationsNoteAdd,
                          style: AppTextStyles.label.copyWith(
                            color: colors.text,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    )
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
