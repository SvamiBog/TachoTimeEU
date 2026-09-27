import 'package:flutter/material.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/limit_bar.dart';
import 'package:tachogo/core/widgets/sections.dart';
import 'package:tachogo/core/widgets/status_chip.dart';

/// Значение справа в строке лимита: длительность или текст состояния.
sealed class RowValue {
  const new();
}

/// «3:55» — JetBrains Mono, читается как «3 часа 55 минут».
class DurationValue extends RowValue {
  const new(this.text, {required this.spoken, this.color});

  final String text;
  final String spoken;
  final Color? color;
}

/// «не начат», «идёт 2:15».
class StatusValue extends RowValue {
  const new(this.text);

  final String text;
}

/// Строка лимита: название, чип и значение, полоса, подписи под ней.
class LimitRow extends StatelessWidget {
  const new({
    required this.title,
    required this.bar,
    this.value,
    this.chip,
    this.left,
    this.right,
    this.onTap,
    super.key,
  });

  final String title;
  final RowValue? value;
  final StatusChip? chip;
  final LimitBar bar;
  final String? left;
  final String? right;
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
                  StatusValue(:final text) => Text(
                    text,
                    style: AppTextStyles.body.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  null => const SizedBox.shrink(),
                },
              ],
            ),
          ),
          const SizedBox(height: 10),
          bar,
          if (left != null || right != null) ...[
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
