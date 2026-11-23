#!/bin/sh
# Scatta le quattro tavole del carosello a 1080x1350 (il formato 4:5 di Instagram).
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
QUI="$(cd "$(dirname "$0")" && pwd)"
for n in 1 2 3 4; do
  "$CHROME" --headless --disable-gpu --hide-scrollbars \
    --window-size=1080,1350 --force-device-scale-factor=1 \
    --screenshot="$QUI/nuvole-$n.png" \
    --virtual-time-budget=2500 \
    "file://$QUI/genera.html?n=$n" 2>/dev/null
  echo "nuvole-$n.png"
done
