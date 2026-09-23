import React from 'react';
import { BookOpen, ShieldAlert, CheckCircle, Info, ExternalLink, Scale, Clock, AlertTriangle } from 'lucide-react';
import { SupportedLanguage } from '../types/tacho';
import { translations } from '../utils/translations';

interface RegulationGuideProps {
  language: SupportedLanguage;
}

export const RegulationGuide: React.FC<RegulationGuideProps> = ({ language }) => {
  const t = translations[language] || translations.en;

  const rules = [
    {
      article: 'Article 7',
      title: 'Continuous Driving & Break Requirements',
      keyRule: 'Max 4 hours 30 minutes continuous driving before taking an uninterrupted break of at least 45 minutes.',
      details: [
        'Break must be at least 45 minutes uninterrupted, OR',
        'Split Break: A break of at least 15 minutes followed by a break of at least 30 minutes (must be in that exact 15m + 30m order).',
        'Crucial: Taking 30 minutes first and 15 minutes second is NOT a valid split break under EC 561/2006!',
        'Any break shorter than 15 minutes does not count towards tachograph break requirements.',
      ],
      color: 'border-emerald-600/60 bg-emerald-950/20',
      badge: 'Continuous Drive',
    },
    {
      article: 'Article 6(1)',
      title: 'Daily Driving Limits & 10-Hour Extensions',
      keyRule: 'Standard daily driving limit is 9 hours.',
      details: [
        'May be extended to at most 10 hours not more than twice during the fixed week (Monday 00:00 to Sunday 24:00 UTC).',
        'Driving day is the total accumulated driving time between any two daily rest periods or between a daily and weekly rest period.',
        'No prior authorization needed for the 10h extension, but tachograph records it automatically.',
      ],
      color: 'border-blue-600/60 bg-blue-950/20',
      badge: 'Daily Limits',
    },
    {
      article: 'Article 8(2)',
      title: 'Daily Rest Periods & 24-Hour Cycle',
      keyRule: 'Within each period of 24 hours after the end of the previous rest, a new daily rest must be completed.',
      details: [
        'Regular Daily Rest: At least 11 uninterrupted hours (Max shift span = 13 hours).',
        'Split Daily Rest: Taken in two periods — first at least 3 hours, second at least 9 hours (total 12h rest, max shift span = 15 hours).',
        'Reduced Daily Rest: At least 9 hours but less than 11 hours (Max shift span = 15 hours). Maximum 3 reduced daily rests permitted between any two weekly rest periods.',
      ],
      color: 'border-purple-600/60 bg-purple-950/20',
      badge: 'Daily Rest',
    },
    {
      article: 'Article 8(5)',
      title: 'Multi-Manning (Double Crew)',
      keyRule: 'Within 30 hours of the end of a rest period, each driver must take at least 9 hours of daily rest.',
      details: [
        'Both drivers must be present in the vehicle for the multi-manning rules to apply (the presence of the second driver is optional only for the first hour of the shift).',
        'Maximum shift span for a two-driver crew is 21 hours (30h window - 9h rest).',
        'The passenger driver sitting beside the driving driver records POA (Period of Availability).',
      ],
      color: 'border-pink-600/60 bg-pink-950/20',
      badge: 'Double Crew',
    },
    {
      article: 'Articles 6(2) & 6(3)',
      title: 'Weekly & Fortnightly Driving Limits',
      keyRule: 'Maximum 56 hours in a single fixed week, maximum 90 hours in any two consecutive weeks.',
      details: [
        'Weekly driving period: Monday 00:00 UTC to Sunday 24:00 UTC.',
        'Single week limit: 56 hours maximum.',
        'Fortnightly limit: Total driving in week 1 + week 2 cannot exceed 90 hours. Then week 2 + week 3 cannot exceed 90 hours, and so on.',
      ],
      color: 'border-amber-600/60 bg-amber-950/20',
      badge: 'Weekly Limits',
    },
    {
      article: 'Article 8(6) & Mobility Package I',
      title: 'Weekly Rest Periods & Cabin Rest Ban',
      keyRule: 'Weekly rest must begin no later than after six 24-hour periods (144 hours) from previous weekly rest.',
      details: [
        'Regular Weekly Rest: At least 45 uninterrupted hours.',
        'Reduced Weekly Rest: At least 24 hours. Must be compensated by equivalent rest taken en bloc before the end of the third following week, attached to another rest of at least 9h.',
        'In any two consecutive weeks: Driver must take at least two regular weekly rests, or one regular and one reduced weekly rest.',
        'Mobility Package I Ban: Regular weekly rest (45h) CANNOT be taken inside the truck cabin! Employer must provide gender-friendly, suitable accommodation with sleeping and sanitary facilities.',
      ],
      color: 'border-cyan-600/60 bg-cyan-950/20',
      badge: 'Weekly Rest',
    },
    {
      article: 'Article 9',
      title: 'Ferry / Train Crossing Interruption Rule',
      keyRule: 'Regular daily rest (11h) or regular weekly rest may be interrupted up to 2 times for max 1 hour total.',
      details: [
        'Applies only when the driver accompanies a vehicle transported by ferryboat or train.',
        'Maximum 2 interruptions (e.g., driving vehicle onto ferry, driving vehicle off ferry).',
        'Total duration of both interruptions together must not exceed 60 minutes.',
        'Driver must have access to a sleeper cabin, bunk, or couchette during the crossing.',
      ],
      color: 'border-teal-600/60 bg-teal-950/20',
      badge: 'Ferry / Train',
    },
    {
      article: 'Article 12',
      title: 'Exceptional Circumstances Derogation',
      keyRule: 'Driving time may be exceeded by up to 1h (or 2h with a 30m break) to reach operational centre or home for weekly rest.',
      details: [
        'Allowed only under exceptional unforeseen circumstances (e.g., severe accident, sudden severe weather, road blocked) without jeopardising road safety.',
        'Driver MUST make a manual printout immediately upon arrival at the destination/parking area and write the reason on the back of the printout.',
        'Any extended time must be compensated by an equivalent period of rest en bloc before the end of the third following week.',
      ],
      color: 'border-rose-600/60 bg-rose-950/20',
      badge: 'Article 12',
    },
  ];

  return (
    <div className="bg-slate-900 border border-slate-800 rounded-2xl p-4 sm:p-6 shadow-xl space-y-6">
      <div className="border-b border-slate-800 pb-4">
        <div className="flex items-center gap-2">
          <BookOpen className="w-5 h-5 text-blue-400" />
          <h2 className="text-lg font-bold text-white">
            {t.rulesHandbook}
          </h2>
        </div>
        <p className="text-xs text-slate-400 mt-1">
          Complete quick-reference handbook of Regulation (EC) No 561/2006, Regulation (EU) 165/2014, and EU Mobility Package I.
        </p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        {rules.map((rule, idx) => (
          <div
            key={idx}
            className={`border rounded-xl p-4 transition-all hover:border-slate-600 ${rule.color}`}
          >
            <div className="flex items-center justify-between gap-2 mb-2">
              <span className="text-xs font-mono-tacho font-bold px-2 py-0.5 rounded bg-black/40 text-white border border-slate-700">
                {rule.article}
              </span>
              <span className="text-[11px] font-semibold text-slate-400">
                {rule.badge}
              </span>
            </div>

            <h3 className="text-sm font-bold text-white mb-1.5">
              {rule.title}
            </h3>

            <div className="text-xs font-medium text-slate-200 bg-black/30 p-2.5 rounded-lg border border-slate-800/80 mb-2.5 leading-relaxed">
              <strong>Rule: </strong>{rule.keyRule}
            </div>

            <ul className="text-xs text-slate-300/90 space-y-1.5 list-disc pl-4 leading-relaxed">
              {rule.details.map((d, dIdx) => (
                <li key={dIdx}>{d}</li>
              ))}
            </ul>
          </div>
        ))}
      </div>

      {/* Roadside Inspection Advice */}
      <div className="bg-blue-950/40 border border-blue-800/80 rounded-xl p-4 text-xs text-slate-300 space-y-2">
        <h4 className="font-bold text-blue-300 flex items-center gap-2 text-sm">
          <Scale className="w-4 h-4 text-blue-400" /> Roadside Inspection Readiness (28 / 56 Days Rule)
        </h4>
        <p className="text-slate-300 leading-relaxed">
          Under European regulations, drivers must be able to produce all tachograph records (driver card data, manual entries, and any thermal printouts) for the <strong>current day and the previous 56 days</strong>. Always ensure manual entries are recorded when switching vehicles or performing out-of-scope work.
        </p>
      </div>
    </div>
  );
};
