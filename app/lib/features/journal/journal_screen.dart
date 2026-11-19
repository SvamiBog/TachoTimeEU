/// Journal (screen 2): the history by weeks and shifts.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/features/export/export_sheet.dart';
import 'package:tachogo/features/journal/journal_week.dart';
import 'package:tachogo/features/journal/shift_edit_screen.dart';

/// Journal (screen 2): weeks → shifts and weekly rests, with highlights for 10
/// h of driving, a workday over 13 h and reduced rest from the engine's rating
/// (`buildJournal`). The whole history is free; "+ Shift" and export are
/// Premium.
class JournalScreen extends ConsumerStatefulWidget {
  const new({super.key});

  /// Сколько последних недель раскрыто сразу: текущая и прошлая.
  static const expandedWeeks = 2;

  @override
  ConsumerState<JournalScreen> createState() => _JournalScreenState();
}

/// Remembers the weeks the driver collapsed or expanded.
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
          AsyncData(:final value) => _WeekList(
            value,
            toggled: _toggled,
            onToggle: _toggle,
          ),
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
      // Кнопка — прямо в Scaffold: у расширенной кнопки он анимирует
      // появление иначе, чем у обёрнутой в свой виджет
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

  void _toggle(DateTime week) => setState(() {
    if (!_toggled.remove(week)) _toggled.add(week);
  });
}

/// The weeks from the newest: the last [JournalScreen.expandedWeeks] expanded,
/// older ones collapsed, unless the driver toggled them.
class _WeekList extends StatelessWidget {
  const new(this.journal, {required this.toggled, required this.onToggle});

  final Journal journal;

  /// Начала недель, которые водитель свернул или раскрыл сам.
  final Set<DateTime> toggled;
  final ValueChanged<DateTime> onToggle;

  @override
  Widget build(BuildContext context) {
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
              AppSpacing.textInset,
              AppSpacing.s8,
              AppSpacing.textInset,
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
              i == 0 ? AppSpacing.betweenCardsMin : AppSpacing.s12,
              AppSpacing.screenPadding,
              0,
            ),
            child:
                (i < JournalScreen.expandedWeeks) !=
                    toggled.contains(week.start)
                ? JournalWeekCard(
                    journal: journal,
                    week: week,
                    onToggle: () => onToggle(week.start),
                  )
                : JournalCollapsedWeek(
                    week: week,
                    onToggle: () => onToggle(week.start),
                  ),
          ),
      ],
    );
  }
}

/// The title with the export button.
class _Header extends StatelessWidget {
  const new({required this.now});

  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: AppSize.header),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.textInset,
          AppSpacing.s8,
          AppSpacing.screenPadding - AppSpacing.s8,
          AppSpacing.s8,
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
