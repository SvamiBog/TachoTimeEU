import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tacho_engine/driving_bans.dart';
import 'package:tachogo/core/config/app_links.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/detail_scaffold.dart';
import 'package:tachogo/core/widgets/sections.dart';
import 'package:tachogo/core/widgets/setting_rows.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/data/settings/settings_providers.dart';
import 'package:tachogo/features/bans/ban_format.dart';
import 'package:tachogo/features/home/detail_rows.dart';
import 'package:tachogo/features/home/snapshot_select.dart';

void openCountryBans(BuildContext context, String code) =>
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => CountryBansScreen(code)));

/// Сколько дней вперёд показывает «Ближайшие запреты».
const upcomingDays = 14;

/// Запреты страны: что сейчас, правила, ближайшие запреты на две недели
/// (календарь — Premium, Фаза 5), где проверить, дата сверки.
class CountryBansScreen extends ConsumerWidget {
  const new(this.code, {super.key});

  final String code;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final locale = context.localeTag;
    final country = europeBans[code]!;
    final mass = ref.watch(vehicleMassProvider).value ?? VehicleMass.over12;
    final now = ref.watch(clockProvider.select(minuteOf));
    final status = banStatus(country, mass, now);
    final rules = [
      for (final r in country.rules)
        if (mass.heavierThan(r.overTonnes)) r,
    ];
    final upcoming = banWindows(
      country,
      mass,
      now,
      now.add(const Duration(days: upcomingDays)),
    );
    final checked = country.checkedOn;
    String two(int n) => n.toString().padLeft(2, '0');
    return DetailScaffold(
      title: l.countryName(code),
      children: [
        SectionTitle(l.bansNowTitle, top: 8),
        _Now(country: country, status: status, now: now),
        if (country.coverage == BanCoverage.rules) ...[
          SectionTitle(l.bansRules),
          CardGroup(
            children: [
              for (final r in country.rules)
                _Line(
                  title: banRuleText(l, r, locale),
                  subtitle: banRuleCaption(l, r, locale),
                  muted: !rules.contains(r),
                ),
            ],
          ),
          if (rules.isNotEmpty) ...[
            SectionTitle(l.bansUpcoming),
            CardGroup(
              children: [
                if (upcoming.isEmpty)
                  _Line(title: l.bansNoUpcoming)
                else
                  for (final w in upcoming)
                    _Line(
                      title: banSpan(w, country.zone, locale),
                      subtitle: [
                        w.kinds.map((k) => l.bansKind(k.name)).join(', '),
                        l.bansScope(w.scope.name),
                        if (w.provisional) l.bansProvisional,
                      ].join(' · '),
                      warn: w.scope.definite,
                    ),
              ],
            ),
          ],
        ] else
          InfoNote(
            country.coverage == BanCoverage.someRoads
                ? l.bansRoadsText
                : l.bansNoneText,
          ),
        if (country.sources.isNotEmpty) ...[
          SectionTitle(l.bansSources),
          CardGroup(
            children: [
              for (final source in country.sources)
                NavRow(
                  icon: Icons.open_in_new,
                  title: Uri.parse(source).host,
                  onTap: () => unawaited(
                    ref.read(linkOpenerProvider).open(Uri.parse(source)),
                  ),
                ),
            ],
          ),
        ],
        InfoNote(
          [
            l.bansChecked(
              '${two(checked.day)}.${two(checked.month)}.${checked.year}',
            ),
            if (country.needsCheck) l.bansNeedsCheck,
            l.bansDisclaimer,
          ].join('\n\n'),
        ),
      ],
    );
  }
}

class _Now extends StatelessWidget {
  const new({required this.country, required this.status, required this.now});

  final CountryBans country;
  final BanStatus status;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final window = status.current ?? status.partial;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.heroCard),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: banColor(colors, status.level),
                  shape: BoxShape.circle,
                ),
                child: const SizedBox.square(dimension: 16),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      banStatusText(l, country, status, now, context.localeTag),
                      style: AppTextStyles.rowTitle.copyWith(
                        color: status.level == BanLevel.active
                            ? colors.errorText
                            : null,
                      ),
                    ),
                    if (window != null)
                      Text(
                        [
                          window.kinds
                              .map((k) => l.bansKind(k.name))
                              .join(', '),
                          l.bansScope(window.scope.name),
                        ].join(' · '),
                        style: AppTextStyles.caption.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Строка правила или запрета: текст и подпись.
class _Line extends StatelessWidget {
  const new({
    required this.title,
    this.subtitle,
    this.muted = false,
    this.warn = false,
  });

  final String title;
  final String? subtitle;

  /// Правило не для этой массы машины.
  final bool muted;

  /// Запрет по всей сети дорог.
  final bool warn;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: AppSize.listRow),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.cardPadding,
          vertical: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: AppTextStyles.rowTitle.copyWith(
                color: muted
                    ? colors.textSecondary
                    : warn
                    ? colors.errorText
                    : null,
              ),
            ),
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
    );
  }
}
