import React, { useState } from 'react';
import { ArrowLeft, Check, Trash2, Calendar, Clock, ChevronRight } from 'lucide-react';
import { ActivityEntry } from '../../types/tacho';

interface ShiftModalProps {
  onClose: () => void;
  onSaveShift: (startCountry: string, endCountry: string, note: string) => void;
  onOpenCountryPicker: () => void;
  startCountry: string;
  endCountry: string;
}

export const ShiftModal: React.FC<ShiftModalProps> = ({
  onClose,
  onSaveShift,
  onOpenCountryPicker,
  startCountry,
  endCountry,
}) => {
  const [restType, setRestType] = useState<'none' | 'daily' | 'weekly'>('daily');
  const [splitRest, setSplitRest] = useState(false);
  const [notes, setNotes] = useState('');

  return (
    <div className="fixed inset-0 bg-black/85 backdrop-blur-xs flex items-end sm:items-center justify-center p-0 sm:p-4 z-50">
      <div className="bg-[#111315] text-[#EDEBE6] border-t sm:border border-[#2A2E33] rounded-t-[28px] sm:rounded-[28px] w-full max-w-[412px] max-h-[92vh] flex flex-col shadow-2xl overflow-y-auto">
        
        {/* Header */}
        <div className="h-16 px-4 flex items-center justify-between border-b border-[#262A2F]">
          <button
            onClick={onClose}
            className="w-10 h-10 rounded-full flex items-center justify-center text-[#EDEBE6] hover:bg-[#262A2F]"
          >
            <ArrowLeft className="w-5 h-5" />
          </button>
          <div className="flex flex-col items-center">
            <h1 className="text-[18px] font-bold">Смена</h1>
            <span className="text-[12px] text-[#A3A8AE]">Сегодня</span>
          </div>
          <button
            onClick={() => {
              onSaveShift(startCountry, endCountry, notes);
              onClose();
            }}
            className="w-10 h-10 rounded-full flex items-center justify-center text-[#F3B33D] hover:bg-[#262A2F]"
          >
            <Check className="w-6 h-6" />
          </button>
        </div>

        {/* Start / End Grid */}
        <h2 className="mx-5 mt-4 mb-2 text-[13px] font-semibold tracking-wider uppercase text-[#A3A8AE]">
          Смена
        </h2>

        <div className="mx-4 bg-[#1A1D20] rounded-[24px] overflow-hidden">
          <div className="grid grid-cols-2 divide-x divide-[#262A2F]">
            {/* Start */}
            <div className="p-4 flex flex-col gap-2.5">
              <span className="text-[13px] text-[#A3A8AE]">Начало</span>
              <button
                type="button"
                onClick={onOpenCountryPicker}
                className="self-start h-10 px-3.5 rounded-full border border-[#3A3F45] flex items-center gap-1.5 font-mono-num text-[14px] font-bold text-[#EDEBE6]"
              >
                {startCountry || 'PL'} <ChevronRight className="w-4 h-4 text-[#A3A8AE]" />
              </button>

              <div className="flex flex-col gap-1.5 mt-1">
                <div className="h-11 px-3 rounded-[12px] bg-[#111315] flex items-center gap-2 text-[#EDEBE6]">
                  <Calendar className="w-4 h-4 text-[#A3A8AE]" />
                  <span className="text-[14px] font-semibold">Сегодня</span>
                </div>
                <div className="h-11 px-3 rounded-[12px] bg-[#111315] flex items-center gap-2 text-[#EDEBE6]">
                  <Clock className="w-4 h-4 text-[#A3A8AE]" />
                  <span className="font-mono-num text-[16px] font-bold">06:49</span>
                </div>
              </div>
            </div>

            {/* End */}
            <div className="p-4 flex flex-col gap-2.5">
              <span className="text-[13px] text-[#A3A8AE]">Конец</span>
              <button
                type="button"
                onClick={onOpenCountryPicker}
                className="self-start h-10 px-3.5 rounded-full border border-[#3A3F45] flex items-center gap-1.5 font-mono-num text-[14px] font-bold text-[#EDEBE6]"
              >
                {endCountry || '—'} <ChevronRight className="w-4 h-4 text-[#A3A8AE]" />
              </button>

              <div className="flex flex-col gap-1.5 mt-1">
                <div className="h-11 px-3 rounded-[12px] bg-[#111315] flex items-center gap-2 text-[#EDEBE6]">
                  <Calendar className="w-4 h-4 text-[#A3A8AE]" />
                  <span className="text-[14px] font-semibold">Сегодня</span>
                </div>
                <div className="h-11 px-3 rounded-[12px] bg-[#111315] flex items-center gap-2 text-[#EDEBE6]">
                  <Clock className="w-4 h-4 text-[#A3A8AE]" />
                  <span className="font-mono-num text-[16px] font-bold">19:10</span>
                </div>
              </div>
            </div>
          </div>

          <div className="min-h-12 px-4 border-t border-[#262A2F] flex items-center justify-between">
            <span className="text-[15px] font-semibold">Длительность</span>
            <span className="font-mono-num text-[16px] font-bold text-[#A3A8AE]">12:21</span>
          </div>
        </div>

        {/* Driving breakdown */}
        <h2 className="mx-5 mt-5 mb-2 text-[13px] font-semibold tracking-wider uppercase text-[#A3A8AE]">
          Вождение
        </h2>

        <div className="mx-4 bg-[#1A1D20] rounded-[24px] overflow-hidden divide-y divide-[#262A2F]">
          <div className="min-h-14 px-4 flex items-center justify-between">
            <span className="text-[15px] font-semibold">За день</span>
            <span className="font-mono-num text-[16px] font-bold">8:55</span>
          </div>
          <div className="min-h-14 px-4 flex items-center justify-between">
            <span className="text-[15px] font-semibold">Непрерывное на конец смены</span>
            <span className="font-mono-num text-[16px] font-bold">2:05</span>
          </div>
        </div>

        {/* Rest after shift */}
        <h2 className="mx-5 mt-5 mb-2 text-[13px] font-semibold tracking-wider uppercase text-[#A3A8AE]">
          Отдых после смены
        </h2>

        <div className="mx-4 bg-[#1A1D20] rounded-[24px] overflow-hidden">
          <div className="p-4">
            <div className="grid grid-cols-3 gap-1 p-1 rounded-[16px] bg-[#111315]">
              {(['none', 'daily', 'weekly'] as const).map((r) => {
                const labels = { none: 'Не начат', daily: 'Суточный', weekly: 'Недельный' };
                const isPicked = restType === r;
                return (
                  <button
                    key={r}
                    onClick={() => setRestType(r)}
                    className={`h-10 rounded-[12px] text-[14px] font-semibold transition-all ${
                      isPicked ? 'bg-[#2F343A] text-[#EDEBE6]' : 'text-[#A3A8AE] hover:text-[#EDEBE6]'
                    }`}
                  >
                    {labels[r]}
                  </button>
                );
              })}
            </div>
          </div>

          <div className="p-4 border-t border-[#262A2F] flex items-center justify-between">
            <div className="flex flex-col gap-0.5">
              <span className="text-[15px] font-semibold">Раздельный отдых 3 + 9</span>
              <span className="text-[13px] text-[#A3A8AE]">Сначала 3 ч, затем 9 ч</span>
            </div>
            <button
              type="button"
              role="switch"
              onClick={() => setSplitRest(!splitRest)}
              className={`w-[52px] h-[32px] p-1 rounded-full transition-colors flex shrink-0 ${
                splitRest ? 'bg-[#F3B33D] justify-end' : 'bg-[#3A3F45] justify-start'
              }`}
            >
              <span className={`w-6 h-6 rounded-full ${splitRest ? 'bg-[#111315]' : 'bg-[#A3A8AE]'}`} />
            </button>
          </div>
        </div>

        {/* Notes */}
        <h2 className="mx-5 mt-5 mb-2 text-[13px] font-semibold tracking-wider uppercase text-[#A3A8AE]">
          Заметки
        </h2>
        <div className="mx-4">
          <textarea
            value={notes}
            onChange={(e) => setNotes(e.target.value)}
            placeholder="Например: паром, ожидание загрузки, CMR..."
            rows={3}
            className="w-full p-4 rounded-[20px] bg-[#1A1D20] text-[#EDEBE6] text-[15px] outline-none border border-transparent focus:border-[#F3B33D] placeholder-[#A3A8AE] resize-none"
          />
        </div>

        {/* Delete button */}
        <div className="p-4 mt-4">
          <button
            onClick={onClose}
            className="w-full h-14 rounded-[18px] border border-[#5A2A27] text-[#FF8F87] hover:bg-[#5A2A27]/20 flex items-center justify-center gap-2 font-semibold text-[15px] transition-colors"
          >
            <Trash2 className="w-5 h-5" />
            Удалить смену
          </button>
        </div>

      </div>
    </div>
  );
};
