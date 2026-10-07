<div align="center">

<img src="../images/icon.png" width="96" alt="Kilim">

# Kilim

**Una alfombra con física de tela para tu escritorio de macOS.**
Arrástrala, dóblala, enróllala – y barre los iconos desordenados de tu escritorio debajo de ella.

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](../../LICENSE)
![macOS 13+](https://img.shields.io/badge/macOS-13%2B-black?logo=apple)
[![Sponsor](https://img.shields.io/badge/sponsor-%E2%99%A5-ea4aaa?logo=githubsponsors)](https://github.com/sponsors/yusufyilmazfr)

[Descargar la última versión](https://github.com/yusufyilmazfr/kilim/releases/latest)

[Türkçe](README.tr.md) · [English](../../README.md) · [Kurdî](README.ku.md) · **Español** · [Français](README.fr.md) · [Deutsch](README.de.md) · [Português](README.pt.md) · [Italiano](README.it.md) · [Nederlands](README.nl.md) · [Polski](README.pl.md) · [Русский](README.ru.md) · [中文](README.zh.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [हिन्दी](README.hi.md) · [বাংলা](README.bn.md) · [العربية](README.ar.md) · [فارسی](README.fa.md) · [اردو](README.ur.md) · [Bahasa Indonesia](README.id.md) · [Tiếng Việt](README.vi.md)

<img src="../images/demo-fold.jpg" width="32%" alt=""> <img src="../images/demo-roll.jpg" width="32%" alt=""> <img src="../images/demo-night.jpg" width="32%" alt="">

</div>

---

## Características

- **Física de tela real** – agarra, tira, dobla y lanza la alfombra.
- **Oculta los iconos del escritorio** – se forman bultos donde están tus iconos y te siguen mientras los arrastras.
- **Modo vistazo** – mantén ⌥ Option (configurable) y la alfombra se vuelve transparente para poder hacer clic en los iconos.
- **Enrollar** – doble clic para enrollar la alfombra, doble clic otra vez para desenrollarla.
- **16 diseños** – persa, turco, kurdo, egipcio, bereber, kazajo, chino, Santa Sofía, İznik, selyúcida… y **tu propia foto tejida** como alfombra.
- **Luz de día y de noche** – el color y la sombra siguen la hora del día.
- Sonidos procedurales de roce y golpe (sin archivos de audio), varios monitores, 21 idiomas.
- Ligera y privada: sin red, sin analíticas.

## Diseños de alfombra

Todos los diseños se pintan con código al iniciar; no hay imágenes incluidas. Con **Mi alfombra…** puedes tejer cualquier foto como alfombra con borde.

<div align="center">
<img src="../images/rugs/kashan.jpg" width="19%" alt="Kashan"> <img src="../images/rugs/turk.jpg" width="19%" alt="Turkish"> <img src="../images/rugs/kurd.jpg" width="19%" alt="Kurdish"> <img src="../images/rugs/egypt.jpg" width="19%" alt="Egypt"> <img src="../images/rugs/iznik.jpg" width="19%" alt="Iznik">
</div>

## Instalación

```sh
curl -fsSL https://raw.githubusercontent.com/yusufyilmazfr/kilim/main/Scripts/install.sh | bash
```

1. Descarga `Kilim-<versión>.zip` desde [Releases](https://github.com/yusufyilmazfr/kilim/releases/latest).
2. Descomprime y arrastra **Kilim.app** a `Aplicaciones`.
3. La primera vez, **clic derecho → Abrir** (la app no está notarizada) o ejecuta: `xattr -dr com.apple.quarantine /Applications/Kilim.app`
4. Kilim vive en la barra de menús (sin icono en el Dock). Si macOS pregunta si puede controlar **Finder**, pulsa **OK**: solo se usa para leer la posición de los iconos.

Para compilar desde el código fuente basta con macOS 13+ y las Xcode Command Line Tools:

```sh
git clone https://github.com/yusufyilmazfr/kilim.git
cd kilim
make run
```

## Uso

| Acción | Resultado |
|---|---|
| Arrastrar la alfombra | Agarrarla, llevarla o doblarla |
| Doble clic | Enrollar / desenrollar |
| Mantener ⌥ Option | Vistazo: la alfombra es transparente y los clics llegan a los iconos |
| Soltar una imagen sobre el icono de la barra de menús | Tejer tu propia alfombra |
| Icono de la barra de menús | Diseño, luz, sonido, idioma, abrir al iniciar sesión, tecla de vistazo |

## Privacidad y permisos

- Sin acceso a la red, sin telemetría, sin cuentas.
- El permiso **Automatización → Finder** solo sirve para leer la posición de los iconos; sin él la alfombra funciona igual, pero sin bultos.
- La imagen de tu alfombra personalizada se guarda solo en local (`~/Library/Application Support/Kilim/`).

## Soporte

- Errores y sugerencias: [Issues](https://github.com/yusufyilmazfr/kilim/issues/new/choose)
- Preguntas e ideas: [Discussions](https://github.com/yusufyilmazfr/kilim/discussions)
- Kilim es gratis. Si te gusta, puedes apoyarlo en [GitHub Sponsors](https://github.com/sponsors/yusufyilmazfr).
- ¡Una estrella en el repositorio también ayuda mucho!

## Contribuir

Se agradecen nuevos diseños, traducciones y correcciones. Lee antes [CONTRIBUTING.md](../../CONTRIBUTING.md) (en inglés).

## Licencia

[MIT](../../LICENSE) © 2026 Yusuf Yılmaz

---

<sub>Para solución de problemas, arquitectura y hoja de ruta, consulta el [README en inglés](../../README.md).</sub>
