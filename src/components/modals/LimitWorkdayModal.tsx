import React from 'react';
import { X, ArrowLeft, Clock, Info } from 'lucide-react';
import { ComplianceMetrics, DriverSettings } from '../../types/tacho';
import { formatMinutesToHM } from '../../utils/compliance';

interface LimitWorkdayModalProps {
  metrics: ComplianceMetrics;
  settings: DriverSettings;
  onClose: () => void;
  onOpenTimeEdit?: () => void;
  onEndDay?: () => void;
}

export const LimitWorkdayModal: React.FC<LimitWorkdayModalProps> = ({
  metrics,
  settings,
  onClose,
  onOpenTimeEdit,
  onEndDay,
}) => {
  const shiftMinutes = metrics.shiftDurationMinutes;
  const shiftPct = Math.min(100, (shiftMinutes / 900) * 100);

  const start = metrics.shiftStartTimestamp ? new Date(metrics.shiftStartTimestamp) : new Date(Date.now() - 288 * 60 * 1000);
  const startTimeStr = start.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });

  // 13h deadline = start + 13h
  const time13h = new Date(start.getTime() + 13 * 3600 * 1000);
  const time13hStr = time13h.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });

  // 15h deadline = start + 15h
  const time15h = new Date(start.getTime() + 15 * 3600 * 1000);
  const time15hStr = time15h.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });

  const remaining13hMin = Math.max(0, 13 * 60 - shiftMinutes);

  return (
    <div className="fixed inset-0 bg-black/80 backdrop-blur-xs flex items-end sm:items-center justify-center p-0 sm:p-4 z-50">
      <div className="bg-[#111315] text-[#EDEBE6] border-t sm:border border-[#2A2E33] rounded-t-[28px] sm:rounded-[28px] w-full max-w-[412px] max-h-[90vh] flex flex-col shadow-2xl overflow-y-auto">
        
        {/* Header */}
        <div className="h-16 px-4 flex items-center gap-2 border-b border-[#262A2F]">
          <button
            onClick={onClose}
            className="w-10 h-10 rounded-full flex items-center justify-center text-[#EDEBE6] hover:bg-[#262A2F]"
          >
            <ArrowLeft className="w-5 h-5" />
          </button>
          <h1 className="text-[18px] font-bold flex-1">Рабочий день</h1>
          <button
            onClick={onClose}
            className="w-8 h-8 rounded-full flex items-center justify-center text-[#A3A8AE] hover:text-[#EDEBE6]"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Hero Card */}
        <section className="m-4 p-5 bg-[#1A1D20] rounded-[28px] flex flex-col gap-3.5">
          <div className="flex items-baseline gap-2.5">
            <span className="font-mono-num text-[52px] font-bold leading-none">
              {formatMinutesToHM(shiftMinutes)}
            </span>
            <span className="text-[15px] text-[#A3A8AE]">из 13:00</span>
          </div>

          <div className="relative h-2.5 rounded-[5px] bg-[#2A2E33]">
            <div
              className="absolute left-0 top-0 h-2.5 rounded-[5px] bg-[#EDEBE6]"
              style={{ width: `${shiftPct}%` }}
            />
            {/* 13h mark at 86.7% */}
            <div className="absolute left-[86.7%] -top-1 w-[2px] h-[18px] rounded-[1px] bg-[#A3A8AE]" />
          </div>

          <div className="flex justify-between font-mono-num text-[12px] text-[#A3A8AE]">
            <span>0</span>
            <span className="ml-auto mr-5">13 ч</span>
            <span>15 ч</span>
          </div>
        </section>

        {/* Breakdown Card */}
        <h2 className="mx-5 mb-2.5 text-[13px] font-semibold tracking-wider uppercase text-[#A3A8AE]">
          Сегодня
        </h2>

        <div className="mx-4 bg-[#1A1D20] rounded-[24px] overflow-hidden divide-y divide-[#262A2F]">
          <div className="min-h-16 p-4 flex items-center gap-3.5">
            <span className="w-2.5 h-2.5 rounded-full bg-[#EDEBE6] shrink-0" />
            <div className="flex-1 flex flex-col gap-0.5">
              <span className="text-[15px] font-semibold">Начало смены</span>
              <span className="text-[13px] text-[#A3A8AE]">{settings.startCountry || 'PL'}</span>
            </div>
            <span className="font-mono-num text-[17px] font-bold">{startTimeStr}</span>
          </div>

          <div className="min-h-16 p-4 flex items-center gap-3.5">
            <span className="w-2.5 h-2.5 rounded-full border-2 border-[#EDEBE6] shrink-0" />
            <div className="flex-1 flex flex-col gap-0.5">
              <span className="text-[15px] font-semibold">13 ч — обычный день</span>
              <span className="text-[13px] text-[#A3A8AE]">
                затем полный отдых 11 ч · ещё {formatMinutesToHM(remaining13hMin)}
              </span>
            </div>
            <span className="font-mono-num text-[17px] font-bold">{time13hStr}</span>
          </div>

          <div className="min-h-16 p-4 flex items-center gap-3.5">
            <span className="w-2.5 h-2.5 rounded-full border-2 border-[#A3A8AE] shrink-0" />
            <div className="flex-1 flex flex-col gap-0.5">
              <span className="text-[15px] font-semibold">15 ч — удлинённый день</span>
              <span className="text-[13px] text-[#A3A8AE]">
                затем сокращённый отдых 9 ч · осталось ×{Math.max(0, 3 - settings.usedReducedRestsThisWeek)}
              </span>
            </div>
            <span className="font-mono-num text-[17px] font-bold text-[#A3A8AE]">{time15hStr}</span>
          </div>
        </div>

        {/* Rule note */}
        <div className="m-4 p-4 rounded-[16px] bg-[#1A1D20] flex gap-3 text-[14px] leading-relaxed text-[#C9CDD2]">
          <Info className="w-5 h-5 text-[#A3A8AE] shrink-0 mt-0.5" />
          <span>
            Суточный отдых должен закончиться в пределах 24 часов от начала смены. Сокращённый отдых 9 ч можно брать не больше трёх раз между недельными отдыхами.
          </span>
        </div>

        {/* Change start / end buttons */}
        <div className="p-4 pt-0 mt-auto grid grid-cols-2 gap-2">
          <button
            onClick={() => {
              onClose();
              if (onOpenTimeEdit) onOpenTimeEdit();
            }}
            className="h-14 rounded-[18px] border border-[#3A3F45] hover:bg-[#262A2F] text-[#EDEBE6] flex items-center justify-center gap-2 text-[14px] font-semibold transition-colors"
          >
            <Clock className="w-4 h-4" />
            Начало смены
          </button>
          <button
            onClick={() => {
              if (onEndDay) onEndDay();
              onClose();
            }}
            className="h-14 rounded-[18px] bg-[#4FBF9F] hover:bg-[#43a78b] text-[#0E2A22] font-bold text-[15px] transition-colors"
          >
            Завершить день
          </button>
        </div>

      </div>
    </div>
  );
};
