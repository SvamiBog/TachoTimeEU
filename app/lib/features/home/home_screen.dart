import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/features/home/alerts.dart';
import 'package:tachogo/features/home/card_reading.dart';
import 'package:tachogo/features/home/hero_card.dart';
import 'package:tachogo/features/home/limit_sections.dart';
import 'package:tachogo/features/home/mode_buttons.dart';
import 'package:tachogo/features/home/snapshot_select.dart';

enum _Load { loading, ready, failed }

/// Главная (экран 1): состояние водителя, кнопки режимов и остатки по
/// всем лимитам. Каждый блок подписан на свою часть расчёта, поэтому тик
/// часов перестраивает только таймеры, у которых сменилась минута.
class HomeScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final load = ref.watch(
      complianceProvider.select(
        (a) => a.hasValue
            ? _Load.ready
            : a.hasError
            ? _Load.failed
            : _Load.loading,
      ),
    );
    return Scaffold(
      body: SafeArea(
        child: switch (load) {
          _Load.loading => const Center(child: CircularProgressIndicator()),
          _Load.failed => const _LoadError(),
          _Load.ready => ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: const [
              HomeHeader(),
              HeroCard(),
              ModeButtons(),
              AlertsSection(),
              TodaySection(),
              RestSection(),
              WeekSection(),
              CardReadingTile(),
            ],
          ),
        },
      ),
    );
  }
}

/// «TachoGo / Ср, 23 сентября · смена с 06:49».
class HomeHeader extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = watchSnapshot(ref, (s) {
      final local = s.now.toLocal();
      return (
        day: DateTime(local.year, local.month, local.day),
        shiftStart: s.shift?.start,
      );
    });
    final l = context.l10n;
    final date = s == null ? '' : formatWeekdayDate(s.day, context.localeTag);
    final shiftStart = s?.shiftStart;
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 64),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding + 4,
          8,
          AppSpacing.screenPadding,
          8,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.appTitle, style: AppTextStyles.header),
            const SizedBox(height: 2),
            Text(
              shiftStart == null
                  ? l.homeNoShift(date)
                  : l.homeShiftSince(date, formatClock(shiftStart)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.small.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.screenPadding * 2),
      child: Text(
        context.l10n.homeLoadError,
        textAlign: TextAlign.center,
        style: AppTextStyles.body.copyWith(color: context.colors.errorText),
      ),
    ),
  );
}
