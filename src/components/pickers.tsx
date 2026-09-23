import React, { useEffect, useMemo, useRef, useState } from 'react';
import { ChevronLeft, ChevronRight } from 'lucide-react';
import { useI18n } from '../i18n';
import { PrimaryButton, SecondaryButton, Segmented, Sheet, SheetHandle } from './ui';

const startOfLocalDay = (ts: number) => {
  const d = new Date(ts);
  return new Date(d.getFullYear(), d.getMonth(), d.getDate()).getTime();
};

const ROW = 40;
const CENTER = 56;

/**
 * Колёсико значения (макеты 07 и 12): текущее значение в центре, соседние
 * сверху и снизу. Меняется касанием соседнего значения, протягиванием,
 * колесом мыши и стрелками клавиатуры — шаг 1.
 */
export const Wheel: React.FC<{
  value: number;
  min: number;
  max: number;
  wrap?: boolean;
  rows?: number;
  label: string;
  suffix?: string;
  pad?: number;
  onChange: (v: number) => void;
}> = ({ value, min, max, wrap = false, rows = 1, label, suffix, pad = 2, onChange }) => {
  const ref = useRef<HTMLDivElement>(null);
  const drag = useRef<{ y: number; value: number; moved: boolean; offset: number } | null>(null);
  const span = max - min + 1;
  const norm = (v: number) => (wrap ? ((((v - min) % span) + span) % span) + min : Math.min(max, Math.max(min, v)));
  const at = (offset: number): number | null => {
    const v = value + offset;
    if (wrap) return norm(v);
    return v < min || v > max ? null : v;
  };
  const text = (v: number) => v.toString().padStart(pad, '0');

  // Колесо мыши: нужен непассивный обработчик, чтобы не прокручивать страницу
  const latest = useRef({ value, onChange, norm });
  latest.current = { value, onChange, norm };
  useEffect(() => {
    const el = ref.current;
    if (!el) return;
    const onWheel = (e: WheelEvent) => {
      e.preventDefault();
      const { value: v, onChange: set, norm: n } = latest.current;
      set(n(v + (e.deltaY > 0 ? 1 : -1)));
    };
    el.addEventListener('wheel', onWheel, { passive: false });
    return () => el.removeEventListener('wheel', onWheel);
  }, []);

  return (
    <div
      ref={ref}
      role="spinbutton"
      tabIndex={0}
      aria-label={label}
      aria-valuenow={value}
      aria-valuemin={min}
      aria-valuemax={max}
      aria-valuetext={`${text(value)}${suffix ? ` ${suffix}` : ''}`}
      onKeyDown={(e) => {
        if (e.key === 'ArrowUp') onChange(norm(value - 1));
        else if (e.key === 'ArrowDown') onChange(norm(value + 1));
        else return;
        e.preventDefault();
      }}
      onPointerDown={(e) => {
        const cell = (e.target as HTMLElement).closest<HTMLElement>('[data-offset]');
        drag.current = { y: e.clientY, value, moved: false, offset: Number(cell?.dataset.offset ?? 0) };
      }}
      onPointerMove={(e) => {
        const d = drag.current;
        if (!d) return;
        const dy = d.y - e.clientY;
        if (!d.moved) {
          if (Math.abs(dy) < 6) return;
          // Захватываем указатель только когда начали тянуть — иначе касание
          // соседнего значения не доходит до него
          d.moved = true;
          e.currentTarget.setPointerCapture(e.pointerId);
        }
        const next = norm(d.value + Math.round(dy / ROW));
        if (next !== value) onChange(next);
      }}
      onPointerUp={() => {
        const d = drag.current;
        drag.current = null;
        if (d && !d.moved && d.offset !== 0) {
          const v = at(d.offset);
          if (v !== null) onChange(v);
        }
      }}
      onPointerCancel={() => (drag.current = null)}
      className="relative flex flex-col items-center select-none touch-none outline-none focus-visible:ring-2 focus-visible:ring-drive rounded-[14px] cursor-ns-resize"
    >
      {Array.from({ length: rows * 2 + 1 }, (_, i) => i - rows).map((offset) => {
        const v = at(offset);
        if (offset === 0) {
          return (
            <div key={offset} className="flex items-baseline justify-center gap-1.5" style={{ height: CENTER, lineHeight: `${CENTER}px` }}>
              <span className="font-mono-num text-[40px] font-bold">{text(value)}</span>
              {suffix && <span className="text-[16px] text-muted">{suffix}</span>}
            </div>
          );
        }
        const far = Math.abs(offset) > 1;
        return (
          <div
            key={offset}
            data-offset={offset}
            aria-hidden="true"
            className={`w-full flex items-center justify-center font-mono-num ${far ? 'text-[20px] text-switch-off' : 'text-[26px] text-muted'}`}
            style={{ height: ROW }}
          >
            {v === null ? '' : text(v)}
          </div>
        );
      })}
    </div>
  );
};

/** Два колёсика с общей подсветкой центральной строки. */
const WheelPair: React.FC<{ rows: number; children: React.ReactNode }> = ({ rows, children }) => (
  <div className="relative grid grid-cols-[1fr_24px_1fr] items-center">
    <div
      aria-hidden="true"
      className="absolute inset-x-0 rounded-[16px] bg-surface2 pointer-events-none"
      style={{ top: rows * ROW, height: CENTER }}
    />
    {children}
  </div>
);

/** Календарь (любой месяц) и время колёсиками. Значение — момент в мс. */
export const DateTimeField: React.FC<{
  value: number;
  onChange: (ts: number) => void;
  max?: number;
}> = ({ value, onChange, max }) => {
  const { t, locale, fmt } = useI18n();
  const selected = new Date(value);
  const [month, setMonth] = useState(() => new Date(selected.getFullYear(), selected.getMonth(), 1));

  const weekdays = useMemo(() => {
    const f = new Intl.DateTimeFormat(locale, { weekday: 'short' });
    // 5 января 2026 — понедельник
    return Array.from({ length: 7 }, (_, i) => f.format(new Date(2026, 0, 5 + i)).replace('.', ''));
  }, [locale]);

  const cells: (number | null)[] = [];
  const offset = (month.getDay() + 6) % 7;
  const daysInMonth = new Date(month.getFullYear(), month.getMonth() + 1, 0).getDate();
  for (let i = 0; i < offset; i++) cells.push(null);
  for (let d = 1; d <= daysInMonth; d++) cells.push(d);
  while (cells.length % 7) cells.push(null);

  const today = startOfLocalDay(Date.now());
  const maxDay = max !== undefined ? startOfLocalDay(max) : Infinity;
  const nextMonth = new Date(month.getFullYear(), month.getMonth() + 1, 1);
  const clamp = (ts: number) => (max !== undefined ? Math.min(ts, max) : ts);

  const set = (patch: { y?: number; mo?: number; d?: number; h?: number; mi?: number }) => {
    const c = new Date(value);
    onChange(
      clamp(
        new Date(
          patch.y ?? c.getFullYear(),
          patch.mo ?? c.getMonth(),
          patch.d ?? c.getDate(),
          patch.h ?? c.getHours(),
          patch.mi ?? c.getMinutes(),
        ).getTime(),
      ),
    );
  };

  return (
    <div className="flex flex-col gap-3">
      <div className="flex items-center justify-between">
        <h3 className="text-[17px] font-bold">{fmt.monthYear(month.getTime())}</h3>
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
              aria-pressed={isSelected}
              onClick={() => set({ y: month.getFullYear(), mo: month.getMonth(), d })}
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

      <div className="pt-2 border-t border-surface2 flex flex-col gap-1">
        <span className="text-[12px] font-semibold tracking-[0.08em] uppercase text-muted">{t.picker.time}</span>
        <WheelPair rows={1}>
          <Wheel label={t.common.hours} value={selected.getHours()} min={0} max={23} wrap onChange={(h) => set({ h })} />
          <span className="relative text-center font-mono-num text-[32px] font-bold">:</span>
          <Wheel label={t.common.minutes} value={selected.getMinutes()} min={0} max={59} wrap onChange={(mi) => set({ mi })} />
        </WheelPair>
      </div>
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

/** Длительность колёсиками часов и минут (макет 07) в пределах [min, max]. */
export const DurationField: React.FC<{
  value: number;
  onChange: (m: number) => void;
  min?: number;
  max: number;
}> = ({ value, onChange, min = 0, max }) => {
  const { t } = useI18n();
  const clamp = (v: number) => Math.min(max, Math.max(min, Math.round(v)));
  const h = Math.floor(value / 60);
  const m = Math.round(value % 60);
  return (
    <WheelPair rows={2}>
      <Wheel
        label={t.common.hours}
        suffix={t.common.h}
        pad={1}
        rows={2}
        value={h}
        min={Math.floor(min / 60)}
        max={Math.floor(max / 60)}
        onChange={(nh) => onChange(clamp(nh * 60 + m))}
      />
      <span />
      <Wheel
        label={t.common.minutes}
        suffix={t.common.min}
        rows={2}
        value={m}
        min={0}
        max={59}
        wrap
        onChange={(nm) => onChange(clamp(h * 60 + nm))}
      />
    </WheelPair>
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
