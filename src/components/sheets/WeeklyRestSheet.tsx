import React from 'react';
import { Bed, Info } from 'lucide-react';
import type { ComplianceMetrics } from '../../domain/compliance';
import { MINUTE } from '../../domain/time';
import type { DriverSettings } from '../../domain/types';
import { useI18n } from '../../i18n';
import { PrimaryButton, SecondaryButton, Sheet, SheetHeader } from '../ui';

export const WeeklyRestSheet: React.FC<{
  metrics: ComplianceMetrics;
  settings: DriverSettings;
  onStartRest: () => void;
  onAddManually: () => void;
  onClose: () => void;
}> = ({ metrics: m, settings, onStartRest, onAddManually, onClose }) => {
  const { t, fmt } = useI18n();
  const deadline = m.weeklyRestDeadline;
  const onWeekly = m.offDutyRest?.weekly ?? false;
  const last = m.lastWeeklyRest;

  return (
    <Sheet onClose={onClose} label={t.weekly.title} full>
      <SheetHeader title={t.weekly.title} onBack={onClose} backLabel={t.common.back} closeLabel={t.common.close} />

      <section className="m-4 p-5 bg-surface rounded-[28px] flex flex-col gap-1.5">
        {onWeekly ? (
          <span className="font-mono-num text-[28px] font-bold leading-tight">
            {t.weekly.ongoing(fmt.hm(m.offDutyRest!.minutes))}
          </span>
        ) : deadline !== null ? (
          <>
            <span className="text-[12px] font-semibold tracking-[0.08em] uppercase text-muted">{t.weekly.startBy}</span>
            <span className={`font-mono-num text-[32px] font-bold leading-tight ${deadline < m.now ? 'text-err-fg' : ''}`}>
              {fmt.weekdayDate(deadline)} · {fmt.time(deadline)}
            </span>
            <span className="text-[14px] text-muted">
              {deadline >= m.now
                ? t.weekly.inTime(fmt.hm((deadline - m.now) / MINUTE))
                : t.weekly.overdue(fmt.hm((m.now - deadline) / MINUTE))}
            </span>
          </>
        ) : (
          <span className="text-[14px] leading-relaxed text-muted">{t.weekly.unknown}</span>
        )}
      </section>

      <h2 className="mx-5 mb-2.5 text-[13px] font-semibold tracking-[0.08em] uppercase text-muted">{t.weekly.next}</h2>
      <div className="mx-4 grid grid-cols-2 gap-2">
        <div className="p-4 rounded-[20px] bg-surface border-[1.5px] border-rest flex flex-col gap-1.5">
          <span className="text-[13px] font-semibold text-rest-fg">{t.weekly.full}</span>
          <span className="font-mono-num text-[28px] font-bold">45 {t.common.h}</span>
          <span className="text-[12px] leading-relaxed text-muted">{t.weekly.fullHint}</span>
        </div>
        <div
          className={`p-4 rounded-[20px] bg-surface border border-line flex flex-col gap-1.5 ${
            m.reducedWeeklyRestAvailable ? '' : 'opacity-50'
          }`}
        >
          <span className="text-[13px] font-semibold text-chip-fg">{t.weekly.reduced}</span>
          <span className="font-mono-num text-[28px] font-bold">24 {t.common.h}</span>
          <span className="text-[12px] leading-relaxed text-muted">
            {m.reducedWeeklyRestAvailable ? t.weekly.reducedYes : t.weekly.reducedNo}
          </span>
        </div>
      </div>

      <h2 className="mx-5 mt-5 mb-2.5 text-[13px] font-semibold tracking-[0.08em] uppercase text-muted">{t.weekly.history}</h2>
      <div className="mx-4 bg-surface rounded-[24px] overflow-hidden divide-y divide-surface2">
        {last ? (
          <div className="min-h-16 p-4 flex items-center gap-3.5">
            <Bed className="w-5 h-5 text-rest shrink-0" />
            <span className="flex-1 flex flex-col gap-0.5">
              <span className="text-[15px] font-semibold">{t.weekly.previous(t.common.restStatus[last.status])}</span>
              <span className="font-mono-num text-[12px] text-muted">
                {fmt.dateTime(last.start)} → {last.end !== null ? fmt.dateTime(last.end) : t.common.now}
              </span>
            </span>
            <span className="font-mono-num text-[17px] font-bold">{fmt.hm(last.minutes)}</span>
          </div>
        ) : (
          <div className="p-4 text-[14px] text-muted">{t.main.noData}</div>
        )}
        <div className="min-h-14 p-4 flex items-center gap-3.5">
          <span className="flex-1 text-[15px] font-semibold">{t.weekly.compensation}</span>
          <span className={`text-[14px] font-semibold ${m.compensation ? 'text-warn-fg' : 'text-rest-fg'}`}>
            {m.compensation
              ? t.weekly.compensationValue(fmt.hm(m.compensation.minutes), fmt.dayMonth(m.compensation.dueBy))
              : t.weekly.compensationNone}
          </span>
        </div>
      </div>

      <div className="m-4 p-4 rounded-[16px] bg-surface flex gap-3 text-[14px] leading-relaxed text-chip-fg">
        <Info className="w-5 h-5 text-muted shrink-0 mt-0.5" />
        <span>{settings.mobilityPackageEnabled ? t.weekly.mobilityOn : t.weekly.mobilityOff}</span>
      </div>

      <div className="p-4 pt-0 mt-auto grid grid-cols-2 gap-2">
        <SecondaryButton
          onClick={() => {
            onClose();
            onAddManually();
          }}
        >
          {t.weekly.addManually}
        </SecondaryButton>
        <PrimaryButton
          tone="rest"
          disabled={onWeekly}
          onClick={() => {
            onStartRest();
            onClose();
          }}
        >
          {t.weekly.startRest}
        </PrimaryButton>
      </div>
    </Sheet>
  );
};
