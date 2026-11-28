/// "Card reconciliation" screen (developer build): for each day the card and
/// the TachoGo log as two strips coloured by activity, and how long they
/// differ. Read only for now: moving the card data into the log comes next.
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show FutureProviderFamily;
import 'package:tacho_engine/card.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/detail_scaffold.dart';
import 'package:tachogo/core/widgets/mode_style.dart';
import 'package:tachogo/core/widgets/sections.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/tachograph/card_reconcile.dart';

void openCardReconcile(BuildContext context, String path) =>
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => CardReconcileScreen(path: path)),
    );

/// Сверка файла карты по пути с журналом: читается файл, время считывания —
/// из имени файла, журнал — весь.
final FutureProviderFamily<CardReconciliation, String> cardReconcileProvider =
    FutureProvider.autoDispose.family<CardReconciliation, String>((
      ref,
      path,
    ) async {
      final card = DriverCard.parse(File(path).readAsBytesSync());
      final periods = cardPeriods(card.days, until: cardReadAt(path));
      final journal = await ref.read(activityRepositoryProvider).periods();
      return reconcileCard(
        card: periods,
        journal: journal,
        now: ref.read(clockProvider),
      );
    });

/// The card reconciliation screen.
class CardReconcileScreen extends ConsumerWidget {
  const new({required this.path, super.key});

  final String path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final result = ref.watch(cardReconcileProvider(path));
    return DetailScaffold(
      title: l.tachoReconcileTitle,
      subtitle: l.tachoBeta,
      children: switch (result) {
        AsyncData(:final value) when value.days.isEmpty => [
          _Text(l.tachoReconcileEmpty),
        ],
        AsyncData(:final value) => [
          _Text(
            l.tachoReconcileSummary(
              value.days.length,
              value.same,
              value.days.length - value.same,
            ),
          ),
          _Text(l.tachoReconcileNote, secondary: true),
          for (final day in value.days) _DayCompare(day),
        ],
        AsyncError() => [_Text(l.tachoReconcileError)],
        _ => const [
          Padding(
            padding: EdgeInsets.all(AppSpacing.screenPadding),
            child: Center(child: CircularProgressIndicator()),
          ),
        ],
      },
    );
  }
}

/// A line of text under the header.
class _Text extends StatelessWidget {
  const new(this.text, {this.secondary = false});

  final String text;
  final bool secondary;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(
      AppSpacing.textInset,
      AppSpacing.s12,
      AppSpacing.textInset,
      0,
    ),
    child: Text(
      text,
      style: (secondary ? AppTextStyles.small : AppTextStyles.body).copyWith(
        color: secondary ? context.colors.textSecondary : context.colors.text,
      ),
    ),
  );
}

/// One day: the date, "matches" or "differs by…", and the two strips.
class _DayCompare extends StatelessWidget {
  const new(this.day);

  final ReconcileDay day;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final differs = Duration(minutes: day.differentMinutes);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.betweenCardsMax),
      child: CardGroup(
        children: [
          CardRow(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        formatWeekdayDate(day.day, context.localeTag),
                        style: AppTextStyles.rowTitle,
                      ),
                    ),
                    Text(
                      day.matches
                          ? l.tachoReconcileSame
                          : l.tachoReconcileDiff(formatHm(differs)),
                      style: AppTextStyles.small.copyWith(
                        color: day.matches
                            ? colors.textSecondary
                            : colors.errorText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s8),
                _Strip(label: l.tachoReconcileCard, segments: day.card),
                const SizedBox(height: AppSpacing.s4),
                _Strip(label: l.appTitle, segments: day.journal),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A day of one log as a coloured strip; grey — no data.
class _Strip extends StatelessWidget {
  const new({required this.label, required this.segments});

  final String label;
  final List<DaySegment> segments;

  /// Ширина подписи полосы.
  static const _labelWidth = 72.0;

  /// Высота полосы.
  static const _height = 12.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        SizedBox(
          width: _labelWidth,
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.small.copyWith(color: colors.textSecondary),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.icon),
            child: SizedBox(
              height: _height,
              child: Row(
                children: [
                  for (final s in segments)
                    Expanded(
                      flex: s.minutes,
                      child: ColoredBox(
                        color: switch (s.mode) {
                          final DriverMode mode? => colors.mode(mode),
                          null => colors.surface2,
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
