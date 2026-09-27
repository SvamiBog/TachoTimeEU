# Шрифты

- **Onest** — интерфейс. https://github.com/googlefonts/onest, лицензия `Onest-OFL.txt`.
- **JetBrains Mono** — время и цифры. https://github.com/JetBrains/JetBrainsMono, лицензия `JetBrainsMono-OFL.txt`.

Обе — SIL Open Font License 1.1 без зарезервированных названий. Статические начертания нарезаны из вариативных `Onest[wght].ttf` и `JetBrainsMono[wght].ttf` репозитория google/fonts: Flutter не выбирает ось `wght` по `FontWeight`.

```bash
pip install fonttools
fonttools varLib.instancer "Onest[wght].ttf" wght=600 --update-name-table -o Onest-SemiBold.ttf
```

Onest — 400, 500, 600, 700; JetBrains Mono — 500, 700 (`docs/design/tokens.json`). Новое начертание — добавить файл сюда и в `pubspec.yaml`.
