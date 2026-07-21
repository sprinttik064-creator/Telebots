#!/usr/bin/env bash
# Скачивает фото автодомов с сайтов вендоров в папку photos/
# Запуск: bash download_photos.sh  (из папки, где лежит avtodom-platforma-local.html)

UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126 Safari/537.36"
mkdir -p photos

dl () { # dl <файл> <url>
  if curl -sL --retry 2 --fail -A "$UA" -o "photos/$1" "$2"; then
    echo "OK   photos/$1"
  else
    echo "SKIP $1  ($2)"
  fi
}

echo "== 1/3 Проверенные прямые URL (вытащены из кода сайтов 21.07.2026) =="
# Blacksford — флот Winnebago/Nexus (Squarespace CDN)
dl bf-hero.jpg     "https://images.squarespace-cdn.com/content/v1/65ec940eedd8c12c02601fe8/4313518b-3768-4525-a28a-7153cb15241c/00-winnebago-rv-for-rent.jpg"
dl bf-solis.jpg    "https://images.squarespace-cdn.com/content/v1/65ec940eedd8c12c02601fe8/1715006976747-NMYJJJ8E7TQE8GTGK340/winnebago-solis-rv-rentals-01.jpg"
dl bf-29t.jpg      "https://images.squarespace-cdn.com/content/v1/65ec940eedd8c12c02601fe8/1748883061895-J3ON7726T9HRT1Z80TQ2/nexus-triumph-29T-00-motorhome-for-rent.jpg"
dl bf-sunflyer.jpg "https://images.squarespace-cdn.com/content/v1/65ec940eedd8c12c02601fe8/1772752571571-76XOFTI4T0G2VJM592MS/winnebago-sunflyer-24gg-exterior-01.jpg"
# Let's Go Camper — автодом с главной
dl lgc-hero.jpg    "https://www.letsgocamper.com/uploads/anasayfa.JPG"
# Travellers Autobarn — кемпервэны
dl tab-hero.jpg    "https://www.travellers-autobarnrv.com/wp-content/uploads/2025/10/Campervan-on-Bixby-Bridge-USA.jpg"
dl tab-miles.jpg   "https://www.travellers-autobarnrv.com/wp-content/uploads/2022/05/Unlimited-MIles-2.jpg"
dl tab-joshua.jpg  "https://www.travellers-autobarnrv.com/wp-content/uploads/2026/06/Group-of-friends-in-front-of-campervan-in-Joshua-Tree-National-Park.jpg"
# Maceravan — фото допоборудования со страницы Extralar
dl mv-kitchen.png  "https://maceravan.com/Uploads/146efcb9-06c7-4929-ab80-8e3d752484ce.png"
dl mv-camp.png     "https://maceravan.com/Uploads/d82de765-7c42-483e-9fa8-3dfd1c5f4529.png"
dl mv-scooter.png  "https://maceravan.com/Uploads/1c9660f8-7723-4ab3-aac7-64231674d7ae.png"
# Nomadic Caravan — реальные фото машины 2020 (запас: карточка вернётся, когда дадут цену)
dl nc-hero.webp    "https://nomadic-caravan.com/storage/campervan/campervan-1/nomadic-caravan-1-reel-520x380.webp"
dl nc-int.webp     "https://nomadic-caravan.com/storage/campervan/campervan-1/campervan-1-8-520x380.webp"

echo ""
echo "== 2/3 Wix-сайты: URL картинок прячутся в JSON внутри страницы — достаём grep'ом =="
wix_scrape () { # wix_scrape <код> <url>
  mkdir -p "photos/src-$1"
  curl -sL -A "$UA" "$2" \
    | grep -oE 'https://static\.wixstatic\.com/media/[A-Za-z0-9_~.\-]+\.(jpg|jpeg|png|webp)' \
    | sort -u | head -25 > "photos/src-$1/urls.txt"
  local i=0
  while read -r u; do
    i=$((i+1))
    curl -sL --retry 1 --fail -A "$UA" -o "photos/src-$1/$1-$(printf '%02d' $i).jpg" "$u" || true
  done < "photos/src-$1/urls.txt"
  echo "src-$1: $(ls photos/src-$1 | grep -c jpg) файлов из $2"
}
wix_scrape ct  "https://www.campervanturkey.com/"
wix_scrape rct "https://www.rentalcaravanturkey.com/en"
wix_scrape crt "https://campervanrentalturkey.com/"

echo ""
echo "== 3/3 KolayKaravan — обычный сайт, пробуем собрать превью объявлений =="
mkdir -p photos/src-kk
curl -sL -A "$UA" "https://www.kolaykaravan.com/karavan-kirala/istanbul" \
  | grep -oE 'https://[^" ]+\.(jpg|jpeg|png|webp)' | sort -u | head -15 > photos/src-kk/urls.txt
i=0; while read -r u; do i=$((i+1)); curl -sL --fail -A "$UA" -o "photos/src-kk/kk-$(printf '%02d' $i).jpg" "$u" || true; done < photos/src-kk/urls.txt
echo "src-kk: $(ls photos/src-kk | grep -c jpg) файлов"

echo ""
echo "================================================================"
echo "Готово. Осталось выбрать по одному лучшему кадру автодома"
echo "из папок photos/src-ct, src-rct, src-crt, src-kk и скопировать:"
echo "  cp photos/src-ct/ct-03.jpg  photos/ct.jpg     # пример"
echo "  cp photos/src-rct/rct-05.jpg photos/rct.jpg"
echo "  cp photos/src-crt/crt-02.jpg photos/crt.jpg"
echo "  cp photos/src-kk/kk-04.jpg  photos/kk.jpg"
echo "HTML уже ссылается на эти имена; где файла нет — покажет иллюстрацию."
echo "Открыть: avtodom-platforma-local.html"
