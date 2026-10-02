import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tacho_engine/driving_bans.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/detail_scaffold.dart';
import 'package:tachogo/core/widgets/sections.dart';
import 'package:tachogo/data/countries/country_providers.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/features/bans/ban_format.dart';
import 'package:tachogo/features/bans/country_bans_screen.dart';
import 'package:tachogo/features/bans/europe_map.dart';
import 'package:tachogo/features/home/detail_rows.dart';
import 'package:tachogo/features/home/snapshot_select.dart';

void openDrivingBans(BuildContext context) => Navigator.of(context)
    .push(MaterialPageRoute<void>(builder: (_) => const DrivingBansScreen()));

/// Состояние запретов стран на текущую минуту.
final banStatusesProvider = Provider<Map<String, BanStatus>>((ref) {
  final now = ref.watch(clockProvider.select(minuteOf));
  return {
    for (final c in europeBans.values) c.code: banStatus(c, bansMass, now),
  };
});

/// Страна, где водитель сейчас: конечная страна смены или начальная.
final banCountryProvider = Provider<String?>((ref) {
  final countries = ref.watch(currentCountriesProvider);
  return countries?.end ?? countries?.start;
});

/// «Запреты движения» для грузовика больше 12 т: схема Европы — где запрет
/// сейчас, скоро, частичный, — и страны списком: касание — экран страны.
/// Сегодня и сейчас — бесплатно; календарь на будущие дни — Premium
/// (Фаза 5, docs/premium.md). Макета нет — из компонентов дизайн-системы.
class DrivingBansScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final statuses = ref.watch(banStatusesProvider);
    final current = ref.watch(banCountryProvider);
    final now = ref.watch(clockProvider.select(minuteOf));
    return DetailScaffold(
      title: l.bansTitle,
      subtitle: l.bansForTrucks,
      children: [
        const SizedBox(height: 8),
        _MapCard(statuses: statuses, current: current),
        SectionTitle(l.bansCountries),
        _CountryList(statuses: statuses, current: current, now: now),
        InfoNote(l.bansDisclaimer),
      ],
    );
  }
}

class _MapCard extends StatelessWidget {
  const new({required this.statuses, required this.current});

  final Map<String, BanStatus> statuses;
  final String? current;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final legend = [
      (BanLevel.active, l.bansLegendActive),
      (BanLevel.soon, l.bansLegendSoon),
      (BanLevel.partial, l.bansLegendPartial),
      (BanLevel.clear, l.bansLegendClear),
      (BanLevel.someRoads, l.bansLegendRoads),
      (BanLevel.none, l.bansNone),
      (null, l.bansLegendNoData),
    ];
    return CardGroup(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BansMap(
                levels: {
                  for (final e in statuses.entries) e.key: e.value.level,
                },
                current: current,
                onCountry: (code) => openCountryBans(context, code),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 14,
                runSpacing: 8,
                children: [
                  for (final (level, label) in legend)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _Dot(banColor(colors, level)),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            label,
                            style: AppTextStyles.caption.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CountryList extends StatelessWidget {
  const new({required this.statuses, required this.current, required this.now});

  final Map<String, BanStatus> statuses;
  final String? current;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final locale = context.localeTag;
    final codes = statuses.keys.toList()
      ..sort((a, b) {
        if (a == current) return -1;
        if (b == current) return 1;
        final byLevel = statuses[a]!.level.index.compareTo(
          statuses[b]!.level.index,
        );
        return byLevel != 0
            ? byLevel
            : l.countryName(a).compareTo(l.countryName(b));
      });
    return CardGroup(
      children: [
        for (final code in codes)
          _CountryRow(
            code: code,
            here: code == current,
            status: statuses[code]!,
            text: banStatusText(
              l,
              europeBans[code]!,
              statuses[code]!,
              now,
              locale,
            ),
          ),
      ],
    );
  }
}

class _CountryRow extends StatelessWidget {
  const new({
    required this.code,
    required this.here,
    required this.status,
    required this.text,
  });

  final String code;
  final bool here;
  final BanStatus status;
  final String text;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () => openCountryBans(context, code),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppSize.listRow),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.cardPadding,
              vertical: 10,
            ),
            child: Row(
              children: [
                _Dot(banColor(colors, status.level), size: 12),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        here
                            ? '${l.countryName(code)} · ${l.bansCurrentCountry}'
                            : l.countryName(code),
                        style: AppTextStyles.rowTitle,
                      ),
                      Text(
                        text,
                        style: AppTextStyles.caption.copyWith(
                          color: status.level == BanLevel.active
                              ? colors.errorText
                              : colors.textSecondary,
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

class _Dot extends StatelessWidget {
  const new(this.color, {this.size = 10});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    child: SizedBox.square(dimension: size),
  );
}
