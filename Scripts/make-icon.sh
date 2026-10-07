#!/bin/bash
# Regenerates Resources/AppIcon.icns from a procedurally painted rug.
#   Scripts/make-icon.sh [theme]     (default: kashan)
set -euo pipefail
cd "$(dirname "$0")/.."

THEME="${1:-kashan}"
swift build -c release >/dev/null
MASTER="$(mktemp -d)/icon-1024.png"
.build/release/Kilim --icon "$THEME" "$MASTER"

SET="$(mktemp -d)/AppIcon.iconset"
mkdir -p "$SET"
for s in 16 32 128 256 512; do
  sips -z $s $s "$MASTER" --out "$SET/icon_${s}x${s}.png" >/dev/null
  sips -z $((s*2)) $((s*2)) "$MASTER" --out "$SET/icon_${s}x${s}@2x.png" >/dev/null
done
iconutil -c icns "$SET" -o Resources/AppIcon.icns
echo "OK -> Resources/AppIcon.icns"
