<div align="center">

<img src="../images/icon.png" width="96" alt="Kilim">

# Kilim

**Un tappeto con fisica del tessuto per la scrivania del tuo macOS.**
Trascinalo, piegalo, arrotolalo – e spazza sotto di esso le icone disordinate del desktop.

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](../../LICENSE)
![macOS 13+](https://img.shields.io/badge/macOS-13%2B-black?logo=apple)
[![Sponsor](https://img.shields.io/badge/sponsor-%E2%99%A5-ea4aaa?logo=githubsponsors)](https://github.com/sponsors/yusufyilmazfr)

[Scarica l'ultima versione](https://github.com/yusufyilmazfr/kilim/releases/latest)

[Türkçe](README.tr.md) · [English](../../README.md) · [Kurdî](README.ku.md) · [Español](README.es.md) · [Français](README.fr.md) · [Deutsch](README.de.md) · [Português](README.pt.md) · **Italiano** · [Nederlands](README.nl.md) · [Polski](README.pl.md) · [Русский](README.ru.md) · [中文](README.zh.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [हिन्दी](README.hi.md) · [বাংলা](README.bn.md) · [العربية](README.ar.md) · [فارسی](README.fa.md) · [اردو](README.ur.md) · [Bahasa Indonesia](README.id.md) · [Tiếng Việt](README.vi.md)

<img src="../images/demo-fold.jpg" width="32%" alt=""> <img src="../images/demo-roll.jpg" width="32%" alt=""> <img src="../images/demo-night.jpg" width="32%" alt="">

</div>

---

## Funzionalità

- **Vera fisica del tessuto** – afferra, tira, piega e lancia il tappeto.
- **Nasconde le icone del desktop** – dove ci sono le icone compaiono rigonfiamenti che le seguono mentre le trascini.
- **Modalità sbirciata** – tieni premuto ⌥ Option (configurabile): il tappeto diventa trasparente e puoi cliccare sulle icone.
- **Arrotola** – doppio clic per arrotolare il tappeto, ancora doppio clic per srotolarlo.
- **16 motivi** – persiano, turco, curdo, egizio, berbero, kazako, cinese, Santa Sofia, İznik, selgiuchide… e **la tua foto** tessuta come tappeto.
- **Luce di giorno e di notte** – colore e ombra seguono l'ora del giorno.
- Suoni procedurali di fruscio e impatto (nessun file audio), più monitor, 21 lingue.
- Leggero e riservato: nessun accesso alla rete, nessuna analisi.

## Motivi dei tappeti

Tutti i motivi sono dipinti dal codice all'avvio; non ci sono immagini incluse. Con **Il mio tappeto…** puoi tessere qualsiasi foto in un tappeto con bordo.

<div align="center">
<img src="../images/rugs/kashan.jpg" width="19%" alt="Kashan"> <img src="../images/rugs/turk.jpg" width="19%" alt="Turkish"> <img src="../images/rugs/kurd.jpg" width="19%" alt="Kurdish"> <img src="../images/rugs/egypt.jpg" width="19%" alt="Egypt"> <img src="../images/rugs/iznik.jpg" width="19%" alt="Iznik">
</div>

## Installazione

```sh
curl -fsSL https://raw.githubusercontent.com/yusufyilmazfr/kilim/main/Scripts/install.sh | bash
```

1. Scarica `Kilim-<versione>.zip` da [Releases](https://github.com/yusufyilmazfr/kilim/releases/latest).
2. Decomprimi e trascina **Kilim.app** in `Applicazioni`.
3. Al primo avvio **clic destro → Apri** (l'app non è notarizzata) oppure: `xattr -dr com.apple.quarantine /Applications/Kilim.app`
4. Kilim vive nella barra dei menu (nessuna icona nel Dock). Se macOS chiede di controllare il **Finder**, premi **OK**: serve solo a leggere la posizione delle icone.

Per compilare dal sorgente bastano macOS 13+ e gli Xcode Command Line Tools:

```sh
git clone https://github.com/yusufyilmazfr/kilim.git
cd kilim
make run
```

## Uso

| Azione | Risultato |
|---|---|
| Trascinare il tappeto | Afferrarlo, portarlo o piegarlo |
| Doppio clic | Arrotola / srotola |
| Tenere premuto ⌥ Option | Sbirciata: tappeto trasparente, i clic raggiungono le icone |
| Rilasciare un'immagine sull'icona della barra dei menu | Tessere il tuo tappeto |
| Icona della barra dei menu | Motivo, luce, suono, lingua, apri al login, tasto sbirciata |

## Privacy e permessi

- Nessun accesso alla rete, nessuna telemetria, nessun account.
- Il permesso **Automazione → Finder** serve solo a leggere la posizione delle icone; senza, il tappeto funziona ma senza rigonfiamenti.
- L'immagine del tuo tappeto personalizzato resta solo in locale (`~/Library/Application Support/Kilim/`).

## Supporto

- Bug e richieste: [Issues](https://github.com/yusufyilmazfr/kilim/issues/new/choose)
- Domande e idee: [Discussions](https://github.com/yusufyilmazfr/kilim/discussions)
- Kilim è gratuito. Se ti piace, puoi sostenerlo su [GitHub Sponsors](https://github.com/sponsors/yusufyilmazfr).
- Anche una stella al repository aiuta molto!

## Contribuire

Nuovi motivi, traduzioni e correzioni sono benvenuti. Leggi prima [CONTRIBUTING.md](../../CONTRIBUTING.md) (in inglese).

## Licenza

[MIT](../../LICENSE) © 2026 Yusuf Yılmaz

---

<sub>Per risoluzione dei problemi, architettura e roadmap vedi il [README in inglese](../../README.md).</sub>
