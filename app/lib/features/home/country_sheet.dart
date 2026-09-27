import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/data/countries/country_providers.dart';
import 'package:tachogo/data/countries/country_repository.dart';
import 'package:tachogo/data/countries/tacho_countries.dart';
import 'package:tachogo/data/settings/settings_providers.dart';

/// Чип стран в шапке главной: «PL → —».
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
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(start ?? '—', style: code),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: colors.textSecondary,
                  ),
                  const SizedBox(width: 8),
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
      builder: (_) =>
          const FractionallySizedBox(heightFactor: 0.9, child: CountrySheet()),
    );

enum _Target { start, end }

class CountrySheet extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<CountrySheet> createState() => _CountrySheetState();
}

class _CountrySheetState extends ConsumerState<CountrySheet> {
  _Target _target = _Target.start;
  String _query = '';
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _pick(String? code) async {
    final shift = ref.read(countryShiftProvider);
    final current = ref.read(currentCountriesProvider);
    final navigator = Navigator.of(context);
    if (shift == null) {
      // Смены нет — это страна следующей смены
      if (code != null) {
        await ref.read(settingsRepositoryProvider).setDefaultCountry(code);
      }
      navigator.pop();
      return;
    }
    final repo = ref.read(countryRepositoryProvider);
    switch (_target) {
      case _Target.start:
        await repo.setShiftCountries(
          shift,
          ShiftCountries(start: code!, end: current?.end),
        );
        setState(() {
          _target = _Target.end;
          _query = '';
          _search.clear();
        });
      case _Target.end:
        final start = current?.start;
        if (start == null) {
          setState(() => _target = _Target.start);
          return;
        }
        await repo.setShiftCountries(
          shift,
          ShiftCountries(start: start, end: code),
        );
        navigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final hasShift = ref.watch(countryShiftProvider) != null;
    final countries = ref.watch(currentCountriesProvider);
    final recent = ref.watch(recentCountriesProvider).value ?? const [];
    final selected = switch (_target) {
      _Target.start => countries?.start,
      _Target.end => countries?.end,
    };
    final q = _query.trim().toLowerCase();
    final list = [
      for (final code in TachoCountries.codes)
        if (q.isEmpty ||
            code.toLowerCase().contains(q) ||
            l.countryName(code).toLowerCase().contains(q))
          code,
    ];
    const pad = AppSpacing.screenPadding + 4;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(pad, 0, pad, 12),
          child: hasShift
              ? _Tabs(
                  target: _target,
                  start: l.countryStartTab(countries?.start ?? '—'),
                  end: l.countryEndTab(countries?.end ?? '—'),
                  onChanged: (t) => setState(() => _target = t),
                )
              : Text(l.countryNextShift, style: AppTextStyles.header),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: pad),
          child: TextField(
            controller: _search,
            onChanged: (v) => setState(() => _query = v),
            style: AppTextStyles.body,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: l.countrySearch,
              hintStyle: AppTextStyles.body.copyWith(
                color: colors.textSecondary,
              ),
              prefixIcon: Icon(Icons.search, color: colors.textSecondary),
              filled: true,
              fillColor: colors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.badge),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        if (recent.isNotEmpty || (hasShift && _target == _Target.end)) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(pad, 16, pad, 8),
            child: Text(
              l.countryRecent.toUpperCase(),
              style: AppTextStyles.section.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(pad, 0, pad, 12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final code in recent)
                  _Pill(
                    code,
                    selected: code == selected,
                    onTap: () => unawaited(_pick(code)),
                  ),
                if (hasShift && _target == _Target.end)
                  _Pill(
                    l.countryClearEnd,
                    selected: false,
                    onTap: () => unawaited(_pick(null)),
                  ),
              ],
            ),
          ),
        ],
        Divider(height: 1, color: colors.surface2),
        Expanded(
          child: list.isEmpty
              ? Center(
                  child: Text(
                    l.countryNotFound,
                    style: AppTextStyles.body.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: list.length + 1,
                  separatorBuilder: (_, _) =>
                      Divider(height: 1, color: colors.surface2),
                  itemBuilder: (context, i) => i == list.length
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(pad, 16, pad, 0),
                          child: Text(
                            l.countryFooter,
                            style: AppTextStyles.caption.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        )
                      : _CountryRow(
                          list[i],
                          selected: list[i] == selected,
                          onTap: () => unawaited(_pick(list[i])),
                        ),
                ),
        ),
      ],
    );
  }
}

class _Tabs extends StatelessWidget {
  const new({
    required this.target,
    required this.start,
    required this.end,
    required this.onChanged,
  });

  final _Target target;
  final String start;
  final String end;
  final ValueChanged<_Target> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    Widget tab(_Target t, String text) {
      final on = t == target;
      return Expanded(
        child: Semantics(
          selected: on,
          inMutuallyExclusiveGroup: true,
          button: true,
          child: Material(
            color: on ? colors.surface2 : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.icon),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => onChanged(t),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: AppSize.minTouch),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.rowTitle.copyWith(
                        color: on ? colors.text : colors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(AppRadius.badge),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [tab(_Target.start, start), tab(_Target.end, end)],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const new(this.text, {required this.selected, required this.onTap});

  final String text;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? colors.drive : Colors.transparent,
        shape: StadiumBorder(
          side: BorderSide(color: selected ? colors.drive : colors.switchOff),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: AppSize.minTouch,
              minWidth: AppSize.minTouch + 12,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                widthFactor: 1,
                child: Text(
                  text,
                  style: AppTextStyles.rowTitle.copyWith(
                    color: selected ? colors.onAccent : colors.text,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CountryRow extends StatelessWidget {
  const new(this.code, {required this.selected, required this.onTap});

  final String code;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final name = context.l10n.countryName(code);
    return Semantics(
      selected: selected,
      button: true,
      label: '$code, $name',
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppSize.listRow),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding + 4,
              vertical: 8,
            ),
            child: Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.surface2,
                    borderRadius: BorderRadius.circular(AppRadius.chip),
                  ),
                  child: SizedBox(
                    width: 48,
                    height: 32,
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(code, style: AppTextStyles.value),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(child: Text(name, style: AppTextStyles.body)),
                if (selected) Icon(Icons.check, color: colors.drive),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
