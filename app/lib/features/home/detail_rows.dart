/// Rows shared by the limit detail screens: milestones and rule notes.
library;

import 'package:flutter/material.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';

/// Milestone dot: solid — already passed, ring — ahead, muted — unavailable.
enum MilestoneDot { solid, ring, muted }

/// A milestone on the limit screens: "13 h — normal day ··· 19:49".
class MilestoneRow extends StatelessWidget {
  const new({
    required this.dot,
    required this.title,
    required this.value,
    this.subtitle,
    this.muted = false,
    this.valueColor,
    super.key,
  });

  final MilestoneDot dot;
  final String title;
  final String? subtitle;
  final String value;
  final bool muted;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dotColor = dot == MilestoneDot.muted
        ? colors.textSecondary
        : colors.text;
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 64),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.cardPadding,
          vertical: 12,
        ),
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: dot == MilestoneDot.solid ? dotColor : null,
                border: dot == MilestoneDot.solid
                    ? null
                    : Border.all(color: dotColor, width: 2),
              ),
              child: const SizedBox.square(dimension: 10),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.rowTitle),
                  if (subtitle case final subtitle?)
                    Text(
                      subtitle,
                      style: AppTextStyles.caption.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              value,
              style: AppTextStyles.value.copyWith(
                color: muted ? colors.textSecondary : valueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Explanation of a rule under the cards of a limit screen.
class InfoNote extends StatelessWidget {
  const new(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.betweenCardsMax,
        AppSpacing.screenPadding,
        0,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.badge),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, size: 20, color: colors.textSecondary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: AppTextStyles.body.copyWith(color: colors.chipText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
