import 'package:flutter/material.dart';
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
import 'package:tachogo/core/widgets/status_chip.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/features/journal/journal_parts.dart';
import 'package:tachogo/features/journal/shift_edit_screen.dart';

Future<void> openShiftDay(BuildContext context, ShiftKey key) => Navigator.of(
  context,
).push(MaterialPageRoute<void>(builder: (_) => ShiftDayScreen(shiftKey: key)));

/// Детали дня: смена из журнала — итоги, записи режимов по порядку и отдых
/// после неё. Смотреть бесплатно, «Изменить смену» — Premium.
class ShiftDayScreen extends ConsumerWidget {
  const new({required this.shiftKey, super.key});

  final ShiftKey shiftKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final journal = ref.watch(journalProvider).value;
    final shift = journal == null ? null : findShift(journal, shiftKey);
    if (journal == null || shift == null) {
      return DetailScaffold(
        title: l.dayTitle,
        children: [
          if (journal == null)
            const Center(child: CircularProgressIndicator())
          else
            Padding(
              padding: const EdgeInsets.all(AppSpacing.screenPadding + 4),
              child: Text(
                l.dayNotFound,
                style: AppTextStyles.body.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ),
        ],
      );
    }
    final meta = journal.metaOf(shift);
    final note = meta.note;
    final recorded = shift.recorded;
    return DetailScaffold(
      title: l.dayTitle,
      subtitle: formatWeekdayFull(shift.start, context.localeTag),
      bottom: SecondaryButton(
        label: l.dayEdit,
        onPressed: () => _edit(context, shift),
      ),
      children: [
        _Summary(shift: shift, route: routeOf(meta)),
        SectionTitle(l.dayModes),
        if (recorded == null)
          const _ManualHint()
        else
          _Modes(blocks: _blocks(journal.timeline, recorded)),
        SectionTitle(l.daySummary),
        _Totals(shift),
        if (note != null) ...[
          SectionTitle(l.dayNotes),
          CardGroup(children: [_TextBlock(note, style: AppTextStyles.body)]),
        ],
      ],
    );
  }

  /// После правки смена могла сдвинуться — возвращаемся в журнал.
  static Future<void> _edit(BuildContext context, JournalShift shift) async {
    final navigator = Navigator.of(context);
    final saved = await openShiftEditor(context, shift: shift);
    if (saved) navigator.pop();
  }

  /// Блоки смены и отдыха после неё.
  static List<Block> _blocks(Timeline timeline, Shift shift) {
    final rest = shift.restAfter;
    return [
      ...shift.blocks,
      if (rest != null)
        ...timeline.blocks.sublist(rest.firstBlock, rest.lastBlock + 1),
    ];
  }
}

class _Summary extends StatelessWidget {
  const new({required this.shift, required this.route});

  final JournalShift shift;
  final String route;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        8,
        AppSpacing.screenPadding,
        0,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.heroCard),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 4,
                children: [
                  Text.rich(
                    TextSpan(
                      text: route,
                      style: AppTextStyles.rowTitle,
                      children: [
                        if (shift.manual != null)
                          TextSpan(
                            text: '  ${l.journalManual}',
                            style: AppTextStyles.small.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Text(
                    shiftTimeOf(l, shift),
                    style: AppTextStyles.numericCaption.copyWith(
                      color: shift.end == null
                          ? colors.drive
                          : colors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ExcludeSemantics(child: ShiftMetrics(shift)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ManualHint extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => CardGroup(
    children: [
      _TextBlock(
        context.l10n.dayManualHint,
        style: AppTextStyles.body.copyWith(color: context.colors.textSecondary),
      ),
    ],
  );
}

/// Текст во всю ширину карточки.
class _TextBlock extends StatelessWidget {
  const new(this.text, {required this.style});

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Text(text, style: style),
    ),
  );
}

/// Записи режимов смены: полоса по времени и список.
class _Modes extends StatelessWidget {
  const new({required this.blocks});

  final List<Block> blocks;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return CardGroup(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          child: ExcludeSemantics(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.chip),
              child: SizedBox(
                height: 12,
                child: Row(
                  children: [
                    for (final b in blocks)
                      Expanded(
                        flex: b.duration.inMinutes.clamp(1, 1 << 20),
                        child: ColoredBox(
                          color: colors.mode(b.mode),
                          child: const SizedBox.expand(),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        for (final b in blocks) _BlockRow(b),
      ],
    );
  }
}

class _BlockRow extends StatelessWidget {
  const new(this.block);

  final Block block;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final b = block;
    // Отдых через полночь — с датой конца
    final time = b.open
        ? '${formatClock(b.start)} → ${l.journalOngoing}'
        : isSameLocalDay(b.start, b.end)
        ? '${formatClock(b.start)}–${formatClock(b.end)}'
        : '${formatClock(b.start)} – ${formatDayMonthClock(b.end)}';
    final marks = [if (b.ferry) l.ferryOn, if (b.dayEnd) l.dayEndMark];
    return MergeSemantics(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppSize.listRow),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.cardPadding,
            vertical: 10,
          ),
          child: Row(
            children: [
              IconTheme(
                data: IconThemeData(color: colors.mode(b.mode)),
                child: ModeIcon(b.mode, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(l.modeName(b.mode), style: AppTextStyles.rowTitle),
                        for (final m in marks) StatusChip(m),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      time,
                      style: AppTextStyles.numericCaption.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              DurationText(
                formatHm(b.duration),
                spoken: spokenDuration(l, b.duration),
                style: AppTextStyles.value,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Итоги смены: работа, готовность, перерывы, непрерывное вождение, отдых.
class _Totals extends StatelessWidget {
  const new(this.shift);

  final JournalShift shift;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = shift;
    final rest = s.rest;
    final restEnd = s.restEnd;
    final status = rest.status;
    final (chip, tone) = rest.ongoing
        ? (l.journalOngoing, Tone.rest)
        : status == null
        ? (null, Tone.neutral)
        : (l.restStatus(status.name), toneOfLevel(s.restLevel));
    return CardGroup(
      children: [
        if (s.recorded != null) ...[
          _ValueRow(label: l.modeWorkFull, value: s.otherWork),
          _ValueRow(label: l.modeAvailability, value: s.availability),
          _ValueRow(label: l.dayBreaks, value: s.breaks),
        ],
        _ValueRow(label: l.dayContinuousAtEnd, value: s.continuousDrivingAtEnd),
        _ValueRow(
          label: l.dayRestAfter,
          caption: [
            l.dayRestKind(rest.kind.name),
            if (rest.split) l.daySplitRest,
            if (restEnd != null) l.dayRestUntil(formatDayMonthClock(restEnd)),
          ].join(' · '),
          value: rest.kind == RestKind.none ? null : rest.duration,
          chip: chip == null ? null : StatusChip(chip, tone: tone),
        ),
      ],
    );
  }
}

class _ValueRow extends StatelessWidget {
  const new({
    required this.label,
    required this.value,
    this.caption,
    this.chip,
  });

  final String label;
  final String? caption;
  final Duration? value;
  final StatusChip? chip;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final value = this.value;
    return MergeSemantics(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppSize.listRow),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.cardPadding,
            vertical: 10,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: AppTextStyles.rowTitle),
                    if (caption case final caption?)
                      Text(
                        caption,
                        style: AppTextStyles.caption.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              if (chip case final chip?) ...[const SizedBox(width: 8), chip],
              const SizedBox(width: 8),
              if (value == null)
                const Text('—', style: AppTextStyles.value)
              else
                DurationText(
                  formatHm(value),
                  spoken: spokenDuration(l, value),
                  style: AppTextStyles.value,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
