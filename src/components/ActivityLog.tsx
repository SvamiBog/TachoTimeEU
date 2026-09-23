import React, { useState } from 'react';
import { Plus, Trash2, Edit2, RotateCcw, Download, FileSpreadsheet, Calendar, Check, X } from 'lucide-react';
import { ActivityEntry, ActivityType, SupportedLanguage } from '../types/tacho';
import { translations } from '../utils/translations';
import { formatMinutesToHM } from '../utils/compliance';
import { generateSampleEntries } from '../utils/storage';

interface ActivityLogProps {
  entries: ActivityEntry[];
  language: SupportedLanguage;
  onUpdateEntries: (entries: ActivityEntry[]) => void;
  onOpenPrintout: () => void;
}

export const ActivityLog: React.FC<ActivityLogProps> = ({
  entries,
  language,
  onUpdateEntries,
  onOpenPrintout,
}) => {
  const t = translations[language] || translations.en;

  const [isAddModalOpen, setIsAddModalOpen] = useState(false);
  const [editingEntryId, setEditingEntryId] = useState<string | null>(null);

  // Form state for add/edit
  const [formActivity, setFormActivity] = useState<ActivityType>('WORK');
  const [formStart, setFormStart] = useState<string>('');
  const [formEnd, setFormEnd] = useState<string>('');
  const [formNote, setFormNote] = useState<string>('');

  const sortedEntries = [...entries].sort((a, b) => b.startTime - a.startTime);

  const handleOpenAddModal = () => {
    const now = new Date();
    const oneHourAgo = new Date(now.getTime() - 60 * 60 * 1000);
    const toIsoTime = (d: Date) => d.toTimeString().slice(0, 5);

    setFormActivity('WORK');
    setFormStart(toIsoTime(oneHourAgo));
    setFormEnd(toIsoTime(now));
    setFormNote('');
    setEditingEntryId(null);
    setIsAddModalOpen(true);
  };

  const handleSaveActivity = (e: React.FormEvent) => {
    e.preventDefault();
    const today = new Date();
    const [sH, sM] = formStart.split(':').map((v) => parseInt(v, 10));
    const [eH, eM] = formEnd.split(':').map((v) => parseInt(v, 10));

    const startDate = new Date(today.getFullYear(), today.getMonth(), today.getDate(), sH, sM, 0);
    const endDate = new Date(today.getFullYear(), today.getMonth(), today.getDate(), eH, eM, 0);

    const startMs = startDate.getTime();
    let endMs = endDate.getTime();
    if (endMs < startMs) {
      endMs += 24 * 60 * 60 * 1000; // cross midnight
    }

    if (editingEntryId) {
      onUpdateEntries(
        entries.map((entry) => {
          if (entry.id === editingEntryId) {
            return {
              ...entry,
              activity: formActivity,
              startTime: startMs,
              endTime: endMs,
              note: formNote.trim(),
            };
          }
          return entry;
        })
      );
    } else {
      const newEntry: ActivityEntry = {
        id: `manual-${Date.now()}`,
        activity: formActivity,
        startTime: startMs,
        endTime: endMs,
        note: formNote.trim() || 'Manual Tachograph Entry (Art. 15/34)',
      };
      onUpdateEntries([...entries, newEntry]);
    }

    setIsAddModalOpen(false);
  };

  const handleDeleteEntry = (id: string) => {
    if (confirm('Delete this tachograph activity entry?')) {
      onUpdateEntries(entries.filter((e) => e.id !== id));
    }
  };

  const handleResetSample = () => {
    if (confirm('Reset log to standard European sample shift data?')) {
      onUpdateEntries(generateSampleEntries());
    }
  };

  const handleClearAll = () => {
    if (confirm('Clear all tachograph activity entries?')) {
      onUpdateEntries([]);
    }
  };

  const handleExportCsv = () => {
    const header = ['ID', 'Activity', 'Start (ISO)', 'End (ISO)', 'Duration (Min)', 'Notes'];
    const rows = entries.map((e) => {
      const dur = e.endTime ? Math.round((e.endTime - e.startTime) / 60000) : 'Ongoing';
      return [
        e.id,
        e.activity,
        new Date(e.startTime).toISOString(),
        e.endTime ? new Date(e.endTime).toISOString() : 'ACTIVE',
        dur,
        `"${(e.note || '').replace(/"/g, '""')}"`,
      ];
    });

    const csvContent = 'data:text/csv;charset=utf-8,' + [header.join(','), ...rows.map((r) => r.join(','))].join('\n');
    const encodedUri = encodeURI(csvContent);
    const link = document.createElement('a');
    link.setAttribute('href', encodedUri);
    link.setAttribute('download', `tachotime_export_${new Date().toISOString().slice(0, 10)}.csv`);
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  };

  const handleExportJson = () => {
    const dataStr = 'data:text/json;charset=utf-8,' + encodeURIComponent(JSON.stringify(entries, null, 2));
    const link = document.createElement('a');
    link.setAttribute('href', dataStr);
    link.setAttribute('download', `tachotime_backup_${new Date().toISOString().slice(0, 10)}.json`);
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  };

  return (
    <div className="bg-slate-900 border border-slate-800 rounded-2xl p-4 sm:p-6 shadow-xl space-y-5">
      
      {/* Header with Actions */}
      <div className="flex flex-wrap items-center justify-between gap-3 border-b border-slate-800 pb-4">
        <div>
          <h2 className="text-lg font-bold text-white flex items-center gap-2">
            <Calendar className="w-5 h-5 text-blue-400" /> {t.activityHistory}
          </h2>
          <p className="text-xs text-slate-400 mt-0.5">
            Detailed record of driving, breaks, work, and availability events.
          </p>
        </div>

        {/* Buttons Toolbar */}
        <div className="flex items-center gap-2 flex-wrap">
          <button
            onClick={handleOpenAddModal}
            className="px-3 py-1.5 rounded-md bg-blue-600 hover:bg-blue-500 text-white text-xs font-bold flex items-center gap-1.5 transition-colors"
          >
            <Plus className="w-3.5 h-3.5" /> {t.addActivity}
          </button>
          
          <button
            onClick={handleExportCsv}
            className="px-2.5 py-1.5 rounded-md bg-slate-800 hover:bg-slate-700 text-slate-200 border border-slate-700 text-xs font-medium flex items-center gap-1.5"
            title="Download CSV"
          >
            <FileSpreadsheet className="w-3.5 h-3.5 text-emerald-400" /> CSV
          </button>

          <button
            onClick={handleExportJson}
            className="px-2.5 py-1.5 rounded-md bg-slate-800 hover:bg-slate-700 text-slate-200 border border-slate-700 text-xs font-medium flex items-center gap-1.5"
            title="Download JSON Backup"
          >
            <Download className="w-3.5 h-3.5 text-sky-400" /> JSON
          </button>

          <button
            onClick={handleResetSample}
            className="px-2.5 py-1.5 rounded-md bg-slate-800 hover:bg-slate-700 text-slate-300 border border-slate-700 text-xs font-medium flex items-center gap-1"
            title="Reload realistic EU demo shift"
          >
            <RotateCcw className="w-3.5 h-3.5 text-amber-400" /> Sample
          </button>

          <button
            onClick={handleClearAll}
            className="px-2.5 py-1.5 rounded-md bg-slate-800 hover:bg-red-950/60 text-slate-400 hover:text-red-300 border border-slate-700 text-xs font-medium"
            title={t.clearAll}
          >
            {t.clearAll}
          </button>
        </div>
      </div>

      {/* Log Table */}
      <div className="overflow-x-auto rounded-xl border border-slate-800">
        <table className="w-full text-left text-xs">
          <thead className="bg-slate-950 text-slate-400 uppercase font-mono-tacho text-[11px] border-b border-slate-800">
            <tr>
              <th className="py-3 px-4">Activity</th>
              <th className="py-3 px-4">{t.startTime}</th>
              <th className="py-3 px-4">{t.endTime}</th>
              <th className="py-3 px-4">{t.duration}</th>
              <th className="py-3 px-4">{t.notes}</th>
              <th className="py-3 px-4 text-right">{t.actions}</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-slate-800/80">
            {sortedEntries.length === 0 ? (
              <tr>
                <td colSpan={6} className="py-8 text-center text-slate-500 font-mono-tacho">
                  No activities recorded yet. Select an activity above to start.
                </td>
              </tr>
            ) : (
              sortedEntries.map((entry) => {
                const isOngoing = entry.endTime === null;
                const durationMin = entry.endTime
                  ? Math.max(0, (entry.endTime - entry.startTime) / 60000)
                  : Math.max(0, (Date.now() - entry.startTime) / 60000);

                const getBadge = () => {
                  switch (entry.activity) {
                    case 'DRIVE':
                      return 'bg-emerald-950 text-emerald-400 border-emerald-800';
                    case 'WORK':
                      return 'bg-amber-950 text-amber-400 border-amber-800';
                    case 'POA':
                      return 'bg-sky-950 text-sky-400 border-sky-800';
                    case 'REST':
                      return 'bg-indigo-950 text-indigo-400 border-indigo-800';
                  }
                };

                return (
                  <tr key={entry.id} className="hover:bg-slate-800/40 transition-colors">
                    <td className="py-3 px-4 font-mono-tacho">
                      <span className={`inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-xs font-bold border ${getBadge()}`}>
                        {entry.activity}
                        {isOngoing && <span className="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-ping ml-0.5"></span>}
                      </span>
                    </td>
                    <td className="py-3 px-4 font-mono-tacho text-slate-300">
                      {new Date(entry.startTime).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', second: '2-digit' })}
                    </td>
                    <td className="py-3 px-4 font-mono-tacho text-slate-300">
                      {isOngoing ? (
                        <span className="text-emerald-400 font-bold uppercase animate-pulse">ACTIVE NOW</span>
                      ) : (
                        new Date(entry.endTime!).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', second: '2-digit' })
                      )}
                    </td>
                    <td className="py-3 px-4 font-mono-tacho font-bold text-white">
                      {formatMinutesToHM(durationMin)}
                    </td>
                    <td className="py-3 px-4 text-slate-400 max-w-xs truncate">
                      {entry.note || '—'}
                    </td>
                    <td className="py-3 px-4 text-right space-x-1 font-mono-tacho">
                      {!isOngoing && (
                        <button
                          onClick={() => {
                            setFormActivity(entry.activity);
                            setFormStart(new Date(entry.startTime).toTimeString().slice(0, 5));
                            setFormEnd(new Date(entry.endTime!).toTimeString().slice(0, 5));
                            setFormNote(entry.note || '');
                            setEditingEntryId(entry.id);
                            setIsAddModalOpen(true);
                          }}
                          className="p-1 hover:text-blue-400 text-slate-400 transition-colors"
                          title="Edit"
                        >
                          <Edit2 className="w-3.5 h-3.5 inline" />
                        </button>
                      )}
                      <button
                        onClick={() => handleDeleteEntry(entry.id)}
                        className="p-1 hover:text-red-400 text-slate-400 transition-colors"
                        title="Delete"
                      >
                        <Trash2 className="w-3.5 h-3.5 inline" />
                      </button>
                    </td>
                  </tr>
                );
              })
            )}
          </tbody>
        </table>
      </div>

      {/* Manual Entry Modal */}
      {isAddModalOpen && (
        <div className="fixed inset-0 bg-black/75 backdrop-blur-xs flex items-center justify-center p-4 z-50">
          <div className="bg-slate-900 border border-slate-700 rounded-xl p-5 max-w-md w-full shadow-2xl space-y-4">
            <div className="flex items-center justify-between border-b border-slate-800 pb-3">
              <h3 className="text-sm font-bold text-white flex items-center gap-2">
                <Plus className="w-4 h-4 text-blue-400" />
                {editingEntryId ? 'Edit Tachograph Activity' : 'Log Past Manual Entry (Art. 34)'}
              </h3>
              <button
                onClick={() => setIsAddModalOpen(false)}
                className="text-slate-400 hover:text-white"
              >
                <X className="w-4 h-4" />
              </button>
            </div>

            <form onSubmit={handleSaveActivity} className="space-y-4">
              <div>
                <label className="block text-xs font-medium text-slate-400 mb-1">Activity Type</label>
                <select
                  value={formActivity}
                  onChange={(e) => setFormActivity(e.target.value as ActivityType)}
                  className="w-full bg-slate-950 border border-slate-700 rounded-md px-3 py-2 text-xs text-white font-mono-tacho"
                >
                  <option value="DRIVE">{t.drive} (Driving)</option>
                  <option value="WORK">{t.work} (Other Work)</option>
                  <option value="REST">{t.rest} (Rest / Break)</option>
                  <option value="POA">{t.poa} (Period of Availability)</option>
                </select>
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="block text-xs font-medium text-slate-400 mb-1">{t.startTime}</label>
                  <input
                    type="time"
                    required
                    value={formStart}
                    onChange={(e) => setFormStart(e.target.value)}
                    className="w-full bg-slate-950 border border-slate-700 rounded-md px-3 py-1.5 text-xs text-white font-mono-tacho"
                  />
                </div>
                <div>
                  <label className="block text-xs font-medium text-slate-400 mb-1">{t.endTime}</label>
                  <input
                    type="time"
                    required
                    value={formEnd}
                    onChange={(e) => setFormEnd(e.target.value)}
                    className="w-full bg-slate-950 border border-slate-700 rounded-md px-3 py-1.5 text-xs text-white font-mono-tacho"
                  />
                </div>
              </div>

              <div>
                <label className="block text-xs font-medium text-slate-400 mb-1">{t.notes} / Location</label>
                <input
                  type="text"
                  value={formNote}
                  onChange={(e) => setFormNote(e.target.value)}
                  className="w-full bg-slate-950 border border-slate-700 rounded-md px-3 py-2 text-xs text-white"
                  placeholder="e.g. Loading at Venlo Logistics Park, walkaround check"
                />
              </div>

              <div className="flex justify-end gap-2 pt-2">
                <button
                  type="button"
                  onClick={() => setIsAddModalOpen(false)}
                  className="px-3 py-1.5 rounded-md bg-slate-800 hover:bg-slate-700 text-slate-300 text-xs font-medium"
                >
                  {t.cancel}
                </button>
                <button
                  type="submit"
                  className="px-4 py-1.5 rounded-md bg-blue-600 hover:bg-blue-500 text-white text-xs font-bold"
                >
                  {t.save}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

    </div>
  );
};
