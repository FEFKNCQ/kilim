<div align="center">

<img src="../images/icon.png" width="96" alt="Kilim">

# Kilim

**Ein Teppich mit Stoffphysik für deinen macOS-Schreibtisch.**
Zieh ihn, falte ihn, roll ihn auf – und kehre deine unordentlichen Desktop-Symbole darunter.

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](../../LICENSE)
![macOS 13+](https://img.shields.io/badge/macOS-13%2B-black?logo=apple)
[![Sponsor](https://img.shields.io/badge/sponsor-%E2%99%A5-ea4aaa?logo=githubsponsors)](https://github.com/sponsors/yusufyilmazfr)

[Neueste Version herunterladen](https://github.com/yusufyilmazfr/kilim/releases/latest)

[Türkçe](README.tr.md) · [English](../../README.md) · [Kurdî](README.ku.md) · [Español](README.es.md) · [Français](README.fr.md) · **Deutsch** · [Português](README.pt.md) · [Italiano](README.it.md) · [Nederlands](README.nl.md) · [Polski](README.pl.md) · [Русский](README.ru.md) · [中文](README.zh.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [हिन्दी](README.hi.md) · [বাংলা](README.bn.md) · [العربية](README.ar.md) · [فارسی](README.fa.md) · [اردو](README.ur.md) · [Bahasa Indonesia](README.id.md) · [Tiếng Việt](README.vi.md)

<img src="../images/demo-fold.jpg" width="32%" alt=""> <img src="../images/demo-roll.jpg" width="32%" alt=""> <img src="../images/demo-night.jpg" width="32%" alt="">

</div>

---

## Funktionen

- **Echte Stoffphysik** – Teppich greifen, ziehen, falten und werfen.
- **Versteckt Desktop-Symbole** – wo Symbole liegen, entstehen Beulen, die dem Symbol beim Ziehen folgen.
- **Blick-Modus** – ⌥ Option (einstellbar) gedrückt halten: der Teppich wird durchsichtig und du kannst die Symbole anklicken.
- **Aufrollen** – Doppelklick rollt den Teppich auf, noch ein Doppelklick rollt ihn wieder aus.
- **16 Muster** – persisch, türkisch, kurdisch, ägyptisch, Berber, kasachisch, chinesisch, Hagia Sophia, İznik, seldschukisch … und **dein eigenes Foto** als gewebter Teppich.
- **Tag- und Nachtlicht** – Farbe und Schatten folgen der Tageszeit.
- Prozedurale Raschel- und Aufprallgeräusche (keine Audiodateien), mehrere Monitore, 21 Sprachen.
- Leicht und privat: kein Netzwerkzugriff, keine Analyse.

## Teppichmuster

Alle Muster werden beim Start per Code gemalt; es sind keine Bilddateien enthalten. Mit **Mein Teppich…** webst du jedes Foto zu einem Teppich mit Bordüre.

<div align="center">
<img src="../images/rugs/kashan.jpg" width="19%" alt="Kashan"> <img src="../images/rugs/turk.jpg" width="19%" alt="Turkish"> <img src="../images/rugs/kurd.jpg" width="19%" alt="Kurdish"> <img src="../images/rugs/egypt.jpg" width="19%" alt="Egypt"> <img src="../images/rugs/iznik.jpg" width="19%" alt="Iznik">
</div>

## Installation

```sh
curl -fsSL https://raw.githubusercontent.com/yusufyilmazfr/kilim/main/Scripts/install.sh | bash
```

1. Lade `Kilim-<Version>.zip` von [Releases](https://github.com/yusufyilmazfr/kilim/releases/latest) herunter.
2. Entpacken und **Kilim.app** in den Ordner `Programme` ziehen.
3. Beim ersten Start **Rechtsklick → Öffnen** (die App ist nicht notarisiert) oder: `xattr -dr com.apple.quarantine /Applications/Kilim.app`
4. Kilim lebt in der Menüleiste (kein Dock-Symbol). Fragt macOS, ob Kilim den **Finder** steuern darf, bestätige mit **OK** – das wird nur genutzt, um die Position der Symbole zu lesen.

Zum Selbstbauen genügen macOS 13+ und die Xcode Command Line Tools:

```sh
git clone https://github.com/yusufyilmazfr/kilim.git
cd kilim
make run
```

## Bedienung

| Aktion | Ergebnis |
|---|---|
| Teppich ziehen | Greifen, tragen oder falten |
| Doppelklick | Auf- / ausrollen |
| ⌥ Option halten | Blick: Teppich durchsichtig, Klicks gehen an die Symbole |
| Bild auf das Menüleistensymbol ziehen | Eigenen Teppich weben |
| Menüleistensymbol | Muster, Licht, Ton, Sprache, Start bei Anmeldung, Blick-Taste |

## Datenschutz und Berechtigungen

- Kein Netzwerkzugriff, keine Telemetrie, keine Konten.
- Die Berechtigung **Automation → Finder** dient nur dem Lesen der Symbolpositionen; ohne sie funktioniert der Teppich weiter, nur ohne Beulen.
- Das Bild deines eigenen Teppichs wird nur lokal gespeichert (`~/Library/Application Support/Kilim/`).

## Support

- Fehler und Wünsche: [Issues](https://github.com/yusufyilmazfr/kilim/issues/new/choose)
- Fragen und Ideen: [Discussions](https://github.com/yusufyilmazfr/kilim/discussions)
- Kilim ist kostenlos. Wenn es dir gefällt, kannst du es über [GitHub Sponsors](https://github.com/sponsors/yusufyilmazfr) unterstützen.
- Auch ein Stern für das Repository hilft sehr!

## Mitwirken

Neue Muster, Übersetzungen und Fehlerbehebungen sind willkommen. Bitte lies zuerst [CONTRIBUTING.md](../../CONTRIBUTING.md) (Englisch).

## Lizenz

[MIT](../../LICENSE) © 2026 Yusuf Yılmaz

---

<sub>Fehlerbehebung, Architektur und Roadmap findest du in der [englischen README](../../README.md).</sub>
