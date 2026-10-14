/// A limit row of the home screen: title, chip, value and bar.
library;

import 'package:flutter/material.dart';
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
    final colors = context.colors;
    final caption = AppTextStyles.caption.copyWith(color: colors.textSecondary);
    final value = this.value;
    final body = Padding(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutBuilder(
            builder: (context, box) => Row(
              children: [
                Expanded(child: Text(title, style: AppTextStyles.rowTitle)),
                if (chip case final chip?) ...[
                  const SizedBox(width: 8),
                  // Чип не отнимает у названия больше половины строки
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: box.maxWidth * 0.45),
                    child: chip,
                  ),
                ],
                const SizedBox(width: 8),
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
                      style: AppTextStyles.body.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                  null => const SizedBox.shrink(),
                },
                // «›» — у строки есть экран с подробностями
                if (this.onTap != null) ...[
                  const SizedBox(width: 2),
                  Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: colors.textSecondary,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 10),
          bar,
          if (footer case final footer?) ...[
            const SizedBox(height: 10),
            footer,
          ] else if (left != null || right != null) ...[
            const SizedBox(height: 10),
            // Обе подписи в одну строку, если помещаются, иначе правая —
            // строкой ниже.
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 12,
              runSpacing: 2,
              children: [
                Text(left ?? '', style: caption),
                if (right case final right?) Text(right, style: caption),
              ],
            ),
          ],
        ],
      ),
    );
    final onTap = this.onTap;
    if (onTap == null) return body;
    return InkWell(onTap: onTap, child: body);
  }
}
