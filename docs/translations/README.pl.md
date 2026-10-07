<div align="center">

<img src="../images/icon.png" width="96" alt="Kilim">

# Kilim

**Dywan z fizyką tkaniny na pulpit Twojego macOS-a.**
Przeciągaj go, składaj, zwijaj – i zamiataj bałagan z ikon pulpitu pod spód.

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](../../LICENSE)
![macOS 13+](https://img.shields.io/badge/macOS-13%2B-black?logo=apple)
[![Sponsor](https://img.shields.io/badge/sponsor-%E2%99%A5-ea4aaa?logo=githubsponsors)](https://github.com/sponsors/yusufyilmazfr)

[Pobierz najnowszą wersję](https://github.com/yusufyilmazfr/kilim/releases/latest)

[Türkçe](README.tr.md) · [English](../../README.md) · [Kurdî](README.ku.md) · [Español](README.es.md) · [Français](README.fr.md) · [Deutsch](README.de.md) · [Português](README.pt.md) · [Italiano](README.it.md) · [Nederlands](README.nl.md) · **Polski** · [Русский](README.ru.md) · [中文](README.zh.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [हिन्दी](README.hi.md) · [বাংলা](README.bn.md) · [العربية](README.ar.md) · [فارسی](README.fa.md) · [اردو](README.ur.md) · [Bahasa Indonesia](README.id.md) · [Tiếng Việt](README.vi.md)

<img src="../images/demo-fold.jpg" width="32%" alt=""> <img src="../images/demo-roll.jpg" width="32%" alt=""> <img src="../images/demo-night.jpg" width="32%" alt="">

</div>

---

## Funkcje

- **Prawdziwa fizyka tkaniny** – chwytaj, ciągnij, składaj i rzucaj dywanem.
- **Ukrywa ikony pulpitu** – tam, gdzie leżą ikony, powstają wybrzuszenia, które podążają za ikoną podczas przeciągania.
- **Tryb podglądu** – przytrzymaj ⌥ Option (można zmienić): dywan staje się przezroczysty i możesz klikać ikony.
- **Zwijanie** – dwuklik zwija dywan, kolejny dwuklik go rozwija.
- **16 wzorów** – perski, turecki, kurdyjski, egipski, berberyjski, kazachski, chiński, Hagia Sophia, İznik, seldżucki… oraz **Twoje własne zdjęcie** utkane w dywan.
- **Światło dzienne i nocne** – kolor i cień zależą od pory dnia.
- Proceduralne dźwięki szelestu i uderzeń (bez plików audio), wiele monitorów, 21 języków.
- Lekki i prywatny: brak dostępu do sieci, brak analityki.

## Wzory dywanów

Wszystkie wzory są malowane kodem przy uruchomieniu; nie ma dołączonych obrazów. Opcją **Mój dywan…** utkasz dowolne zdjęcie w dywan z bordiurą.

<div align="center">
<img src="../images/rugs/kashan.jpg" width="19%" alt="Kashan"> <img src="../images/rugs/turk.jpg" width="19%" alt="Turkish"> <img src="../images/rugs/kurd.jpg" width="19%" alt="Kurdish"> <img src="../images/rugs/egypt.jpg" width="19%" alt="Egypt"> <img src="../images/rugs/iznik.jpg" width="19%" alt="Iznik">
</div>

## Instalacja

```sh
curl -fsSL https://raw.githubusercontent.com/yusufyilmazfr/kilim/main/Scripts/install.sh | bash
```

1. Pobierz `Kilim-<wersja>.zip` ze strony [Releases](https://github.com/yusufyilmazfr/kilim/releases/latest).
2. Rozpakuj i przeciągnij **Kilim.app** do `Programy`.
3. Przy pierwszym uruchomieniu **kliknij prawym → Otwórz** (aplikacja nie jest notaryzowana) lub wykonaj: `xattr -dr com.apple.quarantine /Applications/Kilim.app`
4. Kilim działa w pasku menu (bez ikony w Docku). Gdy macOS zapyta o zgodę na sterowanie **Finderem**, kliknij **OK** – służy to tylko do odczytu pozycji ikon.

Do zbudowania ze źródeł wystarczą macOS 13+ i Xcode Command Line Tools:

```sh
git clone https://github.com/yusufyilmazfr/kilim.git
cd kilim
make run
```

## Obsługa

| Działanie | Efekt |
|---|---|
| Przeciągnięcie dywanu | Chwyć, przenieś lub złóż |
| Dwuklik | Zwiń / rozwiń |
| Przytrzymanie ⌥ Option | Podgląd: przezroczysty dywan, kliknięcia trafiają w ikony |
| Upuszczenie obrazu na ikonę w pasku menu | Utkaj własny dywan |
| Ikona w pasku menu | Wzór, światło, dźwięk, język, uruchamianie przy logowaniu, klawisz podglądu |

## Prywatność i uprawnienia

- Brak dostępu do sieci, telemetrii i kont.
- Uprawnienie **Automatyzacja → Finder** służy tylko do odczytu pozycji ikon; bez niego dywan działa, ale bez wybrzuszeń.
- Obraz Twojego dywanu jest przechowywany tylko lokalnie (`~/Library/Application Support/Kilim/`).

## Wsparcie

- Błędy i pomysły: [Issues](https://github.com/yusufyilmazfr/kilim/issues/new/choose)
- Pytania i pomysły: [Discussions](https://github.com/yusufyilmazfr/kilim/discussions)
- Kilim jest darmowy. Jeśli Ci się podoba, możesz go wesprzeć przez [GitHub Sponsors](https://github.com/sponsors/yusufyilmazfr).
- Gwiazdka dla repozytorium też bardzo pomaga!

## Współtworzenie

Nowe wzory, tłumaczenia i poprawki są mile widziane. Najpierw przeczytaj [CONTRIBUTING.md](../../CONTRIBUTING.md) (po angielsku).

## Licencja

[MIT](../../LICENSE) © 2026 Yusuf Yılmaz

---

<sub>Rozwiązywanie problemów, architektura i plan rozwoju: [README po angielsku](../../README.md).</sub>
