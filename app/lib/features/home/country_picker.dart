/// The tachograph country picker shared by the home country sheet, the company
/// country sheet and the shift form: tabs, search, recent countries, the list.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/choice_pill.dart';
import 'package:tachogo/core/widgets/segmented_tabs.dart';
import 'package:tachogo/data/countries/country_providers.dart';
import 'package:tachogo/data/countries/tacho_countries.dart';

/// Which country of the shift is being picked.
enum CountryTarget { start, end }

/// Tachograph country picker: "Start / End" tabs, search, recent countries, the
/// list of codes. [onPick] gets the choice — a code, or null ("Not set" for the
/// end country) — and returns the tab to show next; null closes the sheet.
class CountryPicker extends ConsumerStatefulWidget {
  const new({
    required this.start,
    required this.end,
    required this.onPick,
    this.initialTarget = CountryTarget.start,
    this.single = false,
    this.title,
    this.closeWith,
    super.key,
  });

  final String? start;
  final String? end;
  final CountryTarget initialTarget;

  /// Одна страна — следующей смены: заголовок вместо вкладок.
  final bool single;

  /// Заголовок одной страны; по умолчанию — «Страна следующей смены».
  final String? title;
  final Future<CountryTarget?> Function(CountryTarget target, String? code)
  onPick;

  /// Значение, с которым закрывается шторка.
  final Object? Function()? closeWith;

  @override
  ConsumerState<CountryPicker> createState() => _CountryPickerState();
}

/// The open tab and the search query.
class _CountryPickerState extends ConsumerState<CountryPicker> {
  late CountryTarget _target = widget.initialTarget;
  String _query = '';
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _pick(String? code) async {
    final navigator = Navigator.of(context);
    final next = await widget.onPick(
      widget.single ? CountryTarget.start : _target,
      code,
    );
    if (!mounted) return;
    if (next == null) {
      navigator.pop(widget.closeWith?.call());
      return;
    }
    setState(() {
      if (next != _target) {
        _query = '';
        _search.clear();
      }
      _target = next;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final hasShift = !widget.single;
    final frequent = ref.watch(frequentCountriesProvider).value ?? const [];
    final selected = switch (_target) {
      CountryTarget.start => widget.start,
      CountryTarget.end => widget.end,
    };
    final q = _query.trim().toLowerCase();
    final list = [
      for (final code in TachoCountries.codes)
        if (q.isEmpty ||
            code.toLowerCase().contains(q) ||
            l.countryName(code).toLowerCase().contains(q))
          code,
    ];
    // У конца смены — «Не указано»: страна конца ещё не известна
    final clearEnd = hasShift && _target == CountryTarget.end;
    const pad = AppSpacing.textInset;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(pad, 0, pad, AppSpacing.s12),
          child: hasShift
              ? _TargetTabs(
                  start: widget.start,
                  end: widget.end,
                  target: _target,
                  onChanged: (t) => setState(() => _target = t),
                )
              : Text(
                  widget.title ?? l.countryNextShift,
                  style: AppTextStyles.header,
                ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: pad),
          child: _SearchField(
            controller: _search,
            onChanged: (v) => setState(() => _query = v),
          ),
        ),
        if (frequent.isNotEmpty || clearEnd)
          _FrequentCountries(
            frequent,
            selected: selected,
            clearEnd: clearEnd,
            onPick: (code) => unawaited(_pick(code)),
          ),
        Divider(height: 1, color: context.colors.surface2),
        Expanded(
          child: _CountryList(
            list,
            selected: selected,
            onPick: (code) => unawaited(_pick(code)),
          ),
        ),
      ],
    );
  }
}

/// "Start · PL / End · —" tabs of a shift's countries.
class _TargetTabs extends StatelessWidget {
  const new({
    required this.start,
    required this.end,
    required this.target,
    required this.onChanged,
  });

  final String? start;
  final String? end;
  final CountryTarget target;
  final ValueChanged<CountryTarget> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return SegmentedTabs<CountryTarget>(
      options: [
        (
          value: CountryTarget.start,
          label: l.countryStartTab(start ?? '—'),
          detail: null,
        ),
        (
          value: CountryTarget.end,
          label: l.countryEndTab(end ?? '—'),
          detail: null,
        ),
      ],
      value: target,
      onChanged: onChanged,
    );
  }
}

/// The search field over the list: by code or by name.
class _SearchField extends StatelessWidget {
  const new({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: AppTextStyles.body,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: context.l10n.countrySearch,
        hintStyle: AppTextStyles.body.copyWith(color: colors.textSecondary),
        prefixIcon: Icon(Icons.search, color: colors.textSecondary),
        filled: true,
        fillColor: colors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.badge),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

/// "Recent" countries as pills; for the end country — also "Not set".
class _FrequentCountries extends StatelessWidget {
  const new(
    this.codes, {
    required this.selected,
    required this.clearEnd,
    required this.onPick,
  });

  final List<String> codes;
  final String? selected;

  /// Пилюля «Не указано» — снять страну конца смены.
  final bool clearEnd;

  /// Выбор: код или null — «Не указано».
  final ValueChanged<String?> onPick;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    const pad = AppSpacing.textInset;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            pad,
            AppSpacing.s16,
            pad,
            AppSpacing.s8,
          ),
          child: Text(
            l.countryFrequent.toUpperCase(),
            style: AppTextStyles.section.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(pad, 0, pad, AppSpacing.s12),
          child: Wrap(
            spacing: AppSpacing.s8,
            runSpacing: AppSpacing.s8,
            children: [
              for (final code in codes)
                ChoicePill(
                  code,
                  selected: code == selected,
                  onTap: () => onPick(code),
                ),
              if (clearEnd)
                ChoicePill(
                  l.countryClearEnd,
                  selected: false,
                  onTap: () => onPick(null),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// The countries found, each row a tap target, with the note under the list;
/// nothing found — a message instead.
class _CountryList extends StatelessWidget {
  const new(this.codes, {required this.selected, required this.onPick});

  final List<String> codes;
  final String? selected;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final caption = AppTextStyles.caption.copyWith(color: colors.textSecondary);
    if (codes.isEmpty) {
      return Center(
        child: Text(
          context.l10n.countryNotFound,
          style: AppTextStyles.body.copyWith(color: colors.textSecondary),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: AppSpacing.s16),
      itemCount: codes.length + 1,
      separatorBuilder: (_, _) => Divider(height: 1, color: colors.surface2),
      itemBuilder: (context, i) => i == codes.length
          ? Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.textInset,
                AppSpacing.s16,
                AppSpacing.textInset,
                0,
              ),
              child: Text(context.l10n.countryFooter, style: caption),
            )
          : _CountryRow(
              codes[i],
              selected: codes[i] == selected,
              onTap: () => onPick(codes[i]),
            ),
    );
  }
}

/// A country row: code, name and a check mark when selected.
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
              horizontal: AppSpacing.textInset,
              vertical: AppSpacing.s8,
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
                const SizedBox(width: AppSpacing.s16),
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
