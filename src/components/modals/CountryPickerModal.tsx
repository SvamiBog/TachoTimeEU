import React, { useState } from 'react';
import { X, Search, Check, MapPin } from 'lucide-react';

interface CountryPickerModalProps {
  startCountry: string;
  endCountry: string;
  onSelectCountry: (type: 'start' | 'end', countryCode: string) => void;
  onClose: () => void;
}

const EU_COUNTRIES = [
  { code: 'PL', name: 'Польша (Poland)' },
  { code: 'D', name: 'Германия (Germany)' },
  { code: 'LT', name: 'Литва (Lithuania)' },
  { code: 'NL', name: 'Нидерланды (Netherlands)' },
  { code: 'F', name: 'Франция (France)' },
  { code: 'B', name: 'Бельгия (Belgium)' },
  { code: 'CZ', name: 'Чехия (Czechia)' },
  { code: 'SK', name: 'Словакия (Slovakia)' },
  { code: 'E', name: 'Испания (Spain)' },
  { code: 'I', name: 'Италия (Italy)' },
  { code: 'A', name: 'Австрия (Austria)' },
  { code: 'H', name: 'Венгрия (Hungary)' },
  { code: 'RO', name: 'Румыния (Romania)' },
  { code: 'BG', name: 'Болгария (Bulgaria)' },
  { code: 'LV', name: 'Латвия (Latvia)' },
  { code: 'EST', name: 'Эстония (Estonia)' },
];

export const CountryPickerModal: React.FC<CountryPickerModalProps> = ({
  startCountry,
  endCountry,
  onSelectCountry,
  onClose,
}) => {
  const [activeTarget, setActiveTarget] = useState<'start' | 'end'>('start');
  const [search, setSearch] = useState('');

  const filtered = EU_COUNTRIES.filter(
    (c) =>
      c.code.toLowerCase().includes(search.toLowerCase()) ||
      c.name.toLowerCase().includes(search.toLowerCase())
  );

  const selectedCode = activeTarget === 'start' ? startCountry : endCountry;

  return (
    <div className="fixed inset-0 bg-black/80 backdrop-blur-xs flex items-end sm:items-center justify-center p-0 sm:p-4 z-50">
      <div className="bg-[#1A1D20] text-[#EDEBE6] border-t sm:border border-[#2A2E33] rounded-t-[28px] sm:rounded-[28px] w-full max-w-[412px] max-h-[85vh] flex flex-col shadow-2xl overflow-hidden animate-in slide-in-from-bottom duration-200">
        
        {/* Header */}
        <div className="p-4 border-b border-[#262A2F] flex items-center justify-between">
          <div className="flex items-center gap-2">
            <MapPin className="w-5 h-5 text-[#F3B33D]" />
            <h2 className="text-[17px] font-bold">Выбор страны (Тахограф)</h2>
          </div>
          <button
            onClick={onClose}
            className="p-1 rounded-full text-[#A3A8AE] hover:text-[#EDEBE6] hover:bg-[#262A2F]"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Tab switch: Начало смены vs Конец смены */}
        <div className="p-3 border-b border-[#262A2F]">
          <div className="grid grid-cols-2 gap-2 bg-[#111315] p-1 rounded-[16px]">
            <button
              onClick={() => setActiveTarget('start')}
              className={`py-2 px-3 rounded-[12px] text-[13px] font-semibold transition-all ${
                activeTarget === 'start'
                  ? 'bg-[#F3B33D] text-[#111315] font-bold shadow'
                  : 'text-[#A3A8AE] hover:text-[#EDEBE6]'
              }`}
            >
              Начало: {startCountry || '—'}
            </button>
            <button
              onClick={() => setActiveTarget('end')}
              className={`py-2 px-3 rounded-[12px] text-[13px] font-semibold transition-all ${
                activeTarget === 'end'
                  ? 'bg-[#F3B33D] text-[#111315] font-bold shadow'
                  : 'text-[#A3A8AE] hover:text-[#EDEBE6]'
              }`}
            >
              Конец: {endCountry || '—'}
            </button>
          </div>
        </div>

        {/* Search */}
        <div className="p-3">
          <div className="relative">
            <Search className="w-4 h-4 text-[#A3A8AE] absolute left-3 top-3" />
            <input
              type="text"
              placeholder="Поиск по коду или названию..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="w-full bg-[#111315] border border-[#2A2E33] rounded-[16px] pl-9 pr-3 py-2 text-[14px] text-[#EDEBE6] placeholder-[#A3A8AE] focus:outline-none focus:border-[#F3B33D]"
            />
          </div>
        </div>

        {/* Quick Recent Chips */}
        <div className="px-4 pb-2 flex items-center gap-2 overflow-x-auto">
          <span className="text-[12px] text-[#A3A8AE]">Частые:</span>
          {['PL', 'D', 'LT', 'NL', 'F', 'CZ'].map((code) => (
            <button
              key={code}
              onClick={() => {
                onSelectCountry(activeTarget, code);
                if (activeTarget === 'start') setActiveTarget('end');
                else onClose();
              }}
              className="px-2.5 py-1 rounded-[8px] bg-[#262A2F] hover:bg-[#2A2E33] text-[12px] font-bold font-mono-num text-[#EDEBE6]"
            >
              {code}
            </button>
          ))}
        </div>

        {/* List of Countries */}
        <div className="flex-1 overflow-y-auto divide-y divide-[#262A2F] px-2">
          {filtered.map((item) => {
            const isSelected = selectedCode === item.code;
            return (
              <button
                key={item.code}
                onClick={() => {
                  onSelectCountry(activeTarget, item.code);
                  if (activeTarget === 'start') {
                    setActiveTarget('end');
                  } else {
                    onClose();
                  }
                }}
                className={`w-full py-3 px-4 flex items-center justify-between text-left hover:bg-[#262A2F]/60 rounded-[12px] transition-colors ${
                  isSelected ? 'bg-[#262A2F]' : ''
                }`}
              >
                <div className="flex items-center gap-3">
                  <span className="w-10 h-7 rounded-[6px] bg-[#111315] border border-[#2A2E33] text-[#F3B33D] font-mono-num font-bold text-[14px] flex items-center justify-center">
                    {item.code}
                  </span>
                  <span className="text-[14px] font-medium text-[#EDEBE6]">
                    {item.name}
                  </span>
                </div>
                {isSelected && <Check className="w-5 h-5 text-[#F3B33D]" />}
              </button>
            );
          })}
        </div>

        {/* Footer Note */}
        <div className="p-3 border-t border-[#262A2F] text-center text-[12px] text-[#A3A8AE]">
          Согласно Регламенту (ЕС) 165/2014 водитель обязан вводить символ страны при начале и окончании смены.
        </div>

      </div>
    </div>
  );
};
