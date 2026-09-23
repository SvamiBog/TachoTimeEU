import React, { useState } from 'react';
import { Check, Sparkles, X } from 'lucide-react';
import { useI18n } from '../../i18n';
import { PrimaryButton, Sheet } from '../ui';

export const PaywallSheet: React.FC<{ isPremium: boolean; onUpgrade: () => void; onClose: () => void }> = ({
  isPremium,
  onUpgrade,
  onClose,
}) => {
  const { t } = useI18n();
  const [plan, setPlan] = useState<'year' | 'month'>('year');
  const [message, setMessage] = useState<string | null>(null);

  const planButton = (value: 'year' | 'month', title: string, hint: string, price: string, badge?: string) => (
    <button
      type="button"
      role="radio"
      aria-checked={plan === value}
      onClick={() => setPlan(value)}
      className={`relative min-h-[72px] px-4 rounded-[20px] bg-surface flex items-center gap-3.5 text-left border-2 ${
        plan === value ? 'border-drive' : 'border-line'
      }`}
    >
      <span className={`w-5 h-5 rounded-full border-2 flex items-center justify-center shrink-0 ${plan === value ? 'border-drive' : 'border-muted'}`}>
        {plan === value && <span className="w-2.5 h-2.5 rounded-full bg-drive" />}
      </span>
      <span className="flex-1 flex flex-col gap-0.5">
        <span className="text-[16px] font-bold">{title}</span>
        <span className="text-[13px] text-muted">{hint}</span>
      </span>
      <span className="font-mono-num text-[20px] font-bold">{price}</span>
      {badge && (
        <span className="absolute -top-2.5 right-4 px-2 py-0.5 rounded-[8px] bg-drive text-on-accent text-[12px] font-bold">{badge}</span>
      )}
    </button>
  );

  return (
    <Sheet onClose={onClose} label={t.common.premium} full>
      <div className="h-14 px-4 flex items-center justify-end">
        <button
          type="button"
          onClick={onClose}
          aria-label={t.common.close}
          className="w-11 h-11 rounded-full flex items-center justify-center hover:bg-surface2"
        >
          <X className="w-5 h-5" />
        </button>
      </div>
      <div className="px-6 flex flex-col gap-3">
        <span className="w-16 h-16 rounded-[20px] bg-drive text-on-accent flex items-center justify-center">
          <Sparkles className="w-8 h-8" />
        </span>
        <h1 className="text-[28px] font-bold tracking-tight leading-tight">TachoTime Premium</h1>
        <p className="text-[15px] leading-relaxed text-muted">{t.paywall.subtitle}</p>
      </div>

      <ul className="mx-4 mt-5 p-2 bg-surface rounded-[24px] divide-y divide-surface2">
        {t.paywall.features.map((f) => (
          <li key={f.title} className="p-3.5 flex gap-3.5 items-start">
            <Check className="w-5 h-5 text-drive shrink-0 mt-0.5" />
            <span className="flex flex-col gap-0.5">
              <span className="text-[15px] font-semibold">{f.title}</span>
              <span className="text-[13px] text-muted">{f.text}</span>
            </span>
          </li>
        ))}
      </ul>

      <div className="mx-4 mt-4 flex flex-col gap-2.5" role="radiogroup">
        {planButton('year', t.paywall.year, t.paywall.yearHint, '€30', '−50%')}
        {planButton('month', t.paywall.month, t.paywall.monthHint, '€5')}
      </div>

      <div className="p-4 mt-auto flex flex-col gap-3">
        <PrimaryButton
          disabled={isPremium}
          onClick={() => {
            onUpgrade();
            onClose();
          }}
        >
          {isPremium ? t.more.premiumActive : t.paywall.subscribe}
        </PrimaryButton>
        <button
          type="button"
          onClick={() => setMessage(isPremium ? t.more.premiumActive : t.paywall.restoreNone)}
          className="min-h-11 text-[14px] font-semibold hover:text-drive"
        >
          {t.paywall.restore}
        </button>
        {message && <p className="text-[13px] text-center text-muted" role="status">{message}</p>}
        <p className="text-[12px] leading-relaxed text-muted text-center">{t.paywall.autoRenew}</p>
        <p className="text-[12px] leading-relaxed text-warn-fg text-center">{t.paywall.demo}</p>
      </div>
    </Sheet>
  );
};
