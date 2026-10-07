<div align="center">

<img src="../images/icon.png" width="96" alt="Kilim">

# Kilim

**Un tapis à la physique de tissu pour votre bureau macOS.**
Faites-le glisser, pliez-le, roulez-le – et balayez les icônes en désordre de votre bureau dessous.

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](../../LICENSE)
![macOS 13+](https://img.shields.io/badge/macOS-13%2B-black?logo=apple)
[![Sponsor](https://img.shields.io/badge/sponsor-%E2%99%A5-ea4aaa?logo=githubsponsors)](https://github.com/sponsors/yusufyilmazfr)

[Télécharger la dernière version](https://github.com/yusufyilmazfr/kilim/releases/latest)

[Türkçe](README.tr.md) · [English](../../README.md) · [Kurdî](README.ku.md) · [Español](README.es.md) · **Français** · [Deutsch](README.de.md) · [Português](README.pt.md) · [Italiano](README.it.md) · [Nederlands](README.nl.md) · [Polski](README.pl.md) · [Русский](README.ru.md) · [中文](README.zh.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [हिन्दी](README.hi.md) · [বাংলা](README.bn.md) · [العربية](README.ar.md) · [فارسی](README.fa.md) · [اردو](README.ur.md) · [Bahasa Indonesia](README.id.md) · [Tiếng Việt](README.vi.md)

<img src="../images/demo-fold.jpg" width="32%" alt=""> <img src="../images/demo-roll.jpg" width="32%" alt=""> <img src="../images/demo-night.jpg" width="32%" alt="">

</div>

---

## Fonctionnalités

- **Vraie physique de tissu** – attrapez, tirez, pliez et lancez le tapis.
- **Cache les icônes du bureau** – des bosses apparaissent là où se trouvent vos icônes et les suivent quand vous les déplacez.
- **Mode coup d'œil** – maintenez ⌥ Option (configurable) : le tapis devient transparent et vous pouvez cliquer sur les icônes.
- **Enroulement** – double-clic pour enrouler le tapis, double-clic à nouveau pour le dérouler.
- **16 motifs** – persan, turc, kurde, égyptien, berbère, kazakh, chinois, Sainte-Sophie, İznik, seldjoukide… et **votre propre photo tissée** en tapis.
- **Lumière jour et nuit** – couleur et ombre suivent l'heure de la journée.
- Sons de froissement et d'impact générés en direct (aucun fichier audio), multi-écrans, 21 langues.
- Léger et respectueux : aucun accès réseau, aucune analyse.

## Motifs de tapis

Tous les motifs sont dessinés par le code au lancement ; aucune image n'est incluse. Avec **Mon tapis…**, tissez n'importe quelle photo en tapis à bordure.

<div align="center">
<img src="../images/rugs/kashan.jpg" width="19%" alt="Kashan"> <img src="../images/rugs/turk.jpg" width="19%" alt="Turkish"> <img src="../images/rugs/kurd.jpg" width="19%" alt="Kurdish"> <img src="../images/rugs/egypt.jpg" width="19%" alt="Egypt"> <img src="../images/rugs/iznik.jpg" width="19%" alt="Iznik">
</div>

## Installation

```sh
curl -fsSL https://raw.githubusercontent.com/yusufyilmazfr/kilim/main/Scripts/install.sh | bash
```

1. Téléchargez `Kilim-<version>.zip` depuis [Releases](https://github.com/yusufyilmazfr/kilim/releases/latest).
2. Décompressez et glissez **Kilim.app** dans `Applications`.
3. Au premier lancement, **clic droit → Ouvrir** (l'app n'est pas notarisée) ou : `xattr -dr com.apple.quarantine /Applications/Kilim.app`
4. Kilim vit dans la barre des menus (pas d'icône dans le Dock). Si macOS demande l'autorisation de contrôler **Finder**, cliquez sur **OK** : elle sert uniquement à lire la position des icônes.

Pour compiler depuis les sources, macOS 13+ et les Xcode Command Line Tools suffisent :

```sh
git clone https://github.com/yusufyilmazfr/kilim.git
cd kilim
make run
```

## Utilisation

| Action | Résultat |
|---|---|
| Faire glisser le tapis | L'attraper, le porter ou le plier |
| Double-clic | Enrouler / dérouler |
| Maintenir ⌥ Option | Coup d'œil : tapis transparent, les clics atteignent les icônes |
| Déposer une image sur l'icône de la barre des menus | Tisser votre propre tapis |
| Icône de la barre des menus | Motif, lumière, son, langue, lancement à l'ouverture de session, touche coup d'œil |

## Confidentialité et autorisations

- Aucun accès réseau, aucune télémétrie, aucun compte.
- L'autorisation **Automatisation → Finder** sert uniquement à lire la position des icônes ; sans elle le tapis fonctionne, mais sans bosses.
- L'image de votre tapis personnalisé reste en local (`~/Library/Application Support/Kilim/`).

## Assistance

- Bugs et suggestions : [Issues](https://github.com/yusufyilmazfr/kilim/issues/new/choose)
- Questions et idées : [Discussions](https://github.com/yusufyilmazfr/kilim/discussions)
- Kilim est gratuit. Si vous l'aimez, vous pouvez le soutenir via [GitHub Sponsors](https://github.com/sponsors/yusufyilmazfr).
- Une étoile sur le dépôt aide aussi beaucoup !

## Contribuer

Nouveaux motifs, traductions et corrections sont les bienvenus. Lisez d'abord [CONTRIBUTING.md](../../CONTRIBUTING.md) (en anglais).

## Licence

[MIT](../../LICENSE) © 2026 Yusuf Yılmaz

---

<sub>Pour le dépannage, l'architecture et la feuille de route, voir le [README anglais](../../README.md).</sub>
