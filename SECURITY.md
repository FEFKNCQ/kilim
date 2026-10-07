# Security Policy

## Supported versions

Only the latest release receives security fixes.

| Version | Supported |
|---------|-----------|
| latest release | |
| older releases | |

## Reporting a vulnerability

**Please do not open a public issue for security problems.**

Use GitHub's private reporting: **Security → [Report a vulnerability](https://github.com/yusufyilmazfr/kilim/security/advisories/new)**.

Please include what you found, how to reproduce it, the affected version and macOS version. You can expect an acknowledgement
within a few days, and we will keep you informed until a fix is released. We are happy to credit you in the release notes.

## What Kilim does on your Mac

Useful context when assessing a report:

- No network access, no telemetry, no auto-update.
- Runs `/usr/bin/osascript` with a fixed AppleScript to read Finder desktop icon positions (requires the Automation → Finder permission).
- Reads a user‑chosen image file to weave a custom rug; a downsized copy is stored in `~/Library/Application Support/Kilim/`.
- Draws transparent, click‑through windows above the desktop; it never records the screen or reads keystrokes
  (it only polls the state of modifier keys and mouse buttons for the peek feature).
