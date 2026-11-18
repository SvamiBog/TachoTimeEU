/// Building blocks of list screens: tab and section titles, the summary card,
/// grouped cards and their rows, durations that screen readers read in words.
library;

import 'package:flutter/material.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';

/// The title of a bottom navigation tab with nothing beside it: "More",
/// "Settings". The screen reader announces it as a header.
class TabTitle extends StatelessWidget {
  const new(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(minHeight: 64),
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding + 4,
        vertical: 8,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Semantics(
          header: true,
          child: Text(text, style: AppTextStyles.header),
        ),
      ),
    ),
  );
}

/// The summary card at the top of a screen: the main value of a limit screen,
/// the app name and version in "About". Children take the card's width.
class HeroCard extends StatelessWidget {
  const new({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(
      AppSpacing.screenPadding,
      8,
      AppSpacing.screenPadding,
      0,
    ),
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.heroCard),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    ),
  );
}

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

/// The frame of a list row: at least 56 dp tall, with the card's side
/// padding. The row's content and its tap handling stay with the caller.
class CardRow extends StatelessWidget {
  const new({required this.child, this.vertical = 10, super.key});

  /// Поля сверху и снизу: у строк с подписью — 10 dp.
  final double vertical;
  final Widget child;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(minHeight: AppSize.listRow),
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.cardPadding,
        vertical: vertical,
      ),
      child: child,
    ),
  );
}

/// The first row of a summary card: a large number and what it counts,
/// "12 working days". The screen reader reads them together.
class CountRow extends StatelessWidget {
  const new({required this.count, required this.label, this.color, super.key});

  final int count;
  final String label;

  /// Цвет числа, если оно говорит о состоянии: есть нарушения.
  final Color? color;

  @override
  Widget build(BuildContext context) => MergeSemantics(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            '$count',
            style: AppTextStyles.valueLarge.copyWith(color: color),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: AppTextStyles.rowTitle)),
        ],
      ),
    ),
  );
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
