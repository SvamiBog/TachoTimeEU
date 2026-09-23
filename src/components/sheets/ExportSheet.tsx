import React, { useState } from 'react';
import { Calendar, Download } from 'lucide-react';
import type { JournalWeek } from '../../domain/journal';
import { ReportPeriod, buildCsv, periodRange, shiftsInRange } from '../../domain/report';
import { DAY } from '../../domain/time';
import type { ActivityEntry, DriverSettings } from '../../domain/types';
import { useI18n } from '../../i18n';
import { Chip, Pills, PrimaryButton, SecondaryButton, Segmented, Sheet, SheetHandle, Switch } from '../ui';

export interface PrintJob {
  from: number;
  to: number;
  includeNotes: boolean;
}

const toInputDate = (ts: number) => {
  const d = new Date(ts);
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
};
const fromInputDate = (v: string) => {
  const [y, m, d] = v.split('-').map(Number);
  return new Date(y, m - 1, d).getTime();
};

export const ExportSheet: React.FC<{
  weeks: JournalWeek[];
  entries: ActivityEntry[];
  settings: DriverSettings;
  now: number;
  onOpenPaywall: () => void;
  onPrint: (job: PrintJob) => void;
  onClose: () => void;
}> = ({ weeks, entries, settings, now, onOpenPaywall, onPrint, onClose }) => {
  const { t, fmt } = useI18n();
  const [period, setPeriod] = useState<ReportPeriod>('days28');
  const [format, setFormat] = useState<'pdf' | 'csv'>('pdf');
  const [includeNotes, setIncludeNotes] = useState(true);
  const [custom, setCustom] = useState({ from: now - 7 * DAY, to: now });

  // Свой период: «по» включает весь последний день
  const range = periodRange(period, now, { from: custom.from, to: Math.min(now, custom.to + DAY) });
  const shifts = shiftsInRange(weeks, range.from, range.to);

  const exportNow = () => {
    if (!settings.isPremium) {
      onClose();
      onOpenPaywall();
      return;
    }
    if (format === 'csv') {
      const blob = new Blob([buildCsv(entries, range.from, range.to, includeNotes)], { type: 'text/csv;charset=utf-8' });
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = `tachotime_${toInputDate(range.from)}_${toInputDate(range.to)}.csv`;
      document.body.appendChild(a);
      a.click();
      a.remove();
      URL.revokeObjectURL(url);
      onClose();
    } else {
      onPrint({ from: range.from, to: range.to, includeNotes });
      onClose();
    }
  };

  return (
    <Sheet onClose={onClose} label={t.export.title}>
      <SheetHandle />
      <div className="p-5 pb-7 flex flex-col gap-4">
        <div className="flex items-center justify-between">
          <h2 className="text-[20px] font-bold">{t.export.title}</h2>
          {!settings.isPremium && <Chip tone="accent">{t.common.premium}</Chip>}
        </div>

        <div className="flex flex-col gap-2">
          <span className="text-[13px] font-semibold tracking-[0.08em] uppercase text-muted">{t.export.period}</span>
          <Pills<ReportPeriod>
            options={[
              { value: 'week', label: t.export.week },
              { value: 'twoWeeks', label: t.export.twoWeeks },
              { value: 'days28', label: t.export.days28 },
              { value: 'custom', label: t.export.custom },
            ]}
            value={period}
            onChange={setPeriod}
          />
          {period === 'custom' ? (
            <div className="grid grid-cols-2 gap-2">
              <label className="flex flex-col gap-1 text-[12px] text-muted">
                {t.export.from}
                <input
                  type="date"
                  value={toInputDate(custom.from)}
                  max={toInputDate(custom.to)}
                  onChange={(e) => e.target.value && setCustom((c) => ({ ...c, from: fromInputDate(e.target.value) }))}
                  className="h-11 px-3 rounded-[12px] bg-surface text-fg font-mono-num text-[14px]"
                />
              </label>
              <label className="flex flex-col gap-1 text-[12px] text-muted">
                {t.export.to}
                <input
                  type="date"
                  value={toInputDate(custom.to)}
                  min={toInputDate(custom.from)}
                  max={toInputDate(now)}
                  onChange={(e) => e.target.value && setCustom((c) => ({ ...c, to: fromInputDate(e.target.value) }))}
                  className="h-11 px-3 rounded-[12px] bg-surface text-fg font-mono-num text-[14px]"
                />
              </label>
            </div>
          ) : (
            <div className="flex items-center gap-2.5 p-3 rounded-[14px] bg-surface">
              <Calendar className="w-4 h-4 text-muted" />
              <span className="font-mono-num text-[14px] font-bold">
                {fmt.date(range.from)} — {fmt.date(range.to)}
              </span>
            </div>
          )}
          <span className={`text-[13px] ${shifts.length ? 'text-muted' : 'text-warn-fg'}`}>
            {shifts.length ? t.export.count(shifts.length) : t.export.empty}
          </span>
        </div>

        <div className="flex flex-col gap-2">
          <span className="text-[13px] font-semibold tracking-[0.08em] uppercase text-muted">{t.export.format}</span>
          <Segmented
            options={[
              { value: 'pdf', label: t.export.pdf },
              { value: 'csv', label: t.export.csv },
            ]}
            value={format}
            onChange={setFormat}
          />
          {format === 'pdf' && <span className="text-[13px] text-muted">{t.export.pdfHint}</span>}
        </div>

        <div className="flex items-center justify-between">
          <span className="text-[15px] font-semibold">{t.export.notes}</span>
          <Switch checked={includeNotes} onChange={setIncludeNotes} label={t.export.notes} />
        </div>

        <div className="grid grid-cols-2 gap-2">
          <SecondaryButton onClick={onClose}>{t.common.cancel}</SecondaryButton>
          <PrimaryButton onClick={exportNow} disabled={!shifts.length} className="flex items-center justify-center gap-2">
            <Download className="w-5 h-5" />
            {t.export.create}
          </PrimaryButton>
        </div>
      </div>
    </Sheet>
  );
};
