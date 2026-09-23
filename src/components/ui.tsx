import React from 'react';
import { ArrowLeft, X } from 'lucide-react';
import type { ActivityType } from '../domain/types';

/** Класс цвета режима: вождение — янтарный, отдых — зелёный, работа — оранжевый, готовность — голубой. */
export const MODE_BG: Record<ActivityType, string> = {
  DRIVE: 'bg-drive',
  REST: 'bg-rest',
  WORK: 'bg-work',
  POA: 'bg-poa',
};
export const MODE_TEXT: Record<ActivityType, string> = {
  DRIVE: 'text-drive',
  REST: 'text-rest',
  WORK: 'text-work',
  POA: 'text-poa',
};
export const MODE_BORDER: Record<ActivityType, string> = {
  DRIVE: 'border-drive',
  REST: 'border-rest',
  WORK: 'border-work',
  POA: 'border-poa',
};

/** Пиктограммы тахографа. */
export const ModeIcon: React.FC<{ mode: ActivityType; size?: number }> = ({ mode, size = 28 }) => {
  const common = {
    width: size,
    height: size,
    viewBox: '0 0 24 24',
    fill: 'none',
    stroke: 'currentColor',
    strokeWidth: 2.2,
    strokeLinecap: 'round' as const,
    strokeLinejoin: 'round' as const,
    className: 'shrink-0',
    'aria-hidden': true,
  };
  switch (mode) {
    case 'DRIVE':
      return (
        <svg {...common}>
          <circle cx="12" cy="12" r="9" />
          <circle cx="12" cy="12" r="2.2" />
          <path d="M3 12h6.8M14.2 12H21" />
        </svg>
      );
    case 'REST':
      return (
        <svg {...common}>
          <path d="M4 5v14M4 13h16v6" />
        </svg>
      );
    case 'WORK':
      return (
        <svg {...common}>
          <path d="M6 18L16.5 7.5M18 18L7.5 7.5" />
          <path d="M14 5l5 5M5 10l5-5" />
        </svg>
      );
    case 'POA':
      return (
        <svg {...common} strokeWidth={2}>
          <rect x="4" y="4" width="16" height="16" rx="2" />
          <path d="M4 20L20 4" />
        </svg>
      );
  }
};

export const SectionTitle: React.FC<{ children: React.ReactNode; className?: string }> = ({ children, className = '' }) => (
  <h2 className={`mx-6 mt-4 mb-1 text-[13px] font-semibold tracking-[0.08em] uppercase text-muted ${className}`}>
    {children}
  </h2>
);

export const Card: React.FC<{ children: React.ReactNode; className?: string }> = ({ children, className = '' }) => (
  <div className={`mx-4 bg-surface rounded-[24px] overflow-hidden divide-y divide-surface2 ${className}`}>{children}</div>
);

export type Tone = 'neutral' | 'warn' | 'bad' | 'rest' | 'accent';

const CHIP_TONE: Record<Tone, string> = {
  neutral: 'bg-surface2 text-chip-fg',
  warn: 'bg-warn-bg text-warn-fg',
  bad: 'bg-err-bg text-err-fg',
  rest: 'bg-rest-bg text-rest-fg',
  accent: 'bg-drive text-on-accent',
};

export const Chip: React.FC<{ tone?: Tone; children: React.ReactNode }> = ({ tone = 'neutral', children }) => (
  <span className={`text-[12px] font-semibold px-2 py-0.5 rounded-[8px] whitespace-nowrap ${CHIP_TONE[tone]}`}>{children}</span>
);

export const Switch: React.FC<{ checked: boolean; onChange: (v: boolean) => void; label: string }> = ({
  checked,
  onChange,
  label,
}) => (
  <button
    type="button"
    role="switch"
    aria-checked={checked}
    aria-label={label}
    onClick={() => onChange(!checked)}
    className={`w-[52px] h-[32px] p-1 rounded-full transition-colors flex shrink-0 ${
      checked ? 'bg-drive justify-end' : 'bg-switch-off justify-start'
    }`}
  >
    <span className={`w-6 h-6 rounded-full ${checked ? 'bg-on-accent' : 'bg-muted'}`} />
  </button>
);

export function Segmented<T extends string | number>({
  options,
  value,
  onChange,
  columns,
}: {
  options: { value: T; label: string }[];
  value: T;
  onChange: (v: T) => void;
  columns?: number;
}) {
  return (
    <div
      className="grid gap-1 p-1 rounded-[16px] bg-bg"
      style={{ gridTemplateColumns: `repeat(${columns ?? options.length}, minmax(0, 1fr))` }}
      role="radiogroup"
    >
      {options.map((o) => (
        <button
          key={String(o.value)}
          type="button"
          role="radio"
          aria-checked={o.value === value}
          onClick={() => onChange(o.value)}
          className={`min-h-11 px-2 rounded-[12px] text-[14px] font-semibold transition-colors ${
            o.value === value ? 'bg-selected text-fg shadow-sm' : 'text-muted hover:text-fg'
          }`}
        >
          {o.label}
        </button>
      ))}
    </div>
  );
}

export function Pills<T extends string | number>({
  options,
  value,
  onChange,
}: {
  options: { value: T; label: string }[];
  value: T;
  onChange: (v: T) => void;
}) {
  return (
    <div className="flex flex-wrap gap-2" role="radiogroup">
      {options.map((o) => (
        <button
          key={String(o.value)}
          type="button"
          role="radio"
          aria-checked={o.value === value}
          onClick={() => onChange(o.value)}
          className={`min-h-11 px-4 rounded-full text-[14px] font-semibold border transition-colors ${
            o.value === value ? 'bg-drive text-on-accent border-drive' : 'text-fg border-switch-off hover:bg-surface2'
          }`}
        >
          {o.label}
        </button>
      ))}
    </div>
  );
}

/** Полоса лимита 6 dp с рисками на порогах. */
export const LimitBar: React.FC<{
  value: number;
  max: number;
  ticks?: number[];
  tone?: 'drive' | 'rest' | 'fg' | 'bad' | 'warn';
}> = ({ value, max, ticks = [], tone = 'drive' }) => {
  const pct = (v: number) => `${Math.min(100, Math.max(0, (v / max) * 100))}%`;
  const fill = { drive: 'bg-drive', rest: 'bg-rest', fg: 'bg-fg', bad: 'bg-err-fg', warn: 'bg-warn-fg' }[tone];
  return (
    <div className="relative h-1.5 rounded-full bg-line">
      <div className={`h-full rounded-full ${fill}`} style={{ width: pct(value) }} />
      {ticks.map((t) => (
        <div
          key={t}
          className="absolute -top-1 w-[2px] h-[14px] rounded-[1px] bg-muted -translate-x-1/2"
          style={{ left: pct(t) }}
        />
      ))}
    </div>
  );
};

/** Нижняя шторка. */
export const Sheet: React.FC<{
  onClose: () => void;
  children: React.ReactNode;
  label: string;
  full?: boolean;
}> = ({ onClose, children, label, full }) => (
  <div
    className="absolute inset-0 z-50 flex items-end justify-center bg-scrim/80"
    onClick={(e) => e.target === e.currentTarget && onClose()}
    role="dialog"
    aria-modal="true"
    aria-label={label}
  >
    <div
      className={`w-full bg-bg text-fg rounded-t-[28px] border-t border-line shadow-2xl flex flex-col overflow-y-auto ${
        full ? 'h-full rounded-t-none border-t-0' : 'max-h-[92%]'
      }`}
    >
      {children}
    </div>
  </div>
);

export const SheetHandle: React.FC = () => <div className="self-center w-10 h-1 mt-3 rounded-full bg-switch-off" />;

export const SheetHeader: React.FC<{
  title: string;
  subtitle?: string;
  onBack: () => void;
  backLabel: string;
  action?: React.ReactNode;
  closeLabel?: string;
}> = ({ title, subtitle, onBack, backLabel, action, closeLabel }) => (
  <header className="sticky top-0 z-20 h-16 px-2 bg-bg flex items-center gap-1 border-b border-surface2">
    <button
      type="button"
      onClick={onBack}
      aria-label={backLabel}
      className="w-12 h-12 rounded-full flex items-center justify-center hover:bg-surface2"
    >
      <ArrowLeft className="w-6 h-6" />
    </button>
    <div className="flex-1 flex flex-col items-center min-w-0">
      <h1 className="text-[18px] font-bold truncate">{title}</h1>
      {subtitle && <span className="text-[12px] text-muted truncate">{subtitle}</span>}
    </div>
    {action ?? (
      <button
        type="button"
        onClick={onBack}
        aria-label={closeLabel ?? backLabel}
        className="w-12 h-12 rounded-full flex items-center justify-center text-muted hover:text-fg"
      >
        <X className="w-5 h-5" />
      </button>
    )}
  </header>
);

export const PrimaryButton: React.FC<React.ButtonHTMLAttributes<HTMLButtonElement> & { tone?: 'drive' | 'rest' }> = ({
  tone = 'drive',
  className = '',
  ...props
}) => (
  <button
    type="button"
    {...props}
    className={`h-14 rounded-[18px] font-bold text-[15px] text-on-accent transition-opacity hover:opacity-90 disabled:opacity-40 ${
      tone === 'rest' ? 'bg-rest' : 'bg-drive'
    } ${className}`}
  />
);

export const SecondaryButton: React.FC<React.ButtonHTMLAttributes<HTMLButtonElement>> = ({ className = '', ...props }) => (
  <button
    type="button"
    {...props}
    className={`h-14 rounded-[18px] border border-switch-off text-fg font-semibold text-[15px] hover:bg-surface2 transition-colors disabled:opacity-40 ${className}`}
  />
);

/** Подтверждение внутри приложения (вместо window.confirm). */
export const ConfirmSheet: React.FC<{
  title: string;
  text: string;
  confirmLabel: string;
  cancelLabel: string;
  danger?: boolean;
  onConfirm: () => void;
  onClose: () => void;
}> = ({ title, text, confirmLabel, cancelLabel, danger, onConfirm, onClose }) => (
  <Sheet onClose={onClose} label={title}>
    <SheetHandle />
    <div className="p-5 pb-7 flex flex-col gap-4">
      <h2 className="text-[20px] font-bold">{title}</h2>
      <p className="text-[15px] leading-relaxed text-muted">{text}</p>
      <div className="grid grid-cols-2 gap-2">
        <SecondaryButton onClick={onClose}>{cancelLabel}</SecondaryButton>
        <button
          type="button"
          onClick={() => {
            onConfirm();
            onClose();
          }}
          className={`h-14 rounded-[18px] font-bold text-[15px] ${
            danger ? 'border border-danger-line text-err-fg hover:bg-err-bg' : 'bg-drive text-on-accent'
          }`}
        >
          {confirmLabel}
        </button>
      </div>
    </div>
  </Sheet>
);
