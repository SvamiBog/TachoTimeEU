import React from 'react';
import { X, Printer, Download, CheckCircle2, AlertTriangle } from 'lucide-react';
import { ActivityEntry, ComplianceMetrics, DriverSettings, SupportedLanguage } from '../types/tacho';
import { translations } from '../utils/translations';
import { formatMinutesToHM } from '../utils/compliance';

interface TachoPrintoutModalProps {
  entries: ActivityEntry[];
  settings: DriverSettings;
  metrics: ComplianceMetrics;
  language: SupportedLanguage;
  onClose: () => void;
}

export const TachoPrintoutModal: React.FC<TachoPrintoutModalProps> = ({
  entries,
  settings,
  metrics,
  language,
  onClose,
}) => {
  const t = translations[language] || translations.en;
  const now = new Date();

  // Sort chronologically
  const sorted = [...entries].sort((a, b) => a.startTime - b.startTime);

  const handlePrint = () => {
    window.print();
  };

  const getSymbol = (act: string) => {
    switch (act) {
      case 'DRIVE': return '◯ ⛟ [DRIVE]';
      case 'WORK': return '⚒   [WORK]';
      case 'POA': return '⊠   [POA]  ';
      case 'REST': return '🛏   [REST] ';
      default: return '       ';
    }
  };

  return (
    <div className="fixed inset-0 bg-black/85 backdrop-blur-xs flex items-center justify-center p-3 sm:p-6 z-50 overflow-y-auto">
      <div className="bg-slate-900 border border-slate-700 rounded-2xl max-w-xl w-full shadow-2xl flex flex-col max-h-[92vh]">
        
        {/* Modal Top Bar */}
        <div className="flex items-center justify-between p-4 border-b border-slate-800 bg-slate-950/80 rounded-t-2xl">
          <div className="flex items-center gap-2">
            <Printer className="w-5 h-5 text-blue-400" />
            <h3 className="font-bold text-white text-sm">
              Official Digital Tachograph 24h Daily Sheet
            </h3>
          </div>
          <div className="flex items-center gap-2">
            <button
              onClick={handlePrint}
              className="px-3 py-1.5 rounded-md bg-blue-600 hover:bg-blue-500 text-white text-xs font-bold flex items-center gap-1.5 transition-colors"
            >
              <Printer className="w-3.5 h-3.5" /> Print / Save PDF
            </button>
            <button
              onClick={onClose}
              className="p-1.5 text-slate-400 hover:text-white rounded-md transition-colors"
            >
              <X className="w-5 h-5" />
            </button>
          </div>
        </div>

        {/* Printable Thermal Receipt Container */}
        <div className="p-4 sm:p-6 overflow-y-auto flex justify-center bg-slate-950">
          <div className="w-full max-w-md bg-amber-50 text-slate-950 font-mono-tacho text-xs p-5 shadow-2xl border border-slate-300 rounded print:border-none print:shadow-none print:p-0">
            
            {/* Header */}
            <div className="text-center border-b-2 border-dashed border-slate-800 pb-3 mb-3">
              <div className="text-sm font-bold tracking-wider">🇪🇺 EUROPEAN UNION</div>
              <div className="font-bold">SMART TACHOGRAPH 24H PRINTOUT</div>
              <div className="text-[10px] text-slate-700">REGULATION (EU) 165/2014 & EC 561/2006</div>
              <div className="text-[10px] mt-1">--------------------------------</div>
              <div className="text-[11px] font-bold">
                PRINT TIMESTAMP: {now.toISOString().replace('T', ' ').slice(0, 19)} UTC
              </div>
            </div>

            {/* Driver Card Info */}
            <div className="border-b border-slate-400 pb-2 mb-2 text-[11px] space-y-0.5">
              <div><strong>DRIVER:</strong> {settings.driverName}</div>
              <div><strong>CARD NO:</strong> {settings.driverCardNumber}</div>
              <div><strong>VRN (PLATE):</strong> {settings.vehiclePlate} [EU]</div>
              <div><strong>CARRIER:</strong> {settings.companyName}</div>
              <div><strong>CREW MODE:</strong> {settings.crewMode === 'SOLO' ? 'SOLO DRIVER (1P)' : 'TEAM CREW (2P)'}</div>
            </div>

            {/* Daily Summary Box */}
            <div className="bg-slate-200/70 p-2 rounded border border-slate-300 text-[11px] mb-3 space-y-1">
              <div className="font-bold text-center border-b border-slate-300 pb-1">24H ACTIVITY SUMMARY</div>
              <div className="flex justify-between">
                <span>DAILY DRIVING:</span>
                <strong>{formatMinutesToHM(metrics.dailyDriveMinutes)}</strong>
              </div>
              <div className="flex justify-between">
                <span>10H EXTENSION TODAY:</span>
                <span>{settings.isExtendedDriveAllowedToday ? 'YES (10h Max)' : 'NO (9h Max)'}</span>
              </div>
              <div className="flex justify-between">
                <span>SHIFT SPAN:</span>
                <strong>{formatMinutesToHM(metrics.shiftDurationMinutes)}</strong>
              </div>
              <div className="flex justify-between">
                <span>WEEKLY DRIVING:</span>
                <strong>{formatMinutesToHM(metrics.weeklyDriveMinutes)} / 56h</strong>
              </div>
              <div className="flex justify-between">
                <span>2-WEEK DRIVING:</span>
                <strong>{formatMinutesToHM(metrics.fortnightlyDriveMinutes)} / 90h</strong>
              </div>
            </div>

            {/* Activity Sequence */}
            <div className="text-[11px] mb-3">
              <div className="font-bold border-b border-slate-800 pb-1 mb-1">
                ACTIVITY LOG (UTC)
              </div>
              <div className="space-y-1">
                {sorted.map((item, idx) => {
                  const sTime = new Date(item.startTime).toTimeString().slice(0, 5);
                  const eTime = item.endTime ? new Date(item.endTime).toTimeString().slice(0, 5) : '...';
                  const durMin = item.endTime
                    ? Math.round((item.endTime - item.startTime) / 60000)
                    : Math.round((Date.now() - item.startTime) / 60000);

                  return (
                    <div key={item.id} className="flex justify-between items-start text-[10px]">
                      <div>
                        <span>{sTime}-{eTime}</span>{' '}
                        <span className="font-bold">{getSymbol(item.activity)}</span>
                      </div>
                      <div className="text-right">
                        <span>{formatMinutesToHM(durMin)}</span>
                      </div>
                    </div>
                  );
                })}
              </div>
            </div>

            {/* Infringements / Compliance Assessment */}
            <div className="border-t border-slate-400 pt-2 mb-3 text-[11px]">
              <div className="font-bold mb-1">COMPLIANCE & INFRINGEMENTS:</div>
              {metrics.infringements.length === 0 ? (
                <div className="text-emerald-800 font-bold text-[10px]">
                  ✓ FULL COMPLIANCE - NO INFRINGEMENTS RECORDED
                </div>
              ) : (
                <div className="space-y-1">
                  {metrics.infringements.map((inf) => (
                    <div key={inf.id} className="text-[10px] text-red-700">
                      <strong>! {inf.article}:</strong> {inf.title}
                    </div>
                  ))}
                </div>
              )}
            </div>

            {/* Manual Article 12 Notes Box */}
            <div className="border-t-2 border-dashed border-slate-800 pt-2 mb-4 text-[10px]">
              <div className="font-bold uppercase">Manual Notes / Art. 12 Derogation Justification:</div>
              <div className="border border-slate-400 h-14 mt-1 p-1 bg-white/70 italic text-slate-600">
                (State reasons if driving was extended to reach safe parking or terminal)
              </div>
            </div>

            {/* Signature Area */}
            <div className="border-t border-slate-800 pt-3 text-[10px] space-y-4">
              <div className="flex justify-between">
                <div>
                  <div>DRIVER SIGNATURE:</div>
                  <div className="h-6 border-b border-slate-500 w-36 mt-2"></div>
                </div>
                <div>
                  <div>INSPECTOR SIGNATURE:</div>
                  <div className="h-6 border-b border-slate-500 w-36 mt-2"></div>
                </div>
              </div>
              <div className="text-center text-[9px] text-slate-600">
                * * * END OF TACHOGRAPH PRINTOUT * * *
              </div>
            </div>

          </div>
        </div>

      </div>
    </div>
  );
};
