/// The shift date and time sheet (screen 12), the day sheet of a custom report
/// period and the month calendar they share. The driver sees local time; UTC
/// goes out.
library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/hm_field.dart';
import 'package:tachogo/core/widgets/segmented_tabs.dart';
import 'package:tachogo/features/journal/picker_sheet.dart';

/// Start and end of a shift after picking.
typedef ShiftTimes = ({DateTime start, DateTime? end});

/// Шторка «Дата и время» (экран 12): начало и, если смена закончилась,
/// конец. [max] — последний день в календаре; время позже него не
/// запрещено — его проверяет сохранение. null — водитель передумал.
Future<ShiftTimes?> showDateTimeSheet(
  BuildContext context, {
  required DateTime start,
  required DateTime? end,
  required DateTime max,
  bool editEnd = false,
}) => showPickerSheet(
  context,
  _DateTimeSheet(start: start, end: end, max: max, editEnd: editEnd),
);

/// Sheet with "Start / End" tabs, each a calendar and a time field.
class _DateTimeSheet extends StatefulWidget {
  const new({
    required this.start,
    required this.end,
    required this.max,
    required this.editEnd,
  });

  final DateTime start;
  final DateTime? end;
  final DateTime max;
  final bool editEnd;

  @override
  State<_DateTimeSheet> createState() => _DateTimeSheetState();
}

/// The start and end picked so far and the open tab.
class _DateTimeSheetState extends State<_DateTimeSheet> {
  late DateTime _start = widget.start;
  late DateTime? _end = widget.end;
  late bool _editEnd = widget.editEnd && widget.end != null;

  /// Во вкладке введено не время — «Готово» недоступна.
  bool _invalid = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final end = _end;
    String detail(DateTime t) => '${formatDayMonth(t)} · ${formatClock(t)}';
    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      label: l.shiftDateTimeTitle,
      explicitChildNodes: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (end != null) ...[
            SegmentedTabs<bool>(
              options: [
                (value: false, label: l.shiftStart, detail: detail(_start)),
                (value: true, label: l.shiftEnd, detail: detail(end)),
              ],
              value: _editEnd,
              onChanged: (v) => setState(() {
                _editEnd = v;
                _invalid = false;
              }),
            ),
            const SizedBox(height: AppSpacing.s16),
          ],
          if (_editEnd && end != null)
            DateTimeField(
              key: const ValueKey('end'),
              value: end,
              max: widget.max,
              onChanged: (t) => setState(() => _end = t),
              onValidChanged: (v) => setState(() => _invalid = !v),
            )
          else
            DateTimeField(
              key: const ValueKey('start'),
              value: _start,
              max: widget.max,
              onChanged: (t) => setState(() => _start = t),
              onValidChanged: (v) => setState(() => _invalid = !v),
            ),
          const SizedBox(height: AppSpacing.s16),
          PickerButtons(
            label: l.done,
            onPressed: _invalid
                ? null
                : () =>
                      Navigator.of(context)
                          .pop<ShiftTimes>((start: _start, end: _end)),
          ),
        ],
      ),
    );
  }
}

/// A month calendar and a time typed on the keyboard. [value] and [max] are
/// UTC, the screen shows local time. [max] is usually "now": its day is marked
/// as today and later days are disabled.
class DateTimeField extends StatefulWidget {
  const new({
    required this.value,
    required this.max,
    required this.onChanged,
    this.onValidChanged,
    this.withTime = true,
    super.key,
  });

  final DateTime value;
  final DateTime max;
  final ValueChanged<DateTime> onChanged;

  /// Введено время (true) или что-то другое (false).
  final ValueChanged<bool>? onValidChanged;

  /// false — только день, без времени.
  final bool withTime;

  @override
  State<DateTimeField> createState() => _DateTimeFieldState();
}

/// The month on screen.
class _DateTimeFieldState extends State<DateTimeField> {
  late DateTime _month = _monthOf(widget.value.toLocal());

  static DateTime _monthOf(DateTime local) => DateTime(local.year, local.month);

  static DateTime _dayOf(DateTime local) =>
      DateTime(local.year, local.month, local.day);

  void _set({int? year, int? month, int? day, int? hour, int? minute}) {
    final c = widget.value.toLocal();
    final t = DateTime(
      year ?? c.year,
      month ?? c.month,
      day ?? c.day,
      hour ?? c.hour,
      minute ?? c.minute,
    ).toUtc();
    widget.onChanged(t);
  }

  @override
  Widget build(BuildContext context) {
    final local = widget.value.toLocal();
    final maxDay = _dayOf(widget.max.toLocal());
    final next = DateTime(_month.year, _month.month + 1);
    final days = DateTime(_month.year, _month.month + 1, 0).day;
    final offset = _month.weekday - DateTime.monday;
    // Неделя — строка из 7 клеток, пустые — до 1-го и после последнего дня
    final cells = <DateTime?>[
      for (var i = 0; i < offset; i++) null,
      for (var d = 1; d <= days; d++) DateTime(_month.year, _month.month, d),
    ];
    while (cells.length % 7 != 0) {
      cells.add(null);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _MonthHeader(
          month: _month,
          onPrevious: () =>
              setState(() => _month = DateTime(_month.year, _month.month - 1)),
          onNext: next.isAfter(maxDay)
              ? null
              : () => setState(() => _month = next),
        ),
        const SizedBox(height: AppSpacing.s8),
        const _WeekdayNames(),
        const SizedBox(height: AppSpacing.s4),
        for (var row = 0; row < cells.length; row += 7)
          _WeekRow(
            cells.sublist(row, row + 7),
            selected: _dayOf(local),
            maxDay: maxDay,
            onPick: (day) =>
                _set(year: day.year, month: day.month, day: day.day),
          ),
        if (widget.withTime) ...[
          Divider(height: 24, color: context.colors.surface2),
          HmField(
            label: context.l10n.pickerTime,
            value: Duration(hours: local.hour, minutes: local.minute),
            onChanged: (v) {
              widget.onValidChanged?.call(v != null);
              if (v != null) _set(hour: v.inHours, minute: v.inMinutes % 60);
            },
          ),
        ],
      ],
    );
  }
}

/// "September 2026" with the previous and next month buttons; [onNext] null —
/// the next month is after the last day allowed.
class _MonthHeader extends StatelessWidget {
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
    return Row(
      children: [
        Expanded(
          child: Text(
            formatMonthYear(month, context.localeTag),
            style: AppTextStyles.header,
          ),
        ),
        IconButton(
          tooltip: l.pickerPrevMonth,
          onPressed: onPrevious,
          icon: const Icon(Icons.chevron_left),
        ),
        IconButton(
          tooltip: l.pickerNextMonth,
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}

/// Weekday names from Monday over the calendar columns; the screen reader
/// reads the day name in each cell instead.
class _WeekdayNames extends StatelessWidget {
  const new();

  static String _capitalized(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';

  @override
  Widget build(BuildContext context) {
    final weekday = DateFormat('EEE', context.localeTag);
    return ExcludeSemantics(
      child: Row(
        children: [
          for (var i = 0; i < 7; i++)
            Expanded(
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    // 5 января 2026 — понедельник
                    _capitalized(weekday.format(DateTime(2026, 1, 5 + i))),
                    style: AppTextStyles.label.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// A week of the calendar: seven cells, empty ones outside the month.
class _WeekRow extends StatelessWidget {
  const new(
    this.days, {
    required this.selected,
    required this.maxDay,
    required this.onPick,
  });

  final List<DateTime?> days;
  final DateTime selected;

  /// Последний день, который можно выбрать: он отмечен как сегодня.
  final DateTime maxDay;
  final ValueChanged<DateTime> onPick;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      children: [
        for (final day in days)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: day == null
                  ? const SizedBox(height: AppSize.minTouch)
                  : _DayCell(
                      day,
                      selected: day == selected,
                      today: day == maxDay,
                      disabled: day.isAfter(maxDay),
                      onTap: () => onPick(day),
                    ),
            ),
          ),
      ],
    ),
  );
}

/// A day of the calendar: selected — filled with the driving colour, today —
/// outlined, after the last day allowed — greyed out and disabled.
class _DayCell extends StatelessWidget {
  const new(
    this.day, {
    required this.selected,
    required this.today,
    required this.disabled,
    required this.onTap,
  });

  final DateTime day;
  final bool selected;
  final bool today;
  final bool disabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      selected: selected,
      label: formatWeekdayFull(day, context.localeTag),
      excludeSemantics: true,
      button: true,
      enabled: !disabled,
      child: Material(
        color: selected ? colors.drive : Colors.transparent,
        shape: StadiumBorder(
          side: today && !selected
              ? BorderSide(color: colors.textSecondary)
              : BorderSide.none,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: disabled ? null : onTap,
          child: SizedBox(
            height: AppSize.minTouch,
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '${day.day}',
                  style: AppTextStyles.valueSmall.copyWith(
                    color: selected
                        ? colors.onAccent
                        : disabled
                        ? colors.textSecondary
                        : colors.text,
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

/// Шторка выбора дня (свой период отчёта): календарь без времени.
/// [initial] и результат — день по календарю телефона, не позже [max].
Future<DateTime?> showDaySheet(
  BuildContext context, {
  required String title,
  required DateTime initial,
  required DateTime max,
}) => showPickerSheet(
  context,
  _DaySheet(title: title, initial: initial, max: max),
);

/// Sheet to pick one day of the calendar.
class _DaySheet extends StatefulWidget {
  const new({required this.title, required this.initial, required this.max});

  final String title;
  final DateTime initial;
  final DateTime max;

  @override
  State<_DaySheet> createState() => _DaySheetState();
}

/// The day picked so far.
class _DaySheetState extends State<_DaySheet> {
  late DateTime _value = widget.initial.toUtc();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      label: widget.title,
      explicitChildNodes: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DateTimeField(
            value: _value,
            max: widget.max,
            withTime: false,
            onChanged: (t) => setState(() => _value = t),
          ),
          const SizedBox(height: AppSpacing.s16),
          PickerButtons(
            label: l.done,
            onPressed: () {
              final local = _value.toLocal();
              Navigator.of(context)
                  .pop(DateTime(local.year, local.month, local.day));
            },
          ),
        ],
      ),
    );
  }
}
