import React, { useState } from 'react';
import { Bed, ChevronDown, Download, Plus } from 'lucide-react';
import type { JournalShift, JournalWeek, Level } from '../domain/journal';
import { LIMITS } from '../domain/limits';
import { useI18n } from '../i18n';
import { Chip, LimitBar, PremiumLock } from './ui';

interface Props {
  weeks: JournalWeek[];
  /** Без Premium новую смену не добавить — на кнопке замок. */
  locked: boolean;
  onOpenShift: (shift: JournalShift | null) => void;
  onOpenExport: () => void;
  now: number;
}

const LEVEL_CHIP: Record<Level, string> = {
  ok: 'bg-surface2 text-fg',
  warn: 'bg-warn-bg text-warn-fg',
  bad: 'bg-err-bg text-err-fg',
};

const hasViolation = (s: JournalShift) => Object.values(s.levels).includes('bad');

export const JournalView: React.FC<Props> = ({ weeks, locked, onOpenShift, onOpenExport, now }) => {
  const { t, fmt } = useI18n();
  // Текущая и прошлая недели раскрыты, более старые — свёрнуты
  const [expanded, setExpanded] = useState<Set<number>>(() => new Set(weeks.slice(0, 2).map((w) => w.start)));
  const toggle = (start: number) =>
    setExpanded((prev) => {
      const next = new Set(prev);
      if (next.has(start)) next.delete(start);
      else next.add(start);
      return next;
    });
  const empty = weeks.every((w) => w.shifts.length === 0 && w.weeklyRests.length === 0);

  return (
    <div className="relative flex flex-col gap-3 pb-6 min-h-full">
      <header className="h-16 px-5 flex items-center justify-between">
        <div className="flex flex-col">
          <h1 className="text-[18px] font-bold tracking-tight">{t.journal.title}</h1>
          <span className="text-[12px] text-muted">{fmt.monthYear(now)}</span>
        </div>
        <button
          type="button"
          onClick={onOpenExport}
          aria-label={t.journal.export}
          className="w-11 h-11 rounded-full flex items-center justify-center hover:bg-surface"
        >
          <Download className="w-5 h-5" />
        </button>
      </header>

      {empty && <p className="mx-6 text-[14px] leading-relaxed text-muted">{t.journal.empty}</p>}

      {weeks.map((week) => {
        const open = expanded.has(week.start);
        const bad = week.shifts.filter(hasViolation).length;
        if (!open) {
          return (
            <button
              key={week.start}
              type="button"
              onClick={() => toggle(week.start)}
              aria-expanded={false}
              className="mx-4 min-h-14 px-4 py-3 rounded-[20px] bg-surface flex items-center justify-between gap-3 text-left"
            >
              <span className="flex flex-col">
                <span className="text-[15px] font-bold">{fmt.weekRange(week.start)}</span>
                <span className="text-[12px] text-muted">{t.journal.olderSummary(week.shifts.length, bad)}</span>
              </span>
              <span className="flex items-center gap-2 text-[13px] text-muted">
                {t.journal.driveShort} <b className="font-mono-num text-fg">{fmt.hm(week.driveMinutes)}</b>
                <ChevronDown className="w-4 h-4" />
              </span>
            </button>
          );
        }
        return (
          <section key={week.start} className="mx-4 bg-surface rounded-[24px] overflow-hidden">
            <button
              type="button"
              onClick={() => toggle(week.start)}
              aria-expanded
              className="w-full p-4 flex flex-col gap-2.5 text-left"
            >
              <span className="flex items-center justify-between">
                <span className="text-[15px] font-bold">{fmt.weekRange(week.start)}</span>
                {week.isCurrent ? <Chip tone="warn">{t.journal.current}</Chip> : <ChevronDown className="w-4 h-4 rotate-180 text-muted" />}
              </span>
              <LimitBar
                value={week.driveMinutes}
                max={LIMITS.weeklyDrive}
                tone={week.driveMinutes > LIMITS.weeklyDrive ? 'bad' : 'drive'}
              />
              <span className="flex justify-between text-[13px] text-muted">
                <span>
                  {t.journal.driveOf} <b className="font-mono-num text-fg">{fmt.hm(week.driveMinutes)}</b> {t.journal.of56}
                </span>
                <span>
                  {t.journal.fortnight}{' '}
                  <b className={`font-mono-num ${week.fortnightMinutes > LIMITS.fortnightDrive ? 'text-err-fg' : 'text-fg'}`}>
                    {fmt.hm(week.fortnightMinutes)}
                  </b>{' '}
                  {t.journal.of90}
                </span>
              </span>
            </button>

            <div className="divide-y divide-surface2 border-t border-surface2">
              {week.shifts.map((s) => (
                <ShiftRow key={s.id} shift={s} onClick={() => onOpenShift(s)} />
              ))}
              {week.weeklyRests.map((r) => (
                <div key={r.start} className="p-3.5 px-4 flex items-center gap-3 bg-rest-bg text-rest-fg">
                  <Bed className="w-5 h-5 text-rest shrink-0" />
                  <span className="flex-1 flex flex-col">
                    <span className="text-[14px] font-semibold">{t.journal.weeklyRestCard(t.common.restStatus[r.status])}</span>
                    <span className="font-mono-num text-[12px] text-muted">
                      {fmt.dateTime(r.start)} → {r.end !== null ? fmt.dateTime(r.end) : t.common.now}
                    </span>
                  </span>
                  <span className="font-mono-num text-[17px] font-bold">{fmt.hm(r.minutes)}</span>
                </div>
              ))}
            </div>
          </section>
        );
      })}

      <div className="sticky bottom-4 mr-4 self-end z-20 mt-auto pt-2">
        <button
          type="button"
          onClick={() => onOpenShift(null)}
          aria-label={t.journal.addShiftAria}
          className="h-14 px-5 rounded-[18px] bg-drive text-on-accent flex items-center gap-2 font-bold text-[15px] shadow-2xl active:scale-95 transition-transform"
        >
          {locked ? <PremiumLock label={t.common.premium} className="w-5 h-5" /> : <Plus className="w-5 h-5 stroke-[2.5]" />}
          {t.journal.addShift}
        </button>
      </div>
    </div>
  );
};

const ShiftRow: React.FC<{ shift: JournalShift; onClick: () => void }> = ({ shift: s, onClick }) => {
  const { t, fmt } = useI18n();
  const live = s.end === null;
  const restValue =
    s.rest.kind === 'none'
      ? '—'
      : s.rest.kind === 'weekly'
        ? t.journal.weeklyShort
        : fmt.hm(s.rest.minutes);

  return (
    <button type="button" onClick={onClick} className="w-full p-3.5 px-4 grid grid-cols-[44px_1fr] gap-3 text-left hover:bg-surface2/40">
      <span className="flex flex-col items-center justify-center">
        <span className="text-[12px] text-muted uppercase font-semibold">{fmt.weekdayShort(s.start)}</span>
        <span className="font-mono-num text-[20px] font-bold leading-tight">{new Date(s.start).getDate()}</span>
      </span>
      <span className="flex flex-col gap-2 min-w-0">
        <span className="flex justify-between items-center gap-2 text-[14px]">
          <span className="font-semibold truncate">
            {s.startCountry ? t.common.route(s.startCountry, s.endCountry) : '—'}
            {s.source === 'manual' && <span className="ml-2 text-[11px] font-normal text-muted">{t.journal.manual}</span>}
          </span>
          <span className={`font-mono-num text-[13px] font-bold shrink-0 ${live ? 'text-drive' : 'text-muted'}`}>
            {fmt.time(s.start)} → {live ? t.common.ongoing : fmt.time(s.end!)}
          </span>
        </span>
        <span className="grid grid-cols-3 gap-1.5">
          <Metric label={t.common.drive} value={fmt.hm(s.driveMinutes)} level={s.levels.drive} />
          <Metric label={t.journal.shift} value={fmt.hm(s.spanMinutes)} level={s.levels.span} />
          <Metric label={t.common.rest} value={restValue} level={s.rest.ongoing ? 'ok' : s.levels.rest} rest={s.rest.ongoing} />
        </span>
      </span>
    </button>
  );
};

const Metric: React.FC<{ label: string; value: string; level: Level; rest?: boolean }> = ({ label, value, level, rest }) => (
  <span className={`p-1.5 px-2 rounded-[10px] flex flex-col ${rest ? 'bg-rest-bg text-rest-fg' : LEVEL_CHIP[level]}`}>
    <span className="text-[11px] opacity-75">{label}</span>
    <span className="font-mono-num text-[15px] font-bold">{value}</span>
  </span>
);
