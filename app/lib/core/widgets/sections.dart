/// Building blocks of list screens: section titles, grouped cards and durations
/// that screen readers read in words.
library;

import 'package:flutter/material.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';

/// A section title: "TODAY".
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

/// A card with rows separated by lines. Rows take the full card width:
/// otherwise a text-only row shrinks to its text and centres itself.
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
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

/// A duration "4:30" that the screen reader reads as "4 hours 30 minutes".
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
