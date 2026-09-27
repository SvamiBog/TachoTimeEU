import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/limit_bar.dart';
import 'package:tachogo/core/widgets/mode_style.dart';
import 'package:tachogo/core/widgets/status_chip.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/features/export/export_sheet.dart';
import 'package:tachogo/features/journal/journal_parts.dart';
import 'package:tachogo/features/journal/shift_day_screen.dart';
import 'package:tachogo/features/journal/shift_edit_screen.dart';

/// Журнал (экран 2): недели → смены, недельный отдых, подсветка 10 ч
/// вождения, 13+ ч рабочего дня и сокращённого отдыха — по оценке движка
/// (`buildJournal`). Вся история бесплатна; «+ Смена» и экспорт — Premium.
class JournalScreen extends ConsumerStatefulWidget {
  const new({super.key});

  /// Сколько последних недель раскрыто сразу: текущая и прошлая.
  static const expandedWeeks = 2;

  @override
  ConsumerState<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends ConsumerState<JournalScreen> {
  /// Недели, которые водитель свернул или раскрыл сам.
  final _toggled = <DateTime>{};

  @override
  Widget build(BuildContext context) {
    final journal = ref.watch(journalProvider);
    final l = context.l10n;
    final colors = context.colors;
    return Scaffold(
      body: SafeArea(
        child: switch (journal) {
          AsyncData(:final value) => _list(value),
          AsyncError() => Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.screenPadding * 2),
              child: Text(
                l.journalLoadError,
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(color: colors.errorText),
              ),
            ),
          ),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => openShiftEditor(context),
        tooltip: l.journalAddShiftSpoken,
        backgroundColor: colors.drive,
        foregroundColor: colors.onAccent,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
        icon: const Icon(Icons.add, size: 22),
        label: Text(l.journalAddShift, style: AppTextStyles.button),
      ),
    );
  }

  Widget _list(Journal journal) {
    final weeks = journal.weeks;
    final empty = weeks.every((w) => w.shifts.isEmpty && w.weeklyRests.isEmpty);
    return ListView(
      // Место под «+ Смена», чтобы она не закрывала последнюю неделю
      padding: const EdgeInsets.only(bottom: 96),
      children: [
        _Header(now: journal.now),
        if (empty)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPadding + 4,
              8,
              AppSpacing.screenPadding + 4,
              0,
            ),
            child: Text(
              context.l10n.journalEmpty,
              style: AppTextStyles.body.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ),
        for (final (i, week) in weeks.indexed)
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              i == 0 ? 8 : 12,
              AppSpacing.screenPadding,
              0,
            ),
            child:
                (i < JournalScreen.expandedWeeks) !=
                    _toggled.contains(week.start)
                ? _WeekCard(
                    journal: journal,
                    week: week,
                    onToggle: () => _toggle(week.start),
                  )
                : _CollapsedWeek(
                    week: week,
                    onToggle: () => _toggle(week.start),
                  ),
          ),
      ],
    );
  }

  void _toggle(DateTime week) => setState(() {
    if (!_toggled.remove(week)) _toggled.add(week);
  });
}

class _Header extends StatelessWidget {
  const new({required this.now});

  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 64),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding + 4,
          8,
          AppSpacing.screenPadding - 8,
          8,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    header: true,
                    child: Text(l.navJournal, style: AppTextStyles.header),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    formatMonthYear(now, context.localeTag),
                    style: AppTextStyles.small.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => showExportSheet(context),
              tooltip: l.journalExport,
              iconSize: 24,
              constraints: const BoxConstraints.tightFor(width: 48, height: 48),
              icon: const Icon(Icons.file_download_outlined),
            ),
          ],
        ),
      ),
    );
  }
}

/// Элемент недели: смена или недельный отдых, от новых к старым.
sealed class _Item {
  const new(this.at);

  final DateTime at;
}

class _ShiftItem extends _Item {
  new(this.shift) : super(shift.start);

  final JournalShift shift;
}

class _RestItem extends _Item {
  new(this.rest, DateTime now) : super(rest.end ?? now);

  final WeeklyRest rest;
}

List<_Item> _items(JournalWeek week, DateTime now) =>
    <_Item>[
      for (final s in week.shifts) _ShiftItem(s),
      for (final r in week.weeklyRests) _RestItem(r, now),
    ]..sort((a, b) {
      final byTime = b.at.compareTo(a.at);
      if (byTime != 0) return byTime;
      // Отдых, закончившийся в начале смены, — под ней
      return a is _ShiftItem ? -1 : 1;
    });

class _WeekCard extends StatelessWidget {
  const new({
    required this.journal,
    required this.week,
    required this.onToggle,
  });

  final Journal journal;
  final JournalWeek week;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(AppRadius.card),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _WeekHeader(week: week, onToggle: onToggle),
          for (final item in _items(week, journal.now)) ...[
            Divider(height: 1, thickness: 1, color: colors.surface2),
            switch (item) {
              _ShiftItem(:final shift) => _ShiftRow(journal, shift),
              _RestItem(:final rest) => _WeeklyRestRow(rest),
            },
          ],
        ],
      ),
    );
  }
}

final int _weekHours = EuLimits.weeklyDriving.inHours;
final int _fortnightHours = EuLimits.fortnightDriving.inHours;

class _WeekHeader extends StatelessWidget {
  const new({required this.week, required this.onToggle});

  final JournalWeek week;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final range = formatWeekRange(week.start, context.localeTag);
    final weekOver = week.driving > EuLimits.weeklyDriving;
    final fortnightOver = week.fortnightDriving > EuLimits.fortnightDriving;
    final caption = AppTextStyles.caption.copyWith(color: colors.textSecondary);
    InlineSpan value(Duration d, {bool over = false}) => TextSpan(
      text: formatHm(d),
      style: AppTextStyles.numericCaption.copyWith(
        fontWeight: FontWeight.w700,
        color: over ? colors.errorText : colors.text,
      ),
    );
    return Semantics(
      button: true,
      expanded: true,
      label: l.journalWeekSpoken(
        range,
        spokenDuration(l, week.driving),
        spokenDuration(l, week.fortnightDriving),
      ),
      excludeSemantics: true,
      child: InkWell(
        onTap: onToggle,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      range,
                      style: AppTextStyles.rowTitle.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (week.isCurrent)
                    StatusChip(l.journalCurrent, tone: Tone.warning)
                  else
                    Icon(
                      Icons.keyboard_arrow_up,
                      size: 20,
                      color: colors.textSecondary,
                    ),
                ],
              ),
              const SizedBox(height: 10),
              LimitBar(
                value: week.driving,
                max: EuLimits.weeklyDriving,
                color: weekOver ? colors.errorText : colors.drive,
              ),
              const SizedBox(height: 10),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: 12,
                runSpacing: 2,
                children: [
                  Text.rich(
                    TextSpan(
                      style: caption,
                      children: [
                        TextSpan(text: '${l.journalDriving} '),
                        value(week.driving, over: weekOver),
                        TextSpan(text: ' ${l.journalOf(_weekHours)}'),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      style: caption,
                      children: [
                        TextSpan(text: '${l.journalFortnight} '),
                        value(week.fortnightDriving, over: fortnightOver),
                        TextSpan(text: ' ${l.journalOf(_fortnightHours)}'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CollapsedWeek extends StatelessWidget {
  const new({required this.week, required this.onToggle});

  final JournalWeek week;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final range = formatWeekRange(week.start, context.localeTag);
    return Semantics(
      button: true,
      expanded: false,
      label: l.journalWeekSpoken(
        range,
        spokenDuration(l, week.driving),
        spokenDuration(l, week.fortnightDriving),
      ),
      excludeSemantics: true,
      child: Material(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.modeButton),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onToggle,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppSize.listRow),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.cardPadding,
                vertical: 8,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      range,
                      style: AppTextStyles.rowTitle.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text.rich(
                    TextSpan(
                      style: AppTextStyles.caption.copyWith(
                        color: colors.textSecondary,
                      ),
                      children: [
                        TextSpan(text: '${l.journalCollapsedDriving} '),
                        TextSpan(
                          text: formatHm(week.driving),
                          style: AppTextStyles.numericCaption.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colors.text,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.keyboard_arrow_down,
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

/// Строка смены: день, страны, время, итоги. Касание — детали дня.
class _ShiftRow extends StatelessWidget {
  const new(this.journal, this.shift);

  final Journal journal;
  final JournalShift shift;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final locale = context.localeTag;
    final s = shift;
    final route = routeOf(journal.metaOf(s));
    final time = shiftTimeOf(l, s);
    final live = s.end == null;
    return Semantics(
      button: true,
      label: l.journalShiftSpoken(
        formatWeekdayFull(s.start, locale),
        route,
        time,
        spokenDuration(l, s.driving),
        spokenDuration(l, s.span),
        restSpokenOf(l, s),
      ),
      excludeSemantics: true,
      child: InkWell(
        onTap: () => openShiftDay(context, keyOf(s)),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.cardPadding,
            vertical: 14,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 44,
                child: Column(
                  children: [
                    Text(
                      formatWeekdayShort(s.start, locale),
                      style: AppTextStyles.small.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    Text(
                      '${s.start.toLocal().day}',
                      style: AppTextStyles.modeTimer,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 2,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: route,
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            children: [
                              if (s.manual != null)
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
                          time,
                          style: AppTextStyles.numericCaption.copyWith(
                            color: live ? colors.drive : colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ShiftMetrics(s),
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

class _WeeklyRestRow extends StatelessWidget {
  const new(this.rest);

  final WeeklyRest rest;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final end = rest.end;
    final title = l.journalWeeklyRest(l.restStatus(rest.status.name));
    final when =
        '${formatDayMonthClock(rest.start)} → '
        '${end == null ? l.weeklyNow : formatDayMonthClock(end)}';
    return Semantics(
      container: true,
      label: '$title. $when. ${spokenDuration(l, rest.duration)}',
      excludeSemantics: true,
      child: ColoredBox(
        color: colors.restBg,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.cardPadding,
            vertical: 14,
          ),
          child: Row(
            children: [
              IconTheme(
                data: IconThemeData(color: colors.rest),
                child: const ModeIcon(DriverMode.rest, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.restText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      when,
                      style: AppTextStyles.numericCaption.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                formatHm(rest.duration),
                style: AppTextStyles.value.copyWith(color: colors.restText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
