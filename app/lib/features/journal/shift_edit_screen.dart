/// Shift form (screen 11): a new manual shift or a shift from the journal.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/widgets/buttons.dart';
import 'package:tachogo/core/widgets/confirm_sheet.dart';
import 'package:tachogo/core/widgets/detail_scaffold.dart';
import 'package:tachogo/core/widgets/journal_save.dart';
import 'package:tachogo/core/widgets/sections.dart';
import 'package:tachogo/data/countries/country_providers.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/data/journal/shift_meta.dart';
import 'package:tachogo/features/export/report_violations.dart';
import 'package:tachogo/features/home/country_sheet.dart';
import 'package:tachogo/features/home/snapshot_select.dart';
import 'package:tachogo/features/journal/pickers.dart';
import 'package:tachogo/features/journal/shift_edit_cards.dart';
import 'package:tachogo/features/journal/shift_form.dart';
import 'package:tachogo/features/journal/shift_form_results.dart';
import 'package:tachogo/features/journal/shift_times_card.dart';

/// Форма смены (экран 11): новая ручная смена или смена из журнала.
/// [presetRest] — вид отдыха новой смены («Указать вручную» недельный
/// отдых, экран 9). Возвращает true, если смену сохранили или удалили.
Future<bool> openShiftEditor(
  BuildContext context, {
  JournalShift? shift,
  RestKind? presetRest,
}) async {
  final saved = await Navigator.of(context).push<bool>(
    MaterialPageRoute(
      builder: (_) => ShiftEditScreen(shift: shift, presetRest: presetRest),
    ),
  );
  return saved ?? false;
}

/// Shift form (screen 11): a new manual shift or a shift from the journal —
/// times, countries, driving, rest after the shift, note; saving, deleting and
/// the checks of `checkManualShift`. The logic is [ShiftForm].
class ShiftEditScreen extends ConsumerStatefulWidget {
  const new({this.shift, this.presetRest, super.key});

  /// Смена из журнала; null — новая ручная смена.
  final JournalShift? shift;
  final RestKind? presetRest;

  @override
  ConsumerState<ShiftEditScreen> createState() => _ShiftEditScreenState();
}

/// The form, errors and saving.
class _ShiftEditScreenState extends ConsumerState<ShiftEditScreen> {
  /// null — журнал ещё не посчитан.
  ShiftForm? _form;
  String? _error;
  bool _saving = false;
  final _note = TextEditingController();

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  /// Форма из смены — один раз, когда журнал посчитан.
  ShiftForm _init(Journal journal, String? defaultCountry) {
    final shift = widget.shift;
    final form = ShiftForm.open(
      shifts: journal.shifts,
      now: ref.read(clockProvider),
      shift: shift,
      meta: shift == null ? ShiftMeta.empty : journal.metaOf(shift),
      presetRest: widget.presetRest,
      defaultCountry: defaultCountry,
    );
    _form = form;
    _note.text = form.initial.note;
    return form;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final journal = ref.watch(journalProvider).value;
    final defaultCountry = ref.watch(defaultCountryProvider);
    final title = widget.shift == null ? l.shiftNewTitle : l.dayTitle;
    final form =
        _form ??
        (journal == null || !defaultCountry.hasValue
            ? null
            : _init(journal, defaultCountry.value));
    if (form == null) {
      return DetailScaffold(
        title: title,
        children: const [Center(child: CircularProgressIndicator())],
      );
    }
    final now = ref.watch(clockProvider.select(minuteOf));
    final periods = journal?.periods ?? const <ActivityPeriod>[];
    final error = _error;
    return PopScope(
      canPop: !form.dirty || _saving,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) unawaited(_requestClose());
      },
      child: DetailScaffold(
        title: title,
        subtitle: formatWeekdayFull(form.values.start, context.localeTag),
        onBack: () => unawaited(_requestClose()),
        action: IconButton(
          onPressed: _saving ? null : () => unawaited(_save()),
          tooltip: l.save,
          icon: Icon(Icons.check, size: 26, color: context.colors.drive),
        ),
        banner: error == null ? null : ShiftErrorBanner(error),
        bottom: form.isNew
            ? null
            : DangerButton(
                label: l.shiftDelete,
                icon: Icons.delete_outline,
                onPressed: _saving ? null : () => unawaited(_delete()),
              ),
        children: [
          if (form.hint(periods, now) case final hint?) ShiftEditHint(hint),
          SectionTitle(l.shiftSection),
          ShiftTimesCard(
            values: form.values,
            now: now,
            onCountry: _pickCountry,
            onDate: ({required editEnd}) => _pickDates(now, editEnd: editEnd),
            onEndNow: () => _selectRest(RestKind.daily, journal),
          ),
          SectionTitle(l.shiftDriving),
          ShiftDrivingCard(
            form: form,
            limits: form.drivingLimits(periods, now),
            onDriving: (v) => _edit((values) => values.withDriving(v)),
            onContinuous: (v) => _edit((values) => values.withContinuous(v)),
          ),
          SectionTitle(l.dayRestAfter),
          ShiftRestCard(
            form: form,
            shifts: journal?.shifts ?? const <JournalShift>[],
            now: now,
            onRest: (kind) => _selectRest(kind, journal),
            onSplit: _setSplit,
          ),
          SectionTitle(l.dayNotes),
          ShiftNoteField(controller: _note, onChanged: _setNote),
        ],
      ),
    );
  }

  // ───────────────────────── правка значений ─────────────────────────

  /// Меняет значения формы; выбор в шторках снимает ошибку.
  void _edit(
    ShiftFormValues Function(ShiftFormValues values) change, {
    bool clearError = true,
  }) {
    final form = _form;
    if (form == null || !mounted) return;
    setState(() {
      if (clearError) _error = null;
      _form = form.withValues(change(form.values));
    });
  }

  // Переключатель и заметка ошибку не снимают
  void _setSplit(bool split) =>
      _edit((values) => values.withSplit(split: split), clearError: false);

  void _setNote(String note) =>
      _edit((values) => values.withNote(note), clearError: false);

  /// Вид отдыха после смены: «Не начат» — смена снова идёт, отдых — смена
  /// кончилась (у идущей — сейчас).
  void _selectRest(RestKind kind, Journal? journal) {
    final current = _form;
    if (current == null) return;
    final (:form, :error) = current.withRest(
      kind,
      shifts: journal?.shifts ?? const <JournalShift>[],
      periods: journal?.periods ?? const <ActivityPeriod>[],
      now: ref.read(clockProvider),
    );
    final l = context.l10n;
    setState(() {
      _form = form;
      _error = error == null ? null : _problemText(l, error, null);
    });
  }

  Future<void> _pickDates(DateTime now, {required bool editEnd}) async {
    final form = _form;
    if (form == null) return;
    final picked = await showDateTimeSheet(
      context,
      start: form.values.start,
      end: form.values.end,
      max: now,
      editEnd: editEnd,
    );
    if (picked != null) {
      _edit((values) => values.withTimes(picked.start, picked.end));
    }
  }

  Future<void> _pickCountry(CountryTarget target) async {
    final form = _form;
    if (form == null) return;
    final picked = await showCountryPicker(
      context,
      start: form.values.startCountry,
      end: form.values.endCountry,
      target: target,
    );
    final current = _form;
    if (picked == null || !mounted || current == null) return;
    final journal = ref.read(journalProvider).value;
    setState(() {
      _error = null;
      _form = current.withCountries(
        picked.start,
        picked.end,
        shifts: journal?.shifts ?? const <JournalShift>[],
        periods: journal?.periods ?? const <ActivityPeriod>[],
        now: ref.read(clockProvider),
      );
    });
  }

  // ───────────────────────── сохранение ─────────────────────────

  Future<void> _requestClose() async {
    final navigator = Navigator.of(context);
    final form = _form;
    if (form == null || !form.dirty) {
      navigator.pop(false);
      return;
    }
    final l = context.l10n;
    final save = await showConfirmSheet(
      context,
      title: l.shiftUnsavedTitle,
      text: l.shiftUnsavedText,
      confirm: l.save,
      cancel: l.shiftDiscard,
    );
    if (save == null || !mounted) return;
    if (save) {
      await _save();
    } else {
      setState(() => _saving = true);
      navigator.pop(false);
    }
  }

  Future<void> _delete() async {
    final shift = widget.shift;
    if (shift == null) return;
    final l = context.l10n;
    final navigator = Navigator.of(context);
    final ok = await showConfirmSheet(
      context,
      title: l.shiftDeleteTitle,
      text: shift.manual != null ? l.shiftDeleteManual : l.shiftDeleteRecorded,
      confirm: l.delete,
      cancel: l.cancel,
      danger: true,
    );
    if (ok != true || !mounted) return;
    setState(() => _saving = true);
    try {
      await ref.read(journalEditRepositoryProvider).deleteShift(shift);
      navigator.pop(true);
    } on Object catch (error, stack) {
      reportSaveError(error, stack);
      if (mounted) {
        setState(() {
          _saving = false;
          _error = l.shiftSaveFailed;
        });
      }
    }
  }

  /// Проверяет форму и сохраняет смену тем путём, который ей подходит
  /// ([ShiftForm.save]). Нарушения лимитов сохранению не мешают — о них
  /// шторка после сохранения.
  Future<void> _save() async {
    final l = context.l10n;
    final journal = ref.read(journalProvider).value;
    final form = _form;
    if (journal == null || form == null) return;
    final now = ref.read(clockProvider);
    final navigator = Navigator.of(context);
    final save = form.save(
      shifts: journal.shifts,
      periods: journal.periods,
      now: now,
    );
    final ShiftWrite write;
    switch (save) {
      case ShiftSaveRefused(:final error, :final conflict):
        _refuse(l, error, conflict);
        return;
      case final ShiftWrite w:
        write = w;
    }
    setState(() {
      _error = null;
      _saving = true;
    });
    try {
      await _write(write);
    } on Object catch (error, stack) {
      reportSaveError(error, stack);
      if (mounted) {
        setState(() {
          _saving = false;
          _error = l.shiftSaveFailed;
        });
      }
      return;
    }
    final values = form.values;
    final violations = await _violationsAfterSave(
      values.start,
      values.end,
      now,
    );
    if (violations.isNotEmpty && mounted) {
      await showNoticeSheet(
        context,
        title: l.shiftSavedViolations,
        text: l.shiftSavedViolationsText,
        items: violations,
        button: l.gotIt,
      );
    }
    navigator.pop(true);
  }

  /// Сохранить нельзя: ошибка над формой, без страны — сразу её выбор.
  void _refuse(
    AppLocalizations l,
    ShiftFormError error,
    JournalShift? conflict,
  ) {
    setState(() => _error = _problemText(l, error, conflict));
    if (error == ShiftFormError.startCountry) {
      unawaited(_pickCountry(CountryTarget.start));
    } else if (error == ShiftFormError.endCountry) {
      unawaited(_pickCountry(CountryTarget.end));
    }
  }

  Future<void> _write(ShiftWrite write) {
    final repo = ref.read(journalEditRepositoryProvider);
    return switch (write) {
      LiveShiftWrite(:final edit, :final meta) => repo.applyLiveEdit(
        edit,
        meta: meta,
      ),
      MetaShiftWrite(:final shiftStart, :final meta) => repo.setShiftMeta(
        shiftStart,
        meta,
      ),
      OngoingShiftWrite(:final shift, :final meta, :final replacing) =>
        repo.startOngoingShift(shift, meta, replacing: replacing),
      ConvertShiftWrite(:final from, :final shift, :final meta) =>
        repo.convertToManual(from, shift, meta),
      ManualShiftWrite(:final shift, :final meta) => repo.saveManualShift(
        shift,
        meta,
      ),
    };
  }

  /// Нарушения по журналу после сохранения: в самой смене, в отдыхе перед
  /// ней и в неделях, куда она попала. Пусто — нарушений нет или журнал не
  /// прочитался.
  Future<List<String>> _violationsAfterSave(
    DateTime start,
    DateTime? end,
    DateTime now,
  ) async {
    final l = context.l10n;
    final locale = context.localeTag;
    final settings =
        ref.read(complianceSettingsProvider).value ??
        const ComplianceSettings();
    // Страны смен — до правки: у остальных смен начало не меняется
    final routes = ref.read(journalProvider).value?.routes ?? const {};
    final activity = ref.read(activityRepositoryProvider);
    final edits = ref.read(journalEditRepositoryProvider);
    try {
      final journal = await readJournal(
        activity: activity,
        edits: edits,
        settings: settings,
        routes: routes,
        now: now,
      );
      return [
        for (final v in violationsAroundShift(
          journal,
          start: start,
          end: end,
          now: now,
          crew: settings.crew,
          l: l,
          locale: locale,
        ))
          v.text,
      ];
    } on Object {
      return const [];
    }
  }

  String _problemText(
    AppLocalizations l,
    ShiftFormError error,
    JournalShift? conflict,
  ) => switch (error) {
    ShiftFormError.startCountry => l.shiftErrStartCountry,
    ShiftFormError.endCountry => l.shiftErrEndCountry,
    ShiftFormError.endBeforeStart => l.shiftErrEndBeforeStart,
    ShiftFormError.future => l.shiftErrFuture,
    ShiftFormError.tooLong => l.shiftErrTooLong,
    ShiftFormError.drivingTooLong => l.shiftErrDrivingTooLong,
    ShiftFormError.continuousTooLong => l.shiftErrContinuous,
    // Пересечение всегда с найденной сменой
    ShiftFormError.overlap => l.shiftErrOverlap(_range(l, conflict!)),
    ShiftFormError.notLast => l.shiftErrNotLast,
  };

  /// «пн 21.09 06:10–19:00».
  String _range(AppLocalizations l, JournalShift s) {
    final end = s.end;
    return '${formatWeekdayDay(s.start, context.localeTag)} '
        '${formatClock(s.start)}–'
        '${end == null ? l.journalOngoing : formatClock(end)}';
  }
}
