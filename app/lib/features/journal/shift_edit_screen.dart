import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tacho_engine/tacho_engine.dart';
import 'package:tachogo/core/l10n/format.dart';
import 'package:tachogo/core/l10n/l10n.dart';
import 'package:tachogo/core/theme/app_colors.dart';
import 'package:tachogo/core/theme/app_tokens.dart';
import 'package:tachogo/core/theme/app_typography.dart';
import 'package:tachogo/core/widgets/buttons.dart';
import 'package:tachogo/core/widgets/confirm_sheet.dart';
import 'package:tachogo/core/widgets/detail_scaffold.dart';
import 'package:tachogo/core/widgets/mode_style.dart';
import 'package:tachogo/core/widgets/sections.dart';
import 'package:tachogo/core/widgets/segmented_tabs.dart';
import 'package:tachogo/core/widgets/status_chip.dart';
import 'package:tachogo/data/countries/country_providers.dart';
import 'package:tachogo/data/journal/journal_providers.dart';
import 'package:tachogo/data/journal/shift_meta.dart';
import 'package:tachogo/features/export/report_violations.dart';
import 'package:tachogo/features/home/compensation_row.dart';
import 'package:tachogo/features/home/country_sheet.dart';
import 'package:tachogo/features/home/snapshot_select.dart';
import 'package:tachogo/features/journal/pickers.dart';

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

/// Значения формы. Время — UTC с точностью до минуты, как на экране.
class _Form {
  new({
    required this.start,
    required this.end,
    required this.restKind,
    required this.split,
    required this.driving,
    required this.continuous,
    required this.startCountry,
    required this.endCountry,
    required this.note,
  });

  DateTime start;

  /// null — смена идёт, отдых не начат.
  DateTime? end;
  RestKind restKind;
  bool split;
  Duration driving;
  Duration continuous;
  String? startCountry;
  String? endCountry;
  String note;

  _Form copy() => _Form(
    start: start,
    end: end,
    restKind: restKind,
    split: split,
    driving: driving,
    continuous: continuous,
    startCountry: startCountry,
    endCountry: endCountry,
    note: note,
  );

  bool sameTiming(_Form o) =>
      start == o.start &&
      end == o.end &&
      restKind == o.restKind &&
      split == o.split &&
      driving == o.driving &&
      continuous == o.continuous;

  bool sameAs(_Form o) =>
      sameTiming(o) &&
      startCountry == o.startCountry &&
      endCountry == o.endCountry &&
      note == o.note;

  ShiftMeta get meta =>
      ShiftMeta(startCountry: startCountry, endCountry: endCountry, note: note);
}

/// Долги компенсации из снимка — для строк отдыха в форме.
typedef _CompensationView = ({
  ValueList<Compensation> all,
  DateTime? restStart,
  Compensation? next,
  DateTime? until,
  bool inTime,
});

_CompensationView _compensationView(ComplianceSnapshot s) {
  final plan = s.restCompensation;
  final until = plan?.until;
  return (
    all: ValueList(s.compensations),
    restStart: s.offDutyRest?.start,
    next: plan?.next,
    until: until == null ? null : minuteOf(until),
    inTime: plan?.inTime ?? false,
  );
}

class ShiftEditScreen extends ConsumerStatefulWidget {
  const new({this.shift, this.presetRest, super.key});

  /// Смена из журнала; null — новая ручная смена.
  final JournalShift? shift;
  final RestKind? presetRest;

  @override
  ConsumerState<ShiftEditScreen> createState() => _ShiftEditScreenState();
}

class _ShiftEditScreenState extends ConsumerState<ShiftEditScreen> {
  _Form? _initial;
  late _Form _form;
  String? _error;
  bool _saving = false;
  final _note = TextEditingController();

  /// Конец и конечная страна до выбора «Не начат» — вернутся, если снова
  /// выбрать отдых.
  ({DateTime? end, String? country})? _beforeNone;

  JournalShift? get _shift => widget.shift;
  bool get _isNew => _shift == null;
  bool get _live => _shift?.live ?? false;
  bool get _recorded => _shift?.recorded != null;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  /// Значения формы из смены — один раз, когда журнал посчитан.
  void _init(Journal journal, String? defaultCountry) {
    final s = _shift;
    final now = floorTimeToMinute(journal.now);
    // Новая смена начинается сейчас и идёт: конец и отдых водитель отметит,
    // когда закончит её (отзыв водителей, 30.09.2026). Недельный отдых
    // «Указать вручную» (экран 9) — прошлая смена: свободное окно до сейчас.
    final slot = s == null && widget.presetRest != null
        ? freeShiftSlot(journal.shifts, now)
        : null;
    final meta = s == null ? ShiftMeta.empty : journal.metaOf(s);
    final manual = s?.manual;
    final restKind =
        manual?.restKind ?? s?.rest.kind ?? widget.presetRest ?? RestKind.none;
    final startCountry = meta.startCountry ?? defaultCountry;
    if (s == null && restKind == RestKind.none) {
      _beforeNone = (end: now, country: startCountry);
    }
    final initial = _Form(
      start: s?.start ?? slot?.start ?? now,
      end: s == null ? slot?.end : s.end,
      restKind: restKind,
      split: manual?.splitRest ?? s?.rest.split ?? false,
      driving: floorToMinute(s?.driving ?? Duration.zero),
      continuous: floorToMinute(s?.continuousDrivingAtEnd ?? Duration.zero),
      startCountry: startCountry,
      // У новой смены конечная страна по умолчанию — начальная
      endCountry: s != null
          ? meta.endCountry
          : restKind == RestKind.none
          ? null
          : startCountry,
      note: meta.note ?? '',
    );
    _initial = initial;
    _form = initial.copy();
    _note.text = initial.note;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final journal = ref.watch(journalProvider).value;
    final defaultCountry = ref.watch(defaultCountryProvider);
    if (_initial == null) {
      if (journal == null || !defaultCountry.hasValue) {
        return DetailScaffold(
          title: _isNew ? l.shiftNewTitle : l.dayTitle,
          children: const [Center(child: CircularProgressIndicator())],
        );
      }
      _init(journal, defaultCountry.value);
    }
    final initial = _initial!;
    final f = _form;
    final now = ref.watch(clockProvider.select(minuteOf));
    final crew = ref.watch(
      complianceSettingsProvider.select((a) => a.value?.crew),
    );
    final dirty = !f.sameAs(initial);
    final error = _error;

    return PopScope(
      canPop: !dirty || _saving,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) unawaited(_requestClose());
      },
      child: DetailScaffold(
        title: _isNew ? l.shiftNewTitle : l.dayTitle,
        subtitle: formatWeekdayFull(f.start, context.localeTag),
        onBack: () => unawaited(_requestClose()),
        action: IconButton(
          onPressed: _saving ? null : () => unawaited(_save()),
          tooltip: l.save,
          icon: Icon(Icons.check, size: 26, color: context.colors.drive),
        ),
        banner: error == null
            ? null
            : Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  0,
                  AppSpacing.screenPadding,
                  8,
                ),
                child: Semantics(
                  liveRegion: true,
                  child: StatusBanner(error, tone: Tone.violation),
                ),
              ),
        bottom: _isNew
            ? null
            : DangerButton(
                label: l.shiftDelete,
                icon: Icons.delete_outline,
                onPressed: _saving ? null : () => unawaited(_delete()),
              ),
        children: [
          if (_hint(l, now, journal) case final hint?) _Hint(hint),
          SectionTitle(l.shiftSection),
          _TimesCard(
            form: f,
            now: now,
            onCountry: _pickCountry,
            onDate: ({required editEnd}) => _pickDates(now, editEnd: editEnd),
            // Пустое завершение: смена кончается — отдых и выбор конца
            onEndNow: () {
              _selectRest(RestKind.daily, journal);
              if (_form.end != null) {
                unawaited(_pickDates(now, editEnd: true));
              }
            },
          ),
          SectionTitle(l.shiftDriving),
          _drivingCard(l, now, journal),
          SectionTitle(l.dayRestAfter),
          _restCard(l, now, journal, crew ?? CrewMode.solo),
          SectionTitle(l.dayNotes),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
            ),
            child: TextField(
              controller: _note,
              onChanged: (v) => setState(() => _form.note = v),
              minLines: 3,
              maxLines: 6,
              style: AppTextStyles.body,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: l.shiftNotesHint,
                hintStyle: AppTextStyles.body.copyWith(
                  color: context.colors.textSecondary,
                ),
                filled: true,
                fillColor: context.colors.surface,
                contentPadding: const EdgeInsets.all(AppSpacing.cardPadding),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.modeButton),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────────────── состояние формы ─────────────────────────

  bool get _liveEnded => _live && _initial!.end != null;

  /// Отдых после «живой» смены уже идёт или начнётся при сохранении.
  bool get _restOngoing => _live && _form.restKind != RestKind.none;

  /// Смена без записей режимов (новая, ручная или прошлая) идёт сейчас —
  /// станет текущей.
  bool get _becomesCurrent => !_live && _form.restKind == RestKind.none;

  bool get _timingChanged => !_form.sameTiming(_initial!);

  bool get _willConvert =>
      _recorded && !_live && _timingChanged && !_becomesCurrent;

  /// Вождение «живой» смены, которое дают сдвиги записей
  /// ([drivingAdjustmentBounds]); null — вождения в смене нет.
  ({Duration min, Duration max})? _liveDrivingRange(
    Journal? journal,
    DateTime now,
  ) {
    final shift = _shift;
    if (!_live || shift == null || journal == null) return null;
    final bounds = drivingAdjustmentBounds(journal.periods, shift.start, now);
    if (bounds == null) return null;
    final driving = _initial!.driving;
    return (min: driving + bounds.min, max: driving + bounds.max);
  }

  /// Вождение «живой» смены сдвигами записей не получить, а после смены
  /// идёт отдых: смена сохранится ручной с этим итогом, как «Завершить
  /// день» на главной.
  bool _drivingToManual(Journal? journal, DateTime now) {
    final driving = _form.driving;
    if (!_restOngoing || driving == _initial!.driving) return false;
    final range = _liveDrivingRange(journal, now);
    return range == null || driving < range.min || driving > range.max;
  }

  String? _hint(AppLocalizations l, DateTime now, Journal? journal) {
    final f = _form;
    if (_live) {
      if (_drivingToManual(journal, now)) return l.shiftLiveConvertHint;
      if (f.restKind == RestKind.none && _initial!.end != null) {
        return l.shiftResumeHint;
      }
      if (_initial!.end == null && f.restKind != RestKind.none) {
        return l.shiftEndNowHint(formatClock(f.end ?? now));
      }
      return l.shiftLiveHint;
    }
    if (_becomesCurrent) {
      return l.shiftOngoingHint(
        formatClock(f.start),
        l.modeName(
          f.driving > Duration.zero ? DriverMode.driving : DriverMode.otherWork,
        ),
      );
    }
    return _willConvert ? l.shiftConvertHint : null;
  }

  bool _hasLater(Journal? journal) {
    final shift = _shift;
    return journal != null &&
        journal.shifts.any(
          (s) =>
              (shift == null || !sameShift(s, shift)) &&
              s.start.isAfter(_form.start),
        );
  }

  void _selectRest(RestKind kind, Journal? journal) => setState(() {
    final f = _form;
    _error = null;
    if (kind == RestKind.none) {
      if (f.restKind == RestKind.none) return;
      if (_hasLater(journal)) {
        _error = context.l10n.shiftErrNotLast;
        return;
      }
      _beforeNone = (end: f.end, country: f.endCountry);
      // Смена снова идёт — конечной страны у неё ещё нет
      f
        ..restKind = RestKind.none
        ..end = null
        ..endCountry = null;
      // и вождение — только то, что дают сдвиги записей
      if (_live) {
        final range = _liveDrivingRange(journal, ref.read(clockProvider));
        final initial = _initial!.driving;
        f.driving = range == null
            ? initial
            : f.driving < range.min
            ? range.min
            : f.driving > range.max
            ? range.max
            : f.driving;
        if (f.continuous > f.driving) f.continuous = f.driving;
      }
      return;
    }
    if (kind == f.restKind) return;
    final previous = f.restKind;
    f.restKind = kind;
    if (previous == RestKind.none) {
      final before = _beforeNone;
      f.end =
          before?.end ??
          (_liveEnded
              ? _initial!.end
              : floorTimeToMinute(journal?.now ?? f.start));
      f.endCountry ??= before?.country ?? (_isNew ? f.startCountry : null);
    }
  });

  // ───────────────────────── карточки ─────────────────────────

  Widget _drivingCard(AppLocalizations l, DateTime now, Journal? journal) {
    final f = _form;
    final initial = _initial!;
    final range = _liveDrivingRange(journal, now);
    // Ручную смену водитель вводит любую, проверка — при сохранении. У
    // «живой» после неё идёт отдых — тоже любую, до длины смены: чего не
    // дадут сдвиги записей, сохранится ручной сменой с итогом. У идущей —
    // только сдвигами записей: главная считает её по ним.
    final (Duration min, Duration? max) = !_live
        ? (Duration.zero, null)
        : _restOngoing
        ? (Duration.zero, floorToMinute(durationBetween(f.start, f.end ?? now)))
        : range == null
        ? (initial.driving, initial.driving)
        : (range.min, range.max);
    final editable = max == null || max > min;
    final continuousAuto = _live || _becomesCurrent;
    return CardGroup(
      children: [
        _ValueRow(
          label: l.shiftPerDay,
          caption: editable ? null : l.shiftDrivingAfterRest,
          value: f.driving,
          onTap: editable
              ? () => unawaited(
                  _pickDuration(
                    title: l.shiftPerDay,
                    value: f.driving,
                    min: min < Duration.zero ? Duration.zero : min,
                    max: max,
                    onPicked: (v) {
                      f.driving = v;
                      // Непрерывное не больше суточного
                      if (f.continuous > v) f.continuous = v;
                    },
                  ),
                )
              : null,
        ),
        _ValueRow(
          label: l.dayContinuousAtEnd,
          caption: continuousAuto ? l.shiftLiveContinuous : null,
          value: _becomesCurrent ? f.driving : f.continuous,
          onTap: continuousAuto || f.driving == Duration.zero
              ? null
              : () => unawaited(
                  _pickDuration(
                    title: l.dayContinuousAtEnd,
                    value: f.continuous,
                    onPicked: (v) => f.continuous = v,
                  ),
                ),
        ),
      ],
    );
  }

  /// Отдых после смены, как его посчитает журнал: у «живой» или не
  /// изменённой смены из записей — по записям, иначе — до начала следующей
  /// смены журнала. null — отдых не начат.
  ({
    RestKind kind,
    Duration duration,
    DateTime? end,
    bool ongoing,
    RestStatus? status,
  })?
  _restPreview(Journal? journal, DateTime now, CrewMode crew) {
    final f = _form;
    final shift = _shift;
    final end = f.end;
    if (f.restKind == RestKind.none || end == null) return null;
    if (shift != null && (_live || (_recorded && !_timingChanged))) {
      final r = shift.rest;
      return (
        kind: r.kind == RestKind.none ? f.restKind : r.kind,
        duration: _liveEnded || !_live ? r.duration : Duration.zero,
        end: shift.restEnd,
        ongoing: _live || r.ongoing,
        status: r.status,
      );
    }
    final rest = manualRestAfter(
      ManualShift(
        start: f.start,
        end: end.isBefore(f.start) ? f.start : end,
        driving: Duration.zero,
        restKind: f.restKind,
      ),
      [
        for (final s in journal?.shifts ?? const <JournalShift>[])
          if (shift == null || !sameShift(s, shift)) s.start,
      ],
      now,
    );
    if (rest == null) return null;
    final span = durationBetween(f.start, end);
    return (
      kind: rest.kind,
      duration: rest.duration,
      end: rest.end,
      ongoing: rest.ongoing,
      status: rest.ongoing
          ? null
          : rest.kind == RestKind.weekly
          ? weeklyRestStatus(rest.duration)
          : dailyRestStatus(
              restInWindow(span, rest.duration, crew),
              split: f.split,
            ),
    );
  }

  Widget _restCard(
    AppLocalizations l,
    DateTime now,
    Journal? journal,
    CrewMode crew,
  ) {
    final f = _form;
    final rest = _restPreview(journal, now, crew);
    final status = rest?.status;
    final restEnd = rest?.end;
    return CardGroup(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          child: SegmentedTabs<RestKind>(
            options: [
              (value: RestKind.none, label: l.shiftRestNone, detail: null),
              (value: RestKind.daily, label: l.shiftRestDaily, detail: null),
              (value: RestKind.weekly, label: l.shiftRestWeekly, detail: null),
            ],
            value: f.restKind,
            onChanged: (k) => _selectRest(k, journal),
          ),
        ),
        if (f.restKind == RestKind.daily && !_restOngoing)
          MergeSemantics(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.cardPadding,
                12,
                AppSpacing.cardPadding - 4,
                12,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.shiftSplit, style: AppTextStyles.rowTitle),
                        Text(
                          l.shiftSplitHint,
                          style: AppTextStyles.caption.copyWith(
                            color: context.colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Switch(
                    value: f.split,
                    onChanged: (v) => setState(() => f.split = v),
                  ),
                ],
              ),
            ),
          ),
        if (rest != null)
          // Длительность не вводится: отдых длится до начала следующей смены
          _ValueRow(
            label: l.shiftDuration,
            caption:
                rest.kind == RestKind.weekly && f.restKind == RestKind.daily
                ? l.shiftRestCountsWeekly
                : restEnd != null
                ? l.shiftRestUntilNext(
                    '${formatWeekdayDay(restEnd, context.localeTag)} '
                    '${formatClock(restEnd)}',
                  )
                : l.shiftRestAutoHint,
            value: floorToMinute(rest.duration),
            chip: rest.ongoing
                ? StatusChip(l.journalOngoing, tone: Tone.rest)
                : status == null
                ? null
                : StatusChip(
                    l.restStatus(status.name),
                    tone: switch (status) {
                      RestStatus.full => Tone.rest,
                      RestStatus.reduced => Tone.warning,
                      RestStatus.insufficient => Tone.violation,
                    },
                  ),
          ),
        if (rest != null) ..._compensationRows(l, now),
      ],
    );
  }

  /// Компенсация в отдыхе после смены, как её посчитал журнал: долг,
  /// присоединённый к этому отдыху, долг за сам отдых, если он сокращённый
  /// недельный, и сколько ещё отдыхать, если отдых идёт. Пока время смены
  /// меняется, журнал ещё не пересчитан — строк нет.
  List<Widget> _compensationRows(AppLocalizations l, DateTime now) {
    final view = watchSnapshot(ref, _compensationView);
    final restStart = _shift?.end;
    if (view == null || restStart == null || _timingChanged) return const [];
    final (:taken, :debt) = compensationOfRest(view.all.items, restStart);
    final next = restStart == view.restStart ? view.next : null;
    final until = view.until;
    final repaidIn = debt?.repaidIn;
    return [
      if (debt != null)
        _ValueRow(
          label: l.weeklyCompensation,
          caption: repaidIn != null
              ? l.compensationRepaidOn(formatDayMonth(repaidIn))
              : l.compensationAttachBy(formatDayMonth(debt.dueBy)),
          value: debt.debt,
          chip: repaidIn != null
              ? StatusChip(l.chipCompensationDone, tone: Tone.rest)
              : debt.dueBy.isBefore(now)
              ? StatusChip(l.chipCompensationOverdue, tone: Tone.violation)
              : null,
        ),
      if (taken > Duration.zero)
        _ValueRow(
          label: l.rowCompensation,
          caption: l.compensationTakenHere,
          value: taken,
          chip: StatusChip(l.chipCompensationDone, tone: Tone.rest),
        ),
      if (next != null && until != null)
        _ValueRow(
          label: l.rowCompensation,
          caption: view.inTime
              ? l.compensationRestUntil(
                  formatWeekdayClock(until, context.localeTag),
                )
              : l.compensationTooLate,
          value: next.debt,
        ),
    ];
  }

  // ───────────────────────── выбор значений ─────────────────────────

  Future<void> _pickDuration({
    required String title,
    required Duration value,
    required void Function(Duration) onPicked,
    Duration min = Duration.zero,
    Duration? max,
  }) async {
    final picked = await showDurationSheet(
      context,
      title: title,
      initial: value,
      min: min,
      max: max != null && max < min ? min : max,
    );
    if (picked != null && mounted) {
      setState(() {
        _error = null;
        onPicked(picked);
      });
    }
  }

  Future<void> _pickDates(DateTime now, {required bool editEnd}) async {
    final picked = await showDateTimeSheet(
      context,
      start: _form.start,
      end: _form.end,
      max: now,
      editEnd: editEnd,
    );
    if (picked != null && mounted) {
      setState(() {
        _error = null;
        _form.start = picked.start;
        if (_form.end != null) _form.end = picked.end;
      });
    }
  }

  Future<void> _pickCountry(CountryTarget target) async {
    final picked = await showCountryPicker(
      context,
      start: _form.startCountry,
      end: _form.endCountry,
      target: target,
    );
    if (picked != null && mounted) {
      setState(() {
        _error = null;
        // Конечную страну идущей смены можно выбрать заранее, как на главной
        _form
          ..startCountry = picked.start
          ..endCountry = picked.end;
      });
    }
  }

  // ───────────────────────── сохранение ─────────────────────────

  Future<void> _requestClose() async {
    final navigator = Navigator.of(context);
    if (_initial == null || _form.sameAs(_initial!)) {
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
    final shift = _shift;
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
    } on Object {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = l.shiftSaveFailed;
        });
      }
    }
  }

  /// Проверяет форму и сохраняет смену тем путём, который ей подходит:
  /// правка записей «живой» смены, страны и заметка без изменения
  /// времени, ручная смена, перевод в ручную или смена, ставшая текущей.
  Future<void> _save() async {
    final l = context.l10n;
    final journal = ref.read(journalProvider).value;
    if (journal == null || _initial == null) return;
    final now = ref.read(clockProvider);
    final f = _form;
    final initial = _initial!;
    final shift = _shift;
    final repo = ref.read(journalEditRepositoryProvider);
    final navigator = Navigator.of(context);

    String? problem;
    Future<void> Function()? write;
    if (f.startCountry == null) {
      problem = l.shiftErrStartCountry;
    } else if (_live && shift != null) {
      final spanEnd = f.end ?? now;
      if (f.start != initial.start || f.end != initial.end) {
        final hit = findOverlap(
          journal.shifts,
          (start: f.start, end: spanEnd),
          now: now,
          except: shift,
        );
        problem = f.start.isAfter(now) || spanEnd.isAfter(now)
            ? l.shiftErrFuture
            : !f.start.isBefore(spanEnd)
            ? l.shiftErrEndBeforeStart
            : hit != null
            ? l.shiftErrOverlap(_range(l, hit))
            : null;
      }
      final toManual = _drivingToManual(journal, now);
      if (problem == null &&
          toManual &&
          f.driving > durationBetween(f.start, spanEnd)) {
        problem = l.shiftErrDrivingTooLong;
      }
      final edit = LiveShiftEdit(
        shiftStart: shift.start,
        restStart: initial.end,
        newStart: f.start != initial.start ? f.start : null,
        endAt: initial.end == null
            ? (f.restKind != RestKind.none ? f.end ?? now : null)
            : (f.end != initial.end ? f.end : null),
        resume: initial.end != null && f.restKind == RestKind.none,
        drivingDelta: toManual ? Duration.zero : f.driving - initial.driving,
        manualDriving: toManual ? f.driving : null,
        restKind: f.restKind,
        splitRest: f.split,
      );
      write = () => repo.applyLiveEdit(edit, meta: f.meta);
    } else if (_recorded && !_timingChanged && shift != null) {
      write = () => repo.setShiftMeta(shift.start, f.meta);
    } else if (f.restKind != RestKind.none && f.endCountry == null) {
      problem = l.shiftErrEndCountry;
    } else {
      final ongoing = f.restKind == RestKind.none;
      final check = checkManualShift(
        start: f.start,
        end: ongoing ? null : f.end,
        driving: f.driving,
        continuousDrivingAtEnd: _becomesCurrent ? f.driving : f.continuous,
        shifts: journal.shifts,
        now: now,
        except: shift,
      );
      problem = check == null ? null : _problemText(l, check);
      final record = ManualShift(
        id: shift?.manual?.id,
        start: f.start,
        end: ongoing || f.end == null
            ? null
            : (f.end!.isBefore(f.start) ? f.start : f.end),
        driving: f.driving,
        continuousDrivingAtEnd: _becomesCurrent ? f.driving : f.continuous,
        restKind: f.restKind,
        splitRest: f.restKind == RestKind.daily && f.split,
      );
      final meta = f.meta;
      write = _becomesCurrent
          ? () => repo.startOngoingShift(record, meta, replacing: shift)
          : _willConvert
          ? () => repo.convertToManual(shift!, record, meta)
          : () => repo.saveManualShift(record, meta);
    }

    if (problem != null) {
      setState(() => _error = problem);
      if (f.startCountry == null) {
        unawaited(_pickCountry(CountryTarget.start));
      } else if (problem == l.shiftErrEndCountry) {
        unawaited(_pickCountry(CountryTarget.end));
      }
      return;
    }
    setState(() {
      _error = null;
      _saving = true;
    });
    try {
      await write!();
    } on Object {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = l.shiftSaveFailed;
        });
      }
      return;
    }
    // Лимиты сохранению не мешают — о нарушениях водитель узнаёт после
    final violations = await _violationsAfterSave(f.start, f.end, now);
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

  /// Нарушения по журналу после сохранения: в самой смене, в отдыхе перед
  /// ней (новая смена его завершила) и в неделях, куда она попала. Пусто —
  /// нарушений нет или журнал не прочитался.
  Future<List<String>> _violationsAfterSave(
    DateTime start,
    DateTime? end,
    DateTime now,
  ) async {
    final l = context.l10n;
    final locale = context.localeTag;
    final crew =
        ref.read(complianceSettingsProvider).value?.crew ?? CrewMode.solo;
    try {
      final periods = await ref.read(activityRepositoryProvider).periods();
      final manual = await ref
          .read(journalEditRepositoryProvider)
          .manualShifts();
      final timeline = analyzeTimeline(periods, now);
      final journal = Journal(
        now: now,
        periods: periods,
        timeline: timeline,
        weeks: buildJournal(
          timeline: timeline,
          now: now,
          manualShifts: manual,
          crew: crew,
        ),
        recordedMeta: const {},
        manualMeta: const {},
      );
      DateTime? previous;
      for (final s in journal.shifts) {
        if (s.start.isBefore(start) &&
            (previous == null || s.start.isAfter(previous))) {
          previous = s.start;
        }
      }
      return [
        for (final v in reportViolations(
          journal,
          (
            start: previous ?? start,
            end: (end ?? now).add(const Duration(minutes: 1)),
          ),
          crew: crew,
          l: l,
          locale: locale,
        ))
          v.text,
      ];
    } on Object {
      return const [];
    }
  }

  String _problemText(AppLocalizations l, ShiftEditProblem p) =>
      switch (p.error) {
        ShiftEditError.endBeforeStart => l.shiftErrEndBeforeStart,
        ShiftEditError.future => l.shiftErrFuture,
        ShiftEditError.tooLong => l.shiftErrTooLong,
        ShiftEditError.drivingTooLong => l.shiftErrDrivingTooLong,
        ShiftEditError.continuousTooLong => l.shiftErrContinuous,
        ShiftEditError.overlap => l.shiftErrOverlap(_range(l, p.conflict!)),
        ShiftEditError.notLast => l.shiftErrNotLast,
      };

  /// «пн 21.09 06:10–19:00».
  String _range(AppLocalizations l, JournalShift s) {
    final end = s.end;
    return '${formatWeekdayDay(s.start, context.localeTag)} '
        '${formatClock(s.start)}–'
        '${end == null ? l.journalOngoing : formatClock(end)}';
  }
}

class _Hint extends StatelessWidget {
  const new(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        8,
        AppSpacing.screenPadding,
        0,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.badge),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, size: 18, color: colors.textSecondary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  text,
                  style: AppTextStyles.caption.copyWith(color: colors.chipText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Карточка «Смена»: начало и конец (страна, дата, время), длительность.
class _TimesCard extends StatelessWidget {
  const new({
    required this.form,
    required this.now,
    required this.onCountry,
    required this.onDate,
    required this.onEndNow,
  });

  final _Form form;
  final DateTime now;
  final void Function(CountryTarget target) onCountry;
  final void Function({required bool editEnd}) onDate;
  final VoidCallback onEndNow;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final end = form.end;
    final span = durationBetween(form.start, end ?? now);
    return CardGroup(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _Side(
                  title: l.shiftStart,
                  country: form.startCountry,
                  at: form.start,
                  onCountry: () => onCountry(CountryTarget.start),
                  onDate: () => onDate(editEnd: false),
                ),
              ),
              VerticalDivider(width: 1, thickness: 1, color: colors.surface2),
              Expanded(
                child: _Side(
                  title: l.shiftEnd,
                  country: form.endCountry,
                  at: end,
                  onRoad: form.restKind == RestKind.none,
                  onCountry: () => onCountry(CountryTarget.end),
                  onDate: () => onDate(editEnd: true),
                  onEndNow: onEndNow,
                ),
              ),
            ],
          ),
        ),
        MergeSemantics(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppSize.listRow),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.cardPadding,
                vertical: 10,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(l.shiftDuration, style: AppTextStyles.rowTitle),
                  ),
                  if (end == null) ...[
                    Text(
                      l.shiftNowSuffix,
                      style: AppTextStyles.label.copyWith(color: colors.drive),
                    ),
                    const SizedBox(width: 8),
                  ],
                  DurationText(
                    formatHm(span),
                    spoken: spokenDuration(l, span),
                    style: AppTextStyles.value.copyWith(
                      color: span > maxManualShiftSpan
                          ? colors.errorText
                          : colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Side extends StatelessWidget {
  const new({
    required this.title,
    required this.country,
    required this.at,
    required this.onCountry,
    required this.onDate,
    this.onRoad = false,
    this.onEndNow,
  });

  final String title;
  final String? country;

  /// null — смена идёт.
  final DateTime? at;
  final bool onRoad;
  final VoidCallback onCountry;
  final VoidCallback onDate;
  final VoidCallback? onEndNow;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final locale = context.localeTag;
    final at = this.at;
    final country = this.country;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                title,
                style: AppTextStyles.caption.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              if (onRoad) StatusChip(l.shiftOnRoad, tone: Tone.warning),
            ],
          ),
          const SizedBox(height: 10),
          Semantics(
            button: true,
            label: l.shiftCountrySpoken(title, country ?? l.shiftChoose),
            excludeSemantics: true,
            child: Material(
              color: colors.background,
              shape: StadiumBorder(side: BorderSide(color: colors.switchOff)),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onCountry,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: AppSize.minTouch,
                    minWidth: AppSize.minTouch,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          country ?? '—',
                          style: AppTextStyles.valueSmall.copyWith(
                            color: country == null
                                ? colors.textSecondary
                                : colors.text,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 18,
                          color: colors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (at == null) ...[
            // Конца нет — поля пустые, как у бланка: касание задаёт конец
            for (final (i, icon) in const [
              Icons.calendar_today_outlined,
              Icons.schedule,
            ].indexed) ...[
              if (i > 0) const SizedBox(height: 6),
              _FieldButton(
                icon: icon,
                text: '—',
                spoken: l.shiftNotSetSpoken(title),
                color: colors.textSecondary,
                onTap: onEndNow ?? onDate,
              ),
            ],
          ] else ...[
            _FieldButton(
              icon: Icons.calendar_today_outlined,
              text: '${formatWeekdayShort(at, locale)}, ${formatDayMonth(at)}',
              spoken: l.shiftDateSpoken(
                title,
                formatWeekdayFull(at, locale),
                formatClock(at),
              ),
              onTap: onDate,
            ),
            const SizedBox(height: 6),
            _FieldButton(
              icon: Icons.schedule,
              text: formatClock(at),
              numeric: true,
              spoken: l.shiftDateSpoken(
                title,
                formatWeekdayFull(at, locale),
                formatClock(at),
              ),
              onTap: onDate,
            ),
          ],
        ],
      ),
    );
  }
}

/// Кнопка поля даты или времени: значок и значение на тёмной плашке.
class _FieldButton extends StatelessWidget {
  const new({
    required this.icon,
    required this.text,
    required this.spoken,
    required this.onTap,
    this.numeric = false,
    this.color,
  });

  final IconData icon;
  final String text;
  final String spoken;
  final VoidCallback onTap;
  final bool numeric;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      label: spoken,
      excludeSemantics: true,
      child: Material(
        color: colors.background,
        borderRadius: BorderRadius.circular(AppRadius.icon),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: AppSize.minTouch,
              minWidth: double.infinity,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Icon(icon, size: 18, color: color ?? colors.textSecondary),
                  const SizedBox(width: 8),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        text,
                        maxLines: 1,
                        style:
                            (numeric
                                    ? AppTextStyles.value
                                    : AppTextStyles.body.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ))
                                .copyWith(color: color),
                      ),
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

/// Строка «название — значение ›»: касание открывает колёсико.
class _ValueRow extends StatelessWidget {
  const new({
    required this.label,
    required this.value,
    this.caption,
    this.chip,
    this.onTap,
  });

  final String label;
  final String? caption;
  final Duration value;
  final StatusChip? chip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colors = context.colors;
    final caption = this.caption;
    final chip = this.chip;
    final body = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: AppSize.listRow),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.cardPadding,
          vertical: 10,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.rowTitle),
                  if (caption != null)
                    Text(
                      caption,
                      style: AppTextStyles.small.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            if (chip != null) ...[const SizedBox(width: 8), chip],
            const SizedBox(width: 8),
            DurationText(
              formatHm(value),
              spoken: spokenDuration(l, value),
              style: AppTextStyles.value,
            ),
            if (onTap != null) ...[
              const SizedBox(width: 4),
              Icon(Icons.chevron_right, color: colors.textSecondary),
            ],
          ],
        ),
      ),
    );
    return MergeSemantics(
      child: onTap == null ? body : InkWell(onTap: onTap, child: body),
    );
  }
}
