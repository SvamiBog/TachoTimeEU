import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/buttons.dart';
import 'package:tachogo/core/widgets/hm_field.dart';
import 'package:tachogo/core/widgets/segmented_tabs.dart';
import 'package:tachogo/core/widgets/status_chip.dart';

// Шторки выбора для правок журнала: дата и время смены (экран 12),
// длительность (экран 7). Время и длительность водитель вводит с
// клавиатуры. Водитель видит местное время, наружу уходит UTC.

const _sheetPadding = EdgeInsets.fromLTRB(
  AppSpacing.screenPadding + 4,
  0,
  AppSpacing.screenPadding + 4,
  24,
);

/// Кнопки «Отмена» и основное действие внизу шторки.
class _SheetButtons extends StatelessWidget {
  const new({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: SecondaryButton(
          label: context.l10n.cancel,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: PrimaryButton(label: label, onPressed: onPressed),
      ),
    ],
  );
}

/// Шторка поднимается над клавиатурой: поле ввода и «Сохранить» не
/// прячутся под ней.
Future<T?> _showSheet<T>(BuildContext context, Widget child) =>
    showModalBottomSheet<T>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SafeArea(
          child: SingleChildScrollView(padding: _sheetPadding, child: child),
        ),
      ),
    );

// ───────────────────────── Дата и время ─────────────────────────

/// Начало и конец смены после выбора.
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
}) => _showSheet(
  context,
  _DateTimeSheet(start: start, end: end, max: max, editEnd: editEnd),
);

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
            const SizedBox(height: 16),
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
          const SizedBox(height: 16),
          _SheetButtons(
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

/// Календарь месяца и время с клавиатуры. [value] и [max] — UTC, на
/// экране — местное время. [max] — обычно «сейчас»: его день отмечен как
/// сегодня, дни позже недоступны.
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
    final l = context.l10n;
    final colors = context.colors;
    final locale = context.localeTag;
    final local = widget.value.toLocal();
    final selected = _dayOf(local);
    final maxDay = _dayOf(widget.max.toLocal());
    final next = DateTime(_month.year, _month.month + 1);
    final days = DateTime(_month.year, _month.month + 1, 0).day;
    final offset = _month.weekday - DateTime.monday;
    final weekday = DateFormat('EEE', locale);
    final cells = <int?>[
      for (var i = 0; i < offset; i++) null,
      for (var d = 1; d <= days; d++) d,
    ];
    while (cells.length % 7 != 0) {
      cells.add(null);
    }

    Widget dayCell(int? d) {
      if (d == null) return const SizedBox(height: AppSize.minTouch);
      final day = DateTime(_month.year, _month.month, d);
      final isSelected = day == selected;
      final disabled = day.isAfter(maxDay);
      final isToday = day == maxDay;
      return Semantics(
        selected: isSelected,
        label: formatWeekdayFull(day, locale),
        excludeSemantics: true,
        button: true,
        enabled: !disabled,
        child: Material(
          color: isSelected ? colors.drive : Colors.transparent,
          shape: StadiumBorder(
            side: isToday && !isSelected
                ? BorderSide(color: colors.textSecondary)
                : BorderSide.none,
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: disabled
                ? null
                : () => _set(year: day.year, month: day.month, day: d),
            child: SizedBox(
              height: AppSize.minTouch,
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '$d',
                    style: AppTextStyles.valueSmall.copyWith(
                      color: isSelected
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                formatMonthYear(_month, locale),
                style: AppTextStyles.header,
              ),
            ),
            IconButton(
              tooltip: l.pickerPrevMonth,
              onPressed: () => setState(
                () => _month = DateTime(_month.year, _month.month - 1),
              ),
              icon: const Icon(Icons.chevron_left),
            ),
            IconButton(
              tooltip: l.pickerNextMonth,
              onPressed: next.isAfter(maxDay)
                  ? null
                  : () => setState(() => _month = next),
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ExcludeSemantics(
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
                          color: colors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        for (var row = 0; row < cells.length; row += 7)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                for (final d in cells.sublist(row, row + 7))
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: dayCell(d),
                    ),
                  ),
              ],
            ),
          ),
        if (widget.withTime) ...[
          Divider(height: 24, color: colors.surface2),
          HmField(
            label: l.pickerTime,
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

  static String _capitalized(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}

/// Шторка выбора дня (свой период отчёта): календарь без времени.
/// [initial] и результат — день по календарю телефона, не позже [max].
Future<DateTime?> showDaySheet(
  BuildContext context, {
  required String title,
  required DateTime initial,
  required DateTime max,
}) => _showSheet(context, _DaySheet(title: title, initial: initial, max: max));

class _DaySheet extends StatefulWidget {
  const new({required this.title, required this.initial, required this.max});

  final String title;
  final DateTime initial;
  final DateTime max;

  @override
  State<_DaySheet> createState() => _DaySheetState();
}

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
          const SizedBox(height: 16),
          _SheetButtons(
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

// ───────────────────────── Длительность ─────────────────────────

/// Шторка «длительность» (экран 7): «Ч:ММ» с клавиатуры. [min]–[max] —
/// пределы, которые задают записи режимов (правка идущей смены); без
/// [max] ограничений нет — значение проверит сохранение. [computed] —
/// сколько насчитало приложение; [hint] — пояснение под полем для
/// введённого значения. [label] — подпись поля, иначе [title]; [action] —
/// кнопка, иначе «Сохранить», неактивная, пока значение не изменили;
/// с [action] подтвердить можно и прежнее. null — водитель передумал.
Future<Duration?> showDurationSheet(
  BuildContext context, {
  required String title,
  required Duration initial,
  Duration? max,
  Duration min = Duration.zero,
  String? subtitle,
  Duration? computed,
  String Function(Duration value)? hint,
  String? label,
  String? action,
}) => _showSheet(
  context,
  _DurationSheet(
    title: title,
    subtitle: subtitle,
    initial: initial,
    min: min,
    max: max,
    computed: computed,
    hint: hint,
    label: label,
    action: action,
  ),
);

class _DurationSheet extends StatefulWidget {
  const new({
    required this.title,
    required this.subtitle,
    required this.initial,
    required this.min,
    required this.max,
    required this.computed,
    required this.hint,
    required this.label,
    required this.action,
  });

  final String title;
  final String? subtitle;
  final Duration initial;
  final Duration min;
  final Duration? max;
  final Duration? computed;
  final String Function(Duration value)? hint;
  final String? label;
  final String? action;

  @override
  State<_DurationSheet> createState() => _DurationSheetState();
}

class _DurationSheetState extends State<_DurationSheet> {
  late Duration? _value = _clamped(widget.initial);

  /// Часов в поле: не больше 99, если предел не выше.
  static const _maxHours = 99;

  Duration _clamped(Duration v) {
    final max = widget.max;
    if (v < widget.min) return widget.min;
    return max != null && v > max ? max : v;
  }

  bool _inRange(Duration v) {
    final max = widget.max;
    return v >= widget.min && (max == null || v <= max);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final computed = widget.computed;
    final subtitle = widget.subtitle;
    final value = _value;
    final max = widget.max;
    final valid = value != null && _inRange(value);
    final hint = value == null ? null : widget.hint?.call(value);
    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      label: widget.title,
      explicitChildNodes: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(widget.title, style: AppTextStyles.header),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTextStyles.body.copyWith(color: colors.textSecondary),
            ),
          ],
          if (computed != null) ...[
            const SizedBox(height: 16),
            DecoratedBox(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(AppRadius.badge),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l.driveEditComputed,
                        style: AppTextStyles.body.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(formatHm(computed), style: AppTextStyles.valueSmall),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          HmField(
            label: widget.label ?? widget.title,
            value: _clamped(widget.initial),
            clock: false,
            maxHours: max == null || max.inHours < _maxHours
                ? _maxHours
                : max.inHours,
            autofocus: true,
            errorText: value != null && !valid
                ? l.pickerRange(formatHm(widget.min), formatHm(max!))
                : null,
            onChanged: (v) => setState(() => _value = v),
          ),
          if (max != null && (value == null || valid)) ...[
            const SizedBox(height: 12),
            Text(
              l.pickerRange(formatHm(widget.min), formatHm(max)),
              style: AppTextStyles.caption.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
          if (hint != null) ...[
            const SizedBox(height: 12),
            StatusBanner(hint, tone: Tone.warning),
          ],
          const SizedBox(height: 16),
          _SheetButtons(
            label: widget.action ?? l.save,
            onPressed:
                !valid || (widget.action == null && value == widget.initial)
                ? null
                : () => Navigator.of(context).pop(value),
          ),
        ],
      ),
    );
  }
}
