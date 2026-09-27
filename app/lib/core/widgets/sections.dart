import 'package:flutter/material.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';

/// Заголовок раздела: «СЕГОДНЯ».
class SectionTitle extends StatelessWidget {
  const new(this.text, {this.top = AppSpacing.beforeSectionMax, super.key});

  final String text;

  /// Отступ сверху: перед разделом 24–28 dp, первый раздел под шапкой — 12.
  final double top;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(
      AppSpacing.screenPadding + 4,
      top,
      AppSpacing.screenPadding + 4,
      10,
    ),
    child: Semantics(
      header: true,
      child: Text(
        text.toUpperCase(),
        style: AppTextStyles.section.copyWith(
          color: context.colors.textSecondary,
        ),
      ),
    ),
  );
}

/// Карточка со строками через линию.
class CardGroup extends StatelessWidget {
  const new({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Material(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            for (final (i, child) in children.indexed) ...[
              if (i > 0)
                Divider(height: 1, thickness: 1, color: colors.surface2),
              child,
            ],
          ],
        ),
      ),
    );
  }
}

/// Длительность «4:30», которую экранный диктор читает как «4 часа
/// 30 минут».
class DurationText extends StatelessWidget {
  const new(this.text, {required this.spoken, this.style, super.key});

  final String text;
  final String spoken;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    label: spoken,
    excludeSemantics: true,
    child: Text(text, style: style, maxLines: 1),
  );
}
