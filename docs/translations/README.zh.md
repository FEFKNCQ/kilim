<div align="center">

<img src="../images/icon.png" width="96" alt="Kilim">

# Kilim

**为你的 macOS 桌面带来具有布料物理效果的地毯。**
拖动、折叠、卷起——把凌乱的桌面图标扫到地毯下面。

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](../../LICENSE)
![macOS 13+](https://img.shields.io/badge/macOS-13%2B-black?logo=apple)
[![Sponsor](https://img.shields.io/badge/sponsor-%E2%99%A5-ea4aaa?logo=githubsponsors)](https://github.com/sponsors/yusufyilmazfr)

[下载最新版本](https://github.com/yusufyilmazfr/kilim/releases/latest)

[Türkçe](README.tr.md) · [English](../../README.md) · [Kurdî](README.ku.md) · [Español](README.es.md) · [Français](README.fr.md) · [Deutsch](README.de.md) · [Português](README.pt.md) · [Italiano](README.it.md) · [Nederlands](README.nl.md) · [Polski](README.pl.md) · [Русский](README.ru.md) · **中文** · [日本語](README.ja.md) · [한국어](README.ko.md) · [हिन्दी](README.hi.md) · [বাংলা](README.bn.md) · [العربية](README.ar.md) · [فارسی](README.fa.md) · [اردو](README.ur.md) · [Bahasa Indonesia](README.id.md) · [Tiếng Việt](README.vi.md)

<img src="../images/demo-fold.jpg" width="32%" alt=""> <img src="../images/demo-roll.jpg" width="32%" alt=""> <img src="../images/demo-night.jpg" width="32%" alt="">

</div>

---

## 功能特色

- **真实的布料物理** – 抓起、拉扯、折叠、抛出地毯。
- **隐藏桌面图标** – 图标所在位置会鼓起凸起,拖动图标时凸起会跟随。
- **透视模式** – 按住 ⌥ Option(可更改),地毯变透明,可直接点击下方图标。
- **卷起** – 双击卷起地毯,再次双击展开。
- **16 种图案** – 波斯、土耳其、库尔德、埃及、柏柏尔、哈萨克、中国、圣索菲亚、伊兹尼克、塞尔柱……还能把**你自己的照片**织成地毯。
- **昼夜光照** – 颜色与阴影随一天的时间变化。
- 程序生成的摩擦声与落地声(无音频文件)、多显示器、21 种语言。
- 轻巧且注重隐私:不联网、无统计分析。

## 地毯图案

所有图案都在启动时用代码绘制,不含任何图片资源。通过**我的地毯…**可把任意照片织成带边框的地毯。

<div align="center">
<img src="../images/rugs/kashan.jpg" width="19%" alt="Kashan"> <img src="../images/rugs/turk.jpg" width="19%" alt="Turkish"> <img src="../images/rugs/kurd.jpg" width="19%" alt="Kurdish"> <img src="../images/rugs/egypt.jpg" width="19%" alt="Egypt"> <img src="../images/rugs/iznik.jpg" width="19%" alt="Iznik">
</div>

## 安装

```sh
curl -fsSL https://raw.githubusercontent.com/yusufyilmazfr/kilim/main/Scripts/install.sh | bash
```

1. 从 [Releases](https://github.com/yusufyilmazfr/kilim/releases/latest) 下载 `Kilim-<版本>.zip`。
2. 解压后将 **Kilim.app** 拖入“应用程序”。
3. 首次打开请**右键 → 打开**(应用未经公证),或运行:`xattr -dr com.apple.quarantine /Applications/Kilim.app`
4. Kilim 常驻菜单栏(无 Dock 图标)。若 macOS 询问是否允许控制**访达**,请点击**好**——仅用于读取桌面图标位置。

从源码构建只需 macOS 13+ 和 Xcode 命令行工具:

```sh
git clone https://github.com/yusufyilmazfr/kilim.git
cd kilim
make run
```

## 使用方法

| 操作 | 效果 |
|---|---|
| 拖动地毯 | 抓起、搬运或折叠 |
| 双击 | 卷起 / 展开 |
| 按住 ⌥ Option | 透视:地毯变透明,点击穿透到图标 |
| 把图片拖到菜单栏图标上 | 织出你自己的地毯 |
| 菜单栏图标 | 图案、光照、声音、语言、登录时启动、透视按键 |

## 隐私与权限

- 无网络访问、无遥测、无账号。
- “自动化 → 访达”权限仅用于读取图标位置;没有它地毯也能运行,只是不会出现凸起。
- 你的自定义地毯图片只保存在本地(`~/Library/Application Support/Kilim/`)。

## 支持

- 问题与建议:[Issues](https://github.com/yusufyilmazfr/kilim/issues/new/choose)
- 提问与想法:[Discussions](https://github.com/yusufyilmazfr/kilim/discussions)
- Kilim 完全免费。如果你喜欢,欢迎通过 [GitHub Sponsors](https://github.com/sponsors/yusufyilmazfr) 支持。
- 给仓库点个 Star 也很有帮助!

## 参与贡献

欢迎提交新图案、翻译和修复。请先阅读 [CONTRIBUTING.md](../../CONTRIBUTING.md)(英文)。

## 许可证

[MIT](../../LICENSE) © 2026 Yusuf Yılmaz

---

<sub>故障排除、架构与路线图请见[英文 README](../../README.md)。</sub>
