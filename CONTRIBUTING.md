# Contributing to Kilim

Thanks for taking the time to contribute! Kilim is a small, friendly project and every kind of help is welcome:
new rug patterns, translations, bug fixes, performance work, documentation, or simply a good bug report.

By participating you agree to follow our [Code of Conduct](CODE_OF_CONDUCT.md).

## Getting started

Requirements: macOS 13+, the Xcode Command Line Tools (`xcode-select --install`). Full Xcode is not needed.

```sh
git clone https://github.com/yusufyilmazfr/kilim.git
cd kilim
make run      # build build/Kilim.app and launch it
make test     # headless checks (languages, audio, physics render)
```

The project has **no third‑party dependencies**.

### Project layout

```
Sources/Kilim/
  main.swift            entry point
  App/                  menu-bar app, windows, input, menu (RugController)
  Simulation/           cloth physics (Cloth) and the roll pose (Roll)
  Rendering/            Metal renderer, lighting model, procedural rug textures
  Audio/                procedural sound synth and thump detection
  Desktop/              Finder desktop-icon polling
  Localization/         21 languages (L10n)
  Diagnostics/          headless developer modes: --selftest, --texture, --langtest, ...
Resources/              Info.plist template, app icon, localized InfoPlist strings
Scripts/                build.sh, package.sh, test.sh, make-icon.sh
docs/                   architecture notes, translated READMEs, images
```

More detail in [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

## Development workflow

1. Fork the repo and create a branch: `git checkout -b feature/my-change`.
2. Make your change. Keep it focused – one topic per pull request.
3. Run `make test` and try the change in the real app with `make run`.
4. Update the [CHANGELOG](CHANGELOG.md) under **Unreleased**.
5. Open a pull request and fill in the template.

### Handy developer commands

```sh
.build/release/Kilim --selftest /tmp/out   # render physics / lighting / roll scenarios as PNGs
.build/release/Kilim --texture             # render every rug to /tmp/kilim-tex-<theme>.png
.build/release/Kilim --custom photo.jpg    # preview a custom rug woven from a picture
.build/release/Kilim --langtest            # fail if any language is missing strings
.build/release/Kilim --audiotest           # numeric sanity check of the sound synth
KILIM_LOG=1 build/Kilim.app/Contents/MacOS/Kilim   # log to /tmp/kilim.log
```

## Code style

- Swift 5.9, 4‑space indentation, LF line endings (see [.editorconfig](.editorconfig)).
- Prefer small, well‑named functions and short doc comments (`///`) that explain *why*, not *what*.
- Keep the render loop and simulation step allocation‑free – they run every frame.
- No third‑party dependencies; use system frameworks (AppKit, Metal, CoreGraphics, AVFoundation).
- The app must stay idle when the rug is at rest. Avoid timers faster than they need to be.

## Adding a rug pattern

1. Add a case to `RugTheme` in `Sources/Kilim/Rendering/RugTexture.swift`.
2. Add a `Palette` for it in `Palette.make`.
3. Write a painter on the private `Designer` type and dispatch to it from the `switch` that selects painters.
4. Add its display name for every language in `L10n.theme(_:)` (English name is acceptable as a fallback for languages without a traditional name).
5. Run `.build/release/Kilim --texture` and look at `/tmp/kilim-tex-<yourtheme>.png`.
   Good rugs have a border, a field, a central motif and tidy corners – check that nothing overlaps or is clipped.
6. Add a downscaled JPEG to `docs/images/rugs/` and a cell to the README gallery.

Please only use patterns that are in the public domain / traditional folk art, and describe their origin in the PR.

## Translations

### App strings

All UI strings live in `Sources/Kilim/Localization/L10n.swift`. Each language is an array in the **exact order** of the `Str` enum.

- Fixing a typo: edit the string and open a PR.
- Adding a language: add a case to `Lang`, its `nativeName`, and a full array to `L10n.table`. `Kilim --langtest` must report all languages complete.
- Adding a string: add a case to the end of `Str` and append a translation to **every** language array.

### README

`README.md` (English) is the source of truth. Translations live in `docs/translations/README.<code>.md`.
When you change the English README, please update the translations you can, and note the ones you could not in your PR – maintainers
and native speakers will follow up.

## Reporting bugs

Please use the [issue templates](https://github.com/yusufyilmazfr/kilim/issues/new/choose). Include your macOS version,
the Mac model, the number of displays and – if possible – a log (`KILIM_LOG=1`).

## Releasing (maintainers)

1. Update `VERSION` and move the **Unreleased** notes in the CHANGELOG under the new version.
2. Run `make test`, then `make package`, which creates `dist/Kilim-<version>.zip` and a SHA‑256 file.
3. Tag the commit (`git tag v$(cat VERSION) && git push --tags`) and attach the zip and checksum to a new GitHub release.
