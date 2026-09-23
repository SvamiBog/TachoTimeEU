import React, { useState } from 'react';
import {
  Sparkles,
  ChevronRight,
  User,
  Download,
  BookOpen,
  MessageSquare,
  Share2,
  Shield,
  Info,
} from 'lucide-react';
import { DriverSettings } from '../types/tacho';

interface MoreViewProps {
  settings: DriverSettings;
  onOpenPaywall: () => void;
  onOpenExportModal: () => void;
  onOpenGuide: () => void;
}

export const MoreView: React.FC<MoreViewProps> = ({
  settings,
  onOpenPaywall,
  onOpenExportModal,
  onOpenGuide,
}) => {
  const [accountEmail, setAccountEmail] = useState<string | null>(null);

  const handleShare = async () => {
    if (navigator.share) {
      try {
        await navigator.share({
          title: 'TachoTime EU',
          text: 'TachoTime — умный таймер тахографа по правилам ЕС 561/2006 и ЕСТР',
          url: window.location.href,
        });
      } catch (err) {
        // Ignored
      }
    } else {
      navigator.clipboard.writeText(window.location.href);
      alert('Ссылка скопирована в буфер обмена!');
    }
  };

  return (
    <div className="flex flex-col gap-3 pb-28 text-[#EDEBE6]">
      
      {/* Header */}
      <header className="h-16 px-5 flex items-center">
        <h1 className="text-[20px] font-bold tracking-tight">Ещё</h1>
      </header>

      {/* Premium Banner Card */}
      <button
        onClick={onOpenPaywall}
        className="mx-4 p-5 rounded-[24px] bg-[#1A1D20] border-[1.5px] border-[#F3B33D] flex items-center gap-4 text-left shadow-lg transition-transform active:scale-[0.99]"
      >
        <span className="w-12 h-12 rounded-[16px] bg-[#F3B33D] text-[#111315] flex items-center justify-center shrink-0">
          <Sparkles className="w-6 h-6 fill-current" />
        </span>
        <div className="flex-1 flex flex-col gap-1">
          <span className="text-[17px] font-bold">TachoTime Premium</span>
          <span className="text-[13px] leading-relaxed text-[#A3A8AE]">
            Экспорт для инспекции, синхронизация и уведомления о лимитах
          </span>
        </div>
        <ChevronRight className="w-5 h-5 text-[#F3B33D] shrink-0" />
      </button>

      {/* Account Row */}
      <div className="mx-4 mt-1 bg-[#1A1D20] rounded-[24px] overflow-hidden border border-[#262A2F]/40 shadow-sm">
        <button
          onClick={() => {
            const email = prompt('Введите ваш Email для синхронизации журнала:');
            if (email) setAccountEmail(email);
          }}
          className="w-full min-h-16 p-4 flex items-center gap-3.5 text-left hover:bg-[#262A2F]/40 transition-colors"
        >
          <div className="w-10 h-10 rounded-[12px] bg-[#262A2F] flex items-center justify-center shrink-0">
            <User className="w-5 h-5 text-[#EDEBE6]" />
          </div>
          <div className="flex-1 flex flex-col">
            <span className="text-[15px] font-semibold">
              {accountEmail ? accountEmail : 'Аккаунт'}
            </span>
            <span className="text-[13px] text-[#A3A8AE]">
              {accountEmail ? 'Синхронизация активна' : 'Необязательно · для синхронизации'}
            </span>
          </div>
          <span className="text-[14px] font-semibold text-[#F3B33D]">
            {accountEmail ? 'Изменить' : 'Войти'}
          </span>
        </button>
      </div>

      {/* Primary Actions Group */}
      <div className="mx-4 mt-1 bg-[#1A1D20] rounded-[24px] overflow-hidden divide-y divide-[#262A2F] border border-[#262A2F]/40 shadow-sm">
        
        {/* Export */}
        <button
          onClick={onOpenExportModal}
          className="w-full min-h-14 p-4 flex items-center gap-3.5 text-left hover:bg-[#262A2F]/40 transition-colors"
        >
          <Download className="w-5 h-5 text-[#EDEBE6] shrink-0" />
          <span className="flex-1 text-[15px] font-semibold">Экспорт отчёта</span>
          <ChevronRight className="w-4 h-4 text-[#A3A8AE]" />
        </button>

        {/* Guide */}
        <button
          onClick={onOpenGuide}
          className="w-full min-h-14 p-4 flex items-center gap-3.5 text-left hover:bg-[#262A2F]/40 transition-colors"
        >
          <BookOpen className="w-5 h-5 text-[#EDEBE6] shrink-0" />
          <span className="flex-1 text-[15px] font-semibold">Инструкция и правила</span>
          <ChevronRight className="w-4 h-4 text-[#A3A8AE]" />
        </button>

        {/* Feedback */}
        <button
          onClick={() => {
            window.location.href = 'mailto:support@tachotime.eu?subject=TachoTime Feedback';
          }}
          className="w-full min-h-14 p-4 flex items-center gap-3.5 text-left hover:bg-[#262A2F]/40 transition-colors"
        >
          <MessageSquare className="w-5 h-5 text-[#EDEBE6] shrink-0" />
          <span className="flex-1 text-[15px] font-semibold">Обратная связь</span>
        </button>

        {/* Share */}
        <button
          onClick={handleShare}
          className="w-full min-h-14 p-4 flex items-center gap-3.5 text-left hover:bg-[#262A2F]/40 transition-colors"
        >
          <Share2 className="w-5 h-5 text-[#EDEBE6] shrink-0" />
          <span className="flex-1 text-[15px] font-semibold">Поделиться приложением</span>
        </button>

      </div>

      {/* Legal & About Group */}
      <div className="mx-4 mt-1 bg-[#1A1D20] rounded-[24px] overflow-hidden divide-y divide-[#262A2F] border border-[#262A2F]/40 shadow-sm">
        
        <button
          onClick={() =>
            alert(
              'Политика конфиденциальности: TachoTime сохраняет все данные смен локально на вашем устройстве. Данные не передаются третьим лицам без вашего согласия.'
            )
          }
          className="w-full min-h-14 p-4 flex items-center gap-3.5 text-left hover:bg-[#262A2F]/40 transition-colors"
        >
          <Shield className="w-5 h-5 text-[#EDEBE6] shrink-0" />
          <span className="flex-1 text-[15px] font-semibold">
            Политика конфиденциальности
          </span>
        </button>

        <div className="min-h-14 p-4 flex items-center gap-3.5">
          <Info className="w-5 h-5 text-[#EDEBE6] shrink-0" />
          <span className="flex-1 text-[15px] font-semibold">О приложении</span>
          <span className="font-mono-num text-[13px] text-[#A3A8AE]">v1.2.0</span>
        </div>

      </div>

      {/* Legal Disclaimer */}
      <p className="mx-6 text-[12px] leading-relaxed text-[#A3A8AE]">
        TachoTime помогает планировать время за рулём и отдых, но не заменяет тахограф и не является юридической консультацией.
      </p>

    </div>
  );
};
