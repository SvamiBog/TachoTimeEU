import React, { useState } from 'react';
import { Calendar, Download, FileText } from 'lucide-react';
import { ActivityEntry, DriverSettings } from '../../types/tacho';

interface ExportModalProps {
  entries: ActivityEntry[];
  settings: DriverSettings;
  onClose: () => void;
  onOpenPaywall: () => void;
}

export const ExportModal: React.FC<ExportModalProps> = ({
  entries,
  settings,
  onClose,
  onOpenPaywall,
}) => {
  const [period, setPeriod] = useState<'w1' | 'w2' | 'd28' | 'custom'>('d28');
  const [format, setFormat] = useState<'pdf' | 'csv'>('pdf');
  const [includeNotes, setIncludeNotes] = useState(true);

  const ranges: Record<string, string> = {
    w1: '21.09 — 23.09 (Текущая неделя)',
    w2: '14.09 — 23.09 (2 недели)',
    d28: '26.08 — 23.09 (28 дней · контроль)',
    custom: 'Выбрать диапазон дат',
  };

  const handleExport = () => {
    if (!settings.isPremium) {
      onOpenPaywall();
      return;
    }

    if (format === 'csv') {
      const csvHeader = 'ID,Activity,StartTime,EndTime,DurationMin,Location,Note\n';
      const rows = entries.map(e => {
        const dur = e.endTime ? Math.round((e.endTime - e.startTime) / 60000) : 0;
        return `${e.id},${e.activity},${new Date(e.startTime).toISOString()},${e.endTime ? new Date(e.endTime).toISOString() : 'ACTIVE'},${dur},"${e.location || ''}","${e.note || ''}"`;
      }).join('\n');
      
      const blob = new Blob([csvHeader + rows], { type: 'text/csv;charset=utf-8;' });
      const url = URL.createObjectURL(blob);
      const link = document.createElement('a');
      link.href = url;
      link.setAttribute('download', `tachotime_report_${new Date().toISOString().slice(0, 10)}.csv`);
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
      onClose();
    } else {
      window.print();
      onClose();
    }
  };

  return (
    <div className="fixed inset-0 bg-black/85 backdrop-blur-xs flex items-end justify-center p-0 z-50">
      <div 
        className="w-full max-w-[412px] bg-[#1A1D20] text-[#EDEBE6] rounded-t-[28px] p-5 pb-8 flex flex-col gap-4 border-t border-[#2A2E33] shadow-2xl animate-in slide-in-from-bottom duration-200"
      >
        <div className="w-10 h-1 bg-[#3A3F45] rounded-full self-center" />

        <div className="flex items-center justify-between">
          <h1 className="text-[20px] font-bold">Экспорт отчёта</h1>
          <span className="text-[12px] font-bold px-2 py-0.5 rounded-[8px] bg-[#F3B33D] text-[#111315]">
            Premium
          </span>
        </div>

        {/* Period selection */}
        <div className="flex flex-col gap-2">
          <span className="text-[13px] font-semibold tracking-wider uppercase text-[#A3A8AE]">
            Период
          </span>
          <div className="flex flex-wrap gap-2">
            {[
              { id: 'w1', label: 'Эта неделя' },
              { id: 'w2', label: '2 недели' },
              { id: 'd28', label: '28 дней' },
              { id: 'custom', label: 'Свой период' },
            ].map((p) => {
              const active = period === p.id;
              return (
                <button
                  key={p.id}
                  onClick={() => setPeriod(p.id as any)}
                  className={`h-10 px-4 rounded-[20px] text-[14px] font-semibold border transition-all ${
                    active
                      ? 'bg-[#F3B33D] text-[#111315] border-[#F3B33D]'
                      : 'bg-transparent text-[#EDEBE6] border-[#3A3F45] hover:bg-[#262A2F]'
                  }`}
                >
                  {p.label}
                </button>
              );
            })}
          </div>

          <div className="flex items-center gap-2.5 p-3 rounded-[14px] bg-[#111315]">
            <Calendar className="w-4 h-4 text-[#A3A8AE]" />
            <span className="font-mono-num text-[14px] font-bold">{ranges[period]}</span>
          </div>
        </div>

        {/* Format */}
        <div className="flex flex-col gap-2">
          <span className="text-[13px] font-semibold tracking-wider uppercase text-[#A3A8AE]">
            Формат
          </span>
          <div className="grid grid-cols-2 gap-1 p-1 rounded-[16px] bg-[#111315]">
            <button
              onClick={() => setFormat('pdf')}
              className={`h-11 rounded-[12px] text-[14px] font-semibold transition-all ${
                format === 'pdf'
                  ? 'bg-[#2F343A] text-[#EDEBE6]'
                  : 'text-[#A3A8AE] hover:text-[#EDEBE6]'
              }`}
            >
              PDF · для инспекции
            </button>
            <button
              onClick={() => setFormat('csv')}
              className={`h-11 rounded-[12px] text-[14px] font-semibold transition-all ${
                format === 'csv'
                  ? 'bg-[#2F343A] text-[#EDEBE6]'
                  : 'text-[#A3A8AE] hover:text-[#EDEBE6]'
              }`}
            >
              CSV · таблица
            </button>
          </div>
        </div>

        {/* Toggle notes */}
        <div className="flex items-center justify-between">
          <span className="text-[15px] font-semibold">Страны и заметки</span>
          <button
            type="button"
            role="switch"
            onClick={() => setIncludeNotes(!includeNotes)}
            className={`w-[52px] h-[32px] p-1 rounded-full transition-colors flex shrink-0 ${
              includeNotes ? 'bg-[#F3B33D] justify-end' : 'bg-[#3A3F45] justify-start'
            }`}
          >
            <span className={`w-6 h-6 rounded-full ${includeNotes ? 'bg-[#111315]' : 'bg-[#A3A8AE]'}`} />
          </button>
        </div>

        {/* Action Button */}
        <div className="grid grid-cols-2 gap-2 mt-2">
          <button
            onClick={onClose}
            className="h-14 rounded-[18px] border border-[#3A3F45] text-[#EDEBE6] font-semibold text-[15px] hover:bg-[#262A2F] transition-colors"
          >
            Отмена
          </button>
          <button
            onClick={handleExport}
            className="h-14 rounded-[18px] bg-[#F3B33D] hover:bg-[#e0a232] text-[#111315] font-bold text-[15px] flex items-center justify-center gap-2 transition-colors"
          >
            <Download className="w-5 h-5" />
            Создать отчёт
          </button>
        </div>

      </div>
    </div>
  );
};
