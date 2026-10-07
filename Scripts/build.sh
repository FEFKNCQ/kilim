#!/bin/bash
# Builds build/Kilim.app (menu-bar app, no Dock icon) from the SwiftPM executable.
#
#   Scripts/build.sh                 ad-hoc signed release build
#   UNIVERSAL=1 Scripts/build.sh     arm64 + x86_64 binary (runs on Intel Macs too; used by package.sh)
#   SIGN_IDENTITY="Developer ID Application: …" Scripts/build.sh
#
set -euo pipefail
cd "$(dirname "$0")/.."

VERSION="$(tr -d '[:space:]' < VERSION)"
BUILD="${BUILD_NUMBER:-$(git rev-list --count HEAD 2>/dev/null || echo 1)}"
APP="build/Kilim.app"

swift build -c release
BIN=.build/release/Kilim
if [ "${UNIVERSAL:-0}" = "1" ]; then
  swift build -c release --triple x86_64-apple-macosx13.0 --scratch-path .build-x86
  lipo -create "$BIN" .build-x86/x86_64-apple-macosx/release/Kilim -output .build/Kilim-universal
  BIN=.build/Kilim-universal
fi
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
cp "$BIN" "$APP/Contents/MacOS/Kilim"
chmod +x "$APP/Contents/MacOS/Kilim"

sed -e "s/__VERSION__/$VERSION/" -e "s/__BUILD__/$BUILD/" Resources/Info.plist > "$APP/Contents/Info.plist"
[ -f Resources/AppIcon.icns ] && cp Resources/AppIcon.icns "$APP/Contents/Resources/AppIcon.icns"
for lproj in Resources/*.lproj; do cp -R "$lproj" "$APP/Contents/Resources/"; done

codesign --force --deep --sign "${SIGN_IDENTITY:--}" "$APP"
echo "OK -> $(pwd)/$APP  (v$VERSION, build $BUILD)"
