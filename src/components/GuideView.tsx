import React from 'react';
import { ArrowLeft } from 'lucide-react';
import type { ActivityType } from '../domain/types';
import { useI18n } from '../i18n';
import { MODE_BG, ModeIcon, SectionTitle } from './ui';

// Цвет значения в списке правил: вождение, отдых или нейтральный
const RULE_TONE = ['text-drive', 'text-drive', 'text-drive', 'text-rest', 'text-fg', 'text-rest', 'text-fg', 'text-fg'];

export const GuideView: React.FC<{ onBack: () => void }> = ({ onBack }) => {
  const { t } = useI18n();
  const modes: { mode: ActivityType; label: string }[] = [
    { mode: 'DRIVE', label: t.common.drive },
    { mode: 'REST', label: t.common.rest },
    { mode: 'WORK', label: t.common.workFull },
    { mode: 'POA', label: t.common.poa },
  ];

  return (
    <div className="flex flex-col gap-3 pb-8">
      <header className="h-16 px-2 flex items-center gap-1 border-b border-surface2">
        <button
          type="button"
          onClick={onBack}
          aria-label={t.common.back}
          className="w-12 h-12 rounded-full flex items-center justify-center hover:bg-surface2"
        >
          <ArrowLeft className="w-5 h-5" />
        </button>
        <h1 className="text-[18px] font-bold">{t.guide.title}</h1>
      </header>

      <SectionTitle>{t.guide.howTo}</SectionTitle>
      <ol className="mx-4 p-2 bg-surface rounded-[24px] divide-y divide-surface2">
        {t.guide.steps.map((step, i) => (
          <li key={i} className="p-3.5 flex gap-3.5 items-start">
            <span className="w-7 h-7 rounded-full bg-drive text-on-accent flex items-center justify-center font-mono-num text-[14px] font-bold shrink-0">
              {i + 1}
            </span>
            <span className="text-[15px] leading-relaxed">{step}</span>
          </li>
        ))}
      </ol>

      <SectionTitle>{t.guide.rules}</SectionTitle>
      <div className="mx-4 bg-surface rounded-[24px] overflow-hidden divide-y divide-surface2">
        {t.guide.items.map((item, i) => (
          <div key={item.title} className="p-4 grid grid-cols-[76px_1fr] gap-3.5">
            <span className={`font-mono-num text-[20px] font-bold ${RULE_TONE[i]}`}>{item.value}</span>
            <span className="flex flex-col gap-1">
              <span className="text-[15px] font-semibold">{item.title}</span>
              <span className="text-[14px] leading-relaxed text-muted">{item.text}</span>
            </span>
          </div>
        ))}
      </div>

      <SectionTitle>{t.guide.colors}</SectionTitle>
      <div className="mx-4 p-4 bg-surface rounded-[24px] grid grid-cols-2 gap-3">
        {modes.map(({ mode, label }) => (
          <span key={mode} className="flex items-center gap-2.5 text-[14px]">
            <span className={`w-8 h-8 rounded-[10px] ${MODE_BG[mode]} text-on-accent flex items-center justify-center shrink-0`}>
              <ModeIcon mode={mode} size={20} />
            </span>
            {label}
          </span>
        ))}
      </div>

      <p className="mx-6 text-[12px] leading-relaxed text-muted">{t.guide.disclaimer}</p>
    </div>
  );
};
