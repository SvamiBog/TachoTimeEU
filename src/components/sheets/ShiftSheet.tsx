import React, { useMemo, useState } from 'react';
import { AlertCircle, ArrowLeft, Calendar, Check, ChevronDown, ChevronRight, Clock, Info, Trash2 } from 'lucide-react';
import type { JournalShift } from '../../domain/journal';
import { LIMITS } from '../../domain/limits';
import { dailyRestStatus, weeklyRestStatus } from '../../domain/shifts';
import { findOverlap, type LiveShiftEdit } from '../../domain/shiftEdit';
import { HOUR, MINUTE, minutesBetween } from '../../domain/time';
import type { ManualShift, RestKind, ShiftMeta } from '../../domain/types';
import { useI18n } from '../../i18n';
import { DateTimeSheet, DurationSheet } from '../pickers';
import { Chip, ConfirmSheet, Segmented, Sheet, Switch } from '../ui';
import { CountrySheet } from './CountrySheet';

interface Props {
  /** Смена из журнала; null — новая ручная смена. */
  shift: JournalShift | null;
  manual?: ManualShift;
  /** Все смены журнала — для проверки пересечений. */
  allShifts: JournalShift[];
  /** Пределы правки вождения «живой» смены (за счёт соседних записей). */
  driveBounds: { min: number; max: number } | null;
  defaultCountry: string;
  presetRest?: RestKind;
  now: number;
  onSaveManual: (m: ManualShift) => void;
  /** Прошлая смена из записей стала ручной: её записи заменяются. */
  onConvert: (shift: JournalShift, m: ManualShift) => void;
  onSaveMeta: (id: string, meta: ShiftMeta) => void;
  onApplyLive: (edit: LiveShiftEdit, meta: ShiftMeta) => void;
  onDelete: (shift: JournalShift) => void;
  onClose: () => void;
}

type Picker = null | 'dates-start' | 'dates-end' | 'country-start' | 'country-end' | 'drive' | 'continuous' | 'rest' | 'delete';

const MAX_SPAN_MINUTES = 30 * 60;
const DEFAULT_SPAN = 10 * HOUR;
const DEFAULT_REST = 11 * HOUR;

/**
 * Время новой смены по умолчанию: 10 ч, заканчивающиеся сейчас, или — если
 * это время занято сменой или записанным отдыхом после неё — ближайшее более
 * раннее свободное окно (с 11 ч отдыха до следующей смены).
 */
function freeSlot(shifts: JournalShift[], now: number): { start: number; end: number } {
  const sorted = [...shifts].sort((a, b) => b.start - a.start);
  const busyUntil = (s: JournalShift) => s.restEnd ?? (s.end === null || s.rest.ongoing ? now : s.end);
  let end = now;
  for (let i = 0; i < 60; i++) {
    const start = end - DEFAULT_SPAN;
    const hit = sorted.find((s) => start < busyUntil(s) && s.start < end + DEFAULT_REST);
    if (!hit) return { start, end };
    end = Math.floor((hit.start - DEFAULT_REST) / MINUTE) * MINUTE;
  }
  return { start: end - DEFAULT_SPAN, end };
}

export const ShiftSheet: React.FC<Props> = ({
  shift,
  manual,
  allShifts,
  driveBounds,
  defaultCountry,
  presetRest,
  now,
  onSaveManual,
  onConvert,
  onSaveMeta,
  onApplyLive,
  onDelete,
  onClose,
}) => {
  const { t, fmt } = useI18n();
  const isNew = !shift;
  const isAuto = shift?.source === 'auto';
  const live = shift?.live ?? false;

  // Начальные значения — чтобы понять, что именно изменили
  const nowMinute = Math.floor(now / MINUTE) * MINUTE;
  const initial = useMemo(
    () => ({
      start: manual?.start ?? shift?.start ?? freeSlot(allShifts, nowMinute).start,
      end: manual ? manual.end : shift ? shift.end : freeSlot(allShifts, nowMinute).end,
      restKind: manual?.rest.kind ?? shift?.rest.kind ?? presetRest ?? 'daily',
      restMinutes: Math.round(
        manual?.rest.minutes ??
          (shift && shift.rest.kind !== 'none'
            ? shift.rest.minutes
            : presetRest === 'weekly'
              ? LIMITS.weeklyRestRegular
              : LIMITS.dailyRestRegular),
      ),
      split: manual?.rest.split ?? shift?.rest.split ?? false,
      drive: Math.floor(manual?.driveMinutes ?? shift?.driveMinutes ?? 0),
      continuous: Math.floor(manual?.continuousDriveAtEndMinutes ?? shift?.continuousDriveAtEndMinutes ?? 0),
    }),
    // Форма открывается один раз — пересчитывать исходные значения каждую секунду не нужно
    [],
  );

  const [start, setStart] = useState(initial.start);
  const [end, setEnd] = useState<number | null>(initial.end);
  const [startCountry, setStartCountry] = useState(shift?.startCountry ?? defaultCountry);
  const [endCountry, setEndCountry] = useState<string | null>(shift?.endCountry ?? null);
  const [restKind, setRestKind] = useState<RestKind>(initial.restKind);
  const [restMinutes, setRestMinutes] = useState(initial.restMinutes);
  const [split, setSplit] = useState(initial.split);
  const [drive, setDrive] = useState(initial.drive);
  const [continuous, setContinuous] = useState(initial.continuous);
  const [notes, setNotes] = useState(shift?.notes ?? '');
  const [picker, setPicker] = useState<Picker>(null);
  const [error, setError] = useState<string | null>(null);

  const liveEnded = live && initial.end !== null; // смена закончилась, идёт отдых
  const restOngoing = live && restKind !== 'none';
  const timingChanged =
    start !== initial.start ||
    end !== initial.end ||
    restKind !== initial.restKind ||
    restMinutes !== initial.restMinutes ||
    split !== initial.split ||
    drive !== initial.drive ||
    continuous !== initial.continuous;
  const willConvert = isAuto && !live && timingChanged;

  const spanEnd = end ?? now;
  const spanMinutes = minutesBetween(start, spanEnd);
  const status = useMemo(() => {
    if (restOngoing) return null;
    if (restKind === 'daily') return dailyRestStatus(restMinutes, split);
    if (restKind === 'weekly') return weeklyRestStatus(restMinutes);
    return null;
  }, [restOngoing, restKind, restMinutes, split]);
  const statusTone = status === 'insufficient' ? 'bad' : status === 'reduced' ? 'warn' : 'rest';

  const rangeOf = (s: JournalShift) =>
    `${fmt.weekdayDate(s.start)} ${fmt.time(s.start)}–${s.end !== null ? fmt.time(s.end) : t.common.ongoing}`;

  const selectRestKind = (kind: RestKind) => {
    setRestKind(kind);
    setError(null);
    if (kind === 'none') {
      setEnd(null);
      if (!live) setEndCountry(null);
      return;
    }
    if (end === null) setEnd(live && initial.end !== null ? initial.end : nowMinute);
    if (kind === 'weekly' && restMinutes < LIMITS.weeklyRestReduced) setRestMinutes(LIMITS.weeklyRestRegular);
    if (kind === 'daily' && restMinutes >= LIMITS.weeklyRestReduced) setRestMinutes(LIMITS.dailyRestRegular);
  };

  const meta: ShiftMeta = { startCountry, endCountry: endCountry ?? undefined, notes };

  const save = () => {
    setError(null);

    // Смена идёт или после неё идёт отдых — правим записи режимов
    if (live && shift) {
      const edit: LiveShiftEdit = { shiftStart: shift.start, restStart: initial.end };
      if (start !== initial.start) edit.newStart = start;
      if (initial.end === null && restKind !== 'none') edit.endAt = end ?? now;
      if (initial.end !== null) {
        if (restKind === 'none') edit.resume = true;
        else if (end !== null && end !== initial.end) edit.endAt = end;
      }
      if (drive !== initial.drive) edit.driveDelta = drive - initial.drive;
      onApplyLive(edit, meta);
      onClose();
      return;
    }

    // Только страны и заметки — смена остаётся привязанной к записям
    if (isAuto && !timingChanged) {
      onSaveMeta(shift!.id, meta);
      onClose();
      return;
    }

    if (restKind !== 'none' && !endCountry) {
      setError(t.shift.errEndCountry);
      setPicker('country-end');
      return;
    }
    if (end !== null && end <= start) return setError(t.shift.errEndBeforeStart);
    if (start > now || (end !== null && end > now)) return setError(t.shift.errFuture);
    if (spanMinutes > MAX_SPAN_MINUTES) return setError(t.shift.errTooLong);
    if (drive > spanMinutes) return setError(t.shift.errDriveTooLong);
    if (continuous > drive) return setError(t.shift.errContinuous);

    const work = { start, end: spanEnd };
    const workHit = findOverlap(allShifts, work, null, shift?.id ?? null, now);
    if (workHit) return setError(t.shift.errOverlap(rangeOf(workHit)));
    if (end !== null && restKind !== 'none') {
      const rest = { start: end, end: end + restMinutes * MINUTE };
      const restHit = findOverlap(allShifts, { start: 0, end: 0 }, rest, shift?.id ?? null, now);
      if (restHit) return setError(t.shift.errRestOverlap(rangeOf(restHit)));
    }

    const record: ManualShift = {
      id: manual?.id ?? `manual-${Date.now()}`,
      start,
      end: restKind === 'none' ? null : end,
      startCountry,
      endCountry: restKind === 'none' ? null : endCountry,
      driveMinutes: drive,
      continuousDriveAtEndMinutes: continuous,
      rest: { kind: restKind, minutes: restKind === 'none' ? 0 : restMinutes, split: restKind === 'daily' && split },
      notes,
    };
    if (willConvert) onConvert(shift!, record);
    else onSaveManual(record);
    onClose();
  };

  const driveMin = live && driveBounds ? initial.drive + driveBounds.min : 0;
  const driveMax = live ? (driveBounds ? initial.drive + driveBounds.max : initial.drive) : Math.max(0, Math.floor(spanMinutes));
  const hint = live
    ? restKind === 'none' && initial.end !== null
      ? t.shift.resumeHint
      : initial.end === null && restKind !== 'none'
        ? t.shift.endNowHint(fmt.time(end ?? now))
        : t.shift.liveHint
    : willConvert
      ? t.shift.convertHint
      : null;

  return (
    <Sheet onClose={onClose} label={isNew ? t.shift.newTitle : t.shift.title} full>
      <header className="sticky top-0 z-20 h-16 px-2 bg-bg flex items-center gap-1 border-b border-surface2">
        <button
          type="button"
          onClick={onClose}
          aria-label={t.common.back}
          className="w-12 h-12 rounded-full flex items-center justify-center hover:bg-surface2 shrink-0"
        >
          <ArrowLeft className="w-6 h-6" />
        </button>
        <div className="flex-1 flex flex-col min-w-0">
          <h1 className="text-[18px] font-bold truncate">{isNew ? t.shift.newTitle : t.shift.title}</h1>
          <span className="text-[12px] text-muted truncate">{fmt.weekdayFullDayMonth(start)}</span>
        </div>
        <button
          type="button"
          onClick={save}
          aria-label={t.common.save}
          className="w-12 h-12 rounded-full flex items-center justify-center text-drive hover:bg-surface2 shrink-0"
        >
          <Check className="w-6 h-6 stroke-[2.5]" />
        </button>
      </header>

      {error && (
        <div className="mx-4 mt-3 p-3.5 rounded-[18px] bg-err-bg text-err-fg text-[13px] flex items-center gap-2.5" role="alert">
          <AlertCircle className="w-5 h-5 shrink-0" />
          <span className="font-semibold">{error}</span>
        </div>
      )}
      {hint && (
        <div className="mx-4 mt-3 p-3 rounded-[16px] bg-surface flex gap-2.5 text-[13px] leading-relaxed text-chip-fg" role="status">
          <Info className="w-4 h-4 shrink-0 mt-0.5 text-muted" />
          <span>{hint}</span>
        </div>
      )}

      <div className="flex-1 flex flex-col gap-5 py-4 pb-10">
        <Section title={t.shift.section}>
          <div className="mx-4 bg-surface rounded-[24px] overflow-hidden">
            <div className="grid grid-cols-2 divide-x divide-surface2">
              <div className="p-4 flex flex-col gap-2.5">
                <span className="text-[13px] text-muted">{t.shift.start}</span>
                <CountryButton code={startCountry} onClick={() => setPicker('country-start')} />
                <DateButtons ts={start} onClick={() => setPicker('dates-start')} />
              </div>
              <div className="p-4 flex flex-col gap-2.5">
                <span className="flex items-center justify-between gap-1">
                  <span className="text-[13px] text-muted">{t.shift.end}</span>
                  {restKind === 'none' && <Chip tone="warn">{t.shift.onRoad}</Chip>}
                </span>
                <CountryButton
                  code={endCountry}
                  placeholder={t.shift.choose}
                  highlight={!!error && !endCountry && restKind !== 'none'}
                  onClick={() => {
                    setError(null);
                    setPicker('country-end');
                  }}
                />
                {end === null ? (
                  <button
                    type="button"
                    onClick={() => selectRestKind('daily')}
                    className="h-11 px-3 rounded-[12px] bg-bg flex items-center gap-2 text-drive text-[13px] font-bold text-left hover:bg-surface2"
                  >
                    <Clock className="w-4 h-4 shrink-0" />
                    {t.shift.nowOngoing}
                  </button>
                ) : (
                  <DateButtons ts={end} onClick={() => setPicker('dates-end')} />
                )}
              </div>
            </div>
            <div className="min-h-14 px-4 border-t border-surface2 flex items-center justify-between">
              <span className="text-[15px] font-semibold">{t.shift.duration}</span>
              <span className={`font-mono-num text-[17px] font-bold ${spanMinutes > MAX_SPAN_MINUTES ? 'text-err-fg' : ''}`}>
                {fmt.hm(spanMinutes)} {end === null && <span className="text-[12px] text-drive">{t.shift.nowSuffix}</span>}
              </span>
            </div>
          </div>
        </Section>

        <Section title={t.shift.driveSection}>
          <div className="mx-4 bg-surface rounded-[24px] overflow-hidden divide-y divide-surface2">
            <ValueRow
              label={t.shift.perDay}
              value={fmt.hm(drive)}
              onClick={!live || driveBounds ? () => setPicker('drive') : undefined}
            />
            <ValueRow
              label={t.shift.continuousAtEnd}
              caption={live ? t.shift.liveContinuous : undefined}
              value={fmt.hm(continuous)}
              onClick={live ? undefined : () => setPicker('continuous')}
            />
            {isAuto && !timingChanged && (
              <>
                <ValueRow label={t.shift.workLabel} value={fmt.hm(shift!.workMinutes)} />
                <ValueRow label={t.shift.poaLabel} value={fmt.hm(shift!.poaMinutes)} />
                <ValueRow label={t.shift.breaksLabel} value={fmt.hm(shift!.breakMinutes)} />
              </>
            )}
          </div>
        </Section>

        <Section title={t.shift.restAfter}>
          <div className="mx-4 bg-surface rounded-[24px] overflow-hidden divide-y divide-surface2">
            <div className="p-4">
              <Segmented
                options={[
                  { value: 'none', label: t.shift.restNone },
                  { value: 'daily', label: t.shift.restDaily },
                  { value: 'weekly', label: t.shift.restWeekly },
                ]}
                value={restKind}
                onChange={selectRestKind}
              />
            </div>

            {restKind === 'daily' && !restOngoing && (
              <div className="p-4 flex items-center justify-between gap-4">
                <span className="flex flex-col gap-0.5">
                  <span className="text-[15px] font-semibold">{t.shift.split}</span>
                  <span className="text-[13px] text-muted">{t.shift.splitHint}</span>
                </span>
                <Switch checked={split} onChange={setSplit} label={t.shift.split} />
              </div>
            )}

            {restKind !== 'none' && (
              <ValueRow
                label={t.shift.restDuration}
                value={restOngoing ? (liveEnded ? fmt.hm(shift!.rest.minutes) : '0:00') : fmt.hm(restMinutes)}
                chip={
                  restOngoing
                    ? { tone: 'rest', text: t.common.ongoing }
                    : status
                      ? { tone: statusTone, text: t.common.restStatus[status] }
                      : undefined
                }
                onClick={restOngoing ? undefined : () => setPicker('rest')}
              />
            )}
          </div>
        </Section>

        <Section title={t.shift.notes}>
          <textarea
            value={notes}
            onChange={(e) => setNotes(e.target.value)}
            placeholder={t.shift.notesPlaceholder}
            rows={3}
            aria-label={t.shift.notes}
            className="mx-4 w-[calc(100%-2rem)] p-4 rounded-[20px] bg-surface placeholder:text-muted border border-transparent outline-none focus:border-drive text-[15px] leading-relaxed resize-none"
          />
        </Section>

        {!isNew && (
          <button
            type="button"
            onClick={() => setPicker('delete')}
            className="mx-4 h-14 rounded-[18px] border border-danger-line text-err-fg hover:bg-err-bg flex items-center justify-center gap-2.5 text-[15px] font-semibold"
          >
            <Trash2 className="w-5 h-5" />
            {t.shift.delete}
          </button>
        )}
      </div>

      {(picker === 'country-start' || picker === 'country-end') && (
        <CountrySheet
          start={startCountry}
          end={endCountry}
          initialTarget={picker === 'country-start' ? 'start' : 'end'}
          allowEmptyEnd={restKind === 'none'}
          onChange={(v) => {
            setStartCountry(v.start);
            setEndCountry(v.end);
            setError(null);
          }}
          onClose={() => setPicker(null)}
        />
      )}
      {(picker === 'dates-start' || picker === 'dates-end') && (
        <DateTimeSheet
          start={start}
          end={end}
          initialTab={picker === 'dates-start' ? 'start' : 'end'}
          max={now}
          onSave={(v) => {
            setStart(v.start);
            setEnd(v.end);
            setError(null);
          }}
          onClose={() => setPicker(null)}
        />
      )}
      {picker === 'drive' && (
        <DurationSheet
          title={t.shift.perDay}
          initial={drive}
          min={driveMin}
          max={Math.max(driveMin, Math.min(driveMax, 24 * 60))}
          onSave={setDrive}
          onClose={() => setPicker(null)}
        />
      )}
      {picker === 'continuous' && (
        <DurationSheet
          title={t.shift.continuousAtEnd}
          initial={continuous}
          max={drive}
          onSave={setContinuous}
          onClose={() => setPicker(null)}
        />
      )}
      {picker === 'rest' && (
        <DurationSheet
          title={t.shift.restDuration}
          initial={restMinutes}
          max={restKind === 'weekly' ? 99 * 60 : 23 * 60}
          onSave={setRestMinutes}
          onClose={() => setPicker(null)}
        />
      )}
      {picker === 'delete' && shift && (
        <ConfirmSheet
          title={t.shift.deleteTitle}
          text={isAuto ? t.shift.deleteAuto : t.shift.deleteManual}
          confirmLabel={t.common.delete}
          cancelLabel={t.common.cancel}
          danger
          onConfirm={() => {
            onDelete(shift);
            onClose();
          }}
          onClose={() => setPicker(null)}
        />
      )}
    </Sheet>
  );
};

const Section: React.FC<{ title: string; children: React.ReactNode }> = ({ title, children }) => (
  <div>
    <h2 className="mx-6 mb-2 text-[13px] font-semibold tracking-[0.08em] uppercase text-muted">{title}</h2>
    {children}
  </div>
);

const CountryButton: React.FC<{ code: string | null; placeholder?: string; highlight?: boolean; onClick: () => void }> = ({
  code,
  placeholder = '—',
  highlight,
  onClick,
}) => (
  <button
    type="button"
    onClick={onClick}
    className={`self-start min-h-11 px-3.5 rounded-full border flex items-center gap-1.5 font-mono-num text-[14px] font-bold ${
      highlight ? 'border-err-fg bg-err-bg text-err-fg' : code ? 'border-switch-off bg-bg hover:border-drive' : 'border-switch-off bg-bg text-muted'
    }`}
  >
    <span>{code ?? placeholder}</span>
    <ChevronDown className="w-4 h-4 text-muted" />
  </button>
);

const DateButtons: React.FC<{ ts: number; onClick: () => void }> = ({ ts, onClick }) => {
  const { fmt } = useI18n();
  const cls = 'h-11 px-3 rounded-[12px] bg-bg flex items-center gap-2 hover:bg-surface2';
  return (
    <div className="flex flex-col gap-1.5 mt-1">
      <button type="button" onClick={onClick} className={cls}>
        <Calendar className="w-4 h-4 text-muted shrink-0" />
        <span className="text-[14px] font-semibold capitalize">{fmt.weekdayDate(ts)}</span>
      </button>
      <button type="button" onClick={onClick} className={cls}>
        <Clock className="w-4 h-4 text-muted shrink-0" />
        <span className="font-mono-num text-[16px] font-bold">{fmt.time(ts)}</span>
      </button>
    </div>
  );
};

const ValueRow: React.FC<{
  label: string;
  caption?: string;
  value: string;
  chip?: { tone: 'bad' | 'warn' | 'rest'; text: string };
  onClick?: () => void;
}> = ({ label, caption, value, chip, onClick }) => {
  const body = (
    <>
      <span className="flex flex-col gap-0.5">
        <span className="text-[15px] font-semibold">{label}</span>
        {caption && <span className="text-[12px] text-muted">{caption}</span>}
      </span>
      <span className="flex items-center gap-2">
        {chip && <Chip tone={chip.tone}>{chip.text}</Chip>}
        <span className="font-mono-num text-[17px] font-bold">{value}</span>
        {onClick && <ChevronRight className="w-4 h-4 text-muted" />}
      </span>
    </>
  );
  const cls = 'w-full min-h-14 px-4 flex items-center justify-between gap-3 text-left';
  return onClick ? (
    <button type="button" onClick={onClick} className={`${cls} hover:bg-surface2/40`}>
      {body}
    </button>
  ) : (
    <div className={cls}>{body}</div>
  );
};
