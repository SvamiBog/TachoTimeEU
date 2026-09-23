type Forms = Partial<Record<Intl.LDMLPluralRule, string>> & { other: string };

/** Выбор словоформы по правилам языка: plural('ru')(5, { one: 'день', few: 'дня', many: 'дней', other: 'дня' }). */
export function makePlural(locale: string) {
  const rules = new Intl.PluralRules(locale);
  return (n: number, forms: Forms): string => forms[rules.select(n)] ?? forms.other;
}
