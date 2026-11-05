/// "Working days" (Premium): for a month, how many days the driver worked and
/// how many rest days they had abroad and in the company country. Drivers are
/// often paid by such days; the app only counts them.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/detail_scaffold.dart';
import 'package:tachogo/core/widgets/sections.dart';
import 'package:tachogo/data/countries/country_providers.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/features/home/detail_rows.dart';
import 'package:tachogo/features/settings/base_country.dart';

void openWorkingDays(BuildContext context) => Navigator.of(context)
    .push(MaterialPageRoute<void>(builder: (_) => const WorkingDaysScreen()));

/// Сутки месяца [month] по местному времени телефона, как UTC-окна для
/// движка: с 1-го числа по последнее, но не позже сегодняшних. Переход на
/// летнее время даёт сутки в 23 и 25 ч.
List<CalendarDay> monthDays(DateTime month, DateTime now) {
  final today = now.toLocal();
  return [
    for (var d = 1; d <= DateUtils.getDaysInMonth(month.year, month.month); d++)
      if (!DateTime(
        month.year,
        month.month,
        d,
      ).isAfter(DateTime(today.year, today.month, today.day)))
        (
          start: DateTime(month.year, month.month, d).toUtc(),
          end: DateTime(month.year, month.month, d + 1).toUtc(),
        ),
  ];
}

/// "Working days" (Premium, `docs/premium.md`): a month with arrows, the number
/// of working days, rest days abroad and in the company country, the calendar
/// of the month and the rule. Without the company country it asks for it: the
/// days are counted against it.
class WorkingDaysScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<WorkingDaysScreen> createState() => _WorkingDaysScreenState();
}

/// The month shown: the first day, local time.
class _WorkingDaysScreenState extends ConsumerState<WorkingDaysScreen> {
  late DateTime _month = _monthOf(ref.read(clockProvider));

  static DateTime _monthOf(DateTime t) {
    final local = t.toLocal();
    return DateTime(local.year, local.month);
  }

  void _shift(int months) =>
      setState(() => _month = DateTime(_month.year, _month.month + months));

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final base = ref.watch(baseCountryProvider);
    final journal = ref.watch(journalProvider).value;
    final current = journal == null || !_month.isBefore(_monthOf(journal.now));
    final days = journal == null
        ? const <CalendarDay>[]
        : monthDays(_month, journal.now);
    final kinds = journal == null || base == null
        ? const <WorkingDayKind>[]
        : workingDayKinds(
            shifts: journal.shifts,
            routes: journal.routes,
            baseCountry: base,
            days: days,
            now: journal.now,
          );
    return DetailScaffold(
      title: l.workDaysTitle,
      children: [
        _MonthBar(
          month: _month,
          onPrevious: () => _shift(-1),
          onNext: current ? null : () => _shift(1),
        ),
        if (base == null) ...[
          InfoNote(l.workDaysNoBase),
          const SizedBox(height: AppSpacing.betweenCardsMax),
          const CardGroup(children: [BaseCountryRow()]),
        ] else ...[
          _Summary(kinds: kinds),
          SectionTitle(formatMonthYear(_month, context.localeTag)),
          _Calendar(month: _month, kinds: kinds),
          InfoNote(l.workDaysRule),
        ],
      ],
    );
  }
}

/// "‹ October 2026 ›": the next month only up to the current one.
class _MonthBar extends StatelessWidget {
  const new({
    required this.month,
    required this.onPrevious,
    required this.onNext,
  });

  final DateTime month;
  final VoidCallback onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          IconButton(
            onPressed: onPrevious,
            tooltip: l.workDaysPrevMonth,
            icon: const Icon(Icons.chevron_left),
          ),
          Expanded(
            child: Text(
              formatMonthYear(month, context.localeTag),
              textAlign: TextAlign.center,
              style: AppTextStyles.header,
            ),
          ),
          IconButton(
            onPressed: onNext,
            tooltip: l.workDaysNextMonth,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}

/// The number of working days, then rest days abroad and in the company
/// country. The dots repeat the calendar: filled — abroad, a ring — in the
/// company country.
class _Summary extends StatelessWidget {
  const new({required this.kinds});

  final List<WorkingDayKind> kinds;

  int _count(WorkingDayKind kind) => kinds.where((k) => k == kind).length;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final working = kinds.where((k) => k.working).length;
    return CardGroup(
      children: [
        MergeSemantics(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text('$working', style: AppTextStyles.valueLarge),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l.workDaysCount(working),
                    style: AppTextStyles.rowTitle,
                  ),
                ),
              ],
            ),
          ),
        ),
        MilestoneRow(
          dot: MilestoneDot.solid,
          dotColor: colors.rest,
          title: l.workDaysWeekendsAbroad,
          subtitle: l.workDaysWeekendsAbroadHint,
          value: '${_count(WorkingDayKind.restAbroad)}',
        ),
        MilestoneRow(
          dot: MilestoneDot.ring,
          dotColor: colors.rest,
          title: l.workDaysWeekendsHome,
          subtitle: l.workDaysWeekendsHomeHint,
          value: '${_count(WorkingDayKind.restHome)}',
        ),
      ],
    );
  }
}

/// The month as a calendar from Monday: a working day is filled, wherever it
/// was; a rest day is green — filled abroad, a ring in the company country;
/// plain — no data; days after today are empty.
class _Calendar extends StatelessWidget {
  const new({required this.month, required this.kinds});

  final DateTime month;

  /// По дням месяца с 1-го; дней после сегодняшнего в нём нет.
  final List<WorkingDayKind> kinds;

  @override
  Widget build(BuildContext context) {
    final locale = context.localeTag;
    final colors = context.colors;
    final count = DateUtils.getDaysInMonth(month.year, month.month);
    // Пустые клетки до 1-го: неделя с понедельника, как в журнале
    final lead = DateTime(month.year, month.month).weekday - DateTime.monday;
    final cells = lead + count;
    final rows = (cells / 7).ceil();
    // 1 января 2024 — понедельник
    final weekdays = [
      for (var i = 0; i < 7; i++)
        formatWeekdayShort(DateTime(2024, 1, 1 + i), locale),
    ];
    return CardGroup(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
          child: Column(
            children: [
              ExcludeSemantics(
                child: Row(
                  children: [
                    for (final w in weekdays)
                      Expanded(
                        child: Text(
                          w,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style: AppTextStyles.small.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              for (var r = 0; r < rows; r++)
                Row(
                  children: [
                    for (var c = 0; c < 7; c++)
                      Expanded(
                        child: switch (r * 7 + c - lead + 1) {
                          final day when day >= 1 && day <= count => _DayCell(
                            date: DateTime(month.year, month.month, day),
                            kind: day <= kinds.length ? kinds[day - 1] : null,
                          ),
                          _ => const SizedBox(height: 44),
                        },
                      ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// A day of the calendar; [kind] null — the day has not come yet.
class _DayCell extends StatelessWidget {
  const new({required this.date, required this.kind});

  final DateTime date;
  final WorkingDayKind? kind;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final kind = this.kind;
    final label = switch (kind) {
      WorkingDayKind.abroad || WorkingDayKind.home => l.workDaysWorking,
      WorkingDayKind.restAbroad => l.workDaysWeekendAbroad,
      WorkingDayKind.restHome => l.workDaysWeekendHome,
      WorkingDayKind.off || null => l.workDaysNoData,
    };
    // Каждый день — свой узел: диктор читает день, а не весь месяц разом
    return Semantics(
      container: true,
      label: '${formatWeekdayFull(date, context.localeTag)}: $label',
      excludeSemantics: true,
      child: SizedBox(
        height: 44,
        child: Center(
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // Рабочий день — один вид, где бы ни был; выходные — как точки
              // итога: за границей — заливка, в стране фирмы — кольцо
              color: switch (kind) {
                WorkingDayKind.abroad || WorkingDayKind.home => colors.text,
                WorkingDayKind.restAbroad => colors.rest,
                _ => null,
              },
              border: kind == WorkingDayKind.restHome
                  ? Border.all(color: colors.rest, width: 2)
                  : null,
            ),
            child: SizedBox.square(
              dimension: 36,
              child: Center(
                child: Text(
                  '${date.day}',
                  style: AppTextStyles.numericCaption.copyWith(
                    color: switch (kind) {
                      WorkingDayKind.abroad ||
                      WorkingDayKind.home => colors.background,
                      WorkingDayKind.restAbroad => colors.onAccent,
                      WorkingDayKind.restHome => colors.text,
                      WorkingDayKind.off || null => colors.textSecondary,
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
