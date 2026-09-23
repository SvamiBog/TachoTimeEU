import React from 'react';
import { Clock, Info } from 'lucide-react';
import type { ComplianceMetrics } from '../../domain/compliance';
import { MINUTE } from '../../domain/time';
import type { DriverSettings } from '../../domain/types';
import { useI18n } from '../../i18n';
import { LimitBar, PrimaryButton, SecondaryButton, Sheet, SheetHeader } from '../ui';

export const WorkdaySheet: React.FC<{
  metrics: ComplianceMetrics;
  settings: DriverSettings;
  country: string;
  onChangeStart: () => void;
  onEndDay: () => void;
  onClose: () => void;
}> = ({ metrics: m, settings, country, onChangeStart, onEndDay, onClose }) => {
  const { t, fmt } = useI18n();
  const shift = m.shift;
  const team = settings.crewMode === 'TEAM';
  const resting = m.currentActivity === 'REST';

  return (
    <Sheet onClose={onClose} label={t.workday.title} full>
      <SheetHeader title={t.workday.title} onBack={onClose} backLabel={t.common.back} closeLabel={t.common.close} />

      <section className="m-4 p-5 bg-surface rounded-[28px] flex flex-col gap-3.5">
        <div className="flex items-baseline gap-2.5">
          <span
            className={`font-mono-num text-[52px] font-bold leading-none ${m.shiftMinutes > m.shiftLimitMinutes ? 'text-err-fg' : ''}`}
          >
            {fmt.hm(m.shiftMinutes)}
          </span>
          <span className="text-[15px] text-muted">{t.workday.of(fmt.hm(m.shiftLimitMinutes))}</span>
        </div>
        <LimitBar
          value={m.shiftMinutes}
          max={m.shiftExtendedLimitMinutes}
          ticks={team ? [m.shiftExtendedLimitMinutes] : [m.shiftRegularLimitMinutes, m.shiftExtendedLimitMinutes]}
          tone={m.shiftMinutes > m.shiftLimitMinutes ? 'bad' : m.shiftMinutes > m.shiftRegularLimitMinutes ? 'warn' : 'fg'}
        />
        {!shift && <span className="text-[14px] text-muted">{t.workday.noShift}</span>}
      </section>

      {shift && (
        <div className="mx-4 bg-surface rounded-[24px] overflow-hidden divide-y divide-surface2">
          <Item dot="solid" title={t.workday.shiftStart} subtitle={country} value={fmt.time(shift.start)} />
          {team ? (
            <Item
              dot="ring"
              title={t.workday.team}
              subtitle={t.workday.teamHint}
              value={fmt.time(shift.start + m.shiftExtendedLimitMinutes * MINUTE)}
            />
          ) : (
            <>
              <Item
                dot="ring"
                title={t.workday.regular}
                subtitle={t.workday.regularHint(fmt.hm(Math.max(0, m.shiftRegularLimitMinutes - m.shiftMinutes)))}
                value={fmt.time(shift.start + m.shiftRegularLimitMinutes * MINUTE)}
              />
              <Item
                dot="muted"
                title={t.workday.extended}
                subtitle={t.workday.extendedHint(m.reducedRestsLeft)}
                value={fmt.time(shift.start + m.shiftExtendedLimitMinutes * MINUTE)}
                muted={m.reducedRestsLeft === 0 && !shift.splitFirstPart}
              />
            </>
          )}
        </div>
      )}

      <div className="m-4 p-4 rounded-[16px] bg-surface flex gap-3 text-[14px] leading-relaxed text-chip-fg">
        <Info className="w-5 h-5 text-muted shrink-0 mt-0.5" />
        <span>{t.workday.rule}</span>
      </div>

      <div className="p-4 pt-0 mt-auto grid grid-cols-2 gap-2">
        <SecondaryButton
          disabled={!shift}
          onClick={() => {
            onClose();
            onChangeStart();
          }}
          className="flex items-center justify-center gap-2"
        >
          <Clock className="w-4 h-4" />
          {t.workday.changeStart}
        </SecondaryButton>
        <PrimaryButton
          tone="rest"
          disabled={!shift || resting}
          onClick={() => {
            onEndDay();
            onClose();
          }}
        >
          {t.workday.endDay}
        </PrimaryButton>
      </div>
    </Sheet>
  );
};

const Item: React.FC<{
  dot: 'solid' | 'ring' | 'muted';
  title: string;
  subtitle: string;
  value: string;
  muted?: boolean;
}> = ({ dot, title, subtitle, value, muted }) => (
  <div className={`min-h-16 p-4 flex items-center gap-3.5 ${muted ? 'opacity-50' : ''}`}>
    <span
      className={`w-2.5 h-2.5 rounded-full shrink-0 ${
        dot === 'solid' ? 'bg-fg' : dot === 'ring' ? 'border-2 border-fg' : 'border-2 border-muted'
      }`}
    />
    <span className="flex-1 flex flex-col gap-0.5">
      <span className="text-[15px] font-semibold">{title}</span>
      <span className="text-[13px] text-muted">{subtitle}</span>
    </span>
    <span className="font-mono-num text-[17px] font-bold">{value}</span>
  </div>
);
