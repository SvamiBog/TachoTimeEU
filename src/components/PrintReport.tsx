import React from 'react';
import type { JournalShift, JournalWeek, Level } from '../domain/journal';
import { shiftsInRange } from '../domain/report';
import { weekStartUtc } from '../domain/time';
import type { DriverSettings } from '../domain/types';
import { useI18n } from '../i18n';
import type { PrintJob } from './sheets/ExportSheet';

/**
 * Отчёт для инспекции. Рисуется в #print-root только на время печати:
 * «Сохранить как PDF» в диалоге печати даёт PDF-файл.
 */
export const PrintReport: React.FC<{ job: PrintJob; weeks: JournalWeek[]; settings: DriverSettings; now: number }> = ({
  job,
  weeks,
  settings,
  now,
}) => {
  const { t, fmt } = useI18n();
  const shifts = shiftsInRange(weeks, job.from, job.to);
  const byWeek = new Map<number, JournalShift[]>();
  for (const s of shifts) {
    const w = weekStartUtc(s.start);
    byWeek.set(w, [...(byWeek.get(w) ?? []), s]);
  }
  const tz = Intl.DateTimeFormat().resolvedOptions().timeZone;
  const mark = (level: Level) => (level === 'bad' ? ' ‼' : level === 'warn' ? ' !' : '');
  const cell = 'border border-black/30 px-1.5 py-1 align-top';
  const num = `${cell} font-mono-num text-right whitespace-nowrap`;

  return (
    <div className="bg-white text-black p-2 text-[10.5px] leading-snug font-sans">
      <h1 className="text-[18px] font-bold">{t.report.title}</h1>
      <p className="text-[11px] mb-3">{t.report.subtitle}</p>

      <table className="mb-3 border-collapse">
        <tbody>
          {[
            [t.report.driver, settings.driverName],
            [t.report.card, settings.driverCardNumber],
            [t.report.vehicle, settings.vehiclePlate],
            [t.report.company, settings.companyName],
            [t.report.period, `${fmt.date(job.from)} — ${fmt.date(job.to)}`],
            [t.report.generated, `${fmt.date(now)} ${fmt.time(now)}`],
          ].map(([k, v]) => (
            <tr key={k}>
              <th className="pr-4 text-left font-semibold">{k}</th>
              <td>{v || '—'}</td>
            </tr>
          ))}
        </tbody>
      </table>
      <p className="mb-3">{t.report.timezone(tz)}</p>

      {[...byWeek.entries()].map(([week, list]) => {
        const summary = weeks.find((w) => w.start === week);
        return (
          <table key={week} className="w-full border-collapse mb-4 break-inside-avoid">
            <thead>
              <tr className="bg-black/5">
                <th className={cell}>{t.report.date}</th>
                <th className={cell}>{t.report.start}</th>
                <th className={cell}>{t.report.end}</th>
                {job.includeNotes && <th className={cell}>{t.report.countries}</th>}
                <th className={cell}>{t.report.drive}</th>
                <th className={cell}>{t.report.work}</th>
                <th className={cell}>{t.report.poa}</th>
                <th className={cell}>{t.report.breaks}</th>
                <th className={cell}>{t.report.span}</th>
                <th className={cell}>{t.report.restAfter}</th>
                {job.includeNotes && <th className={cell}>{t.report.notes}</th>}
              </tr>
            </thead>
            <tbody>
              {list.map((s) => (
                <tr key={s.id}>
                  <td className={cell}>
                    {fmt.weekdayDate(s.start)}
                    {s.source === 'manual' && ' *'}
                  </td>
                  <td className={num}>{fmt.time(s.start)}</td>
                  <td className={num}>{s.end !== null ? fmt.dateTime(s.end) : t.common.ongoing}</td>
                  {job.includeNotes && (
                    <td className={cell}>{s.startCountry ? t.common.route(s.startCountry, s.endCountry) : '—'}</td>
                  )}
                  <td className={num}>
                    {fmt.hm(s.driveMinutes)}
                    {mark(s.levels.drive)}
                  </td>
                  <td className={num}>{s.source === 'auto' ? fmt.hm(s.workMinutes) : '—'}</td>
                  <td className={num}>{s.source === 'auto' ? fmt.hm(s.poaMinutes) : '—'}</td>
                  <td className={num}>{s.source === 'auto' ? fmt.hm(s.breakMinutes) : '—'}</td>
                  <td className={num}>
                    {fmt.hm(s.spanMinutes)}
                    {mark(s.levels.span)}
                  </td>
                  <td className={num}>
                    {s.rest.kind === 'none'
                      ? '—'
                      : `${fmt.hm(s.rest.minutes)}${s.rest.status ? ` ${t.common.restStatus[s.rest.status]}` : ''}`}
                    {mark(s.levels.rest)}
                  </td>
                  {job.includeNotes && <td className={cell}>{s.notes}</td>}
                </tr>
              ))}
              {summary && (
                <tr className="font-semibold">
                  <td className={cell} colSpan={job.includeNotes ? 4 : 3}>
                    {t.report.weekTotal(fmt.weekRange(week))}
                  </td>
                  <td className={num}>{fmt.hm(summary.driveMinutes)}</td>
                  <td className={cell} colSpan={job.includeNotes ? 6 : 5}>
                    {t.journal.fortnight} {fmt.hm(summary.fortnightMinutes)} {t.journal.of90}
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        );
      })}

      <p className="font-semibold mt-2">{t.report.marks}</p>
      <ul className="mb-3">
        <li>! / ‼ — {t.report.markDrive}</li>
        <li>! / ‼ — {t.report.markSpan}</li>
        <li>! / ‼ — {t.report.markRest}</li>
        <li>* — {t.report.manual}</li>
      </ul>
      <p className="mb-8">{t.report.disclaimer}</p>
      <p>
        {t.report.signature}: ______________________________
      </p>
    </div>
  );
};
