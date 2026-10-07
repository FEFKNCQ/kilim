#!/bin/bash
# Installs the latest Kilim release into /Applications, clears the macOS quarantine flag and launches it.
#
#   curl -fsSL https://raw.githubusercontent.com/yusufyilmazfr/kilim/main/Scripts/install.sh | bash
#
# Options (environment variables):
#   KILIM_DEST=~/Applications   install somewhere else (default: /Applications)
#   KILIM_NO_OPEN=1             do not launch the app afterwards
# You can also pass a local zip:  Scripts/install.sh dist/Kilim-1.0.0.zip
set -euo pipefail

REPO="yusufyilmazfr/kilim"
DEST="${KILIM_DEST:-/Applications}"
APP="Kilim.app"

[ "$(uname)" = "Darwin" ] || { echo "Kilim only runs on macOS." >&2; exit 1; }

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

if [ $# -ge 1 ] && [ -f "$1" ]; then
  ZIP="$1"
else
  echo "==> Looking for the latest release…"
  URL="$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" \
        | sed -n 's/.*"browser_download_url": *"\([^"]*\.zip\)".*/\1/p' | head -1)"
  [ -n "$URL" ] || { echo "Could not find a release zip for $REPO." >&2; exit 1; }
  echo "==> Downloading $URL"
  ZIP="$TMP/Kilim.zip"
  curl -fSL --progress-bar "$URL" -o "$ZIP"
  if WANT="$(curl -fsSL "$URL.sha256" 2>/dev/null | awk '{print $1}')" && [ -n "$WANT" ]; then
    GOT="$(shasum -a 256 "$ZIP" | awk '{print $1}')"
    [ "$WANT" = "$GOT" ] || { echo "Checksum mismatch, aborting." >&2; exit 1; }
    echo "==> Checksum OK"
  fi
fi

echo "==> Installing to $DEST"
ditto -x -k "$ZIP" "$TMP/unzipped"
[ -d "$TMP/unzipped/$APP" ] || { echo "$APP not found in the archive." >&2; exit 1; }
mkdir -p "$DEST"
pkill -x Kilim 2>/dev/null || true
rm -rf "${DEST:?}/$APP"
ditto "$TMP/unzipped/$APP" "$DEST/$APP"
xattr -dr com.apple.quarantine "$DEST/$APP" 2>/dev/null || true

echo "==> Installed $DEST/$APP"
if [ -z "${KILIM_NO_OPEN:-}" ]; then
  open "$DEST/$APP"
  echo "Kilim lives in the menu bar. Allow it to control Finder when macOS asks."
fi
