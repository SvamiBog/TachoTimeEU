/// A limit row of the home screen: title, chip, value and bar, and the helpers
/// the limit sections build its parts with.
library;

import 'package:flutter/material.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/limit_bar.dart';
import 'package:tachogo/core/widgets/sections.dart';
import 'package:tachogo/core/widgets/status_chip.dart';

/// The value on the right of a limit row: a duration or a state text.
sealed class RowValue {
  const new();
}

/// "3:55" in JetBrains Mono, read aloud as "3 hours 55 minutes".
class DurationValue extends RowValue {
  const new(this.text, {required this.spoken, this.color});

  final String text;
  final String spoken;
  final Color? color;
}

/// "not started", "in progress 2:15".
class StatusValue extends RowValue {
  const new(this.text);

  final String text;
}

/// Длительность в строке лимита: при «превышено» — цветом ошибки.
DurationValue limitDuration(
  BuildContext context,
  Duration d, {
  Tone tone = Tone.neutral,
  Color? color,
}) => DurationValue(
  formatHm(d),
  spoken: spokenDuration(context.l10n, d),
  color: tone == Tone.violation ? context.colors.errorText : color,
);

/// Чип строки: при «скоро» и «превышено» — вместо обычного.
StatusChip? limitChip(
  BuildContext context,
  Tone tone, {
  required String soon,
  String? normal,
}) => switch (tone) {
  Tone.violation => StatusChip(context.l10n.chipExceeded, tone: Tone.violation),
  Tone.warning => StatusChip(soon, tone: Tone.warning),
  _ => normal == null ? null : StatusChip(normal),
};

/// Цвет полосы: при «превышено» — цвет ошибки, иначе [normal].
Color limitBarColor(BuildContext context, Tone tone, Color normal) =>
    tone == Tone.violation ? context.colors.errorText : normal;

/// A limit row: title, chip and value, bar, captions under it.
class LimitRow extends StatelessWidget {
  const new({
    required this.title,
    required this.bar,
    this.value,
    this.chip,
    this.left,
    this.right,
    this.footer,
    this.onTap,
    super.key,
  });

  final String title;
  final RowValue? value;
  final StatusChip? chip;
  final LimitBar bar;
  final String? left;
  final String? right;

  /// Низ строки вместо подписей [left] и [right]: остатки рабочего дня.
  final Widget? footer;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final body = Padding(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TitleLine(
            title: title,
            chip: chip,
            value: value,
            details: this.onTap != null,
          ),
          const SizedBox(height: AppSpacing.s10),
          bar,
          if (footer case final footer?) ...[
            const SizedBox(height: AppSpacing.s10),
            footer,
          ] else if (left != null || right != null) ...[
            const SizedBox(height: AppSpacing.s10),
            _Captions(left: left, right: right),
          ],
        ],
      ),
    );
    final onTap = this.onTap;
    if (onTap == null) return body;
    return InkWell(onTap: onTap, child: body);
  }
}

/// The top line of a limit row: title, chip, value and "›" when the row opens
/// a details screen.
class _TitleLine extends StatelessWidget {
  const new({
    required this.title,
    required this.chip,
    required this.value,
    required this.details,
  });

  final String title;
  final StatusChip? chip;
  final RowValue? value;

  /// У строки есть экран с подробностями — «›» справа.
  final bool details;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final value = this.value;
    return LayoutBuilder(
      builder: (context, box) => Row(
        children: [
          Expanded(child: Text(title, style: AppTextStyles.rowTitle)),
          if (chip case final chip?) ...[
            const SizedBox(width: AppSpacing.s8),
            // Чип не отнимает у названия больше половины строки
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: box.maxWidth * 0.45),
              child: chip,
            ),
          ],
          const SizedBox(width: AppSpacing.s8),
          switch (value) {
            DurationValue(:final text, :final spoken, :final color) =>
              DurationText(
                text,
                spoken: spoken,
                style: AppTextStyles.value.copyWith(color: color),
              ),
            // Длинное состояние на другом языке («nierozpoczęty»)
            // переносится, а не выталкивает строку за край.
            StatusValue(:final text) => ConstrainedBox(
              constraints: BoxConstraints(maxWidth: box.maxWidth * 0.35),
              child: Text(
                text,
                textAlign: TextAlign.end,
                style: AppTextStyles.body.copyWith(color: colors.textSecondary),
              ),
            ),
            null => const SizedBox.shrink(),
          },
          // «›» — у строки есть экран с подробностями
          if (details) ...[
            const SizedBox(width: 2),
            Icon(Icons.chevron_right, size: 20, color: colors.textSecondary),
          ],
        ],
      ),
    );
  }
}

/// Both captions under the bar on one line if they fit; otherwise the right
/// one moves to the next line.
class _Captions extends StatelessWidget {
  const new({required this.left, required this.right});

  final String? left;
  final String? right;

  @override
  Widget build(BuildContext context) {
    final caption = AppTextStyles.caption.copyWith(
      color: context.colors.textSecondary,
    );
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      spacing: AppSpacing.s12,
      runSpacing: 2,
      children: [
        Text(left ?? '', style: caption),
        if (right case final right?) Text(right, style: caption),
      ],
    );
  }
}
