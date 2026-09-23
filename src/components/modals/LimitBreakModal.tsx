import React, { useState } from 'react';
import { ArrowLeft, Check, X } from 'lucide-react';
import { ComplianceMetrics } from '../../types/tacho';

interface LimitBreakModalProps {
  metrics: ComplianceMetrics;
  onClose: () => void;
  onSave?: () => void;
  onStartBreak?: () => void;
}

export const LimitBreakModal: React.FC<LimitBreakModalProps> = ({
  metrics,
  onClose,
  onSave,
  onStartBreak,
}) => {
  const [splitEnabled, setSplitEnabled] = useState(true);
  const [hours, setHours] = useState(0);
  const [minutes, setMinutes] = useState(15);

  return (
    <div className="fixed inset-0 bg-black/80 backdrop-blur-xs flex items-end sm:items-center justify-center p-0 sm:p-4 z-50">
      <div className="bg-[#111315] text-[#EDEBE6] border-t sm:border border-[#2A2E33] rounded-t-[28px] sm:rounded-[28px] w-full max-w-[412px] max-h-[90vh] flex flex-col shadow-2xl overflow-y-auto">
        
        {/* Header */}
        <div className="h-16 px-4 flex items-center justify-between border-b border-[#262A2F]">
          <button
            onClick={onClose}
            className="w-10 h-10 rounded-full flex items-center justify-center text-[#EDEBE6] hover:bg-[#262A2F]"
          >
            <ArrowLeft className="w-5 h-5" />
          </button>
          <h1 className="text-[18px] font-bold">Перерыв</h1>
          <button
            onClick={() => {
              if (onSave) onSave();
              onClose();
            }}
            className="w-10 h-10 rounded-full flex items-center justify-center text-[#F3B33D] hover:bg-[#262A2F]"
          >
            <Check className="w-6 h-6" />
          </button>
        </div>

        {/* Hero Card */}
        <section className="m-4 p-5 bg-[#1A1D20] rounded-[28px] flex flex-col gap-3.5">
          <div className="flex justify-between items-baseline">
            <span className="text-[15px] font-semibold">Перерыв после 4:30 вождения</span>
            <span className="font-mono-num text-[15px] font-bold">
              {metrics.hasSplit15 ? '0:15 / 0:45' : '0:00 / 0:45'}
            </span>
          </div>

          <div className="grid grid-cols-3 gap-1.5">
            <div
              className={`h-9 rounded-[10px] flex items-center justify-center text-[13px] font-bold ${
                metrics.hasSplit15
                  ? 'bg-[#4FBF9F] text-[#0E2A22]'
                  : 'border border-dashed border-[#4FBF9F] text-[#9FE3CE]'
              }`}
            >
              15 мин {metrics.hasSplit15 ? '✓' : ''}
            </div>
            <div
              className={`col-span-2 h-9 rounded-[10px] flex items-center justify-center text-[13px] font-bold border border-dashed border-[#4FBF9F] text-[#9FE3CE]`}
            >
              30 мин — осталось
            </div>
          </div>

          <span className="text-[13px] text-[#A3A8AE]">
            {metrics.hasSplit15
              ? 'Первая часть взята в 08:48–09:03'
              : 'Требуется непрерывный перерыв 45 мин или раздельный 15 + 30 мин.'}
          </span>
        </section>

        {/* Correction section */}
        <h2 className="mx-5 mb-2 text-[13px] font-semibold tracking-wider uppercase text-[#A3A8AE]">
          Корректировка
        </h2>

        <div className="mx-4 bg-[#1A1D20] rounded-[24px] overflow-hidden divide-y divide-[#262A2F]">
          <div className="p-4 flex flex-col gap-2">
            <span className="text-[15px] font-semibold">Длительность</span>
            
            {/* Number adjustment picker */}
            <div className="grid grid-cols-2 gap-3 pt-2">
              <div className="flex flex-col items-center bg-[#111315] p-3 rounded-[16px]">
                <span className="text-[12px] text-[#A3A8AE] mb-1">Часы</span>
                <div className="flex items-center gap-3">
                  <button
                    onClick={() => setHours(Math.max(0, hours - 1))}
                    className="w-8 h-8 rounded-full bg-[#262A2F] text-[#EDEBE6] font-bold text-lg"
                  >
                    -
                  </button>
                  <span className="font-mono-num text-[28px] font-bold">{hours}</span>
                  <button
                    onClick={() => setHours(hours + 1)}
                    className="w-8 h-8 rounded-full bg-[#262A2F] text-[#EDEBE6] font-bold text-lg"
                  >
                    +
                  </button>
                </div>
              </div>

              <div className="flex flex-col items-center bg-[#111315] p-3 rounded-[16px]">
                <span className="text-[12px] text-[#A3A8AE] mb-1">Минуты</span>
                <div className="flex items-center gap-3">
                  <button
                    onClick={() => setMinutes(Math.max(0, minutes - 5))}
                    className="w-8 h-8 rounded-full bg-[#262A2F] text-[#EDEBE6] font-bold text-lg"
                  >
                    -
                  </button>
                  <span className="font-mono-num text-[28px] font-bold">{minutes}</span>
                  <button
                    onClick={() => setMinutes(minutes + 5)}
                    className="w-8 h-8 rounded-full bg-[#262A2F] text-[#EDEBE6] font-bold text-lg"
                  >
                    +
                  </button>
                </div>
              </div>
            </div>
          </div>

          <div className="p-4 flex items-center justify-between gap-4">
            <div className="flex-1 flex flex-col gap-1">
              <span className="text-[15px] font-semibold">Раздельный перерыв 15 + 30</span>
              <span className="text-[13px] leading-relaxed text-[#A3A8AE]">
                Первая часть не меньше 15 мин, вторая — не меньше 30 мин
              </span>
            </div>
            <button
              type="button"
              role="switch"
              onClick={() => setSplitEnabled(!splitEnabled)}
              className={`w-[52px] h-[32px] p-1 rounded-full transition-colors flex shrink-0 ${
                splitEnabled ? 'bg-[#F3B33D] justify-end' : 'bg-[#3A3F45] justify-start'
              }`}
            >
              <span className={`w-6 h-6 rounded-full ${splitEnabled ? 'bg-[#111315]' : 'bg-[#A3A8AE]'}`} />
            </button>
          </div>
        </div>

        {/* Action Button */}
        <div className="p-4 mt-auto">
          <button
            onClick={() => {
              if (onStartBreak) onStartBreak();
              if (onSave) onSave();
              onClose();
            }}
            className="w-full h-14 rounded-[18px] bg-[#F3B33D] hover:bg-[#e0a232] text-[#111315] font-bold text-[16px] transition-colors"
          >
            {onStartBreak ? 'Начать перерыв' : 'Сохранить'}
          </button>
        </div>

      </div>
    </div>
  );
};
