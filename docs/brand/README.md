# Фирменный комплект TachoGo

Логотип, знак и иконки, версия 1.0, октябрь 2026. Макет с правилами: https://claude.ai/artifact/K7nuQSWi39kfa2pzKfQfzV. Файлы здесь — оригиналы из него; ресурсы Android нарисованы по ним.

## Знак

Шкала тахографа с открытым сектором — буква G; стрелка проходит через разрыв и выходит за шкалу — «поехали». Построение в координатах 100 × 100 с центром (50, 50):

| Элемент | Построение |
|---|---|
| Кольцо | радиус 29, толщина 11 — модуль X |
| Разрыв | от 8° до 62°, концы скруглены |
| Стрелка | ось 35°, длина 39 — выходит за внешний край кольца |
| Ось | Ø 15, отверстие Ø 4,8 |

- Охранное поле вокруг логотипа — не меньше 2X.
- Минимальный размер: знак — 16 px (4 мм), горизонтальный логотип — 100 px (25 мм), вертикальный — 56 px (15 мм).
- Нельзя: растягивать и сжимать, менять цвета, поворачивать, ставить на пёстрый фон.

## Цвета и шрифты

| Цвет | Значение | Где |
|---|---|---|
| Navy | `#0F1E33` | фон иконки и сплэша, текст логотипа на светлом |
| Amber | `#FFB020` | шкала на тёмном, «Go» |
| Amber Deep | `#E89A00` | стрелка на светлом |
| White | `#FFFFFF` | стрелка на тёмном |
| Paper | `#F4F3EF` | светлые фоны |

Цвета бренда — для иконок, сплэша, сайта и магазина. Интерфейс приложения красится только токенами `docs/design/tokens.json` (`app/lib/core/theme/`).

Надпись в логотипе — Unbounded Bold, в файлах переведена в кривые; шрифт интерфейса — Onest.

## Файлы

| Файл | Что |
|---|---|
| `logo/tachogo-horizontal.svg`, `-dark.svg` | Горизонтальный логотип — основной; на светлом и на тёмном фоне |
| `logo/tachogo-vertical.svg`, `-dark.svg` | Вертикальный — для квадратных форматов и сплэша |
| `logo/tachogo-horizontal-black.svg`, `-white.svg` | Одним цветом: чёрный — печать, факс, гравировка; белый — фото, плёнка на кабину |
| `mark/mark.svg`, `-dark.svg`, `-mono.svg` | Знак на светлом, на тёмном и одним цветом |
| `icons/play-store-512.png` | Значок страницы в Google Play: квадрат без скругления, углы скругляет сам Play |
| `icons/favicon.svg`, `favicon-32.png` | Значок сайта |
| `icons/ios-1024.png`, `-dark.png`, `-tinted.png` | Иконки iOS: стандартная, тёмная и тонированная (iOS 18) — для iOS-версии, Фаза 8 |

## Где используется

| Где | Файл | Как |
|---|---|---|
| Иконка, Android 8+ | `app/android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml` | Адаптивная: фон `@color/brand_navy` (`values/colors.xml`), знак `drawable/ic_launcher_foreground.xml`. Знак 100 × 100 растянут на видимые 72 dp холста 108 dp (×0,72), конец стрелки — в безопасном круге 66 dp; форму вырезает лаунчер |
| Тематические значки, Android 13+ | `drawable/ic_launcher_monochrome.xml` | Тот же знак одним цветом, система красит его в цвета обоев |
| Иконка, Android 7 | `mipmap-*dpi/ic_launcher.png`, 48–192 px | Скруглённый квадрат Navy со знаком, отрисован из `mark/mark-dark.svg` |
| Значок уведомлений | `drawable/ic_stat_tachogo.xml` | Белый знак 22 dp на холсте 24 dp: Android рисует значок по альфа-каналу. Уведомления о лимитах (`NotificationPlatform.smallIcon`) и сервиса автоопределения (`TrackingPlatform.notificationIcon`, meta-data в `AndroidManifest.xml`) |
| Сплэш | `drawable/launch_background.xml`, `values-v31/styles.xml` | Знак на Navy, в светлой и тёмной теме одинаково; до Android 12 — окно запуска, с 12 — SplashScreen API |
| Google Play | `icons/play-store-512.png` | Загружается в Play Console (`docs/beta/play-console.md`) |
| Сайт | `site/favicon.svg`, `site/favicon-32.png`, `site/logo.svg`, `site/logo-dark.svg` | Значок вкладки на всех страницах, логотип на главной — по теме браузера |

Иконки и сплэш проверяет тест CI-11 (`app/test/config/platform_config_test.dart`), значок уведомлений в итоговом манифесте — CI-06 (`app/tool/check_android_manifest.dart`). В `app/ios/` пока иконки шаблона Flutter: iOS приостановлен до релиза.
