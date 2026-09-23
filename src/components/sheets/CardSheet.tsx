import React from 'react';
import { CreditCard } from 'lucide-react';
import { useI18n } from '../../i18n';
import { PrimaryButton, SecondaryButton, Sheet, SheetHandle } from '../ui';

export const CardSheet: React.FC<{
  lastRead: number | null;
  onMarkToday: () => void;
  onClose: () => void;
}> = ({ lastRead, onMarkToday, onClose }) => {
  const { t, fmt } = useI18n();
  return (
    <Sheet onClose={onClose} label={t.card.title}>
      <SheetHandle />
      <div className="p-5 pb-7 flex flex-col gap-4">
        <div className="flex items-center gap-2.5">
          <CreditCard className="w-6 h-6 text-drive" />
          <h2 className="text-[20px] font-bold">{t.card.title}</h2>
        </div>
        <span className="text-[15px]">{lastRead === null ? t.card.never : t.card.last(fmt.date(lastRead))}</span>
        <p className="text-[14px] leading-relaxed text-muted">{t.card.rule}</p>
        <div className="grid grid-cols-2 gap-2">
          <SecondaryButton onClick={onClose}>{t.common.close}</SecondaryButton>
          <PrimaryButton
            onClick={() => {
              onMarkToday();
              onClose();
            }}
          >
            {t.card.markToday}
          </PrimaryButton>
        </div>
      </div>
    </Sheet>
  );
};
