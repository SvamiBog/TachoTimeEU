/// Home card for a truck driving ban in the country where the driver is now.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tacho_engine/driving_bans.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/widgets/sections.dart';
import 'package:tachogo/core/widgets/setting_rows.dart';
import 'package:tachogo/data/bans/ban_data_providers.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/features/bans/ban_format.dart';
import 'package:tachogo/features/bans/country_bans_screen.dart';
import 'package:tachogo/features/bans/driving_bans_screen.dart';
import 'package:tachogo/features/home/snapshot_select.dart';

/// Запрет в стране водителя ([banCountryProvider]) на текущую минуту, если
/// он идёт или начнётся в ближайшие 3 ч. Частичные запреты и запреты на
/// отдельных дорогах главная не показывает — они на экране страны.
/// Считается одна страна, а не все, как в [banStatusesProvider].
final homeBanProvider =
    Provider<({CountryBans country, BanStatus status, DateTime now})?>((ref) {
      final code = ref.watch(banCountryProvider);
      if (code == null) return null;
      final country = ref.watch(banDataProvider.select((all) => all[code]));
      if (country == null) return null;
      final now = ref.watch(clockProvider.select(minuteOf));
      final status = banStatus(country, bansMass, now);
      return switch (status.level) {
        BanLevel.active ||
        BanLevel.soon => (country: country, status: status, now: now),
        _ => null,
      };
    });

/// A driving ban in the driver's current country: on now or starting soon.
/// A tap opens the country's bans. There is no mockup — built from the design
/// system rows, like the company country card above it.
class BanCard extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ban = ref.watch(homeBanProvider);
    if (ban == null) return const SizedBox.shrink();
    final l = context.l10n;
    final code = ban.country.code;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.betweenCardsMax),
      child: CardGroup(
        children: [
          NavRow(
            icon: Icons.do_not_disturb_on_outlined,
            iconColor: banColor(context.colors, ban.status.level),
            title: l.countryName(code),
            subtitle: banStatusText(
              l,
              ban.country,
              ban.status,
              ban.now,
              context.localeTag,
            ),
            onTap: () => openCountryBans(context, code),
          ),
        ],
      ),
    );
  }
}
