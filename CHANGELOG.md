# Changelog

All notable changes to this project are documented here.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the project follows [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- Rug size menu (S / M / L / XL) that resizes the rug in place.
- `make package` now builds a universal binary (Apple silicon + Intel).
- One-line installer (`Scripts/install.sh`) that downloads the latest release, clears quarantine and launches the app.

## [1.0.0] - 2026-10-07

First public release.

### Added
- Cloth‑simulated rug (44×30 position‑based Verlet cloth) that can be dragged, pulled, folded and tossed.
- Desktop icons are hidden under the rug; bumps appear where the icons are and follow icons while dragged.
- Peek mode with a configurable key (⌥ Option / ⇧ Shift / ⌘ Command); the rug turns into a ghost and lets clicks through.
- Double‑click to roll the rug up and unroll it.
- 15 procedurally painted rug patterns (Kashan, Isfahan, Tabriz, Turkmen, Kilim, Turkish, Kurdish, Ancient Egypt, Khayamiya,
  Beni Ourain, Kazak, Chinese, Ayasofya, İznik, Seljuk) plus a custom rug woven from your own picture.
- Day / evening / night lighting with automatic time‑of‑day mode.
- Procedural rustle and thump sounds (can be muted).
- Multi‑monitor support.
- 21 UI languages.
- Menu‑bar app with launch‑at‑login, sponsor link and drop‑target for images.

### Changed
- Project renamed from the internal prototype name to **Kilim**; sources reorganised into modules, build scripts moved to `Scripts/`.

[Unreleased]: https://github.com/yusufyilmazfr/kilim/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/yusufyilmazfr/kilim/releases/tag/v1.0.0
