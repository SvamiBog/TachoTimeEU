import React, { useState } from 'react';
import { X, Sparkles, Check } from 'lucide-react';

interface PaywallModalProps {
  onClose: () => void;
  onUpgrade: () => void;
}

export const PaywallModal: React.FC<PaywallModalProps> = ({ onClose, onUpgrade }) => {
  const [selectedPlan, setSelectedPlan] = useState<'year' | 'month'>('year');

  return (
    <div className="fixed inset-0 bg-black/85 backdrop-blur-xs flex items-end sm:items-center justify-center p-0 sm:p-4 z-50">
      <div className="bg-[#111315] text-[#EDEBE6] border-t sm:border border-[#2A2E33] rounded-t-[28px] sm:rounded-[28px] w-full max-w-[412px] max-h-[90vh] flex flex-col shadow-2xl overflow-y-auto">
        
        {/* Close Button Header */}
        <div className="h-14 px-4 flex items-center justify-end">
          <button
            onClick={onClose}
            className="w-10 h-10 rounded-full flex items-center justify-center text-[#EDEBE6] hover:bg-[#262A2F]"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Hero Title */}
        <div className="px-6 flex flex-col gap-3">
          <div className="w-16 h-16 rounded-[20px] bg-[#F3B33D] text-[#111315] flex items-center justify-center">
            <Sparkles className="w-8 h-8 fill-current" />
          </div>
          <h1 className="text-[28px] font-bold tracking-tight leading-tight">
            TachoTime Premium
          </h1>
          <p className="text-[15px] leading-relaxed text-[#A3A8AE]">
            Всё для спокойной проверки на дороге и работы без потери данных.
          </p>
        </div>

        {/* Feature List */}
        <ul className="mx-4 mt-5 p-2 bg-[#1A1D20] rounded-[24px] divide-y divide-[#262A2F]">
          <li className="p-3.5 flex gap-3.5 items-start">
            <Check className="w-5 h-5 text-[#F3B33D] shrink-0 mt-0.5" />
            <div className="flex flex-col gap-0.5">
              <span className="text-[15px] font-semibold">Отчёт PDF и CSV</span>
              <span className="text-[13px] text-[#A3A8AE]">Для инспектора и работодателя</span>
            </div>
          </li>

          <li className="p-3.5 flex gap-3.5 items-start">
            <Check className="w-5 h-5 text-[#F3B33D] shrink-0 mt-0.5" />
            <div className="flex flex-col gap-0.5">
              <span className="text-[15px] font-semibold">Уведомления о лимитах</span>
              <span className="text-[13px] text-[#A3A8AE]">Перерыв, конец дня, считывание карты</span>
            </div>
          </li>

          <li className="p-3.5 flex gap-3.5 items-start">
            <Check className="w-5 h-5 text-[#F3B33D] shrink-0 mt-0.5" />
            <div className="flex flex-col gap-0.5">
              <span className="text-[15px] font-semibold">Синхронизация и резервная копия</span>
              <span className="text-[13px] text-[#A3A8AE]">Данные не пропадут при смене телефона</span>
            </div>
          </li>

          <li className="p-3.5 flex gap-3.5 items-start">
            <Check className="w-5 h-5 text-[#F3B33D] shrink-0 mt-0.5" />
            <div className="flex flex-col gap-0.5">
              <span className="text-[15px] font-semibold">Полная история журнала</span>
              <span className="text-[13px] text-[#A3A8AE]">Без ограничения по времени</span>
            </div>
          </li>
        </ul>

        {/* Tariff Picker */}
        <div className="mx-4 mt-4 flex flex-col gap-2.5">
          {/* Year plan */}
          <button
            type="button"
            onClick={() => setSelectedPlan('year')}
            className={`relative min-h-[72px] px-4 rounded-[20px] bg-[#1A1D20] text-[#EDEBE6] flex items-center gap-3.5 text-left border-2 transition-all ${
              selectedPlan === 'year' ? 'border-[#F3B33D]' : 'border-[#2A2E33]'
            }`}
          >
            <div
              className={`w-5 h-5 rounded-full border-2 flex items-center justify-center shrink-0 ${
                selectedPlan === 'year' ? 'border-[#F3B33D]' : 'border-[#5A6068]'
              }`}
            >
              {selectedPlan === 'year' && <div className="w-2.5 h-2.5 rounded-full bg-[#F3B33D]" />}
            </div>
            <div className="flex-1 flex flex-col gap-0.5">
              <span className="text-[16px] font-bold">Год</span>
              <span className="text-[13px] text-[#A3A8AE]">€2,50 в месяц</span>
            </div>
            <span className="font-mono-num text-[20px] font-bold">€30</span>
            <span className="absolute -top-2.5 right-4 px-2 py-0.5 rounded-[8px] bg-[#F3B33D] text-[#111315] text-[12px] font-bold">
              −50%
            </span>
          </button>

          {/* Month plan */}
          <button
            type="button"
            onClick={() => setSelectedPlan('month')}
            className={`min-h-[72px] px-4 rounded-[20px] bg-[#1A1D20] text-[#EDEBE6] flex items-center gap-3.5 text-left border-2 transition-all ${
              selectedPlan === 'month' ? 'border-[#F3B33D]' : 'border-[#2A2E33]'
            }`}
          >
            <div
              className={`w-5 h-5 rounded-full border-2 flex items-center justify-center shrink-0 ${
                selectedPlan === 'month' ? 'border-[#F3B33D]' : 'border-[#5A6068]'
              }`}
            >
              {selectedPlan === 'month' && <div className="w-2.5 h-2.5 rounded-full bg-[#F3B33D]" />}
            </div>
            <div className="flex-1 flex flex-col gap-0.5">
              <span className="text-[16px] font-bold">Месяц</span>
              <span className="text-[13px] text-[#A3A8AE]">Отмена в любой момент</span>
            </div>
            <span className="font-mono-num text-[20px] font-bold">€5</span>
          </button>
        </div>

        {/* Footer Actions */}
        <div className="p-4 mt-auto flex flex-col gap-3">
          <button
            onClick={() => {
              onUpgrade();
              onClose();
            }}
            className="h-14 rounded-[18px] bg-[#F3B33D] hover:bg-[#e0a232] text-[#111315] font-bold text-[16px] transition-colors"
          >
            Оформить Premium
          </button>
          <button
            onClick={onClose}
            className="h-10 text-[14px] font-semibold text-[#EDEBE6] hover:text-[#F3B33D]"
          >
            Восстановить покупки
          </button>
          <p className="text-[12px] leading-relaxed text-[#A3A8AE] text-center">
            Подписка продлевается автоматически. Отменить можно в любой момент.
          </p>
        </div>

      </div>
    </div>
  );
};
