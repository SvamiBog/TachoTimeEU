import React from 'react';
import { ArrowLeft } from 'lucide-react';

interface GuideViewProps {
  onBack: () => void;
}

export const GuideView: React.FC<GuideViewProps> = ({ onBack }) => {
  return (
    <div className="flex flex-col gap-3 pb-24 text-[#EDEBE6]">
      
      {/* Header */}
      <header className="h-16 px-4 flex items-center gap-2 border-b border-[#262A2F]">
        <button
          onClick={onBack}
          className="w-10 h-10 rounded-full flex items-center justify-center text-[#EDEBE6] hover:bg-[#262A2F]"
        >
          <ArrowLeft className="w-5 h-5" />
        </button>
        <h1 className="text-[18px] font-bold">Инструкция и правила</h1>
      </header>

      {/* Section: Как пользоваться */}
      <h2 className="mx-6 mt-3 text-[13px] font-bold tracking-wider uppercase text-[#A3A8AE]">
        Как пользоваться
      </h2>

      <ol className="mx-4 p-2 bg-[#1A1D20] rounded-[24px] divide-y divide-[#262A2F]">
        <li className="p-3.5 flex gap-3.5 items-start">
          <span className="w-7 h-7 rounded-full bg-[#F3B33D] text-[#111315] flex items-center justify-center font-mono-num text-[14px] font-bold shrink-0">
            1
          </span>
          <span className="text-[15px] leading-relaxed">
            Переключайте режим кнопками на главном экране: вождение, отдых, работа или готовность.
          </span>
        </li>
        <li className="p-3.5 flex gap-3.5 items-start">
          <span className="w-7 h-7 rounded-full bg-[#F3B33D] text-[#111315] flex items-center justify-center font-mono-num text-[14px] font-bold shrink-0">
            2
          </span>
          <span className="text-[15px] leading-relaxed">
            Укажите страну начала и конца смены — как на тахографе.
          </span>
        </li>
        <li className="p-3.5 flex gap-3.5 items-start">
          <span className="w-7 h-7 rounded-full bg-[#F3B33D] text-[#111315] flex items-center justify-center font-mono-num text-[14px] font-bold shrink-0">
            3
          </span>
          <span className="text-[15px] leading-relaxed">
            Следите за лимитами. Приложение заранее предупредит о перерыве и конце дня. Любое время можно поправить вручную.
          </span>
        </li>
      </ol>

      {/* Section: Правила ЕС 561/2006 и ЕСТР */}
      <h2 className="mx-6 mt-4 text-[13px] font-bold tracking-wider uppercase text-[#A3A8AE]">
        Правила ЕС 561/2006 и ЕСТР
      </h2>

      <div className="mx-4 bg-[#1A1D20] rounded-[24px] overflow-hidden divide-y divide-[#262A2F] border border-[#262A2F]/40 shadow-sm">
        
        {/* 4:30 */}
        <div className="p-4 grid grid-cols-[76px_1fr] gap-3.5">
          <span className="font-mono-num text-[20px] font-bold text-[#F3B33D]">4:30</span>
          <div className="flex flex-col gap-1">
            <span className="text-[15px] font-semibold">Непрерывное вождение</span>
            <span className="text-[14px] leading-relaxed text-[#A3A8AE]">
              Затем перерыв 45 мин. Можно разделить: сначала 15 мин, потом 30 мин.
            </span>
          </div>
        </div>

        {/* 9 ч */}
        <div className="p-4 grid grid-cols-[76px_1fr] gap-3.5">
          <span className="font-mono-num text-[20px] font-bold text-[#F3B33D]">9 ч</span>
          <div className="flex flex-col gap-1">
            <span className="text-[15px] font-semibold">Вождение за день</span>
            <span className="text-[14px] leading-relaxed text-[#A3A8AE]">
              Дважды в неделю можно продлить до 10 ч.
            </span>
          </div>
        </div>

        {/* 56 ч */}
        <div className="p-4 grid grid-cols-[76px_1fr] gap-3.5">
          <span className="font-mono-num text-[20px] font-bold text-[#F3B33D]">56 ч</span>
          <div className="flex flex-col gap-1">
            <span className="text-[15px] font-semibold">Вождение за неделю</span>
            <span className="text-[14px] leading-relaxed text-[#A3A8AE]">
              За любые две недели подряд — не больше 90 ч.
            </span>
          </div>
        </div>

        {/* 11 ч */}
        <div className="p-4 grid grid-cols-[76px_1fr] gap-3.5">
          <span className="font-mono-num text-[20px] font-bold text-[#4FBF9F]">11 ч</span>
          <div className="flex flex-col gap-1">
            <span className="text-[15px] font-semibold">Суточный отдых</span>
            <span className="text-[14px] leading-relaxed text-[#A3A8AE]">
              До трёх раз между недельными отдыхами можно сократить до 9 ч. Раздельный вариант — 3 ч + 9 ч.
            </span>
          </div>
        </div>

        {/* 13/15 */}
        <div className="p-4 grid grid-cols-[76px_1fr] gap-3.5">
          <span className="font-mono-num text-[20px] font-bold text-[#EDEBE6]">13/15</span>
          <div className="flex flex-col gap-1">
            <span className="text-[15px] font-semibold">Рабочий день</span>
            <span className="text-[14px] leading-relaxed text-[#A3A8AE]">
              Отдых должен закончиться в пределах 24 ч от начала смены: 13 ч при полном отдыхе, 15 ч при сокращённом.
            </span>
          </div>
        </div>

        {/* 45 ч */}
        <div className="p-4 grid grid-cols-[76px_1fr] gap-3.5">
          <span className="font-mono-num text-[20px] font-bold text-[#4FBF9F]">45 ч</span>
          <div className="flex flex-col gap-1">
            <span className="text-[15px] font-semibold">Недельный отдых</span>
            <span className="text-[14px] leading-relaxed text-[#A3A8AE]">
              Сокращённый — 24 ч, с компенсацией до конца третьей недели. Полный отдых нельзя проводить в кабине.
            </span>
          </div>
        </div>

        {/* 144 ч */}
        <div className="p-4 grid grid-cols-[76px_1fr] gap-3.5">
          <span className="font-mono-num text-[20px] font-bold text-[#EDEBE6]">144 ч</span>
          <div className="flex flex-col gap-1">
            <span className="text-[15px] font-semibold">Рабочая неделя</span>
            <span className="text-[14px] leading-relaxed text-[#A3A8AE]">
              Недельный отдых начинается не позже чем через шесть периодов по 24 ч после предыдущего.
            </span>
          </div>
        </div>

        {/* 28 дн */}
        <div className="p-4 grid grid-cols-[76px_1fr] gap-3.5">
          <span className="font-mono-num text-[20px] font-bold text-[#EDEBE6]">28 дн</span>
          <div className="flex flex-col gap-1">
            <span className="text-[15px] font-semibold">Карта водителя</span>
            <span className="text-[14px] leading-relaxed text-[#A3A8AE]">
              Данные карты нужно считывать не реже раза в 28 дней.
            </span>
          </div>
        </div>

      </div>

      {/* Section: Цвета и значки */}
      <h2 className="mx-6 mt-4 text-[13px] font-bold tracking-wider uppercase text-[#A3A8AE]">
        Цвета и значки
      </h2>

      <div className="mx-4 p-4 bg-[#1A1D20] rounded-[24px] grid grid-cols-2 gap-3 border border-[#262A2F]/40">
        <div className="flex items-center gap-2.5 text-[14px]">
          <div className="w-8 h-8 rounded-[10px] bg-[#F3B33D] text-[#111315] flex items-center justify-center shrink-0">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round">
              <circle cx="12" cy="12" r="9" />
              <circle cx="12" cy="12" r="2.2" />
              <path d="M3 12h6.8M14.2 12H21" />
            </svg>
          </div>
          <span>Вождение</span>
        </div>

        <div className="flex items-center gap-2.5 text-[14px]">
          <div className="w-8 h-8 rounded-[10px] bg-[#4FBF9F] text-[#111315] flex items-center justify-center shrink-0">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round">
              <path d="M4 5v14M4 13h16v6" />
            </svg>
          </div>
          <span>Отдых</span>
        </div>

        <div className="flex items-center gap-2.5 text-[14px]">
          <div className="w-8 h-8 rounded-[10px] bg-[#EE8B5A] text-[#111315] flex items-center justify-center shrink-0">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round">
              <path d="M6 18L16.5 7.5M18 18L7.5 7.5" />
              <path d="M14 5l5 5M5 10l5-5" />
            </svg>
          </div>
          <span>Другая работа</span>
        </div>

        <div className="flex items-center gap-2.5 text-[14px]">
          <div className="w-8 h-8 rounded-[10px] bg-[#86A8F0] text-[#111315] flex items-center justify-center shrink-0">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinejoin="round">
              <rect x="4" y="4" width="16" height="16" rx="1" />
              <path d="M4 20L20 4" />
            </svg>
          </div>
          <span>Готовность</span>
        </div>
      </div>

      <p className="mx-6 text-[12px] leading-relaxed text-[#A3A8AE]">
        TachoTime помогает планировать время, но не заменяет тахограф и не является юридической консультацией. Официальный текст правил — Регламент (ЕС) 561/2006 и Соглашение ЕСТР.
      </p>

    </div>
  );
};
