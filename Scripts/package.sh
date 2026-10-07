#!/bin/bash
# Builds a universal (Apple silicon + Intel) app and zips it for a GitHub release: dist/Kilim-<version>.zip (+ SHA-256).
set -euo pipefail
cd "$(dirname "$0")/.."

UNIVERSAL=1 "$(dirname "$0")/build.sh"
VERSION="$(tr -d '[:space:]' < VERSION)"
mkdir -p dist
ZIP="dist/Kilim-$VERSION.zip"
rm -f "$ZIP"
ditto -c -k --keepParent build/Kilim.app "$ZIP"
( cd dist && shasum -a 256 "Kilim-$VERSION.zip" | tee "Kilim-$VERSION.zip.sha256" )
echo "OK -> $ZIP"
