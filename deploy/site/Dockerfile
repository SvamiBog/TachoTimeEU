# Сайт TachoGo на Railway: Caddy отдаёт папку public/ — собранный site/
# (лендинг, политика, подписанный bans/v1.json). Папку собирает workflow
# «Сайт» (.github/workflows/site.yml) и выкладывает её вместе с этим файлом
# командой railway up; из git напрямую Railway сервис не собирает.
FROM caddy:2.8.4-alpine
COPY Caddyfile /etc/caddy/Caddyfile
COPY public /srv
