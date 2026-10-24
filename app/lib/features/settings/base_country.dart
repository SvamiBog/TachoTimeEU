/// The company country: required, because two reduced weekly rests in a row
/// may not be taken there (Art. 8(6)) and working days are counted against it.
/// The row in settings and onboarding and the home card until it is chosen.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/widgets/sections.dart';
import 'package:tachogo/core/widgets/setting_rows.dart';
import 'package:tachogo/data/countries/country_providers.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/features/home/country_sheet.dart';

/// "Company country · Poland ›" in settings and onboarding.
class BaseCountryRow extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final code = ref.watch(baseCountryProvider);
    return NavRow(
      title: l.settingsBaseCountry,
      subtitle: l.settingsBaseCountryHint,
      value: code == null ? l.baseCountryNotSet : l.countryName(code),
      onTap: () => unawaited(showBaseCountrySheet(context)),
    );
  }
}

/// The home card while the company country is not chosen — for those who
/// went through onboarding before it existed. Gone once it is chosen.
class BaseCountryCard extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missing = ref.watch(
      complianceSettingsProvider.select(
        (a) => a.hasValue && a.value!.baseCountry == null,
      ),
    );
    if (!missing) return const SizedBox.shrink();
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.betweenCardsMax),
      child: CardGroup(
        children: [
          NavRow(
            icon: Icons.flag_outlined,
            title: l.baseCountryCardTitle,
            subtitle: l.baseCountryCardText,
            onTap: () => unawaited(showBaseCountrySheet(context)),
          ),
        ],
      ),
    );
  }
}
