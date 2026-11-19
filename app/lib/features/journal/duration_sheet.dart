/// The duration sheet (screen 7): "H:MM" typed on the keyboard within the
/// bounds the journal sets.
library;

import 'package:flutter/material.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/hm_field.dart';
import 'package:tachogo/core/widgets/status_chip.dart';
import 'package:tachogo/features/journal/picker_sheet.dart';

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
}) => showPickerSheet(
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

/// Sheet to type a duration "H:MM" within bounds.
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

/// The duration typed so far, kept within the bounds.
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
    final caption = AppTextStyles.caption.copyWith(
      color: context.colors.textSecondary,
    );
    final computed = widget.computed;
    final subtitle = widget.subtitle;
    final value = _value;
    final max = widget.max;
    final valid = value != null && _inRange(value);
    final hint = value == null ? null : widget.hint?.call(value);
    final range = max == null
        ? null
        : l.pickerRange(formatHm(widget.min), formatHm(max));
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
            const SizedBox(height: AppSpacing.s4),
            Text(
              subtitle,
              style: AppTextStyles.body.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ],
          if (computed != null) ...[
            const SizedBox(height: AppSpacing.s16),
            _Computed(computed),
          ],
          const SizedBox(height: AppSpacing.s16),
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
          if (range != null && (value == null || valid)) ...[
            const SizedBox(height: AppSpacing.s12),
            Text(range, style: caption),
          ],
          if (hint != null) ...[
            const SizedBox(height: AppSpacing.s12),
            StatusBanner(hint, tone: Tone.warning),
          ],
          const SizedBox(height: AppSpacing.s16),
          PickerButtons(
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

/// "Computed by the app      4:30": what the journal counted, for comparison.
class _Computed extends StatelessWidget {
  const new(this.value);

  final Duration value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.badge),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s16,
          vertical: AppSpacing.s14,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                context.l10n.driveEditComputed,
                style: AppTextStyles.body.copyWith(color: colors.textSecondary),
              ),
            ),
            const SizedBox(width: AppSpacing.s8),
            Text(formatHm(value), style: AppTextStyles.valueSmall),
          ],
        ),
      ),
    );
  }
}
