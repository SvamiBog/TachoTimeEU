# Сервер лицензий — настройка и переменные

Сервер выдаёт приложению подписанный токен Premium (уровень 3 защиты) и передаёт зашифрованные данные при переносе на другое устройство. Что делает приложение и зачем всё это — [docs/premium.md](../premium.md).

Стек любой. Нужно:
- HTTPS;
- БД: одноразовые challenge, ключи App Attest, переносы;
- хранилище для файлов переноса — та же БД или S3-совместимое;
- хранилище секретов на хостинге (переменные окружения не в git).

Шаблон переменных — [license-server.env.example](license-server.env.example).

## 1. Что подготовить

- Приложение в Google Play Console (хотя бы на треке внутреннего тестирования).
- Проект в Google Cloud (можно тот же, что для Firebase).
- Apple Developer Program, приложение в App Store Connect.
- Проект в RevenueCat.
- Два окружения сервера: `dev` и `prod`, с **разными** ключами подписи и БД.

## 2. Ключ подписи токенов (Ed25519)

Для каждого окружения — свой ключ. Команды работают в Git Bash (OpenSSL 1.1.1+):

```bash
openssl genpkey -algorithm ed25519 -out license_prod_k1.pem
```

```bash
openssl pkey -in license_prod_k1.pem -pubout -outform DER | tail -c 32 | base64
```

- Содержимое `license_prod_k1.pem` (приватный ключ) → `LICENSE_SIGNING_KEY` в секретах хостинга. Файл после этого удалить с диска, копию хранить в менеджере паролей.
- Вторая команда печатает публичный ключ (44 символа) → в приложение, `LICENSE_PUBLIC_KEYS=k1:<ключ>` в `config/prod.json`.
- `k1` → `LICENSE_SIGNING_KID`.

> **Важно.** Dev-сервер работает с `INTEGRITY_MODE=log` и выдаёт токены даже мод-версиям. Если у dev и prod один ключ, такой токен подойдёт к prod-приложению. Поэтому в prod-сборке только prod-ключи.

Смена ключа:
1. Сгенерировать `k2`, добавить его публичный ключ в приложение: `LICENSE_PUBLIC_KEYS=k1:…,k2:…`. Выпустить обновление.
2. Когда большинство перешло на новую версию — на сервере `LICENSE_SIGNING_KEY` = `k2`, `LICENSE_SIGNING_KID=k2`, а `LICENSE_PREVIOUS_PUBLIC_KEYS=k1:…` (чтобы перенос данных принимал ещё живые токены `k1`).
3. Через `LICENSE_TTL_HOURS` убрать `k1` из `LICENSE_PREVIOUS_PUBLIC_KEYS`, в следующей версии приложения — из `LICENSE_PUBLIC_KEYS`.

## 3. RevenueCat

1. Добавить приложения Google Play и App Store, продукты €5/мес и €30/год.
2. Entitlement `premium`, привязать к нему оба продукта → `REVENUECAT_ENTITLEMENT_ID=premium`.
3. Project settings → Restore behavior: **Transfer to new App User ID**. Тогда восстановление покупки на новом телефоне снимает Premium со старого, и одну подписку нельзя держать на нескольких устройствах.
4. API keys:
   - публичные SDK-ключи (`goog_…`, `appl_…`) → в приложение, `REVENUECAT_ANDROID_KEY` и `REVENUECAT_IOS_KEY`;
   - Secret API key для API v1 (`sk_…`) → `REVENUECAT_SECRET_KEY`, только на сервер.

## 4. Google Play Integrity

1. Google Cloud Console → APIs & Services → Library → **Google Play Integrity API** → Enable.
2. Номер проекта (Project number, на главной проекта) → в приложение, `PLAY_CLOUD_PROJECT_NUMBER`.
3. Play Console → приложение → App integrity → Play Integrity API → **Link Cloud project** — выбрать этот проект.
4. Google Cloud → IAM & Admin → Service accounts → создать аккаунт → Keys → Add key → JSON. Содержимое файла → `GOOGLE_SERVICE_ACCOUNT_JSON` (можно в base64). Если расшифровка вердикта отвечает 403 — проверить, что проект привязан в Play Console.
5. Play Console → App integrity → App signing → **App signing key certificate** → SHA-256 → `ANDROID_CERT_SHA256`. В Play Console он в hex с двоеточиями, в вердикте — base64url. Сервер сравнивает байты. Сверьте с первым реальным вердиктом из внутреннего тестирования.
6. `ANDROID_PACKAGE_NAME` = applicationId приложения.
7. У Play Integrity есть суточная квота запросов — следить в Play Console, при росте запросить увеличение. Приложение запрашивает токен не чаще раза в сутки, так что квоты хватит надолго.

Проверка работает только для приложения, установленного из Google Play. Сборка, поставленная через `adb install`, получит `UNRECOGNIZED_VERSION` — это ожидаемо.

## 5. Apple App Attest

1. Apple Developer → Identifiers → App ID приложения → включить **App Attest**. В Xcode добавить capability App Attest.
2. `APPLE_TEAM_ID` — Membership details, 10 символов. `APPLE_BUNDLE_ID` — bundle ID приложения.
3. `APPLE_APP_ATTEST_ENV`: сборки из Xcode — `development`, TestFlight и App Store — `production`. Dev-сервер — `development`, prod — `production`.
4. Корневой сертификат **Apple App Attestation Root CA** (страница Apple PKI) положить в код сервера, не в переменные.
5. Минимальная версия iOS в приложении — 14 (раньше App Attest нет). На симуляторе App Attest не работает — для него dev-сервер с `INTEGRITY_MODE=log`.

Алгоритм проверки — документ Apple «Validating apps that connect to your server». Для этого сервера `clientDataHash` считается из привязки (раздел 7.2), а `appId` = `APPLE_TEAM_ID` + `.` + `APPLE_BUNDLE_ID`.

## 6. Переменные окружения

| Переменная | Обяз. | Пример | Откуда | Секрет |
|---|---|---|---|---|
| `APP_ENV` | да | `prod` | `dev` или `prod` | |
| `PORT` | | `8080` | хостинг | |
| `DATABASE_URL` | да | `postgres://…` | хостинг | да |
| `LICENSE_SIGNING_KEY` | да | PEM PKCS#8 | раздел 2 | да |
| `LICENSE_SIGNING_KID` | да | `k1` | раздел 2 | |
| `LICENSE_PREVIOUS_PUBLIC_KEYS` | | `k0:<base64>` | только при смене ключа | |
| `LICENSE_ISSUER` | да | `tachotime-license` | фиксировано | |
| `LICENSE_TTL_HOURS` | | `168` | срок токена, 7 дней | |
| `CHALLENGE_TTL_SECONDS` | | `300` | | |
| `INTEGRITY_MODE` | да | `enforce` | `enforce` в prod, `log` в dev | |
| `RATE_LIMIT_PER_INSTALL_PER_HOUR` | | `20` | | |
| `REVENUECAT_SECRET_KEY` | да | `sk_…` | раздел 3 | да |
| `REVENUECAT_ENTITLEMENT_ID` | да | `premium` | раздел 3 | |
| `ANDROID_PACKAGE_NAME` | да | applicationId | раздел 4 | |
| `ANDROID_CERT_SHA256` | да | `AB:CD:…` | раздел 4 | |
| `GOOGLE_SERVICE_ACCOUNT_JSON` | да | `{…}` или base64 | раздел 4 | да |
| `PLAY_INTEGRITY_REQUIRE_DEVICE` | | `none` | `none` / `basic` / `device` | |
| `APPLE_TEAM_ID` | да | `ABCDE12345` | раздел 5 | |
| `APPLE_BUNDLE_ID` | да | bundle ID | раздел 5 | |
| `APPLE_APP_ATTEST_ENV` | да | `production` | раздел 5 | |
| `TRANSFER_TTL_HOURS` | | `24` | | |
| `TRANSFER_MAX_BYTES` | | `10485760` | 10 МБ | |
| `S3_ENDPOINT`, `S3_BUCKET`, `S3_ACCESS_KEY_ID`, `S3_SECRET_ACCESS_KEY` | если файлы в S3 | | хостинг | ключи — да |

`INTEGRITY_MODE`:
- `enforce` — не прошёл проверку подлинности → `403`, токена нет.
- `log` — проверка выполняется и пишется в лог, но токен выдаётся (с `att: "unverified"`). Только для dev. Можно временно включить в prod на первые дни после релиза, чтобы оценить ложные отказы, — но пока он включён, уровень 3 не защищает.

`PLAY_INTEGRITY_REQUIRE_DEVICE` — требование к устройству. По умолчанию `none`: проверяется только, что приложение настоящее. У водителей много телефонов с root и кастомными прошивками, поэтому ужесточать — только по данным логов.

Различия окружений:

| | dev | prod |
|---|---|---|
| Ключ подписи | свой | свой |
| `INTEGRITY_MODE` | `log` | `enforce` |
| `APPLE_APP_ATTEST_ENV` | `development` | `production` |
| БД | своя | своя |
| RevenueCat | общий проект, покупки sandbox | общий проект |

## 7. API

Все тела — JSON, кроме файлов переноса. Ошибки: `{ "error": "<код>", "message": "<текст для лога>" }`.

| Код | HTTP | Что делает приложение |
|---|---|---|
| `bad_request` | 400 | ошибка в приложении, отправить в crash reporting |
| `token_invalid` | 401 | запросить новый токен |
| `not_entitled` | 402 | удалить токен, Premium выключен |
| `integrity_failed` | 403 | оставить текущий токен до срока, показать «Установите приложение из Google Play / App Store» |
| `not_found` | 404 | перенос истёк или уже удалён |
| `challenge_invalid` | 409 | запросить challenge заново |
| `attest_required` | 409 | iOS: создать новый ключ App Attest и пройти attestation |
| `payload_too_large` | 413 | сообщить пользователю |
| `rate_limited` | 429 | повторить позже |
| `upstream_unavailable` | 503 | Google, Apple или RevenueCat недоступны — оставить токен, повторить позже |

### 7.1. `POST /v1/license/challenge`

```json
{ "installId": "3f1c…" }
```

Ответ `200`:

```json
{ "challenge": "<32 случайных байта, base64url>", "expiresAt": "2026-09-24T12:05:00Z" }
```

Сервер хранит `challenge` вместе с `installId` `CHALLENGE_TTL_SECONDS`. Challenge одноразовый.

### 7.2. `POST /v1/license/token`

Привязка запроса — строка, которую считают и приложение, и сервер:

```
binding = "tachotime-license/v1|" + challenge + "|" + installId + "|" + appUserId + "|" + platform
```

- Android: `requestHash = base64url(SHA-256(UTF-8(binding)))` без `=` — передаётся в стандартный запрос Play Integrity.
- iOS: `clientDataHash = SHA-256(UTF-8(binding))` (32 байта) — передаётся в `attestKey` или `generateAssertion`.

Запрос Android:

```json
{
  "platform": "android",
  "installId": "3f1c…",
  "appUserId": "$RCAnonymousID:…",
  "challenge": "…",
  "appVersion": "1.0.0+12",
  "android": { "integrityToken": "…" }
}
```

Запрос iOS — первый раз с `attestation`, дальше с `assertion`:

```json
{
  "platform": "ios",
  "installId": "3f1c…",
  "appUserId": "$RCAnonymousID:…",
  "challenge": "…",
  "appVersion": "1.0.0+12",
  "ios": { "keyId": "…", "attestation": "<base64>" }
}
```

```json
{ "ios": { "keyId": "…", "assertion": "<base64>" } }
```

Что делает сервер, по порядку:

1. Проверяет поля и лимит запросов для `installId`.
2. Находит challenge: есть, не истёк, выдан этому `installId`. Удаляет его сразу, даже если дальше будет отказ.
3. Считает `binding` и хеш.
4. Проверяет подлинность приложения.
   - **Android.** `POST https://playintegrity.googleapis.com/v1/{ANDROID_PACKAGE_NAME}:decodeIntegrityToken` с OAuth сервисного аккаунта (scope `https://www.googleapis.com/auth/playintegrity`). В ответе `tokenPayloadExternal`:
     - `requestDetails.requestPackageName` = `ANDROID_PACKAGE_NAME`;
     - `requestDetails.requestHash` = посчитанный хеш;
     - `requestDetails.timestampMillis` не старше `CHALLENGE_TTL_SECONDS`;
     - `appIntegrity.appRecognitionVerdict` = `PLAY_RECOGNIZED`;
     - `appIntegrity.certificateSha256Digest` содержит `ANDROID_CERT_SHA256`;
     - `deviceIntegrity.deviceRecognitionVerdict` — по `PLAY_INTEGRITY_REQUIRE_DEVICE`.
   - **iOS, attestation.** Проверка по документу Apple: цепочка до Apple App Attestation Root CA, nonce в расширении сертификата, `keyId`, `rpIdHash` от `appId`, счётчик 0, `aaguid` по `APPLE_APP_ATTEST_ENV`. Сохранить `keyId`, публичный ключ, счётчик, `installId`.
   - **iOS, assertion.** Найти `keyId` этого `installId` (нет — `attest_required`), проверить подпись, `rpIdHash`, счётчик больше сохранённого. Обновить счётчик.
   - Не прошло: при `enforce` — `403 integrity_failed`, при `log` — записать в лог и продолжить.
5. Проверяет подписку: `GET https://api.revenuecat.com/v1/subscribers/{appUserId}` (URL-кодировать), заголовок `Authorization: Bearer {REVENUECAT_SECRET_KEY}`. Premium активен, если в `subscriber.entitlements[REVENUECAT_ENTITLEMENT_ID]` поле `expires_date` пустое или в будущем. Нет — `402 not_entitled`.
6. Считает срок токена: `now + LICENSE_TTL_HOURS`. Если продление выключено (`unsubscribe_detected_at` или `billing_issues_detected_at` у подписки в `subscriber.subscriptions[product_identifier]`) — не позже `expires_date`.
7. Подписывает токен, отвечает `200`:

```json
{ "token": "<JWT>", "expiresAt": "2026-10-01T12:00:00Z" }
```

### 7.3. Формат токена

JWT, подпись EdDSA (Ed25519).

Заголовок:

```json
{ "alg": "EdDSA", "typ": "JWT", "kid": "k1" }
```

Данные:

```json
{
  "iss": "tachotime-license",
  "sub": "$RCAnonymousID:…",
  "ins": "3f1c…",
  "plt": "android",
  "ent": ["premium"],
  "att": "play",
  "iat": 1790000000,
  "exp": 1790604800
}
```

`att`: `play`, `appattest` или `unverified` (только при `INTEGRITY_MODE=log`).

### 7.4. Перенос данных

`POST /v1/transfer` — загрузить. Заголовки `Authorization: Bearer <токен>`, `Content-Type: application/octet-stream`, тело — шифротекст до `TRANSFER_MAX_BYTES`.

Сервер проверяет подпись токена (текущий ключ или `LICENSE_PREVIOUS_PUBLIC_KEYS`), `iss`, `exp`, `premium` в `ent`. Ответ `201`:

```json
{ "transferId": "<16 случайных байт, base64url>", "expiresAt": "2026-09-25T12:00:00Z" }
```

`GET /v1/transfer/{transferId}` — скачать. Токен не нужен: на новом устройстве подписки может ещё не быть, а без ключа из QR-кода данные бесполезны. Ответ `200` с телом-шифротекстом или `404`.

`DELETE /v1/transfer/{transferId}` — приложение вызывает после успешного импорта. Если не вызвало — сервер удаляет через `TRANSFER_TTL_HOURS`.

### 7.5. `GET /health`

`200` без тела — для мониторинга хостинга.

## 8. Какие данные хранятся

| Что | Поля | Срок |
|---|---|---|
| Challenge | challenge, installId, expiresAt | `CHALLENGE_TTL_SECONDS` |
| Ключи App Attest | keyId, installId, публичный ключ, счётчик, lastUsedAt | удалять через 180 дней без использования |
| Переносы | transferId, шифротекст, размер, expiresAt | до `DELETE` или `TRANSFER_TTL_HOURS` |
| Логи | итог проверки, хеш installId, версия приложения, платформа | 30 дней |

`appUserId` и данные журнала в открытом виде сервер не хранит. Это стоит отразить в политике конфиденциальности.

## 9. Безопасность

- Секреты (`LICENSE_SIGNING_KEY`, `REVENUECAT_SECRET_KEY`, `GOOGLE_SERVICE_ACCOUNT_JSON`, `DATABASE_URL`, `S3_*`) — только в хранилище секретов хостинга. Файлы `.env` — не в git.
- В логи не писать токены лицензии, токены Play Integrity, attestation, assertion и `appUserId`.
- Только HTTPS. Привязка к сертификату сервера в приложении не нужна: подделать токен без приватного ключа нельзя.
- Часы сервера синхронизированы (NTP) — от них зависят сроки токенов и challenge.
- Резервные копии БД. Если ключи App Attest потеряны, iOS-устройства получат `attest_required` и пройдут attestation заново.

## 10. Проверка перед релизом

- [ ] У dev и prod разные ключи подписи. В prod-сборке приложения только prod-ключи.
- [ ] В prod `INTEGRITY_MODE=enforce`, `APPLE_APP_ATTEST_ENV=production`.
- [ ] Установка с внутреннего тестирования Google Play → токен выдан.
- [ ] Тот же APK через `adb install` → `403 integrity_failed`.
- [ ] Пересобранный и переподписанный APK → `403 integrity_failed`.
- [ ] Сборка из TestFlight → токен выдан.
- [ ] Покупка в sandbox → токен выдан. Отмена или возврат → при следующем запросе `402`, Premium выключен.
- [ ] Перенос: загрузка с токеном → скачивание на втором устройстве → импорт → `DELETE`.
- [ ] Загрузка без токена или с просроченным → `401`.
- [ ] Сервер выключен → приложение работает с Premium до срока токена.
- [ ] В логах нет токенов и `appUserId`.
