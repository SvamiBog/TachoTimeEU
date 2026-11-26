/// Home screen tile while a tachograph is connected: the activity in the log
/// follows the tachograph (BT-20). Tap opens the tachograph screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/features/tachograph/tachograph_controller.dart';
import 'package:tachogo/features/tachograph/tachograph_screen.dart';

/// "Activity from the tachograph · DTCO…: change the activity on the
/// tachograph"; nothing when no tachograph is connected.
class TachographLinkTile extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final device = ref.watch(tachographLinkProvider);
    if (device == null) return const SizedBox.shrink();
    final l = context.l10n;
    final colors = context.colors;
    final name = device.name.trim().isEmpty
        ? l.tachoUnnamed
        : device.name.trim();
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.betweenCardsMax,
        AppSpacing.screenPadding,
        0,
      ),
      child: Material(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => openTachograph(context),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            child: Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.surface2,
                    borderRadius: BorderRadius.circular(AppRadius.icon),
                  ),
                  child: SizedBox.square(
                    dimension: AppSize.minTouch,
                    child: Icon(
                      Icons.bluetooth_connected,
                      size: 22,
                      color: colors.text,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.s14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.tachoLinkTitle, style: AppTextStyles.rowTitle),
                      const SizedBox(height: 2),
                      Text(
                        l.tachoLinkHint(name),
                        style: AppTextStyles.small.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: colors.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
