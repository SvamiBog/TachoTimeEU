import React from 'react';
import { AlertCircle, AlertTriangle, CheckCircle2, ShieldCheck, FileText, ArrowRight } from 'lucide-react';
import { InfringementItem, SupportedLanguage } from '../types/tacho';
import { translations } from '../utils/translations';

interface ComplianceAlertsProps {
  infringements: InfringementItem[];
  language: SupportedLanguage;
  onOpenHandbook: () => void;
}

export const ComplianceAlerts: React.FC<ComplianceAlertsProps> = ({
  infringements,
  language,
  onOpenHandbook,
}) => {
  const t = translations[language] || translations.en;

  const violations = infringements.filter((item) => item.severity === 'violation');
  const warnings = infringements.filter((item) => item.severity === 'warning');

  return (
    <div className="space-y-3">
      {/* If 100% compliant with zero warnings or violations */}
      {infringements.length === 0 && (
        <div className="bg-emerald-950/40 border border-emerald-800/80 rounded-xl p-3.5 flex items-center justify-between shadow-md">
          <div className="flex items-center gap-3">
            <div className="w-8 h-8 rounded-full bg-emerald-500/20 text-emerald-400 flex items-center justify-center shrink-0">
              <ShieldCheck className="w-5 h-5" />
            </div>
            <div>
              <h4 className="text-sm font-bold text-emerald-300">
                {t.noInfringements}
              </h4>
              <p className="text-xs text-emerald-400/80">
                All continuous driving, break allocations, daily drive, and duty spans conform to Regulation (EC) No 561/2006.
              </p>
            </div>
          </div>
          <button
            onClick={onOpenHandbook}
            className="text-xs text-emerald-300 hover:text-emerald-200 flex items-center gap-1 font-semibold underline underline-offset-4 hidden sm:flex shrink-0"
          >
            Rules Guide <ArrowRight className="w-3.5 h-3.5" />
          </button>
        </div>
      )}

      {/* Violations List */}
      {violations.map((item) => (
        <div
          key={item.id}
          className="bg-red-950/60 border-2 border-red-600 rounded-xl p-4 shadow-lg animate-tacho-blink relative"
        >
          <div className="flex items-start gap-3">
            <div className="w-9 h-9 rounded-lg bg-red-600/30 text-red-400 flex items-center justify-center shrink-0 mt-0.5">
              <AlertCircle className="w-5 h-5" />
            </div>
            <div className="flex-1">
              <div className="flex flex-wrap items-center justify-between gap-2">
                <span className="text-xs font-mono-tacho font-bold px-2 py-0.5 rounded bg-red-900/80 text-red-200 uppercase border border-red-700">
                  {item.article}
                </span>
                <span className="text-xs font-bold text-red-300">CRITICAL INFRINGEMENT</span>
              </div>
              <h4 className="text-base font-extrabold text-white mt-1">
                {item.title}
              </h4>
              <p className="text-xs text-red-200 mt-1 leading-relaxed">
                {item.message}
              </p>
              <div className="mt-2.5 p-2 rounded bg-black/40 border border-red-800/60 text-xs text-red-300">
                <strong className="text-white">Required Action: </strong>
                {item.recommendation}
              </div>
            </div>
          </div>
        </div>
      ))}

      {/* Warnings List */}
      {warnings.map((item) => (
        <div
          key={item.id}
          className="bg-amber-950/50 border border-amber-600/80 rounded-xl p-3.5 shadow-md"
        >
          <div className="flex items-start gap-3">
            <div className="w-8 h-8 rounded-lg bg-amber-500/20 text-amber-400 flex items-center justify-center shrink-0 mt-0.5">
              <AlertTriangle className="w-4 h-4" />
            </div>
            <div className="flex-1">
              <div className="flex flex-wrap items-center justify-between gap-2">
                <span className="text-[11px] font-mono-tacho font-semibold px-2 py-0.5 rounded bg-amber-900/60 text-amber-300 border border-amber-700/60">
                  {item.article}
                </span>
                <span className="text-[11px] font-bold text-amber-400 uppercase">Warning Notice</span>
              </div>
              <h4 className="text-sm font-bold text-white mt-1">
                {item.title}
              </h4>
              <p className="text-xs text-amber-200 mt-0.5">
                {item.message}
              </p>
              <p className="text-xs text-amber-300/90 mt-1 font-mono-tacho">
                → {item.recommendation}
              </p>
            </div>
          </div>
        </div>
      ))}
    </div>
  );
};
