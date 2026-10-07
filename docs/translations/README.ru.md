<div align="center">

<img src="../images/icon.png" width="96" alt="Kilim">

# Kilim

**Ковёр с физикой ткани для рабочего стола macOS.**
Таскайте его, складывайте, сворачивайте – и заметайте беспорядок из значков рабочего стола под него.

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](../../LICENSE)
![macOS 13+](https://img.shields.io/badge/macOS-13%2B-black?logo=apple)
[![Sponsor](https://img.shields.io/badge/sponsor-%E2%99%A5-ea4aaa?logo=githubsponsors)](https://github.com/sponsors/yusufyilmazfr)

[Скачать последнюю версию](https://github.com/yusufyilmazfr/kilim/releases/latest)

[Türkçe](README.tr.md) · [English](../../README.md) · [Kurdî](README.ku.md) · [Español](README.es.md) · [Français](README.fr.md) · [Deutsch](README.de.md) · [Português](README.pt.md) · [Italiano](README.it.md) · [Nederlands](README.nl.md) · [Polski](README.pl.md) · **Русский** · [中文](README.zh.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [हिन्दी](README.hi.md) · [বাংলা](README.bn.md) · [العربية](README.ar.md) · [فارسی](README.fa.md) · [اردو](README.ur.md) · [Bahasa Indonesia](README.id.md) · [Tiếng Việt](README.vi.md)

<img src="../images/demo-fold.jpg" width="32%" alt=""> <img src="../images/demo-roll.jpg" width="32%" alt=""> <img src="../images/demo-night.jpg" width="32%" alt="">

</div>

---

## Возможности

- **Настоящая физика ткани** – хватайте, тяните, складывайте и бросайте ковёр.
- **Прячет значки рабочего стола** – на месте значков появляются бугры, которые следуют за значком при перетаскивании.
- **Режим подглядывания** – удерживайте ⌥ Option (настраивается): ковёр становится прозрачным, и можно кликать по значкам.
- **Сворачивание** – двойной клик сворачивает ковёр, ещё один – разворачивает.
- **16 узоров** – персидский, турецкий, курдский, египетский, берберский, казахский, китайский, Айя-София, Изник, сельджукский… и **ваша собственная фотография**, вытканная в ковёр.
- **Дневной и ночной свет** – цвет и тень зависят от времени суток.
- Процедурные звуки шуршания и ударов (без аудиофайлов), несколько мониторов, 21 язык.
- Лёгкий и приватный: без доступа к сети, без аналитики.

## Узоры ковров

Все узоры рисуются кодом при запуске; готовых изображений в пакете нет. Через **Мой ковёр…** любое фото превращается в ковёр с каймой.

<div align="center">
<img src="../images/rugs/kashan.jpg" width="19%" alt="Kashan"> <img src="../images/rugs/turk.jpg" width="19%" alt="Turkish"> <img src="../images/rugs/kurd.jpg" width="19%" alt="Kurdish"> <img src="../images/rugs/egypt.jpg" width="19%" alt="Egypt"> <img src="../images/rugs/iznik.jpg" width="19%" alt="Iznik">
</div>

## Установка

```sh
curl -fsSL https://raw.githubusercontent.com/yusufyilmazfr/kilim/main/Scripts/install.sh | bash
```

1. Скачайте `Kilim-<версия>.zip` со страницы [Releases](https://github.com/yusufyilmazfr/kilim/releases/latest).
2. Распакуйте и перетащите **Kilim.app** в `Программы`.
3. При первом запуске **правый клик → Открыть** (приложение не нотаризовано) или выполните: `xattr -dr com.apple.quarantine /Applications/Kilim.app`
4. Kilim живёт в строке меню (значка в Dock нет). Если macOS спросит разрешение управлять **Finder**, нажмите **OK** – оно нужно только для чтения положения значков.

Для сборки из исходников достаточно macOS 13+ и Xcode Command Line Tools:

```sh
git clone https://github.com/yusufyilmazfr/kilim.git
cd kilim
make run
```

## Использование

| Действие | Результат |
|---|---|
| Перетащить ковёр | Схватить, нести или сложить |
| Двойной клик | Свернуть / развернуть |
| Удерживать ⌥ Option | Подглядывание: ковёр прозрачен, клики проходят к значкам |
| Перетащить изображение на значок в строке меню | Выткать свой ковёр |
| Значок в строке меню | Узор, свет, звук, язык, запуск при входе, клавиша подглядывания |

## Конфиденциальность и разрешения

- Нет доступа к сети, телеметрии и учётных записей.
- Разрешение **Автоматизация → Finder** нужно только для чтения положения значков; без него ковёр работает, но без бугров.
- Картинка вашего ковра хранится только локально (`~/Library/Application Support/Kilim/`).

## Поддержка

- Ошибки и пожелания: [Issues](https://github.com/yusufyilmazfr/kilim/issues/new/choose)
- Вопросы и идеи: [Discussions](https://github.com/yusufyilmazfr/kilim/discussions)
- Kilim бесплатен. Если он вам нравится, поддержите проект через [GitHub Sponsors](https://github.com/sponsors/yusufyilmazfr).
- Звезда репозиторию тоже очень помогает!

## Участие

Новые узоры, переводы и исправления приветствуются. Сначала прочитайте [CONTRIBUTING.md](../../CONTRIBUTING.md) (на английском).

## Лицензия

[MIT](../../LICENSE) © 2026 Yusuf Yılmaz

---

<sub>Решение проблем, архитектура и планы – в [README на английском](../../README.md).</sub>
