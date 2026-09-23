import React, { useState } from 'react';
import { Info } from 'lucide-react';

interface TimeEditModalProps {
  initialMinutes?: number;
  onClose: () => void;
  onSave: (adjustedMinutes: number) => void;
}

export const TimeEditModal: React.FC<TimeEditModalProps> = ({
  initialMinutes = 235, // 3:55
  onClose,
  onSave,
}) => {
  const [hours, setHours] = useState(Math.floor(initialMinutes / 60));
  const [minutes, setMinutes] = useState(initialMinutes % 60);

  const selectedTotal = hours * 60 + minutes;
  const diff = selectedTotal - initialMinutes;
  const diffSign = diff >= 0 ? `+${Math.floor(diff / 60)}:${Math.abs(diff % 60).toString().padStart(2, '0')}` : `-${Math.floor(Math.abs(diff) / 60)}:${Math.abs(diff % 60).toString().padStart(2, '0')}`;

  return (
    <div className="fixed inset-0 bg-black/85 backdrop-blur-xs flex items-end justify-center p-0 z-50">
      <div 
        className="w-full max-w-[412px] bg-[#1A1D20] text-[#EDEBE6] rounded-t-[28px] p-5 pb-8 flex flex-col gap-4 border-t border-[#2A2E33] shadow-2xl animate-in slide-in-from-bottom duration-200"
      >
        <div className="w-10 h-1 bg-[#3A3F45] rounded-full self-center" />

        <div className="flex flex-col gap-1">
          <h1 className="text-[20px] font-bold">Суточное вождение</h1>
          <span className="text-[14px] text-[#A3A8AE]">Ручная корректировка · сегодня</span>
        </div>

        <div className="flex justify-between items-center p-3 rounded-[14px] bg-[#111315] text-[14px] text-[#A3A8AE]">
          <span>Посчитано приложением</span>
          <span className="font-mono-num text-[15px] font-bold text-[#EDEBE6]">
            {Math.floor(initialMinutes / 60)}:{(initialMinutes % 60).toString().padStart(2, '0')}
          </span>
        </div>

        {/* Wheel / Time Picker */}
        <div className="grid grid-cols-2 gap-3 bg-[#111315] p-3 rounded-[20px] border border-[#262A2F]">
          <div className="flex flex-col items-center">
            <span className="text-[12px] text-[#A3A8AE] mb-2 font-medium">Часы</span>
            <div className="flex items-center gap-4">
              <button
                onClick={() => setHours(Math.max(0, hours - 1))}
                className="w-10 h-10 rounded-full bg-[#262A2F] text-lg font-bold flex items-center justify-center hover:bg-[#3A3F45]"
              >
                -
              </button>
              <div className="flex items-baseline gap-1">
                <span className="font-mono-num text-[32px] font-bold">{hours}</span>
                <span className="text-[14px] text-[#A3A8AE]">ч</span>
              </div>
              <button
                onClick={() => setHours(Math.min(12, hours + 1))}
                className="w-10 h-10 rounded-full bg-[#262A2F] text-lg font-bold flex items-center justify-center hover:bg-[#3A3F45]"
              >
                +
              </button>
            </div>
          </div>

          <div className="flex flex-col items-center">
            <span className="text-[12px] text-[#A3A8AE] mb-2 font-medium">Минуты</span>
            <div className="flex items-center gap-4">
              <button
                onClick={() => setMinutes(Math.max(0, minutes - 5))}
                className="w-10 h-10 rounded-full bg-[#262A2F] text-lg font-bold flex items-center justify-center hover:bg-[#3A3F45]"
              >
                -
              </button>
              <div className="flex items-baseline gap-1">
                <span className="font-mono-num text-[32px] font-bold">{minutes.toString().padStart(2, '0')}</span>
                <span className="text-[14px] text-[#A3A8AE]">мин</span>
              </div>
              <button
                onClick={() => setMinutes(Math.min(59, minutes + 5))}
                className="w-10 h-10 rounded-full bg-[#262A2F] text-lg font-bold flex items-center justify-center hover:bg-[#3A3F45]"
              >
                +
              </button>
            </div>
          </div>
        </div>

        {/* Diff badge */}
        <div className="flex gap-2.5 p-3 rounded-[14px] bg-[#2B2415] text-[#F7D38A] text-[13px] leading-relaxed">
          <Info className="w-4 h-4 shrink-0 mt-0.5" />
          <span>
            {diff !== 0 ? `${diffSign} к расчёту.` : 'Время без изменений.'} Используйте, если режим переключили не вовремя — лимиты пересчитаются.
          </span>
        </div>

        {/* Buttons */}
        <div className="grid grid-cols-2 gap-2 mt-2">
          <button
            onClick={onClose}
            className="h-14 rounded-[18px] border border-[#3A3F45] text-[#EDEBE6] font-semibold text-[15px] hover:bg-[#262A2F] transition-colors"
          >
            Отмена
          </button>
          <button
            onClick={() => {
              onSave(selectedTotal);
              onClose();
            }}
            className="h-14 rounded-[18px] bg-[#F3B33D] hover:bg-[#e0a232] text-[#111315] font-bold text-[15px] transition-colors"
          >
            Сохранить
          </button>
        </div>
      </div>
    </div>
  );
};
