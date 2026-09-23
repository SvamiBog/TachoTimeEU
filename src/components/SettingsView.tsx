import React, { useState } from 'react';
import { ChevronRight, Trash2, Sparkles, Check, Globe } from 'lucide-react';
import { AppTheme, DriverSettings, SupportedLanguage } from '../types/tacho';

interface SettingsViewProps {
  settings: DriverSettings;
  onUpdateSettings: (newSettings: Partial<DriverSettings>) => void;
  onOpenExportModal: () => void;
  onOpenPaywall: () => void;
  onClearData: () => void;
}

export const SettingsView: React.FC<SettingsViewProps> = ({
  settings,
  onUpdateSettings,
  onOpenExportModal,
  onOpenPaywall,
  onClearData,
}) => {
  const [showLanguageModal, setShowLanguageModal] = useState(false);

  const languages: { code: SupportedLanguage; label: string }[] = [
    { code: 'ru', label: 'Русский' },
    { code: 'ua', label: 'Українська' },
    { code: 'pl', label: 'Polski' },
    { code: 'en', label: 'English' },
    { code: 'de', label: 'Deutsch' },
  ];

  const currentLanguageLabel =
    languages.find((l) => l.code === settings.language)?.label || 'Русский';

  return (
    <div className="flex flex-col gap-3 pb-28 text-[#EDEBE6]">
      
      {/* Header */}
      <header className="h-16 px-5 flex items-center">
        <h1 className="text-[20px] font-bold tracking-tight">Настройки</h1>
      </header>

      {/* Section: ОБЩЕЕ */}
      <h2 className="mx-6 mt-1 text-[13px] font-bold tracking-wider uppercase text-[#A3A8AE]">
        Общее
      </h2>

      <div className="mx-4 bg-[#1A1D20] rounded-[24px] overflow-hidden divide-y divide-[#262A2F] border border-[#262A2F]/40 shadow-sm">
        
        {/* Language Button */}
        <button
          onClick={() => setShowLanguageModal(true)}
          className="w-full min-h-14 p-4 flex items-center justify-between text-left hover:bg-[#262A2F]/40 transition-colors"
        >
          <span className="text-[15px] font-semibold">Язык</span>
          <div className="flex items-center gap-2">
            <span className="text-[14px] text-[#A3A8AE]">{currentLanguageLabel}</span>
            <ChevronRight className="w-4 h-4 text-[#A3A8AE]" />
          </div>
        </button>

        {/* Theme Picker */}
        <div className="p-4 flex flex-col gap-2.5">
          <span className="text-[15px] font-semibold">Оформление</span>
          <div className="grid grid-cols-3 gap-1 p-1 rounded-[16px] bg-[#111315]">
            {(['system', 'light', 'dark'] as AppTheme[]).map((th) => {
              const labels = { system: 'Система', light: 'Светлая', dark: 'Тёмная' };
              const isSelected = settings.theme === th;
              return (
                <button
                  key={th}
                  onClick={() => onUpdateSettings({ theme: th })}
                  className={`h-10 rounded-[12px] text-[14px] font-semibold transition-all ${
                    isSelected
                      ? 'bg-[#2F343A] text-[#EDEBE6]'
                      : 'text-[#A3A8AE] hover:text-[#EDEBE6]'
                  }`}
                >
                  {labels[th]}
                </button>
              );
            })}
          </div>
        </div>

      </div>

      {/* Section: ПРАВИЛА */}
      <h2 className="mx-6 mt-4 text-[13px] font-bold tracking-wider uppercase text-[#A3A8AE]">
        Правила
      </h2>

      <div className="mx-4 bg-[#1A1D20] rounded-[24px] overflow-hidden border border-[#262A2F]/40 shadow-sm">
        <div className="p-4 flex items-center justify-between gap-4">
          <div className="flex flex-col gap-1">
            <span className="text-[15px] font-semibold">Пакет мобильности</span>
            <span className="text-[13px] leading-relaxed text-[#A3A8AE]">
              Два сокращённых недельных отдыха подряд при международных перевозках
            </span>
          </div>
          <button
            type="button"
            role="switch"
            onClick={() =>
              onUpdateSettings({ mobilityPackageEnabled: !settings.mobilityPackageEnabled })
            }
            className={`w-[52px] h-[32px] p-1 rounded-full transition-colors flex shrink-0 ${
              settings.mobilityPackageEnabled
                ? 'bg-[#F3B33D] justify-end'
                : 'bg-[#3A3F45] justify-start'
            }`}
          >
            <span
              className={`w-6 h-6 rounded-full ${
                settings.mobilityPackageEnabled ? 'bg-[#111315]' : 'bg-[#A3A8AE]'
              }`}
            />
          </button>
        </div>
      </div>

      {/* Section: УВЕДОМЛЕНИЯ */}
      <h2 className="mx-6 mt-4 text-[13px] font-bold tracking-wider uppercase text-[#A3A8AE]">
        Уведомления
      </h2>

      <div className="mx-4 bg-[#1A1D20] rounded-[24px] overflow-hidden divide-y divide-[#262A2F] border border-[#262A2F]/40 shadow-sm">
        
        {/* Warning lead time */}
        <div className="p-4 flex flex-col gap-2.5">
          <div className="flex flex-col">
            <span className="text-[15px] font-semibold">Предупреждать о лимитах</span>
            <span className="text-[13px] text-[#A3A8AE]">Перерыв, конец дня, вождение</span>
          </div>
          <div className="flex gap-2">
            {[15, 30, 60].map((min) => {
              const isSelected = settings.notifyLeadMinutes === min;
              const label = min === 60 ? '1 час' : `${min} мин`;
              return (
                <button
                  key={min}
                  onClick={() => onUpdateSettings({ notifyLeadMinutes: min as any })}
                  className={`h-10 px-4 rounded-full text-[14px] font-semibold border transition-all ${
                    isSelected
                      ? 'bg-[#F3B33D] text-[#111315] border-[#F3B33D]'
                      : 'bg-transparent text-[#EDEBE6] border-[#3A3F45] hover:bg-[#262A2F]'
                  }`}
                >
                  {label}
                </button>
              );
            })}
          </div>
        </div>

        {/* Switch: Break */}
        <div className="min-h-14 px-4 py-3 flex items-center justify-between">
          <span className="text-[15px] font-medium">Перерыв</span>
          <button
            type="button"
            role="switch"
            onClick={() => onUpdateSettings({ notifyBreak: !settings.notifyBreak })}
            className={`w-[52px] h-[32px] p-1 rounded-full transition-colors flex shrink-0 ${
              settings.notifyBreak ? 'bg-[#F3B33D] justify-end' : 'bg-[#3A3F45] justify-start'
            }`}
          >
            <span
              className={`w-6 h-6 rounded-full ${
                settings.notifyBreak ? 'bg-[#111315]' : 'bg-[#A3A8AE]'
              }`}
            />
          </button>
        </div>

        {/* Switch: End of shift */}
        <div className="min-h-14 px-4 py-3 flex items-center justify-between">
          <span className="text-[15px] font-medium">Конец рабочего дня</span>
          <button
            type="button"
            role="switch"
            onClick={() => onUpdateSettings({ notifyShiftEnd: !settings.notifyShiftEnd })}
            className={`w-[52px] h-[32px] p-1 rounded-full transition-colors flex shrink-0 ${
              settings.notifyShiftEnd ? 'bg-[#F3B33D] justify-end' : 'bg-[#3A3F45] justify-start'
            }`}
          >
            <span
              className={`w-6 h-6 rounded-full ${
                settings.notifyShiftEnd ? 'bg-[#111315]' : 'bg-[#A3A8AE]'
              }`}
            />
          </button>
        </div>

        {/* Switch: Driving limit */}
        <div className="min-h-14 px-4 py-3 flex items-center justify-between">
          <span className="text-[15px] font-medium">Лимит вождения</span>
          <button
            type="button"
            role="switch"
            onClick={() =>
              onUpdateSettings({ notifyDrivingLimit: !settings.notifyDrivingLimit })
            }
            className={`w-[52px] h-[32px] p-1 rounded-full transition-colors flex shrink-0 ${
              settings.notifyDrivingLimit ? 'bg-[#F3B33D] justify-end' : 'bg-[#3A3F45] justify-start'
            }`}
          >
            <span
              className={`w-6 h-6 rounded-full ${
                settings.notifyDrivingLimit ? 'bg-[#111315]' : 'bg-[#A3A8AE]'
              }`}
            />
          </button>
        </div>

        {/* Card reading group */}
        <div className="p-4 flex flex-col gap-3">
          <div className="flex items-center justify-between">
            <div className="flex flex-col">
              <span className="text-[15px] font-medium">Считывание карты</span>
              <span className="text-[13px] text-[#A3A8AE]">Каждые 28 дней</span>
            </div>
            <button
              type="button"
              role="switch"
              onClick={() =>
                onUpdateSettings({ notifyCardReading: !settings.notifyCardReading })
              }
              className={`w-[52px] h-[32px] p-1 rounded-full transition-colors flex shrink-0 ${
                settings.notifyCardReading ? 'bg-[#F3B33D] justify-end' : 'bg-[#3A3F45] justify-start'
              }`}
            >
              <span
                className={`w-6 h-6 rounded-full ${
                  settings.notifyCardReading ? 'bg-[#111315]' : 'bg-[#A3A8AE]'
                }`}
              />
            </button>
          </div>

          <div className="flex flex-col gap-2">
            <span className="text-[13px] text-[#A3A8AE]">Предупредить за</span>
            <div className="flex gap-2">
              {[3, 7, 14].map((d) => {
                const isSelected = settings.cardReadingAlertDays === d;
                return (
                  <button
                    key={d}
                    onClick={() => onUpdateSettings({ cardReadingAlertDays: d as any })}
                    className={`h-10 px-4 rounded-full text-[14px] font-semibold border transition-all ${
                      isSelected
                        ? 'bg-[#F3B33D] text-[#111315] border-[#F3B33D]'
                        : 'bg-transparent text-[#EDEBE6] border-[#3A3F45] hover:bg-[#262A2F]'
                    }`}
                  >
                    {d} дней
                  </button>
                );
              })}
            </div>
          </div>
        </div>

      </div>

      {/* Section: ДАННЫЕ */}
      <h2 className="mx-6 mt-4 text-[13px] font-bold tracking-wider uppercase text-[#A3A8AE]">
        Данные
      </h2>

      <div className="mx-4 bg-[#1A1D20] rounded-[24px] overflow-hidden divide-y divide-[#262A2F] border border-[#262A2F]/40 shadow-sm">
        
        {/* Export Report */}
        <button
          onClick={onOpenExportModal}
          className="w-full min-h-14 p-4 flex items-center justify-between text-left hover:bg-[#262A2F]/40 transition-colors"
        >
          <span className="text-[15px] font-semibold">Экспорт отчёта</span>
          <div className="flex items-center gap-2">
            <span className="text-[13px] text-[#A3A8AE]">PDF · CSV</span>
            <ChevronRight className="w-4 h-4 text-[#A3A8AE]" />
          </div>
        </button>

        {/* Cloud sync / Backup */}
        <button
          onClick={onOpenPaywall}
          className="w-full min-h-14 p-4 flex items-center justify-between text-left hover:bg-[#262A2F]/40 transition-colors"
        >
          <span className="text-[15px] font-semibold">Синхронизация и резервная копия</span>
          <div className="flex items-center gap-2">
            <span className="text-[12px] font-bold px-2 py-0.5 rounded-[8px] bg-[#F3B33D] text-[#111315]">
              Premium
            </span>
            <ChevronRight className="w-4 h-4 text-[#A3A8AE]" />
          </div>
        </button>

        {/* Clear Data */}
        <button
          onClick={() => {
            if (window.confirm('Вы действительно хотите очистить все данные смен и восстановить образец?')) {
              onClearData();
            }
          }}
          className="w-full min-h-14 p-4 flex items-center gap-3 text-left text-[#FF8F87] hover:bg-[#5A2A27]/20 transition-colors font-semibold text-[15px]"
        >
          <Trash2 className="w-5 h-5 shrink-0" />
          <span>Очистить все данные</span>
        </button>

      </div>

      {/* Language Picker Sheet */}
      {showLanguageModal && (
        <div className="fixed inset-0 bg-black/80 backdrop-blur-xs flex items-end sm:items-center justify-center p-0 sm:p-4 z-50">
          <div className="bg-[#1A1D20] text-[#EDEBE6] border-t sm:border border-[#2A2E33] rounded-t-[28px] sm:rounded-[28px] w-full max-w-[412px] p-4 flex flex-col gap-2 shadow-2xl">
            <div className="flex items-center justify-between pb-2 border-b border-[#262A2F]">
              <div className="flex items-center gap-2">
                <Globe className="w-5 h-5 text-[#F3B33D]" />
                <h3 className="text-[17px] font-bold">Выберите язык</h3>
              </div>
              <button
                onClick={() => setShowLanguageModal(false)}
                className="text-[#A3A8AE] hover:text-[#EDEBE6] text-[14px]"
              >
                Закрыть
              </button>
            </div>

            <div className="divide-y divide-[#262A2F]">
              {languages.map((l) => (
                <button
                  key={l.code}
                  onClick={() => {
                    onUpdateSettings({ language: l.code });
                    setShowLanguageModal(false);
                  }}
                  className="w-full py-3.5 px-3 flex items-center justify-between text-left hover:bg-[#262A2F] rounded-[12px] transition-colors"
                >
                  <span className="text-[15px] font-medium">{l.label}</span>
                  {settings.language === l.code && (
                    <Check className="w-5 h-5 text-[#F3B33D]" />
                  )}
                </button>
              ))}
            </div>
          </div>
        </div>
      )}

    </div>
  );
};
