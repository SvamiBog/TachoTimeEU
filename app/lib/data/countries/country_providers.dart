import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tachogo/data/countries/country_repository.dart';
import 'package:tachogo/data/db/database_provider.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/data/settings/settings_providers.dart';

final countryRepositoryProvider = Provider<CountryRepository>(
  (ref) => CountryRepository(
    ref.watch(databaseProvider),
    ref.watch(settingsRepositoryProvider),
  ),
);

final shiftCountriesProvider = StreamProvider<Map<DateTime, ShiftCountries>>(
  (ref) => ref.watch(countryRepositoryProvider).watchShifts(),
);

final recentCountriesProvider = StreamProvider<List<String>>(
  (ref) => ref.watch(countryRepositoryProvider).watchRecent(),
);

final defaultCountryProvider = StreamProvider<String?>(
  (ref) => ref.watch(settingsRepositoryProvider).watchDefaultCountry(),
);

/// Смена, к которой относятся страны на главной: текущая, а во время
/// отдыха после неё — только что закончившаяся. null — смены нет.
final countryShiftProvider = Provider<DateTime?>(
  (ref) => ref.watch(
    complianceProvider.select((a) {
      final s = a.value;
      if (s == null) return null;
      if (s.shift case final shift?) return shift.start;
      if (s.offDutyRest == null) return null;
      return s.timeline.shifts.lastOrNull?.start;
    }),
  ),
);

/// Страны для шапки главной: сохранённые или, пока не выбраны, страна по
/// умолчанию в начале. null — выбирать ещё не из чего.
final currentCountriesProvider = Provider<ShiftCountries?>((ref) {
  final shift = ref.watch(countryShiftProvider);
  final saved = shift == null
      ? null
      : ref.watch(shiftCountriesProvider.select((a) => a.value?[shift]));
  if (saved != null) return saved;
  final fallback = ref.watch(defaultCountryProvider.select((a) => a.value));
  return fallback == null ? null : ShiftCountries(start: fallback);
});

/// Записывает страну по умолчанию новой смене, как только смена началась.
/// Держит главная.
final shiftCountryAutofillProvider = Provider<void>((ref) {
  ref.listen(complianceProvider.select((a) => a.value?.shift?.start), (
    _,
    start,
  ) {
    if (start != null) {
      ref.read(countryRepositoryProvider).ensureShift(start).ignore();
    }
  }, fireImmediately: true);
});
