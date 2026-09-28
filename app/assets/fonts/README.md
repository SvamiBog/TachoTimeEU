# Шрифты

- **Onest** — интерфейс. https://github.com/googlefonts/onest, лицензия `Onest-OFL.txt`.
- **JetBrains Mono** — время и цифры. https://github.com/JetBrains/JetBrainsMono, лицензия `JetBrainsMono-OFL.txt`.
- **Noto Sans Georgian** — запасной шрифт для грузинского: в Onest и JetBrains Mono его букв нет. https://github.com/notofonts/georgian, лицензия `NotoSansGeorgian-OFL.txt`. Статические 400 и 700 из Google Fonts (версия 2.005), нарезать не нужно. Подключён как `fontFamilyFallback` темы и всех стилей и как запасной шрифт PDF-отчёта: грузинский выглядит одинаково на всех телефонах и в отчёте.

- **Noto Sans Greek** — греческие буквы для PDF-отчёта на греческом: в Onest их нет. На экране греческий берётся из системного шрифта Android. Нарезан из `NotoSans-Regular.ttf` (Google Fonts, https://github.com/notofonts/latin-greek-cyrillic) — только греческий и расширенный греческий, лицензия `NotoSansGreek-OFL.txt`:

  ```bash
  pyftsubset NotoSans-Regular.ttf --unicodes="U+0370-03FF,U+1F00-1FFF" \
    --layout-features='*' --name-IDs='*' --name-legacy --notdef-outline \
    --output-file=NotoSansGreek-Regular.ttf
  ```

Все четыре — SIL Open Font License 1.1 без зарезервированных названий. Статические начертания нарезаны из вариативных `Onest[wght].ttf` и `JetBrainsMono[wght].ttf` репозитория google/fonts: Flutter не выбирает ось `wght` по `FontWeight`.

```bash
pip install fonttools
fonttools varLib.instancer "Onest[wght].ttf" wght=600 --update-name-table -o Onest-SemiBold.ttf
```

Onest — 400, 500, 600, 700; JetBrains Mono — 500, 700 (`docs/design/tokens.json`); Noto Sans Georgian — 400 и 700, остальные веса Flutter берёт ближайшие. Новое начертание — добавить файл сюда и в `pubspec.yaml`.
