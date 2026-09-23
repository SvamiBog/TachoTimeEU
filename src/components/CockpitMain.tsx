import React from 'react';
import { ChevronDown, CreditCard, AlertCircle } from 'lucide-react';
import { ActivityType, ComplianceMetrics, DriverSettings } from '../types/tacho';
import { formatMinutesToHM } from '../utils/compliance';

interface CockpitMainProps {
  metrics: ComplianceMetrics;
  settings: DriverSettings;
  activeActivity: ActivityType;
  onSelectActivity: (type: ActivityType) => void;
  onOpenCountryPicker: () => void;
  onOpenLimitBreak: () => void;
  onOpenLimitWorkday: () => void;
  onOpenLimitWeeklyRest: () => void;
  onOpenTimeEdit: () => void;
  onOpenPaywall: () => void;
}

export const CockpitMain: React.FC<CockpitMainProps> = ({
  metrics,
  settings,
  activeActivity,
  onSelectActivity,
  onOpenCountryPicker,
  onOpenLimitBreak,
  onOpenLimitWorkday,
  onOpenLimitWeeklyRest,
  onOpenTimeEdit,
  onOpenPaywall,
}) => {
  // Gauge geometry: 240px x 240px, radius 102
  const radius = 102;
  const circumference = 2 * Math.PI * radius; // ~640.88
  // Max drive continuous is 270 min (4h 30m)
  const continuousMin = metrics.continuousDriveMinutes;
  const breakRemainingMin = Math.max(0, 270 - continuousMin);
  
  // Progress fraction (inverted: fills as you approach limit)
  const driveFraction = Math.min(1, Math.max(0, continuousMin / 270));
  const strokeOffset = circumference * (1 - driveFraction);

  // Remaining time to break formatting
  const remH = Math.floor(breakRemainingMin / 60);
  const remM = Math.floor(breakRemainingMin % 60);
  const remFormatted = `${remH}:${remM.toString().padStart(2, '0')}`;

  // Continuous drive formatting
  const contH = Math.floor(continuousMin / 60);
  const contM = Math.floor(continuousMin % 60);
  const contFormatted = `${contH}:${contM.toString().padStart(2, '0')}`;

  // Mode color definition
  const getModeColor = (act: ActivityType) => {
    switch (act) {
      case 'DRIVE': return '#F3B33D';
      case 'REST': return '#4FBF9F';
      case 'WORK': return '#EE8B5A';
      case 'POA': return '#86A8F0';
    }
  };

  const currentColor = getModeColor(activeActivity);

  // Active duration formatting
  const durSec = metrics.currentActivityDurationSeconds;
  const durH = Math.floor(durSec / 3600);
  const durM = Math.floor((durSec % 3600) / 60);
  const liveDurationStr = `${durH}:${durM.toString().padStart(2, '0')}`;

  // Days left to card read
  const msSinceLastRead = Date.now() - settings.lastCardReadTimestamp;
  const daysSinceRead = Math.floor(msSinceLastRead / (24 * 3600 * 1000));
  const cardDaysLeft = Math.max(0, 28 - daysSinceRead);

  return (
    <div className="flex flex-col gap-3 pb-24 text-[#EDEBE6]">
      
      {/* Top Header Bar */}
      <header className="h-16 px-5 flex items-center justify-between">
        <div className="flex flex-col">
          <span className="text-[20px] font-bold tracking-tight">TachoTime</span>
          <span className="text-[12px] text-[#A3A8AE]">
            Ср, 23 сентября · смена с 06:49
          </span>
        </div>

        {/* Country Chip */}
        <button
          type="button"
          onClick={onOpenCountryPicker}
          className="h-10 px-3.5 rounded-full bg-[#1A1D20] border border-[#2A2E33] hover:border-[#F3B33D] flex items-center gap-1 font-mono-num text-[14px] font-bold text-[#EDEBE6] transition-colors"
        >
          <span>{settings.startCountry || 'PL'}</span>
          <span className="text-[#A3A8AE]">→</span>
          <span>{settings.endCountry || '—'}</span>
          <ChevronDown className="w-4 h-4 text-[#A3A8AE] ml-0.5" />
        </button>
      </header>

      {/* Hero Card with 240px Ring Gauge */}
      <section className="mx-4 p-5 rounded-[28px] bg-[#1A1D20] flex flex-col items-center gap-4 relative overflow-hidden shadow-lg border border-[#262A2F]/40">
        
        {/* Gauge Ring */}
        <div 
          onClick={onOpenLimitBreak}
          className="relative w-[240px] h-[240px] flex items-center justify-center cursor-pointer select-none group"
        >
          <svg className="w-full h-full -rotate-90" viewBox="0 0 240 240">
            {/* Background circle track */}
            <circle
              cx="120"
              cy="120"
              r={radius}
              fill="none"
              stroke="#2A2E33"
              strokeWidth="14"
            />
            {/* Active progress stroke */}
            <circle
              cx="120"
              cy="120"
              r={radius}
              fill="none"
              stroke={currentColor}
              strokeWidth="14"
              strokeLinecap="round"
              strokeDasharray={circumference}
              strokeDashoffset={strokeOffset}
              className="transition-all duration-700 ease-out"
            />
          </svg>

          {/* Center text in ring */}
          <div className="absolute inset-0 flex flex-col items-center justify-center text-center">
            <span className="text-[12px] font-bold tracking-widest uppercase text-[#A3A8AE]">
              До перерыва
            </span>
            <span className="font-mono-num text-[60px] font-bold tracking-tight leading-none my-1">
              {remFormatted}
            </span>
            <span className="text-[13px] text-[#A3A8AE]">
              непрерывно <span className="font-mono-num text-[#EDEBE6] font-semibold">{contFormatted}</span> из 4:30
            </span>
          </div>
        </div>

        {/* Warning / Split Break Banner */}
        <button
          onClick={onOpenLimitBreak}
          className="w-full py-2.5 px-3.5 rounded-[16px] bg-[#2B2415] hover:bg-[#382e1b] text-[#F7D38A] text-[13px] font-semibold flex items-center justify-center gap-2 transition-colors text-center"
        >
          <AlertCircle className="w-4 h-4 shrink-0 text-[#F3B33D]" />
          <span>
            {metrics.hasSplit15
              ? 'Нужен перерыв 30 мин — вторая часть раздельного 15 + 30'
              : 'Нужен перерыв 45 мин (или раздельный 15 + 30)'}
          </span>
        </button>

        {/* Active Mode Status Row */}
        <div className="flex items-center gap-2 text-[14px]">
          <span
            className="w-2.5 h-2.5 rounded-full animate-pulse"
            style={{ backgroundColor: currentColor }}
          />
          <span className="font-semibold text-[#EDEBE6]">
            {activeActivity === 'DRIVE' && 'Вождение'}
            {activeActivity === 'REST' && 'Отдых'}
            {activeActivity === 'WORK' && 'Другая работа'}
            {activeActivity === 'POA' && 'Готовность'}
          </span>
          <span className="text-[#A3A8AE]">с 09:25</span>
          <span className="text-[#A3A8AE]">·</span>
          <span className="font-mono-num font-bold text-[#EDEBE6]">{liveDurationStr}</span>
        </div>

      </section>

      {/* 4 Mode Buttons in a single row (Height 88px, Radius 20px) */}
      <div className="mx-4 grid grid-cols-4 gap-2">
        
        {/* Вождение */}
        <button
          type="button"
          onClick={() => onSelectActivity('DRIVE')}
          className={`h-[88px] rounded-[20px] p-1 flex flex-col items-center justify-center gap-1.5 transition-all active:scale-95 border ${
            activeActivity === 'DRIVE'
              ? 'bg-[#F3B33D] text-[#111315] border-[#F3B33D] shadow-lg shadow-[#F3B33D]/20 font-bold'
              : 'bg-[#1A1D20] text-[#EDEBE6] border-[#2A2E33] hover:border-[#F3B33D]/50'
          }`}
        >
          <svg
            width="28"
            height="28"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeWidth="2.2"
            strokeLinecap="round"
            strokeLinejoin="round"
            className="shrink-0"
          >
            <circle cx="12" cy="12" r="9" />
            <circle cx="12" cy="12" r="2.2" />
            <path d="M3 12h6.8M14.2 12H21" />
          </svg>
          <span className="text-[12px] sm:text-[13px] font-semibold text-center leading-tight">
            Вождение
          </span>
        </button>

        {/* Отдых */}
        <button
          type="button"
          onClick={() => onSelectActivity('REST')}
          className={`h-[88px] rounded-[20px] p-1 flex flex-col items-center justify-center gap-1.5 transition-all active:scale-95 border ${
            activeActivity === 'REST'
              ? 'bg-[#4FBF9F] text-[#0E2A22] border-[#4FBF9F] shadow-lg shadow-[#4FBF9F]/20 font-bold'
              : 'bg-[#1A1D20] text-[#EDEBE6] border-[#2A2E33] hover:border-[#4FBF9F]/50'
          }`}
        >
          <svg
            width="28"
            height="28"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeWidth="2.2"
            strokeLinecap="round"
            strokeLinejoin="round"
            className="shrink-0"
          >
            <path d="M4 5v14M4 13h16v6" />
          </svg>
          <span className="text-[12px] sm:text-[13px] font-semibold text-center leading-tight">
            Отдых
          </span>
        </button>

        {/* Работа */}
        <button
          type="button"
          onClick={() => onSelectActivity('WORK')}
          className={`h-[88px] rounded-[20px] p-1 flex flex-col items-center justify-center gap-1.5 transition-all active:scale-95 border ${
            activeActivity === 'WORK'
              ? 'bg-[#EE8B5A] text-[#111315] border-[#EE8B5A] shadow-lg shadow-[#EE8B5A]/20 font-bold'
              : 'bg-[#1A1D20] text-[#EDEBE6] border-[#2A2E33] hover:border-[#EE8B5A]/50'
          }`}
        >
          <svg
            width="28"
            height="28"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeWidth="2.2"
            strokeLinecap="round"
            className="shrink-0"
          >
            <path d="M6 18L16.5 7.5M18 18L7.5 7.5" />
            <path d="M14 5l5 5M5 10l5-5" />
          </svg>
          <span className="text-[12px] sm:text-[13px] font-semibold text-center leading-tight">
            Работа
          </span>
        </button>

        {/* Готовность */}
        <button
          type="button"
          onClick={() => onSelectActivity('POA')}
          className={`h-[88px] rounded-[20px] p-1 flex flex-col items-center justify-center gap-1.5 transition-all active:scale-95 border ${
            activeActivity === 'POA'
              ? 'bg-[#86A8F0] text-[#111315] border-[#86A8F0] shadow-lg shadow-[#86A8F0]/20 font-bold'
              : 'bg-[#1A1D20] text-[#EDEBE6] border-[#2A2E33] hover:border-[#86A8F0]/50'
          }`}
        >
          <svg
            width="28"
            height="28"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeWidth="2"
            strokeLinejoin="round"
            className="shrink-0"
          >
            <rect x="4" y="4" width="16" height="16" rx="2" />
            <path d="M4 20L20 4" />
          </svg>
          <span className="text-[12px] sm:text-[13px] font-semibold text-center leading-tight">
            Готовность
          </span>
        </button>

      </div>

      {/* Section: СЕГОДНЯ */}
      <h2 className="mx-6 mt-4 mb-1 text-[13px] font-bold tracking-wider uppercase text-[#A3A8AE]">
        Сегодня
      </h2>

      <div className="mx-4 bg-[#1A1D20] rounded-[24px] overflow-hidden divide-y divide-[#262A2F] border border-[#262A2F]/40 shadow-sm">
        
        {/* Непрерывное вождение */}
        <button
          onClick={onOpenTimeEdit}
          className="w-full p-4 flex flex-col gap-2 text-left hover:bg-[#262A2F]/40 transition-colors"
        >
          <div className="flex justify-between items-baseline">
            <span className="text-[15px] font-semibold">Непрерывное вождение</span>
            <div className="flex items-center gap-2">
              <span className="text-[12px] font-bold px-2 py-0.5 rounded-[8px] bg-[#2B2415] text-[#F7D38A]">
                скоро перерыв
              </span>
              <span className="font-mono-num text-[15px] font-bold">
                {contFormatted} / 4:30
              </span>
            </div>
          </div>
          <div className="h-1.5 rounded-full bg-[#2A2E33] overflow-hidden">
            <div
              className="h-full rounded-full bg-[#F3B33D]"
              style={{ width: `${Math.min(100, (continuousMin / 270) * 100)}%` }}
            />
          </div>
        </button>

        {/* Рабочий день */}
        <button
          onClick={onOpenLimitWorkday}
          className="w-full p-4 flex flex-col gap-2 text-left hover:bg-[#262A2F]/40 transition-colors"
        >
          <div className="flex justify-between items-baseline">
            <span className="text-[15px] font-semibold">Рабочий день</span>
            <div className="flex items-center gap-2">
              <span className="text-[12px] font-bold px-2 py-0.5 rounded-[8px] bg-[#262A2F] text-[#A3A8AE]">
                15 ч ×3
              </span>
              <span className="font-mono-num text-[15px] font-bold">
                {formatMinutesToHM(metrics.shiftDurationMinutes)} / 13:00
              </span>
            </div>
          </div>
          <div className="relative h-1.5 rounded-full bg-[#2A2E33]">
            <div
              className="h-full rounded-full bg-[#EDEBE6]"
              style={{ width: `${Math.min(100, (metrics.shiftDurationMinutes / 780) * 100)}%` }}
            />
            {/* 13h threshold mark */}
            <div className="absolute left-[86.7%] -top-1 w-[2px] h-[14px] rounded-[1px] bg-[#A3A8AE]" />
          </div>
        </button>

        {/* Суточное вождение */}
        <button
          onClick={onOpenTimeEdit}
          className="w-full p-4 flex flex-col gap-2 text-left hover:bg-[#262A2F]/40 transition-colors"
        >
          <div className="flex justify-between items-baseline">
            <span className="text-[15px] font-semibold">Суточное вождение</span>
            <div className="flex items-center gap-2">
              <span className="text-[12px] font-bold px-2 py-0.5 rounded-[8px] bg-[#262A2F] text-[#A3A8AE]">
                10 ч ×2
              </span>
              <span className="font-mono-num text-[15px] font-bold">
                {formatMinutesToHM(metrics.dailyDriveMinutes)} / 9:00
              </span>
            </div>
          </div>
          <div className="relative h-1.5 rounded-full bg-[#2A2E33]">
            <div
              className="h-full rounded-full bg-[#F3B33D]"
              style={{ width: `${Math.min(100, (metrics.dailyDriveMinutes / 540) * 100)}%` }}
            />
            {/* 9h threshold mark */}
            <div className="absolute left-[90%] -top-1 w-[2px] h-[14px] rounded-[1px] bg-[#A3A8AE]" />
          </div>
        </button>

        {/* Перерыв */}
        <button
          onClick={onOpenLimitBreak}
          className="w-full p-4 flex flex-col gap-2 text-left hover:bg-[#262A2F]/40 transition-colors"
        >
          <div className="flex justify-between items-baseline">
            <span className="text-[15px] font-semibold">Перерыв</span>
            <div className="flex items-center gap-2">
              <span className="text-[12px] font-bold px-2 py-0.5 rounded-[8px] bg-[#16261F] text-[#9FE3CE]">
                15 + 30
              </span>
              <span className="font-mono-num text-[15px] font-bold text-[#4FBF9F]">
                0:15 / 0:45
              </span>
            </div>
          </div>
          <div className="relative h-1.5 rounded-full bg-[#2A2E33]">
            <div
              className="h-full rounded-full bg-[#4FBF9F]"
              style={{ width: '33.3%' }}
            />
            {/* Split tick at 33.3% */}
            <div className="absolute left-[33.3%] -top-1 w-[2px] h-[14px] rounded-[1px] bg-[#A3A8AE]" />
          </div>
          <span className="text-[12px] text-[#A3A8AE]">
            Взято 15 мин в 08:48 · ещё 30 мин
          </span>
        </button>

      </div>

      {/* Section: ОТДЫХ */}
      <h2 className="mx-6 mt-4 mb-1 text-[13px] font-bold tracking-wider uppercase text-[#A3A8AE]">
        Отдых
      </h2>

      <div className="mx-4 bg-[#1A1D20] rounded-[24px] overflow-hidden divide-y divide-[#262A2F] border border-[#262A2F]/40 shadow-sm">
        
        {/* Суточный отдых */}
        <button
          onClick={onOpenLimitWorkday}
          className="w-full p-4 flex items-center justify-between text-left hover:bg-[#262A2F]/40 transition-colors"
        >
          <div className="flex flex-col gap-0.5">
            <span className="text-[15px] font-semibold">Суточный отдых</span>
            <span className="text-[13px] text-[#A3A8AE]">
              11 ч полный · 9 ч сокращённый · 3 + 9
            </span>
          </div>
          <div className="flex items-center gap-2">
            <span className="text-[12px] font-bold px-2 py-0.5 rounded-[8px] bg-[#262A2F] text-[#A3A8AE]">
              9 ч ×3
            </span>
            <span className="text-[14px] text-[#A3A8AE]">не начат</span>
          </div>
        </button>

        {/* Недельный отдых */}
        <button
          onClick={onOpenLimitWeeklyRest}
          className="w-full p-4 flex items-center justify-between text-left hover:bg-[#262A2F]/40 transition-colors"
        >
          <div className="flex flex-col gap-0.5">
            <span className="text-[15px] font-semibold">Недельный отдых</span>
            <span className="text-[13px] text-[#A3A8AE]">
              45 ч полный · 24 ч сокращённый
            </span>
          </div>
          <div className="flex items-center gap-2">
            <span className="text-[12px] font-bold px-2 py-0.5 rounded-[8px] bg-[#16261F] text-[#9FE3CE]">
              24 ч доступен
            </span>
            <span className="text-[14px] text-[#A3A8AE]">до вс 06:10</span>
          </div>
        </button>

      </div>

      {/* Section: НЕДЕЛЯ */}
      <h2 className="mx-6 mt-4 mb-1 text-[13px] font-bold tracking-wider uppercase text-[#A3A8AE]">
        Неделя
      </h2>

      <div className="mx-4 bg-[#1A1D20] rounded-[24px] overflow-hidden divide-y divide-[#262A2F] border border-[#262A2F]/40 shadow-sm">
        
        {/* Недельное вождение */}
        <div className="p-4 flex flex-col gap-2">
          <div className="flex justify-between items-baseline">
            <span className="text-[15px] font-semibold">Недельное вождение</span>
            <span className="font-mono-num text-[15px] font-bold">
              21:40 / 56:00
            </span>
          </div>
          <div className="h-1.5 rounded-full bg-[#2A2E33] overflow-hidden">
            <div className="h-full rounded-full bg-[#F3B33D] w-[38.7%]" />
          </div>
          <span className="text-[12px] text-[#A3A8AE]">
            ещё <span className="font-mono-num font-semibold text-[#EDEBE6]">34:20</span>
          </span>
        </div>

        {/* Двухнедельное вождение */}
        <div className="p-4 flex flex-col gap-2">
          <div className="flex justify-between items-baseline">
            <span className="text-[15px] font-semibold">Двухнедельное вождение</span>
            <div className="flex items-center gap-2">
              <span className="text-[12px] font-bold px-2 py-0.5 rounded-[8px] bg-[#2B2415] text-[#F7D38A]">
                ограничивает
              </span>
              <span className="font-mono-num text-[15px] font-bold">
                57:14 / 90:00
              </span>
            </div>
          </div>
          <div className="h-1.5 rounded-full bg-[#2A2E33] overflow-hidden">
            <div className="h-full rounded-full bg-[#F3B33D] w-[63.6%]" />
          </div>
          <span className="text-[12px] text-[#A3A8AE]">
            ещё <span className="font-mono-num font-semibold text-[#EDEBE6]">32:46</span>
          </span>
        </div>

        {/* Рабочая неделя */}
        <div className="p-4 flex flex-col gap-2">
          <div className="flex justify-between items-baseline">
            <span className="text-[15px] font-semibold">Рабочая неделя</span>
            <div className="flex items-center gap-2">
              <span className="text-[12px] font-bold px-2 py-0.5 rounded-[8px] bg-[#262A2F] text-[#A3A8AE]">
                144 ч
              </span>
              <span className="font-mono-num text-[15px] font-bold">
                53:27 / 144:00
              </span>
            </div>
          </div>
          <div className="h-1.5 rounded-full bg-[#2A2E33] overflow-hidden">
            <div className="h-full rounded-full bg-[#EDEBE6] w-[37.1%]" />
          </div>
          <span className="text-[12px] text-[#A3A8AE]">
            с пн 21.09, 06:10 · ещё <span className="font-mono-num font-semibold text-[#EDEBE6]">90:33</span> → вс 06:10
          </span>
        </div>

      </div>

      {/* Card Reading Notice Card */}
      <div 
        onClick={onOpenPaywall}
        className="mx-4 p-4 rounded-[24px] bg-[#1A1D20] border border-[#262A2F]/40 flex flex-col gap-2 cursor-pointer hover:border-[#F3B33D]/40 transition-colors"
      >
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2.5">
            <CreditCard className="w-5 h-5 text-[#F3B33D]" />
            <span className="text-[15px] font-semibold">Считывание карты</span>
          </div>
          <span className="font-mono-num text-[15px] font-bold text-[#F3B33D]">
            {cardDaysLeft} дн
          </span>
        </div>
        <div className="h-1.5 rounded-full bg-[#2A2E33] overflow-hidden">
          <div className="h-full rounded-full bg-[#F3B33D] w-[75%]" />
        </div>
        <span className="text-[12px] text-[#A3A8AE]">
          последнее 02.09 · до 30.09 (лимит 28 дней)
        </span>
      </div>

    </div>
  );
};
