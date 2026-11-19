/// Start and end countries of the shift (Mobility Package): the chip in the
/// home header and the sheets with the country picker — for the shift on the
/// home screen, the company country and the shift form.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/data/countries/country_providers.dart';
import 'package:tachogo/data/countries/country_repository.dart';
import 'package:tachogo/data/settings/settings_providers.dart';
import 'package:tachogo/features/home/country_picker.dart';

// Форма смены берёт выбор страны отсюда вместе с шторкой.
export 'package:tachogo/features/home/country_picker.dart'
    show CountryPicker, CountryTarget;

/// Countries chip in the home header: "PL → —".
class CountryChip extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final colors = context.colors;
    final countries = ref.watch(currentCountriesProvider);
    final start = countries?.start;
    final end = countries?.end;
    final label = switch ((start, end)) {
      (null, _) => l.countryChipNone,
      (final s?, null) => l.countryChipNoEnd(s),
      (final s?, final e?) => l.countryChip(s, e),
    };
    const code = AppTextStyles.rowTitle;
    return Semantics(
      container: true,
      button: true,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: colors.surface,
        shape: StadiumBorder(side: BorderSide(color: colors.line)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => showCountrySheet(context),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppSize.minTouch),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(start ?? '—', style: code),
                  const SizedBox(width: AppSpacing.s8),
                  Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: colors.textSecondary,
                  ),
                  const SizedBox(width: AppSpacing.s8),
                  Text(
                    end ?? '—',
                    style: code.copyWith(
                      color: end == null ? colors.textSecondary : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Шторка «Выбор страны» (экран 10): начало и конец смены. Без смены —
/// страна следующей смены.
Future<void> showCountrySheet(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => const _AboveKeyboard(
        child: FractionallySizedBox(heightFactor: 0.9, child: CountrySheet()),
      ),
    );

/// Lifts the searchable sheet above the keyboard so the list does not go under
/// it.
class _AboveKeyboard extends StatelessWidget {
  const new({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
    child: child,
  );
}

/// Shift countries on the home screen: a choice is written to the shift at once
/// (free, like switching activity).
class CountrySheet extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasShift = ref.watch(countryShiftProvider) != null;
    final countries = ref.watch(currentCountriesProvider);
    return CountryPicker(
      start: countries?.start,
      end: countries?.end,
      single: !hasShift,
      onPick: (target, code) => _pick(ref, target, code),
    );
  }

  static Future<CountryTarget?> _pick(
    WidgetRef ref,
    CountryTarget target,
    String? code,
  ) async {
    final shift = ref.read(countryShiftProvider);
    final current = ref.read(currentCountriesProvider);
    if (shift == null) {
      // Смены нет — это страна следующей смены
      if (code != null) {
        await ref.read(settingsRepositoryProvider).setDefaultCountry(code);
      }
      return null;
    }
    final repo = ref.read(countryRepositoryProvider);
    switch (target) {
      case CountryTarget.start:
        await repo.setShiftCountries(
          shift,
          ShiftCountries(start: code!, end: current?.end),
        );
        return CountryTarget.end;
      case CountryTarget.end:
        final start = current?.start;
        if (start == null) return CountryTarget.start;
        await repo.setShiftCountries(
          shift,
          ShiftCountries(start: start, end: code),
        );
        return null;
    }
  }
}

/// Шторка «Страна фирмы»: выбор сразу пишется в настройки расчёта.
Future<void> showBaseCountrySheet(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => const _AboveKeyboard(
        child: FractionallySizedBox(heightFactor: 0.9, child: _BaseCountry()),
      ),
    );

/// The company country picker: one country, written to settings at once.
class _BaseCountry extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) => CountryPicker(
    start: ref.watch(baseCountryProvider),
    end: null,
    single: true,
    title: context.l10n.settingsBaseCountry,
    onPick: (_, code) async {
      if (code != null) {
        await ref.read(settingsRepositoryProvider).setBaseCountry(code);
      }
      return null;
    },
  );
}

/// Шторка выбора стран для формы смены: страны меняются в форме, а не в
/// БД. Возвращает выбранные страны; null — шторку закрыли.
Future<({String? start, String? end})?> showCountryPicker(
  BuildContext context, {
  required String? start,
  required String? end,
  CountryTarget target = CountryTarget.start,
}) => showModalBottomSheet<({String? start, String? end})>(
  context: context,
  showDragHandle: true,
  isScrollControlled: true,
  builder: (_) => _AboveKeyboard(
    child: FractionallySizedBox(
      heightFactor: 0.9,
      child: _LocalCountries(start: start, end: end, target: target),
    ),
  ),
);

/// Country picker that keeps its choice locally and returns it to the caller,
/// for forms that save later.
class _LocalCountries extends StatefulWidget {
  const new({required this.start, required this.end, required this.target});

  final String? start;
  final String? end;
  final CountryTarget target;

  @override
  State<_LocalCountries> createState() => _LocalCountriesState();
}

/// The start and end countries picked so far.
class _LocalCountriesState extends State<_LocalCountries> {
  late String? _start = widget.start;
  late String? _end = widget.end;

  @override
  Widget build(BuildContext context) => CountryPicker(
    start: _start,
    end: _end,
    initialTarget: widget.target,
    closeWith: () => (start: _start, end: _end),
    onPick: (target, code) async {
      setState(() {
        if (target == CountryTarget.start) {
          _start = code;
        } else {
          _end = code;
        }
      });
      return target == CountryTarget.start ? CountryTarget.end : null;
    },
  );
}
