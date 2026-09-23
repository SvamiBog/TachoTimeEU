import React, { useState } from 'react';
import { Info } from 'lucide-react';
import { useI18n } from '../../i18n';
import { DurationField } from '../pickers';
import { PrimaryButton, SecondaryButton, Sheet, SheetHandle } from '../ui';

/**
 * Ручная корректировка суточного вождения. Значение ограничено тем,
 * что можно взять у соседнего отрезка, поэтому записи не наезжают друг на друга.
 */
export const DriveEditSheet: React.FC<{
  computedMinutes: number;
  bounds: { min: number; max: number } | null;
  onSave: (deltaMinutes: number) => void;
  onClose: () => void;
}> = ({ computedMinutes, bounds, onSave, onClose }) => {
  const { t, fmt } = useI18n();
  const base = Math.floor(computedMinutes);
  const [value, setValue] = useState(base);
  const diff = value - base;

  return (
    <Sheet onClose={onClose} label={t.driveEdit.title}>
      <SheetHandle />
      <div className="p-5 pb-7 flex flex-col gap-4">
        <div className="flex flex-col gap-1">
          <h2 className="text-[20px] font-bold">{t.driveEdit.title}</h2>
          <span className="text-[14px] text-muted">{t.driveEdit.subtitle}</span>
        </div>
        <div className="flex justify-between items-center p-3 rounded-[14px] bg-surface text-[14px] text-muted">
          <span>{t.driveEdit.computed}</span>
          <span className="font-mono-num text-[15px] font-bold text-fg">{fmt.hm(base)}</span>
        </div>

        {bounds ? (
          <>
            <DurationField
              value={value}
              onChange={setValue}
              min={base + bounds.min}
              max={base + bounds.max}
              minuteStep={1}
            />
            <span className="text-[13px] text-muted">{t.picker.range(fmt.hm(base + bounds.min), fmt.hm(base + bounds.max))}</span>
            <div className="flex gap-2.5 p-3 rounded-[14px] bg-warn-bg text-warn-fg text-[13px] leading-relaxed">
              <Info className="w-4 h-4 shrink-0 mt-0.5" />
              <span>
                {diff !== 0 ? t.driveEdit.diff(`${diff > 0 ? '+' : ''}${fmt.hm(diff)}`) : t.driveEdit.noChange} {t.driveEdit.hint}
              </span>
            </div>
          </>
        ) : (
          <span className="text-[14px] text-muted">{t.driveEdit.noDrive}</span>
        )}

        <div className="grid grid-cols-2 gap-2">
          <SecondaryButton onClick={onClose}>{t.common.cancel}</SecondaryButton>
          <PrimaryButton
            disabled={!bounds || diff === 0}
            onClick={() => {
              onSave(diff);
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
