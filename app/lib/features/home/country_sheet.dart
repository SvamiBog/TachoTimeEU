import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/segmented_tabs.dart';
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

/// Страны смены на главной: выбор сразу пишется в смену (бесплатно, как
/// переключение режима).
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
  builder: (_) => FractionallySizedBox(
    heightFactor: 0.9,
    child: _LocalCountries(start: start, end: end, target: target),
  ),
);

class _LocalCountries extends StatefulWidget {
  const new({required this.start, required this.end, required this.target});

  final String? start;
  final String? end;
  final CountryTarget target;

  @override
  State<_LocalCountries> createState() => _LocalCountriesState();
}

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

/// Какую страну смены выбирают.
enum CountryTarget { start, end }

/// Выбор страны тахографа: вкладки «Начало / Конец», поиск, недавние,
/// список кодов. [onPick] получает выбор — код или null («Не указывать»
/// конечную) — и возвращает вкладку, которую показать дальше; null —
/// закрыть шторку.
class CountryPicker extends ConsumerStatefulWidget {
  const new({
    required this.start,
    required this.end,
    required this.onPick,
    this.initialTarget = CountryTarget.start,
    this.single = false,
    this.closeWith,
    super.key,
  });

  final String? start;
  final String? end;
  final CountryTarget initialTarget;

  /// Одна страна — следующей смены: заголовок вместо вкладок.
  final bool single;
  final Future<CountryTarget?> Function(CountryTarget target, String? code)
  onPick;

  /// Значение, с которым закрывается шторка.
  final Object? Function()? closeWith;

  @override
  ConsumerState<CountryPicker> createState() => _CountryPickerState();
}

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
    final colors = context.colors;
    final hasShift = !widget.single;
    final recent = ref.watch(recentCountriesProvider).value ?? const [];
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
    const pad = AppSpacing.screenPadding + 4;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(pad, 0, pad, 12),
          child: hasShift
              ? SegmentedTabs<CountryTarget>(
                  options: [
                    (
                      value: CountryTarget.start,
                      label: l.countryStartTab(widget.start ?? '—'),
                      detail: null,
                    ),
                    (
                      value: CountryTarget.end,
                      label: l.countryEndTab(widget.end ?? '—'),
                      detail: null,
                    ),
                  ],
                  value: _target,
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
        if (recent.isNotEmpty ||
            (hasShift && _target == CountryTarget.end)) ...[
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
                if (hasShift && _target == CountryTarget.end)
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
