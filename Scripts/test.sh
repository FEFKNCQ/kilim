#!/bin/bash
# Headless checks for local verification: build, language completeness, audio sanity, and a physics/render smoke test.
set -euo pipefail
cd "$(dirname "$0")/.."

swift build -c release
BIN=.build/release/Kilim

echo "== languages =="; "$BIN" --langtest | head -1
echo "== audio =="
AUDIO="$("$BIN" --audiotest)"
echo "$AUDIO" | tail -5
if echo "$AUDIO" | grep -q "nan=true"; then echo "NaN in audio output"; exit 1; fi
echo "== selftest ==";  OUT="$(mktemp -d)"; "$BIN" --selftest "$OUT" | tail -3; ls "$OUT" | head -3
echo "all checks passed"
