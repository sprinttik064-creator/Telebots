# Автодома · Турция vs США — платформа сравнения

## Файлы
- `avtodom-platforma-local.html` — платформа сравнения рынков (одна страница, без сборки)
- `download_photos.sh` — опционально: скачивает фото вендоров в `photos/` для офлайн-режима

## Как открыть
Просто открыть `avtodom-platforma-local.html` в браузере — всё работает сразу:
фото подгружаются напрямую с сайтов вендоров (Blacksford, Travellers Autobarn,
Let's Go Camper, Maceravan, Nomadic) по проверенным прямым URL.

Каскад источников каждого фото: `photos/…` локально → CDN вендора → встроенная
иллюстрация. Ничего не ломается ни офлайн, ни при смерти ссылки.

## Фото
Все карточки уже с фото — файлы лежат в `photos/` в репозитории:
- `ct.jpg` — Campervan Turkey (закат с шарами Каппадокии), `rct.jpg`,
  `kk.jpg` — выбраны из кандидатов в `photos/src-*`;
- `crt.webp` — hero с сайта CampervanRentalTurkey (их SPA грузит фото машин
  из API, поэтому Wix-скрейп скрипта там пуст);
- остальные — скачаны по прямым URL из `download_photos.sh`.

Заменить кадр: выбрать другой файл из `photos/src-ct` / `src-rct` / `src-kk`
и скопировать поверх (`cp photos/src-ct/ct-06.jpg photos/ct.jpg`).
Обновить всё заново: `bash download_photos.sh` (нужен доступ в интернет —
локально или в окружении с Network access: Full/Custom; запасной путь —
workflow `download-photos.yml` в GitHub Actions).

## Хостинг (Vercel / Netlify) — в 2 клика

Репозиторий уже готов к статик-деплою: `netlify.toml` и `vercel.json` настроены
так, что корневой URL сразу отдаёт платформу (rewrite на
`avtodom-platforma-local.html`, без видимого редиректа), фото едут из `photos/`.
Сборка не нужна.

**Netlify:** [Deploy to Netlify](https://app.netlify.com/start/deploy?repository=https://github.com/sprinttik064-creator/Telebots)
→ авторизоваться в своём Netlify → Deploy. Через ~20 сек будет ссылка вида
`https://<имя>.netlify.app`.

**Vercel:** [Deploy with Vercel](https://vercel.com/new/clone?repository-url=https://github.com/sprinttik064-creator/Telebots)
→ Import → Deploy (Framework Preset: Other, всё по умолчанию). Ссылка вида
`https://<имя>.vercel.app`.

Оба варианта привязывают репозиторий: каждый `git push` в ветку
пере-деплоит сайт автоматически. Логин в Vercel/Netlify делается один раз в
браузере — токен в коде не нужен.

**GitHub Pages** (без сторонних сервисов): Settings → Pages → Build and
deployment → Source: **GitHub Actions**. Затем Actions → workflow **pages** →
Run workflow. Через ~1 мин сайт будет на
`https://sprinttik064-creator.github.io/Telebots/`.

> Любой из трёх хостингов требует ровно одно действие в браузере
> (авторизация Vercel/Netlify или включение Pages) — это граница
> безопасности площадок, автоматизировать её из кода нельзя.
> Мгновенное превью без всякой настройки уже живёт на claude.ai
> (ссылка в чате).

## Что внутри
- Котировки 60 дней — анимированный рейтинг 9 предложений
- Турция · 7 и США · 7 — карточки вендоров: фото, детали, сортировка, чекбоксы «сравнить» и модальное сравнение бок-о-бок
- Водители — каналы найма в обеих странах с ценами
- Анализ рынков — структура обоих рынков, сезонность, «что делать»
- Итог — сводная таблица бюджета

Дизайн: скругление 30px по всем элементам, плавные анимации (стаггер карточек,
рост баров, count-up цифр, переходы вкладок), уважение prefers-reduced-motion,
клавиатурная навигация, печать в PDF (все секции разворачиваются).
