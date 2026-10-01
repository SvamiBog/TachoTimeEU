import 'package:flutter/material.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';

/// Точка вехи: сплошная — уже было, кольцо — впереди, приглушённая —
/// недоступно.
enum MilestoneDot { solid, ring, muted }

/// Веха на экранах лимитов: «13 ч — обычный день ··· 19:49».
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

/// Пояснение правила под карточками экрана лимита.
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
