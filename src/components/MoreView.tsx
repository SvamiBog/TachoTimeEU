import React, { useState } from 'react';
import { BookOpen, ChevronRight, Download, Info, MessageSquare, Share2, Shield, Sparkles, User } from 'lucide-react';
import type { DriverSettings } from '../domain/types';
import { useI18n } from '../i18n';
import { Chip, SecondaryButton, Sheet, SheetHandle } from './ui';

declare const __APP_VERSION__: string;

interface Props {
  settings: DriverSettings;
  onOpenPaywall: () => void;
  onOpenExport: () => void;
  onOpenGuide: () => void;
}

export const MoreView: React.FC<Props> = ({ settings, onOpenPaywall, onOpenExport, onOpenGuide }) => {
  const { t } = useI18n();
  const [privacyOpen, setPrivacyOpen] = useState(false);
  const [toast, setToast] = useState<string | null>(null);

  const share = async () => {
    const data = { title: 'TachoGo', text: t.more.shareText, url: window.location.href };
    if (navigator.share) {
      try {
        await navigator.share(data);
      } catch {
        // пользователь закрыл диалог
      }
      return;
    }
    try {
      await navigator.clipboard.writeText(window.location.href);
      setToast(t.more.copied);
      setTimeout(() => setToast(null), 2500);
    } catch {
      // буфер обмена недоступен
    }
  };

  const row = 'w-full min-h-14 p-4 flex items-center gap-3.5 text-left hover:bg-surface2/40';

  return (
    <div className="flex flex-col gap-3 pb-8">
      <header className="h-16 px-5 flex items-center">
        <h1 className="text-[18px] font-bold tracking-tight">{t.more.title}</h1>
      </header>

      <button
        type="button"
        onClick={onOpenPaywall}
        className="mx-4 p-5 rounded-[24px] bg-surface border-[1.5px] border-drive flex items-center gap-4 text-left active:scale-[0.99] transition-transform"
      >
        <span className="w-12 h-12 rounded-[16px] bg-drive text-on-accent flex items-center justify-center shrink-0">
          <Sparkles className="w-6 h-6" />
        </span>
        <span className="flex-1 flex flex-col gap-1">
          <span className="text-[17px] font-bold">TachoGo Premium</span>
          <span className="text-[13px] leading-relaxed text-muted">
            {settings.isPremium ? t.more.premiumActive : t.more.premiumText}
          </span>
        </span>
        <ChevronRight className="w-5 h-5 text-drive shrink-0" />
      </button>

      <div className="mx-4 bg-surface rounded-[24px] overflow-hidden">
        <div className="min-h-16 p-4 flex items-center gap-3.5">
          <span className="w-10 h-10 rounded-[12px] bg-surface2 flex items-center justify-center shrink-0">
            <User className="w-5 h-5" />
          </span>
          <span className="flex-1 flex flex-col">
            <span className="text-[15px] font-semibold">{t.more.account}</span>
            <span className="text-[13px] text-muted">{t.more.accountHint}</span>
          </span>
          <Chip>{t.common.soon}</Chip>
        </div>
      </div>

      <div className="mx-4 bg-surface rounded-[24px] overflow-hidden divide-y divide-surface2">
        <button type="button" onClick={onOpenExport} className={row}>
          <Download className="w-5 h-5 shrink-0" />
          <span className="flex-1 text-[15px] font-semibold">{t.settings.export}</span>
          <ChevronRight className="w-4 h-4 text-muted" />
        </button>
        <button type="button" onClick={onOpenGuide} className={row}>
          <BookOpen className="w-5 h-5 shrink-0" />
          <span className="flex-1 text-[15px] font-semibold">{t.more.guide}</span>
          <ChevronRight className="w-4 h-4 text-muted" />
        </button>
        <a href="mailto:support@tachotime.eu?subject=TachoGo" className={row}>
          <MessageSquare className="w-5 h-5 shrink-0" />
          <span className="flex-1 text-[15px] font-semibold">{t.more.feedback}</span>
        </a>
        <button type="button" onClick={share} className={row}>
          <Share2 className="w-5 h-5 shrink-0" />
          <span className="flex-1 text-[15px] font-semibold">{t.more.share}</span>
          {toast && <span className="text-[13px] text-rest-fg">{toast}</span>}
        </button>
      </div>

      <div className="mx-4 bg-surface rounded-[24px] overflow-hidden divide-y divide-surface2">
        <button type="button" onClick={() => setPrivacyOpen(true)} className={row}>
          <Shield className="w-5 h-5 shrink-0" />
          <span className="flex-1 text-[15px] font-semibold">{t.more.privacy}</span>
          <ChevronRight className="w-4 h-4 text-muted" />
        </button>
        <div className="min-h-14 p-4 flex items-center gap-3.5">
          <Info className="w-5 h-5 shrink-0" />
          <span className="flex-1 text-[15px] font-semibold">{t.more.about}</span>
          <span className="font-mono-num text-[13px] text-muted">v{__APP_VERSION__}</span>
        </div>
      </div>

      <p className="mx-6 text-[12px] leading-relaxed text-muted">{t.more.disclaimer}</p>

      {privacyOpen && (
        <Sheet onClose={() => setPrivacyOpen(false)} label={t.more.privacy}>
          <SheetHandle />
          <div className="p-5 pb-7 flex flex-col gap-4">
            <h2 className="text-[20px] font-bold">{t.more.privacy}</h2>
            <p className="text-[15px] leading-relaxed text-muted">{t.more.privacyText}</p>
            <SecondaryButton onClick={() => setPrivacyOpen(false)}>{t.common.close}</SecondaryButton>
          </div>
        </Sheet>
      )}
    </div>
  );
};
