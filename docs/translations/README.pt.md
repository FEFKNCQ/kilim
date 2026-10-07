<div align="center">

<img src="../images/icon.png" width="96" alt="Kilim">

# Kilim

**Um tapete com física de tecido para o seu ambiente de trabalho do macOS.**
Arraste-o, dobre-o, enrole-o – e varra os ícones bagunçados da sua mesa para debaixo dele.

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](../../LICENSE)
![macOS 13+](https://img.shields.io/badge/macOS-13%2B-black?logo=apple)
[![Sponsor](https://img.shields.io/badge/sponsor-%E2%99%A5-ea4aaa?logo=githubsponsors)](https://github.com/sponsors/yusufyilmazfr)

[Baixar a versão mais recente](https://github.com/yusufyilmazfr/kilim/releases/latest)

[Türkçe](README.tr.md) · [English](../../README.md) · [Kurdî](README.ku.md) · [Español](README.es.md) · [Français](README.fr.md) · [Deutsch](README.de.md) · **Português** · [Italiano](README.it.md) · [Nederlands](README.nl.md) · [Polski](README.pl.md) · [Русский](README.ru.md) · [中文](README.zh.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [हिन्दी](README.hi.md) · [বাংলা](README.bn.md) · [العربية](README.ar.md) · [فارسی](README.fa.md) · [اردو](README.ur.md) · [Bahasa Indonesia](README.id.md) · [Tiếng Việt](README.vi.md)

<img src="../images/demo-fold.jpg" width="32%" alt=""> <img src="../images/demo-roll.jpg" width="32%" alt=""> <img src="../images/demo-night.jpg" width="32%" alt="">

</div>

---

## Recursos

- **Física de tecido real** – agarre, puxe, dobre e jogue o tapete.
- **Esconde os ícones da área de trabalho** – surgem calombos onde estão os ícones e eles acompanham o ícone ao arrastá-lo.
- **Modo espiar** – segure ⌥ Option (configurável) e o tapete fica transparente para você clicar nos ícones.
- **Enrolar** – clique duplo para enrolar o tapete e outro clique duplo para desenrolar.
- **16 padrões** – persa, turco, curdo, egípcio, berbere, cazaque, chinês, Santa Sofia, İznik, seljúcida… e **a sua própria foto** tecida como tapete.
- **Luz de dia e de noite** – cor e sombra seguem a hora do dia.
- Sons procedurais de atrito e impacto (sem arquivos de áudio), vários monitores, 21 idiomas.
- Leve e privado: sem rede, sem análises.

## Padrões de tapete

Todos os padrões são pintados por código ao iniciar; não há imagens incluídas. Com **Meu tapete…** você tece qualquer foto num tapete com borda.

<div align="center">
<img src="../images/rugs/kashan.jpg" width="19%" alt="Kashan"> <img src="../images/rugs/turk.jpg" width="19%" alt="Turkish"> <img src="../images/rugs/kurd.jpg" width="19%" alt="Kurdish"> <img src="../images/rugs/egypt.jpg" width="19%" alt="Egypt"> <img src="../images/rugs/iznik.jpg" width="19%" alt="Iznik">
</div>

## Instalação

```sh
curl -fsSL https://raw.githubusercontent.com/yusufyilmazfr/kilim/main/Scripts/install.sh | bash
```

1. Baixe `Kilim-<versão>.zip` em [Releases](https://github.com/yusufyilmazfr/kilim/releases/latest).
2. Descompacte e arraste **Kilim.app** para `Aplicativos`.
3. Na primeira vez, **clique direito → Abrir** (o app não é notarizado) ou execute: `xattr -dr com.apple.quarantine /Applications/Kilim.app`
4. O Kilim fica na barra de menus (sem ícone no Dock). Se o macOS perguntar se pode controlar o **Finder**, clique em **OK** – serve apenas para ler a posição dos ícones.

Para compilar a partir do código-fonte, bastam macOS 13+ e as Xcode Command Line Tools:

```sh
git clone https://github.com/yusufyilmazfr/kilim.git
cd kilim
make run
```

## Uso

| Ação | Resultado |
|---|---|
| Arrastar o tapete | Agarrar, carregar ou dobrar |
| Clique duplo | Enrolar / desenrolar |
| Segurar ⌥ Option | Espiar: tapete transparente, os cliques chegam aos ícones |
| Soltar uma imagem no ícone da barra de menus | Tecer o seu próprio tapete |
| Ícone da barra de menus | Padrão, luz, som, idioma, abrir ao iniciar sessão, tecla de espiar |

## Privacidade e permissões

- Sem acesso à rede, sem telemetria, sem contas.
- A permissão **Automação → Finder** serve só para ler a posição dos ícones; sem ela o tapete funciona, mas sem calombos.
- A imagem do seu tapete personalizado fica apenas no seu Mac (`~/Library/Application Support/Kilim/`).

## Suporte

- Erros e sugestões: [Issues](https://github.com/yusufyilmazfr/kilim/issues/new/choose)
- Perguntas e ideias: [Discussions](https://github.com/yusufyilmazfr/kilim/discussions)
- O Kilim é gratuito. Se gostou, apoie-o no [GitHub Sponsors](https://github.com/sponsors/yusufyilmazfr).
- Uma estrela no repositório também ajuda muito!

## Contribuir

Novos padrões, traduções e correções são bem-vindos. Leia antes o [CONTRIBUTING.md](../../CONTRIBUTING.md) (em inglês).

## Licença

[MIT](../../LICENSE) © 2026 Yusuf Yılmaz

---

<sub>Para solução de problemas, arquitetura e roteiro, veja o [README em inglês](../../README.md).</sub>
