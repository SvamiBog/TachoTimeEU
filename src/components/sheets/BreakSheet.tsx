import React, { useState } from 'react';
import type { ComplianceMetrics } from '../../domain/compliance';
import { lastBreakInfo } from '../../domain/entries';
import { LIMITS } from '../../domain/limits';
import { MINUTE } from '../../domain/time';
import type { ActivityEntry } from '../../domain/types';
import { useI18n } from '../../i18n';
import { DurationField } from '../pickers';
import { PrimaryButton, SecondaryButton, Sheet, SheetHeader } from '../ui';

export const BreakSheet: React.FC<{
  metrics: ComplianceMetrics;
  entries: ActivityEntry[];
  onStartBreak: () => void;
  onSetDuration: (minutes: number) => void;
  onClose: () => void;
}> = ({ metrics: m, entries, onStartBreak, onSetDuration, onClose }) => {
  const { t, fmt } = useI18n();
  const info = m.shift ? lastBreakInfo(entries, m.shift.start, m.now) : null;
  const [duration, setDuration] = useState(info?.minutes ?? 0);
  const first = m.breakFirstPart;
  const current = m.currentBreak;
  const resting = m.currentActivity === 'REST';

  const firstTone = first ? 'bg-rest text-on-accent' : 'border border-dashed border-rest text-rest-fg';
  const secondDone = current && current.requiredMinutes === LIMITS.breakSplitSecond && current.minutes >= LIMITS.breakSplitSecond;

  return (
    <Sheet onClose={onClose} label={t.breakSheet.title} full>
      <SheetHeader title={t.breakSheet.title} onBack={onClose} backLabel={t.common.back} closeLabel={t.common.close} />

      <section className="m-4 p-5 bg-surface rounded-[28px] flex flex-col gap-3.5">
        <div className="flex justify-between items-baseline gap-2">
          <span className="text-[15px] font-semibold">{t.breakSheet.hero}</span>
          <span className="font-mono-num text-[15px] font-bold">
            {fmt.hm(m.continuousDriveMinutes)} / 4:30
          </span>
        </div>
        <div className="grid grid-cols-3 gap-1.5">
          <div className={`h-10 rounded-[10px] flex items-center justify-center text-[13px] font-bold ${firstTone}`}>
            {t.breakSheet.part15} {first ? '✓' : ''}
          </div>
          <div
            className={`col-span-2 h-10 rounded-[10px] flex items-center justify-center text-[13px] font-bold ${
              secondDone ? 'bg-rest text-on-accent' : 'border border-dashed border-rest text-rest-fg'
            }`}
          >
            {first ? `${t.breakSheet.part30} — ${t.breakSheet.left}` : t.breakSheet.full45}
          </div>
        </div>
        <span className="text-[13px] text-muted">
          {current
            ? t.breakSheet.resting(fmt.hm(current.minutes), current.requiredMinutes)
            : first
              ? t.breakSheet.firstTaken(fmt.time(first.start), fmt.time(first.start + first.minutes * MINUTE))
              : t.breakSheet.none}
        </span>
      </section>

      <h2 className="mx-5 mb-2 text-[13px] font-semibold tracking-[0.08em] uppercase text-muted">{t.breakSheet.correction}</h2>
      <div className="mx-4 bg-surface rounded-[24px] overflow-hidden divide-y divide-surface2">
        <div className="p-4 flex flex-col gap-3">
          {info ? (
            <>
              <span className="text-[15px] font-semibold">
                {info.open ? t.breakSheet.currentDuration : t.breakSheet.lastDuration}
              </span>
              <DurationField value={duration} onChange={setDuration} min={1} max={Math.max(1, info.max)} />
              <span className="text-[13px] text-muted">{t.picker.range('0:01', fmt.hm(info.max))}</span>
            </>
          ) : (
            <span className="text-[14px] text-muted">{t.breakSheet.noBreakToEdit}</span>
          )}
        </div>
        <div className="p-4 flex flex-col gap-1">
          <span className="text-[15px] font-semibold">{t.breakSheet.splitTitle}</span>
          <span className="text-[13px] leading-relaxed text-muted">{t.breakSheet.splitText}</span>
        </div>
      </div>

      <div className="p-4 mt-auto grid grid-cols-2 gap-2">
        <SecondaryButton
          disabled={!info || duration === info.minutes}
          onClick={() => {
            onSetDuration(duration);
            onClose();
          }}
        >
          {t.common.save}
        </SecondaryButton>
        <PrimaryButton
          tone="rest"
          disabled={resting}
          onClick={() => {
            onStartBreak();
            onClose();
          }}
        >
          {resting ? t.breakSheet.resting2 : t.breakSheet.start}
        </PrimaryButton>
      </div>
    </Sheet>
  );
};
