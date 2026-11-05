// Layout and accessibility audit of one TachoGo site page at the current
// viewport (.claude/agents/site-review.md, section 9). Evaluates to a JSON
// string; run it with javascript_tool or through cdp.mjs. It measures, the
// reviewer judges.
(async () => {
  await document.fonts.ready;
  const de = document.documentElement;
  const vw = de.clientWidth;
  const cs = (e) => getComputedStyle(e);
  const id = (e) => e.tagName.toLowerCase() + (e.id ? '#' + e.id : '') +
    (e.classList.length ? '.' + [...e.classList].join('.') : '');
  const txt = (e) => (e.innerText || e.getAttribute('aria-label') || '')
    .replace(/\s+/g, ' ').trim().slice(0, 40);

  // Меню (<details>) проверяем открытыми: закрытое меню на 320 px не видно,
  // а открытое может уехать за край экрана. В конце закрываем обратно.
  const closed = [...document.querySelectorAll('details:not([open])')];
  for (const d of closed) d.open = true;

  try {
    const shown = (e) => {
      const r = e.getBoundingClientRect();
      return r.width > 0 && r.height > 0 && cs(e).visibility !== 'hidden';
    };
    const clipped = (e) => {
      for (let p = e.parentElement; p && p !== document.body; p = p.parentElement) {
        if (cs(p).overflowX !== 'visible') return true;
      }
      return false;
    };
    const ownText = (e) => [...e.childNodes]
      .filter((n) => n.nodeType === 3).map((n) => n.textContent).join('');
    const rgb = (c) => (c.match(/[\d.]+/g) || []).map(Number);
    const lum = (c) => {
      const f = (v) => {
        v /= 255;
        return v <= 0.03928 ? v / 12.92 : ((v + 0.055) / 1.055) ** 2.4;
      };
      return 0.2126 * f(c[0]) + 0.7152 * f(c[1]) + 0.0722 * f(c[2]);
    };
    const bg = (e) => {
      for (let p = e; p; p = p.parentElement) {
        const c = rgb(cs(p).backgroundColor);
        if (c.length >= 3 && (c[3] ?? 1) > 0.5) return c;
      }
      return [255, 255, 255];
    };

    const overflow = [], spill = [], contrast = new Set(), targets = [];
    const text = {};
    for (const e of [...document.querySelectorAll('body *')].filter(shown)) {
      const r = e.getBoundingClientRect(), s = cs(e);
      if (!clipped(e) && (r.right > vw + 1 || r.left < -1)) {
        overflow.push(`${id(e)} ${Math.round(r.left)}..${Math.round(r.right)}`);
      }
      if (e.clientWidth && e.scrollWidth > e.clientWidth + 1 &&
          !e.closest('.ticker,.sr')) {
        spill.push(`${id(e)} «${txt(e)}» ${e.scrollWidth}>${e.clientWidth}`);
      }
      const own = ownText(e);
      if (!own.trim()) continue;
      const family = s.fontFamily.split(',')[0].replace(/"/g, '').trim();
      const key = `${s.fontWeight}|${family}`;
      text[key] = (text[key] || '') +
        (s.textTransform === 'uppercase' ? own.toUpperCase() : own);
      // Логотип и декоративные части (aria-hidden: бегущая строка, макет
      // телефона) — вне WCAG 1.4.3
      if (e.closest('.logo,[aria-hidden="true"]')) continue;
      const a = lum(rgb(s.color)), b = lum(bg(e));
      const ratio = (Math.max(a, b) + 0.05) / (Math.min(a, b) + 0.05);
      const size = parseFloat(s.fontSize);
      const need = size >= 24 || (+s.fontWeight >= 700 && size >= 18.66) ? 3 : 4.5;
      if (ratio < need) contrast.add(`${id(e)} «${txt(e)}» ${ratio.toFixed(2)} < ${need}`);
    }

    for (const e of document.querySelectorAll('a[href],button,summary,input,select,textarea')) {
      if (!shown(e)) continue;
      // Ссылка внутри фразы — исключение WCAG 2.5.8
      if (cs(e).display === 'inline' && e.closest('p')) continue;
      const r = e.getBoundingClientRect();
      if (r.width < 44 || r.height < 44) {
        targets.push(`${id(e)} «${txt(e)}» ${Math.round(r.width)}×${Math.round(r.height)}`);
      }
    }

    // Знака нет в шрифте, если с ним рисуется ровно то же, что одним запасным
    // шрифтом, — и для моноширинного, и для засечек. Сравниваем по пикселям:
    // по ширине не видно, когда оба запасных рисуют знак одинаково.
    const canvas = document.createElement('canvas');
    canvas.width = canvas.height = 80;
    const g = canvas.getContext('2d', { willReadFrequently: true });
    const pix = (font, ch) => {
      g.clearRect(0, 0, 80, 80);
      g.font = font;
      g.textBaseline = 'top';
      g.fillText(ch, 10, 10);
      const data = g.getImageData(0, 0, 80, 80).data;
      let h = 0;
      for (let i = 3; i < data.length; i += 4) h = (h * 31 + data[i]) | 0;
      return h;
    };
    const ownFonts = new Set([...document.fonts].map((f) => f.family.replace(/"/g, '')));
    const missingGlyphs = {};
    for (const [key, chars] of Object.entries(text)) {
      const [weight, family] = key.split('|');
      if (!ownFonts.has(family)) continue;
      const set = [...new Set(chars.replace(/\s/g, ''))];
      await document.fonts.load(`${weight} 40px "${family}"`, set.join(''));
      const lost = set.filter((ch) => ['monospace', 'serif'].every(
        (f) => pix(`${weight} 40px "${family}", ${f}`, ch) === pix(`${weight} 40px ${f}`, ch),
      ));
      if (lost.length) missingGlyphs[key] = lost.join('');
    }

    // Якоря: после перехода первая строка цели не должна оказаться под
    // липкой шапкой. При горизонтальном переполнении телефон расширяет
    // layout viewport, и видимая область сдвигается на visualViewport.offsetTop —
    // считаем от неё
    const top = [...document.querySelectorAll('header,.top')]
      .find((e) => cs(e).position === 'sticky' || cs(e).position === 'fixed');
    const header = top ? top.getBoundingClientRect().height : 0;
    const vvShift = () => (window.visualViewport ? visualViewport.offsetTop : 0);
    const y0 = scrollY;
    const anchors = [];
    if (de.scrollWidth > vw) anchors.push(`note: page wider than viewport (${de.scrollWidth} > ${vw}), anchor tops measured from the visual viewport`);
    const hrefs = new Set([...document.querySelectorAll('a[href^="#"]')]
      .map((a) => a.getAttribute('href')).filter((h) => h.length > 1));
    for (const h of hrefs) {
      const t = document.getElementById(decodeURIComponent(h.slice(1)));
      if (!t) {
        anchors.push(`${h}: no target`);
        continue;
      }
      t.scrollIntoView({ behavior: 'instant', block: 'start' });
      const first = t.querySelector('h1,h2,h3,p,a') || t;
      const seen = first.getBoundingClientRect().top - vvShift();
      if (seen < header) {
        anchors.push(`${h}: ${id(first)} «${txt(first)}» top ${Math.round(seen)} < header ${Math.round(header)}`);
      }
    }
    scrollTo({ top: y0, behavior: 'instant' });

    return JSON.stringify({
      page: location.pathname, lang: de.lang, vw, vh: innerHeight,
      scrollWidth: de.scrollWidth, height: de.scrollHeight,
      overflow: overflow.slice(0, 25), spill: spill.slice(0, 25),
      contrast: [...contrast].slice(0, 25), targets, missingGlyphs, anchors,
      headings: [...document.querySelectorAll('h1,h2,h3,h4,h5,h6')]
        .map((h) => `${h.tagName} ${txt(h)}`),
      landmarks: [...document.querySelectorAll('header,nav,main,footer')].map(id),
    }, null, 1);
  } finally {
    for (const d of closed) d.open = false;
  }
})()
