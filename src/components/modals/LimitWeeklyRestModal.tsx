import React from 'react';
import { ArrowLeft, X, Bed, Info } from 'lucide-react';

interface LimitWeeklyRestModalProps {
  onClose: () => void;
  onStartRest: () => void;
}

export const LimitWeeklyRestModal: React.FC<LimitWeeklyRestModalProps> = ({
  onClose,
  onStartRest,
}) => {
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
          <h1 className="text-[18px] font-bold">Недельный отдых</h1>
          <button
            onClick={onClose}
            className="w-8 h-8 rounded-full flex items-center justify-center text-[#A3A8AE] hover:text-[#EDEBE6]"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Hero Card */}
        <section className="m-4 p-5 bg-[#1A1D20] rounded-[28px] flex flex-col gap-1.5">
          <span className="text-[12px] font-semibold tracking-wider uppercase text-[#A3A8AE]">
            Начать не позже
          </span>
          <span className="font-mono-num text-[36px] font-bold leading-tight">
            Вс 27.09 · 06:10
          </span>
          <span className="text-[14px] text-[#A3A8AE]">
            через 90:33 — конец рабочей недели (144 ч)
          </span>
        </section>

        {/* Next Rest Options */}
        <h2 className="mx-5 mb-2.5 text-[13px] font-semibold tracking-wider uppercase text-[#A3A8AE]">
          Следующий отдых
        </h2>

        <div className="mx-4 grid grid-cols-2 gap-2">
          <div className="p-4 rounded-[20px] bg-[#1A1D20] border-[1.5px] border-[#4FBF9F] flex flex-col gap-1.5">
            <span className="text-[13px] font-semibold text-[#9FE3CE]">Полный</span>
            <span className="font-mono-num text-[28px] font-bold">45 ч</span>
            <span className="text-[12px] leading-relaxed text-[#A3A8AE]">не в кабине</span>
          </div>

          <div className="p-4 rounded-[20px] bg-[#1A1D20] border border-[#2A2E33] flex flex-col gap-1.5">
            <span className="text-[13px] font-semibold text-[#C9CDD2]">Сокращённый</span>
            <span className="font-mono-num text-[28px] font-bold">24 ч</span>
            <span className="text-[12px] leading-relaxed text-[#A3A8AE]">доступен · с компенсацией</span>
          </div>
        </div>

        {/* History */}
        <h2 className="mx-5 mt-5 mb-2.5 text-[13px] font-semibold tracking-wider uppercase text-[#A3A8AE]">
          История
        </h2>

        <div className="mx-4 bg-[#1A1D20] rounded-[24px] overflow-hidden divide-y divide-[#262A2F]">
          <div className="min-h-16 p-4 flex items-center gap-3.5">
            <Bed className="w-5 h-5 text-[#4FBF9F] shrink-0" />
            <div className="flex-1 flex flex-col gap-0.5">
              <span className="text-[15px] font-semibold">Предыдущий · полный</span>
              <span className="font-mono-num text-[12px] text-[#A3A8AE]">
                18.09 11:20 → 21.09 06:10
              </span>
            </div>
            <span className="font-mono-num text-[17px] font-bold">66:50</span>
          </div>

          <div className="min-h-14 p-4 flex items-center gap-3.5">
            <span className="flex-1 text-[15px] font-semibold">Долг по компенсации</span>
            <span className="text-[14px] font-semibold text-[#9FE3CE]">нет</span>
          </div>
        </div>

        {/* Info */}
        <div className="m-4 p-4 rounded-[16px] bg-[#1A1D20] flex gap-3 text-[14px] leading-relaxed text-[#C9CDD2]">
          <Info className="w-5 h-5 text-[#A3A8AE] shrink-0 mt-0.5" />
          <span>
            Пакет мобильности включён: при международных перевозках можно взять два сокращённых отдыха подряд, если они проходят за пределами страны регистрации. Сокращение компенсируется до конца третьей недели.
          </span>
        </div>

        {/* Actions */}
        <div className="p-4 pt-0 mt-auto grid grid-cols-2 gap-2">
          <button
            onClick={onClose}
            className="h-14 rounded-[18px] border border-[#3A3F45] hover:bg-[#262A2F] text-[#EDEBE6] font-semibold text-[15px] transition-colors"
          >
            Указать вручную
          </button>
          <button
            onClick={() => {
              onStartRest();
              onClose();
            }}
            className="h-14 rounded-[18px] bg-[#4FBF9F] hover:bg-[#43a78b] text-[#0E2A22] font-bold text-[15px] transition-colors"
          >
            Начать отдых
          </button>
        </div>

      </div>
    </div>
  );
};
