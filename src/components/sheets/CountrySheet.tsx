import React, { useMemo, useState } from 'react';
import { Check, MapPin, Search, X } from 'lucide-react';
import { FREQUENT_COUNTRIES, TACHO_COUNTRIES, countryName } from '../../domain/countries';
import { useI18n } from '../../i18n';
import { Segmented, Sheet } from '../ui';

/**
 * Выбор стран начала и конца смены. Вкладка открывается та, для которой
 * вызвали; после выбора начала — переход к концу, после конца — закрытие.
 */
export const CountrySheet: React.FC<{
  start: string;
  end: string | null;
  initialTarget: 'start' | 'end';
  /** Можно ли оставить конечную страну пустой (смена ещё идёт). */
  allowEmptyEnd?: boolean;
  onChange: (v: { start: string; end: string | null }) => void;
  onClose: () => void;
}> = ({ start, end, initialTarget, allowEmptyEnd = true, onChange, onClose }) => {
  const { t, locale } = useI18n();
  const [target, setTarget] = useState(initialTarget);
  const [search, setSearch] = useState('');

  const list = useMemo(
    () =>
      TACHO_COUNTRIES.map((c) => ({ code: c.code, name: countryName(c.code, locale) })).sort((a, b) =>
        a.name.localeCompare(b.name, locale),
      ),
    [locale],
  );
  const q = search.trim().toLowerCase();
  const filtered = q ? list.filter((c) => c.code.toLowerCase().includes(q) || c.name.toLowerCase().includes(q)) : list;
  const selected = target === 'start' ? start : end;

  const pick = (code: string | null) => {
    if (target === 'start') {
      onChange({ start: code ?? start, end });
      setTarget('end');
      setSearch('');
    } else {
      onChange({ start, end: code });
      onClose();
    }
  };

  return (
    <Sheet onClose={onClose} label={t.country.title}>
      <div className="p-4 border-b border-surface2 flex items-center justify-between">
        <div className="flex items-center gap-2">
          <MapPin className="w-5 h-5 text-drive" />
          <h2 className="text-[17px] font-bold">{t.country.title}</h2>
        </div>
        <button
          type="button"
          onClick={onClose}
          aria-label={t.common.close}
          className="w-11 h-11 rounded-full flex items-center justify-center text-muted hover:text-fg"
        >
          <X className="w-5 h-5" />
        </button>
      </div>

      <div className="p-3 border-b border-surface2">
        <Segmented
          options={[
            { value: 'start', label: t.country.startTab(start || '—') },
            { value: 'end', label: t.country.endTab(end ?? '—') },
          ]}
          value={target}
          onChange={setTarget}
        />
      </div>

      <div className="p-3">
        <label className="relative block">
          <Search className="w-4 h-4 text-muted absolute left-3 top-3.5" />
          <input
            type="search"
            placeholder={t.country.search}
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            className="w-full h-11 bg-surface border border-line rounded-[16px] pl-9 pr-3 text-[14px] placeholder:text-muted focus:outline-none focus:border-drive"
          />
        </label>
      </div>

      <div className="px-4 pb-2 flex items-center gap-2 overflow-x-auto">
        <span className="text-[12px] text-muted shrink-0">{t.country.frequent}</span>
        {FREQUENT_COUNTRIES.map((code) => (
          <button
            key={code}
            type="button"
            onClick={() => pick(code)}
            className="min-h-9 px-3 rounded-[8px] bg-surface2 text-[13px] font-bold font-mono-num"
          >
            {code}
          </button>
        ))}
        {target === 'end' && allowEmptyEnd && (
          <button
            type="button"
            onClick={() => pick(null)}
            className="min-h-9 px-3 rounded-[8px] border border-line text-[13px] font-semibold shrink-0"
          >
            {t.country.clearEnd}
          </button>
        )}
      </div>

      <div className="flex-1 overflow-y-auto px-2 min-h-[240px]">
        {filtered.map((c) => (
          <button
            key={c.code}
            type="button"
            onClick={() => pick(c.code)}
            className={`w-full min-h-12 px-4 flex items-center justify-between text-left rounded-[12px] hover:bg-surface2/60 ${
              selected === c.code ? 'bg-surface2' : ''
            }`}
          >
            <span className="flex items-center gap-3">
              <span className="w-12 h-7 rounded-[6px] bg-surface border border-line text-drive font-mono-num font-bold text-[13px] flex items-center justify-center">
                {c.code}
              </span>
              <span className="text-[14px] font-medium">{c.name}</span>
            </span>
            {selected === c.code && <Check className="w-5 h-5 text-drive" />}
          </button>
        ))}
      </div>

      <div className="p-3 border-t border-surface2 text-center text-[12px] text-muted">{t.country.footer}</div>
    </Sheet>
  );
};
