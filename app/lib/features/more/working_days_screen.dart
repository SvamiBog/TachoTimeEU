/// "Working days" (Premium): the days of a month the driver spent at least
/// partly abroad or worked in the company country, and their pay at a daily
/// rate. Drivers are often paid by such days.
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
import 'package:tachogo/core/widgets/choice_pill.dart';
import 'package:tachogo/core/widgets/detail_scaffold.dart';
import 'package:tachogo/core/widgets/sections.dart';
import 'package:tachogo/core/widgets/setting_rows.dart';
import 'package:tachogo/data/countries/country_providers.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/data/settings/settings_providers.dart';
import 'package:tachogo/data/settings/settings_repository.dart';
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

/// Ставка из поля ввода в сотых: «85», «85,5», «1 200.50». null — не число
/// или больше 99 999 999,99.
int? parseCents(String text) {
  final clean = text.replaceAll(RegExp(r'[\s  ]'), '').replaceAll(',', '.');
  final match = RegExp(r'^(\d{1,8})(?:\.(\d{0,2}))?$').firstMatch(clean);
  if (match == null) return null;
  final fraction = (match[2] ?? '').padRight(2, '0');
  return int.parse(match[1]!) * 100 + int.parse(fraction);
}

/// "Working days" (Premium, `docs/premium.md`): a month with arrows, the number
/// of working days abroad and at home, the daily rate and the amount, the
/// calendar of the month and the rule. Without the company country it asks for
/// it: the days are counted against it.
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
    final rate = ref.watch(dayRateProvider).value ?? const DayRate();
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
          _Summary(kinds: kinds, rate: rate),
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

/// The number of working days, abroad and at home, the rate and the amount.
class _Summary extends StatelessWidget {
  const new({required this.kinds, required this.rate});

  final List<WorkingDayKind> kinds;
  final DayRate rate;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final locale = context.localeTag;
    final abroad = kinds.where((k) => k == WorkingDayKind.abroad).length;
    final home = kinds.where((k) => k == WorkingDayKind.home).length;
    final total = abroad + home;
    final rateText = rate.cents == 0
        ? l.workDaysRateNotSet
        : formatMoney(rate.cents, rate.currency, locale);
    return CardGroup(
      children: [
        MergeSemantics(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text('$total', style: AppTextStyles.valueLarge),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l.workDaysCount(total),
                    style: AppTextStyles.rowTitle,
                  ),
                ),
              ],
            ),
          ),
        ),
        MilestoneRow(
          dot: MilestoneDot.solid,
          title: l.workDaysAbroad,
          subtitle: l.workDaysAbroadHint,
          value: '$abroad',
        ),
        MilestoneRow(
          dot: MilestoneDot.ring,
          title: l.workDaysHome,
          subtitle: l.workDaysHomeHint,
          value: '$home',
        ),
        NavRow(
          title: l.workDaysRate,
          value: rateText,
          numericValue: rate.cents != 0,
          onTap: () => unawaited(showDayRateSheet(context, rate)),
        ),
        if (rate.cents != 0)
          // Сумма — во всю ширину: длинная («12 345 678 soʻm») переносится
          MergeSemantics(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.workDaysAmount, style: AppTextStyles.rowTitle),
                  const SizedBox(height: 4),
                  Text(
                    formatMoney(total * rate.cents, rate.currency, locale),
                    style: AppTextStyles.valueLarge,
                  ),
                  Text(
                    l.workDaysAmountHint('$total', rateText),
                    style: AppTextStyles.caption.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// The month as a calendar from Monday: a solid day — abroad, a ring — work in
/// the company country, plain — not a working day; days after today are
/// empty.
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
      WorkingDayKind.abroad => l.workDaysAbroad,
      WorkingDayKind.home => l.workDaysHome,
      WorkingDayKind.off || null => l.workDaysOff,
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
              color: kind == WorkingDayKind.abroad ? colors.text : null,
              border: kind == WorkingDayKind.home
                  ? Border.all(color: colors.text, width: 2)
                  : null,
            ),
            child: SizedBox.square(
              dimension: 36,
              child: Center(
                child: Text(
                  '${date.day}',
                  style: AppTextStyles.numericCaption.copyWith(
                    color: switch (kind) {
                      WorkingDayKind.abroad => colors.background,
                      WorkingDayKind.home => colors.text,
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

/// Шторка «Ставка за рабочий день»: сумма и валюта.
Future<void> showDayRateSheet(BuildContext context, DayRate rate) =>
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => _DayRateSheet(rate),
    );

/// The rate being edited: the amount field and the currency.
class _DayRateSheet extends ConsumerStatefulWidget {
  const new(this.rate);

  final DayRate rate;

  @override
  ConsumerState<_DayRateSheet> createState() => _DayRateSheetState();
}

/// The entered amount and the chosen currency.
class _DayRateSheetState extends ConsumerState<_DayRateSheet> {
  late final _amount = TextEditingController(
    text: widget.rate.cents == 0
        ? ''
        : (widget.rate.cents % 100 == 0
              ? '${widget.rate.cents ~/ 100}'
              : (widget.rate.cents / 100).toStringAsFixed(2)),
  );
  late String _currency = widget.rate.currency;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final cents = parseCents(_amount.text);
    if (cents == null) return;
    final navigator = Navigator.of(context);
    await ref
        .read(settingsRepositoryProvider)
        .setDayRate(DayRate(cents: cents, currency: _currency));
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    const pad = AppSpacing.screenPadding + 4;
    final valid = parseCents(_amount.text) != null;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(pad, 0, pad, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.workDaysRateTitle, style: AppTextStyles.header),
            const SizedBox(height: 16),
            TextField(
              controller: _amount,
              autofocus: true,
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) => unawaited(_save()),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d.,\s]')),
              ],
              style: AppTextStyles.valueSmall,
              decoration: InputDecoration(
                labelText: l.workDaysRate,
                suffixText: _currency,
                filled: true,
                fillColor: colors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.badge),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l.workDaysCurrency.toUpperCase(),
              style: AppTextStyles.section.copyWith(
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final code in DayRate.currencies)
                  ChoicePill(
                    code,
                    selected: code == _currency,
                    onTap: () => setState(() => _currency = code),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: l.save,
              onPressed: valid ? () => unawaited(_save()) : null,
            ),
          ],
        ),
      ),
    );
  }
}
