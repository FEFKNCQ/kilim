<div align="center">

<img src="../images/icon.png" width="96" alt="Kilim">

# Kilim

**Een kleed met stoffenfysica voor je macOS-bureaublad.**
Sleep het, vouw het, rol het op – en veeg je rommelige bureaubladiconen eronder.

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](../../LICENSE)
![macOS 13+](https://img.shields.io/badge/macOS-13%2B-black?logo=apple)
[![Sponsor](https://img.shields.io/badge/sponsor-%E2%99%A5-ea4aaa?logo=githubsponsors)](https://github.com/sponsors/yusufyilmazfr)

[Download de nieuwste versie](https://github.com/yusufyilmazfr/kilim/releases/latest)

[Türkçe](README.tr.md) · [English](../../README.md) · [Kurdî](README.ku.md) · [Español](README.es.md) · [Français](README.fr.md) · [Deutsch](README.de.md) · [Português](README.pt.md) · [Italiano](README.it.md) · **Nederlands** · [Polski](README.pl.md) · [Русский](README.ru.md) · [中文](README.zh.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [हिन्दी](README.hi.md) · [বাংলা](README.bn.md) · [العربية](README.ar.md) · [فارسی](README.fa.md) · [اردو](README.ur.md) · [Bahasa Indonesia](README.id.md) · [Tiếng Việt](README.vi.md)

<img src="../images/demo-fold.jpg" width="32%" alt=""> <img src="../images/demo-roll.jpg" width="32%" alt=""> <img src="../images/demo-night.jpg" width="32%" alt="">

</div>

---

## Functies

- **Echte stoffenfysica** – pak, trek, vouw en gooi het kleed.
- **Verbergt bureaubladiconen** – waar iconen liggen ontstaan bulten die het icoon volgen terwijl je het sleept.
- **Gluurmodus** – houd ⌥ Option (instelbaar) ingedrukt: het kleed wordt doorzichtig en je kunt op de iconen klikken.
- **Oprollen** – dubbelklik om het kleed op te rollen, nogmaals dubbelklikken om uit te rollen.
- **16 patronen** – Perzisch, Turks, Koerdisch, Egyptisch, Berber, Kazachs, Chinees, Hagia Sophia, İznik, Seltsjoeks… en **je eigen foto** geweven tot kleed.
- **Dag- en nachtlicht** – kleur en schaduw volgen het tijdstip van de dag.
- Procedurele ritsel- en plofgeluiden (geen audiobestanden), meerdere monitoren, 21 talen.
- Licht en privé: geen netwerktoegang, geen analyse.

## Kleedpatronen

Alle patronen worden bij het starten met code geschilderd; er zijn geen afbeeldingen meegeleverd. Met **Mijn kleed…** weef je elke foto tot een kleed met rand.

<div align="center">
<img src="../images/rugs/kashan.jpg" width="19%" alt="Kashan"> <img src="../images/rugs/turk.jpg" width="19%" alt="Turkish"> <img src="../images/rugs/kurd.jpg" width="19%" alt="Kurdish"> <img src="../images/rugs/egypt.jpg" width="19%" alt="Egypt"> <img src="../images/rugs/iznik.jpg" width="19%" alt="Iznik">
</div>

## Installatie

```sh
curl -fsSL https://raw.githubusercontent.com/yusufyilmazfr/kilim/main/Scripts/install.sh | bash
```

1. Download `Kilim-<versie>.zip` van [Releases](https://github.com/yusufyilmazfr/kilim/releases/latest).
2. Pak uit en sleep **Kilim.app** naar `Programma's`.
3. Bij de eerste start **rechtsklik → Open** (de app is niet genotariseerd) of voer uit: `xattr -dr com.apple.quarantine /Applications/Kilim.app`
4. Kilim leeft in de menubalk (geen Dock-icoon). Vraagt macOS of Kilim de **Finder** mag bedienen, klik dan op **OK** – dit wordt alleen gebruikt om iconposities te lezen.

Om zelf te bouwen volstaan macOS 13+ en de Xcode Command Line Tools:

```sh
git clone https://github.com/yusufyilmazfr/kilim.git
cd kilim
make run
```

## Gebruik

| Actie | Resultaat |
|---|---|
| Kleed slepen | Vastpakken, dragen of vouwen |
| Dubbelklik | Op- / uitrollen |
| ⌥ Option ingedrukt houden | Gluren: kleed doorzichtig, klikken gaan naar de iconen |
| Afbeelding op het menubalkicoon laten vallen | Je eigen kleed weven |
| Menubalkicoon | Patroon, licht, geluid, taal, openen bij inloggen, gluurtoets |

## Privacy en rechten

- Geen netwerktoegang, geen telemetrie, geen accounts.
- De toestemming **Automatisering → Finder** dient alleen om iconposities te lezen; zonder werkt het kleed gewoon, maar zonder bulten.
- De afbeelding van je eigen kleed blijft lokaal (`~/Library/Application Support/Kilim/`).

## Ondersteuning

- Bugs en wensen: [Issues](https://github.com/yusufyilmazfr/kilim/issues/new/choose)
- Vragen en ideeën: [Discussions](https://github.com/yusufyilmazfr/kilim/discussions)
- Kilim is gratis. Vind je het leuk, steun het dan via [GitHub Sponsors](https://github.com/sponsors/yusufyilmazfr).
- Een ster voor de repository helpt ook enorm!

## Bijdragen

Nieuwe patronen, vertalingen en bugfixes zijn welkom. Lees eerst [CONTRIBUTING.md](../../CONTRIBUTING.md) (Engels).

## Licentie

[MIT](../../LICENSE) © 2026 Yusuf Yılmaz

---

<sub>Voor probleemoplossing, architectuur en roadmap zie de [Engelse README](../../README.md).</sub>
