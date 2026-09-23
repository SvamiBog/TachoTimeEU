import React, { useMemo, useState } from 'react';
import { ChevronLeft, ChevronRight, Minus, Plus } from 'lucide-react';
import { useI18n } from '../i18n';
import { PrimaryButton, SecondaryButton, Segmented, Sheet, SheetHandle } from './ui';

const startOfLocalDay = (ts: number) => {
  const d = new Date(ts);
  return new Date(d.getFullYear(), d.getMonth(), d.getDate()).getTime();
};

/** Календарь (любой месяц) и точное время. Значение — момент в мс. */
export const DateTimeField: React.FC<{
  value: number;
  onChange: (ts: number) => void;
  max?: number;
}> = ({ value, onChange, max }) => {
  const { t, locale } = useI18n();
  const selected = new Date(value);
  const [month, setMonth] = useState(() => new Date(selected.getFullYear(), selected.getMonth(), 1));

  const weekdays = useMemo(() => {
    const f = new Intl.DateTimeFormat(locale, { weekday: 'short' });
    // 5 января 2026 — понедельник
    return Array.from({ length: 7 }, (_, i) => f.format(new Date(2026, 0, 5 + i)).replace('.', ''));
  }, [locale]);
  const monthTitle = new Intl.DateTimeFormat(locale, { month: 'long', year: 'numeric' }).format(month);

  const cells: (number | null)[] = [];
  const offset = (month.getDay() + 6) % 7;
  const daysInMonth = new Date(month.getFullYear(), month.getMonth() + 1, 0).getDate();
  for (let i = 0; i < offset; i++) cells.push(null);
  for (let d = 1; d <= daysInMonth; d++) cells.push(d);
  while (cells.length % 7) cells.push(null);

  const today = startOfLocalDay(Date.now());
  const maxDay = max !== undefined ? startOfLocalDay(max) : Infinity;
  const nextMonth = new Date(month.getFullYear(), month.getMonth() + 1, 1);
  const hh = selected.getHours().toString().padStart(2, '0');
  const mm = selected.getMinutes().toString().padStart(2, '0');

  const pickDay = (day: number) => {
    const d = new Date(value);
    const next = new Date(month.getFullYear(), month.getMonth(), day, d.getHours(), d.getMinutes()).getTime();
    onChange(max !== undefined ? Math.min(next, max) : next);
  };
  const setTime = (text: string) => {
    const [h, m] = text.split(':').map(Number);
    if (Number.isNaN(h) || Number.isNaN(m)) return;
    const d = new Date(value);
    const next = new Date(d.getFullYear(), d.getMonth(), d.getDate(), h, m).getTime();
    onChange(max !== undefined ? Math.min(next, max) : next);
  };

  return (
    <div className="flex flex-col gap-3">
      <div className="flex items-center justify-between">
        <h3 className="text-[17px] font-bold capitalize">{monthTitle}</h3>
        <div className="flex items-center gap-1">
          <button
            type="button"
            aria-label={t.picker.prevMonth}
            onClick={() => setMonth(new Date(month.getFullYear(), month.getMonth() - 1, 1))}
            className="w-11 h-11 rounded-full flex items-center justify-center hover:bg-surface2"
          >
            <ChevronLeft className="w-5 h-5" />
          </button>
          <button
            type="button"
            aria-label={t.picker.nextMonth}
            disabled={nextMonth.getTime() > maxDay}
            onClick={() => setMonth(nextMonth)}
            className="w-11 h-11 rounded-full flex items-center justify-center hover:bg-surface2 disabled:text-switch-off"
          >
            <ChevronRight className="w-5 h-5" />
          </button>
        </div>
      </div>

      <div className="grid grid-cols-7 gap-1 text-center">
        {weekdays.map((d) => (
          <span key={d} className="h-6 text-[12px] font-semibold text-muted capitalize">
            {d}
          </span>
        ))}
        {cells.map((d, idx) => {
          if (d === null) return <div key={`e${idx}`} className="h-10" />;
          const dayTs = new Date(month.getFullYear(), month.getMonth(), d).getTime();
          const isSelected = startOfLocalDay(value) === dayTs;
          const disabled = dayTs > maxDay;
          return (
            <button
              key={d}
              type="button"
              disabled={disabled}
              onClick={() => pickDay(d)}
              className={`h-10 rounded-full font-mono-num text-[15px] font-bold ${
                isSelected
                  ? 'bg-drive text-on-accent'
                  : disabled
                    ? 'text-switch-off'
                    : dayTs === today
                      ? 'border border-muted hover:bg-surface2'
                      : 'hover:bg-surface2'
              }`}
            >
              {d}
            </button>
          );
        })}
      </div>

      <label className="flex items-center justify-between gap-3 pt-2 border-t border-surface2">
        <span className="text-[12px] font-semibold tracking-[0.08em] uppercase text-muted">{t.picker.time}</span>
        <input
          type="time"
          value={`${hh}:${mm}`}
          onChange={(e) => setTime(e.target.value)}
          className="h-12 px-3 rounded-[14px] bg-surface2 font-mono-num text-[24px] font-bold text-fg"
        />
      </label>
    </div>
  );
};

/** Шторка выбора начала и (необязательно) конца. */
export const DateTimeSheet: React.FC<{
  start: number;
  end: number | null;
  initialTab: 'start' | 'end';
  max: number;
  onSave: (v: { start: number; end: number | null }) => void;
  onClose: () => void;
}> = ({ start: s0, end: e0, initialTab, max, onSave, onClose }) => {
  const { t, fmt } = useI18n();
  const [tab, setTab] = useState(e0 === null ? 'start' : initialTab);
  const [start, setStart] = useState(s0);
  const [end, setEnd] = useState(e0);

  return (
    <Sheet onClose={onClose} label={t.shift.section}>
      <SheetHandle />
      <div className="p-5 pb-7 flex flex-col gap-4">
        {end !== null && (
          <Segmented
            options={[
              { value: 'start', label: `${t.shift.start} · ${fmt.dayMonth(start)} ${fmt.time(start)}` },
              { value: 'end', label: `${t.shift.end} · ${fmt.dayMonth(end)} ${fmt.time(end)}` },
            ]}
            value={tab}
            onChange={setTab}
          />
        )}
        {tab === 'start' || end === null ? (
          <DateTimeField key="start" value={start} onChange={setStart} max={max} />
        ) : (
          <DateTimeField key="end" value={end} onChange={setEnd} max={max} />
        )}
        <div className="grid grid-cols-2 gap-2">
          <SecondaryButton onClick={onClose}>{t.common.cancel}</SecondaryButton>
          <PrimaryButton
            onClick={() => {
              onSave({ start, end });
              onClose();
            }}
          >
            {t.common.done}
          </PrimaryButton>
        </div>
      </div>
    </Sheet>
  );
};

/** Выбор длительности: часы и минуты кнопками или вводом, в пределах [min, max]. */
export const DurationField: React.FC<{
  value: number;
  onChange: (m: number) => void;
  min?: number;
  max: number;
  minuteStep?: number;
}> = ({ value, onChange, min = 0, max, minuteStep = 5 }) => {
  const { t } = useI18n();
  const clamp = (v: number) => Math.min(max, Math.max(min, Math.round(v)));
  const h = Math.floor(value / 60);
  const m = Math.round(value % 60);

  const column = (label: string, v: number, step: number, set: (n: number) => void, pad: number) => (
    <div className="flex flex-col items-center gap-2 bg-bg p-3 rounded-[20px]">
      <span className="text-[12px] text-muted font-medium">{label}</span>
      <div className="flex items-center gap-3">
        <button
          type="button"
          aria-label={t.picker.minus(label)}
          onClick={() => onChange(clamp(value - step))}
          className="w-11 h-11 rounded-full bg-surface2 flex items-center justify-center"
        >
          <Minus className="w-5 h-5" />
        </button>
        <input
          inputMode="numeric"
          aria-label={label}
          value={v.toString().padStart(pad, '0')}
          onChange={(e) => {
            const n = Number(e.target.value.replace(/\D/g, ''));
            if (!Number.isNaN(n)) set(n);
          }}
          className="w-14 text-center bg-transparent font-mono-num text-[32px] font-bold"
        />
        <button
          type="button"
          aria-label={t.picker.plus(label)}
          onClick={() => onChange(clamp(value + step))}
          className="w-11 h-11 rounded-full bg-surface2 flex items-center justify-center"
        >
          <Plus className="w-5 h-5" />
        </button>
      </div>
    </div>
  );

  return (
    <div className="grid grid-cols-2 gap-3">
      {column(t.common.hours, h, 60, (n) => onChange(clamp(n * 60 + m)), 1)}
      {column(t.common.minutes, m, minuteStep, (n) => onChange(clamp(h * 60 + Math.min(59, n))), 2)}
    </div>
  );
};

export const DurationSheet: React.FC<{
  title: string;
  subtitle?: string;
  initial: number;
  min?: number;
  max: number;
  onSave: (m: number) => void;
  onClose: () => void;
}> = ({ title, subtitle, initial, min = 0, max, onSave, onClose }) => {
  const { t, fmt } = useI18n();
  const [value, setValue] = useState(Math.min(max, Math.max(min, Math.round(initial))));
  return (
    <Sheet onClose={onClose} label={title}>
      <SheetHandle />
      <div className="p-5 pb-7 flex flex-col gap-4">
        <div className="flex flex-col gap-1">
          <h2 className="text-[20px] font-bold">{title}</h2>
          {subtitle && <span className="text-[14px] text-muted">{subtitle}</span>}
        </div>
        <DurationField value={value} onChange={setValue} min={min} max={max} />
        {(min > 0 || max < 100 * 60) && <span className="text-[13px] text-muted">{t.picker.range(fmt.hm(min), fmt.hm(max))}</span>}
        <div className="grid grid-cols-2 gap-2">
          <SecondaryButton onClick={onClose}>{t.common.cancel}</SecondaryButton>
          <PrimaryButton
            onClick={() => {
              onSave(value);
              onClose();
            }}
          >
            {t.common.save}
          </PrimaryButton>
        </div>
      </div>
    </Sheet>
  );
};
