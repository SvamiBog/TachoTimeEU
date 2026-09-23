import React, { useMemo, useState } from 'react';
import { AlertCircle, Calendar, Check, ChevronDown, ChevronRight, Clock, Trash2 } from 'lucide-react';
import type { JournalShift } from '../../domain/journal';
import { LIMITS } from '../../domain/limits';
import { dailyRestStatus, weeklyRestStatus } from '../../domain/shifts';
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
  defaultCountry: string;
  presetRest?: RestKind;
  now: number;
  onSaveManual: (m: ManualShift) => void;
  onSaveMeta: (id: string, meta: ShiftMeta) => void;
  onDelete: (shift: JournalShift) => void;
  onClose: () => void;
}

type Picker = null | 'dates-start' | 'dates-end' | 'country-start' | 'country-end' | 'drive' | 'continuous' | 'rest' | 'delete';

export const ShiftSheet: React.FC<Props> = ({ shift, manual, defaultCountry, presetRest, now, onSaveManual, onSaveMeta, onDelete, onClose }) => {
  const { t, fmt } = useI18n();
  const isAuto = shift?.source === 'auto';
  const isNew = !shift;

  const nowMinute = Math.floor(now / MINUTE) * MINUTE;
  const [start, setStart] = useState(manual?.start ?? shift?.start ?? nowMinute - 10 * HOUR);
  const [end, setEnd] = useState<number | null>(manual ? manual.end : shift ? shift.end : nowMinute);
  const [startCountry, setStartCountry] = useState(shift?.startCountry ?? defaultCountry);
  const [endCountry, setEndCountry] = useState<string | null>(shift?.endCountry ?? null);
  const [restKind, setRestKind] = useState<RestKind>(manual?.rest.kind ?? presetRest ?? (isNew ? 'daily' : 'none'));
  const [restMinutes, setRestMinutes] = useState(
    manual?.rest.minutes ?? (presetRest === 'weekly' ? LIMITS.weeklyRestRegular : LIMITS.dailyRestRegular),
  );
  const [split, setSplit] = useState(manual?.rest.split ?? false);
  const [drive, setDrive] = useState(manual?.driveMinutes ?? 0);
  const [continuous, setContinuous] = useState(manual?.continuousDriveAtEndMinutes ?? 0);
  const [notes, setNotes] = useState(shift?.notes ?? '');
  const [picker, setPicker] = useState<Picker>(null);
  const [error, setError] = useState<string | null>(null);

  const spanMinutes = minutesBetween(start, end ?? now);
  const status = useMemo(() => {
    if (isAuto) return shift!.rest.status;
    if (restKind === 'daily') return dailyRestStatus(restMinutes, split);
    if (restKind === 'weekly') return weeklyRestStatus(restMinutes);
    return null;
  }, [isAuto, shift, restKind, restMinutes, split]);

  const statusTone = status === 'insufficient' ? 'bad' : status === 'reduced' ? 'warn' : 'rest';

  const selectRestKind = (kind: RestKind) => {
    setRestKind(kind);
    setError(null);
    if (kind === 'none') {
      setEnd(null);
      setEndCountry(null);
    } else {
      if (end === null) setEnd(nowMinute);
      if (kind === 'weekly' && restMinutes < LIMITS.weeklyRestReduced) setRestMinutes(LIMITS.weeklyRestRegular);
      if (kind === 'daily' && restMinutes >= LIMITS.weeklyRestReduced) setRestMinutes(LIMITS.dailyRestRegular);
    }
  };

  const save = () => {
    if (isAuto) {
      onSaveMeta(shift!.id, { startCountry, endCountry: endCountry ?? undefined, notes });
      onClose();
      return;
    }
    if (restKind !== 'none' && !endCountry) {
      setError(t.shift.errEndCountry);
      setPicker('country-end');
      return;
    }
    if (end !== null && end < start) return setError(t.shift.errEndBeforeStart);
    if (start > now || (end !== null && end > now)) return setError(t.shift.errFuture);
    if (drive > spanMinutes) return setError(t.shift.errDriveTooLong);
    if (continuous > drive) return setError(t.shift.errContinuous);

    onSaveManual({
      id: manual?.id ?? `manual-${Date.now()}`,
      start,
      end: restKind === 'none' ? null : end,
      startCountry,
      endCountry: restKind === 'none' ? null : endCountry,
      driveMinutes: drive,
      continuousDriveAtEndMinutes: continuous,
      rest: { kind: restKind, minutes: restKind === 'none' ? 0 : restMinutes, split: restKind === 'daily' && split },
      notes,
    });
    onClose();
  };

  const editable = !isAuto;
  const ongoing = isAuto ? shift!.end === null : restKind === 'none';

  return (
    <Sheet onClose={onClose} label={isNew ? t.shift.newTitle : t.shift.title} full>
      <header className="sticky top-0 z-20 h-16 px-2 bg-bg flex items-center justify-between border-b border-surface2">
        <button
          type="button"
          onClick={onClose}
          aria-label={t.common.back}
          className="w-12 h-12 rounded-full flex items-center justify-center hover:bg-surface2"
        >
          <ChevronDown className="w-6 h-6 rotate-90" />
        </button>
        <div className="flex-1 flex flex-col items-center">
          <h1 className="text-[18px] font-bold">{isNew ? t.shift.newTitle : t.shift.title}</h1>
          <span className="text-[12px] text-muted">{fmt.weekdayDayMonth(start)}</span>
        </div>
        <button
          type="button"
          onClick={save}
          aria-label={t.common.save}
          className="w-12 h-12 rounded-full flex items-center justify-center text-drive hover:bg-surface2"
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

      {isAuto && <p className="mx-6 mt-3 text-[13px] leading-relaxed text-muted">{t.shift.autoHint}</p>}

      <div className="flex-1 flex flex-col gap-5 py-4 pb-10">
        <div>
          <h2 className="mx-6 mb-2 text-[13px] font-semibold tracking-[0.08em] uppercase text-muted">{t.shift.section}</h2>
          <div className="mx-4 bg-surface rounded-[24px] overflow-hidden">
            <div className="grid grid-cols-2 divide-x divide-surface2">
              <div className="p-4 flex flex-col gap-2.5">
                <span className="text-[13px] text-muted">{t.shift.start}</span>
                <CountryButton code={startCountry} onClick={() => setPicker('country-start')} />
                <DateButtons ts={start} disabled={!editable} onClick={() => setPicker('dates-start')} />
              </div>
              <div className="p-4 flex flex-col gap-2.5">
                <span className="flex items-center justify-between">
                  <span className="text-[13px] text-muted">{t.shift.end}</span>
                  {ongoing && <Chip tone="warn">{t.shift.onRoad}</Chip>}
                </span>
                <CountryButton
                  code={endCountry}
                  placeholder={t.shift.choose}
                  highlight={!!error && !endCountry}
                  onClick={() => {
                    setError(null);
                    setPicker('country-end');
                  }}
                />
                {end === null ? (
                  <div className="h-11 px-3 rounded-[12px] bg-bg/50 flex items-center gap-2 text-drive text-[13px] font-bold">
                    <Clock className="w-4 h-4 shrink-0" />
                    {t.shift.nowOngoing}
                  </div>
                ) : (
                  <DateButtons ts={end} disabled={!editable} onClick={() => setPicker('dates-end')} />
                )}
              </div>
            </div>
            <div className="min-h-14 px-4 border-t border-surface2 flex items-center justify-between">
              <span className="text-[15px] font-semibold">{t.shift.duration}</span>
              <span className="font-mono-num text-[17px] font-bold">
                {fmt.hm(spanMinutes)} {ongoing && <span className="text-[12px] text-drive">{t.shift.nowSuffix}</span>}
              </span>
            </div>
          </div>
        </div>

        <div>
          <h2 className="mx-6 mb-2 text-[13px] font-semibold tracking-[0.08em] uppercase text-muted">{t.shift.driveSection}</h2>
          <div className="mx-4 bg-surface rounded-[24px] overflow-hidden divide-y divide-surface2">
            <ValueRow
              label={t.shift.perDay}
              value={fmt.hm(isAuto ? shift!.driveMinutes : drive)}
              onClick={editable ? () => setPicker('drive') : undefined}
            />
            <ValueRow
              label={t.shift.continuousAtEnd}
              value={fmt.hm(isAuto ? shift!.continuousDriveAtEndMinutes : continuous)}
              onClick={editable ? () => setPicker('continuous') : undefined}
            />
            {isAuto && (
              <>
                <ValueRow label={t.shift.workLabel} value={fmt.hm(shift!.workMinutes)} />
                <ValueRow label={t.shift.poaLabel} value={fmt.hm(shift!.poaMinutes)} />
                <ValueRow label={t.shift.breaksLabel} value={fmt.hm(shift!.breakMinutes)} />
              </>
            )}
          </div>
        </div>

        <div>
          <h2 className="mx-6 mb-2 text-[13px] font-semibold tracking-[0.08em] uppercase text-muted">{t.shift.restAfter}</h2>
          <div className="mx-4 bg-surface rounded-[24px] overflow-hidden divide-y divide-surface2">
            {editable ? (
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
            ) : (
              <div className="min-h-14 px-4 flex items-center justify-between">
                <span className="text-[15px] font-semibold">
                  {shift!.rest.kind === 'weekly' ? t.shift.restWeekly : shift!.rest.kind === 'daily' ? t.shift.restDaily : t.shift.restNone}
                </span>
                {shift!.rest.ongoing && <Chip tone="rest">{t.common.ongoing}</Chip>}
              </div>
            )}

            {editable && restKind === 'daily' && (
              <div className="p-4 flex items-center justify-between gap-4">
                <span className="flex flex-col gap-0.5">
                  <span className="text-[15px] font-semibold">{t.shift.split}</span>
                  <span className="text-[13px] text-muted">{t.shift.splitHint}</span>
                </span>
                <Switch checked={split} onChange={setSplit} label={t.shift.split} />
              </div>
            )}

            {(isAuto ? shift!.rest.kind !== 'none' : restKind !== 'none') && (
              <ValueRow
                label={t.shift.restDuration}
                value={fmt.hm(isAuto ? shift!.rest.minutes : restMinutes)}
                chip={status ? { tone: statusTone, text: t.common.restStatus[status] } : undefined}
                onClick={editable ? () => setPicker('rest') : undefined}
              />
            )}
          </div>
        </div>

        <div>
          <h2 className="mx-6 mb-2 text-[13px] font-semibold tracking-[0.08em] uppercase text-muted">{t.shift.notes}</h2>
          <textarea
            value={notes}
            onChange={(e) => setNotes(e.target.value)}
            placeholder={t.shift.notesPlaceholder}
            rows={3}
            aria-label={t.shift.notes}
            className="mx-4 w-[calc(100%-2rem)] p-4 rounded-[20px] bg-surface placeholder:text-muted border border-transparent outline-none focus:border-drive text-[15px] leading-relaxed resize-none"
          />
        </div>

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
          allowEmptyEnd={ongoing}
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
          max={Math.min(spanMinutes, 24 * 60)}
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

const DateButtons: React.FC<{ ts: number; disabled: boolean; onClick: () => void }> = ({ ts, disabled, onClick }) => {
  const { fmt } = useI18n();
  const cls = 'h-11 px-3 rounded-[12px] bg-bg flex items-center gap-2 disabled:opacity-100 enabled:hover:bg-surface2';
  return (
    <div className="flex flex-col gap-1.5 mt-1">
      <button type="button" disabled={disabled} onClick={onClick} className={cls}>
        <Calendar className="w-4 h-4 text-muted shrink-0" />
        <span className="text-[14px] font-semibold">{fmt.weekdayDate(ts)}</span>
      </button>
      <button type="button" disabled={disabled} onClick={onClick} className={cls}>
        <Clock className="w-4 h-4 text-muted shrink-0" />
        <span className="font-mono-num text-[16px] font-bold">{fmt.time(ts)}</span>
      </button>
    </div>
  );
};

const ValueRow: React.FC<{
  label: string;
  value: string;
  chip?: { tone: 'bad' | 'warn' | 'rest'; text: string };
  onClick?: () => void;
}> = ({ label, value, chip, onClick }) => {
  const body = (
    <>
      <span className="text-[15px] font-semibold">{label}</span>
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
