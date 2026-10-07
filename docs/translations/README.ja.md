<div align="center">

<img src="../images/icon.png" width="96" alt="Kilim">

# Kilim

**macOS のデスクトップに、布の物理シミュレーションで動くラグを。**
ドラッグして、折って、丸めて――散らかったデスクトップのアイコンをラグの下に掃き入れましょう。

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](../../LICENSE)
![macOS 13+](https://img.shields.io/badge/macOS-13%2B-black?logo=apple)
[![Sponsor](https://img.shields.io/badge/sponsor-%E2%99%A5-ea4aaa?logo=githubsponsors)](https://github.com/sponsors/yusufyilmazfr)

[最新版をダウンロード](https://github.com/yusufyilmazfr/kilim/releases/latest)

[Türkçe](README.tr.md) · [English](../../README.md) · [Kurdî](README.ku.md) · [Español](README.es.md) · [Français](README.fr.md) · [Deutsch](README.de.md) · [Português](README.pt.md) · [Italiano](README.it.md) · [Nederlands](README.nl.md) · [Polski](README.pl.md) · [Русский](README.ru.md) · [中文](README.zh.md) · **日本語** · [한국어](README.ko.md) · [हिन्दी](README.hi.md) · [বাংলা](README.bn.md) · [العربية](README.ar.md) · [فارسی](README.fa.md) · [اردو](README.ur.md) · [Bahasa Indonesia](README.id.md) · [Tiếng Việt](README.vi.md)

<img src="../images/demo-fold.jpg" width="32%" alt=""> <img src="../images/demo-roll.jpg" width="32%" alt=""> <img src="../images/demo-night.jpg" width="32%" alt="">

</div>

---

## 特長

- **本物の布の物理** – ラグをつかんで、引いて、折って、投げられます。
- **デスクトップのアイコンを隠す** – アイコンの位置にふくらみができ、アイコンをドラッグするとふくらみも追従します。
- **のぞき見モード** – ⌥ Option(変更可)を押し続けるとラグが透け、下のアイコンをクリックできます。
- **ロール** – ダブルクリックでラグを丸め、もう一度ダブルクリックで広げます。
- **16 種類の柄** – ペルシャ、トルコ、クルド、エジプト、ベルベル、カザフ、中国、アヤソフィア、イズニク、セルジューク…そして**あなたの写真**を織り込んだラグ。
- **昼夜のライティング** – 色と影が時刻に合わせて変化します。
- 手続き生成の衣擦れ音と着地音(音声ファイルなし)、マルチモニター対応、21 言語。
- 軽量でプライバシー重視:ネットワークアクセスも解析もありません。

## ラグの柄

すべての柄は起動時にコードで描画され、画像素材は含まれません。**マイラグ…**で好きな写真を縁取り付きのラグに織り上げられます。

<div align="center">
<img src="../images/rugs/kashan.jpg" width="19%" alt="Kashan"> <img src="../images/rugs/turk.jpg" width="19%" alt="Turkish"> <img src="../images/rugs/kurd.jpg" width="19%" alt="Kurdish"> <img src="../images/rugs/egypt.jpg" width="19%" alt="Egypt"> <img src="../images/rugs/iznik.jpg" width="19%" alt="Iznik">
</div>

## インストール

```sh
curl -fsSL https://raw.githubusercontent.com/yusufyilmazfr/kilim/main/Scripts/install.sh | bash
```

1. [Releases](https://github.com/yusufyilmazfr/kilim/releases/latest) から `Kilim-<バージョン>.zip` をダウンロードします。
2. 展開して **Kilim.app** を「アプリケーション」へドラッグします。
3. 初回は**右クリック → 開く**(公証されていません)、または `xattr -dr com.apple.quarantine /Applications/Kilim.app` を実行します。
4. Kilim はメニューバーに常駐します(Dock アイコンなし)。macOS が **Finder** の制御許可を求めたら **OK** を押してください。デスクトップアイコンの位置を読むためだけに使います。

ソースからのビルドには macOS 13 以降と Xcode コマンドラインツールだけで足ります:

```sh
git clone https://github.com/yusufyilmazfr/kilim.git
cd kilim
make run
```

## 使い方

| 操作 | 動作 |
|---|---|
| ラグをドラッグ | つかむ・運ぶ・折る |
| ダブルクリック | 丸める / 広げる |
| ⌥ Option を押し続ける | のぞき見:ラグが透け、クリックがアイコンに届く |
| 画像をメニューバーのアイコンにドロップ | 自分のラグを織る |
| メニューバーのアイコン | 柄、ライト、サウンド、言語、ログイン時に開く、のぞき見キー |

## プライバシーと権限

- ネットワークアクセス、テレメトリ、アカウントは一切ありません。
- 「オートメーション → Finder」の権限はアイコン位置の読み取り専用です。許可しなくてもラグは動作しますが、ふくらみは出ません。
- カスタムラグの画像はローカルにのみ保存されます(`~/Library/Application Support/Kilim/`)。

## サポート

- 不具合・要望:[Issues](https://github.com/yusufyilmazfr/kilim/issues/new/choose)
- 質問・アイデア:[Discussions](https://github.com/yusufyilmazfr/kilim/discussions)
- Kilim は無料です。気に入っていただけたら [GitHub Sponsors](https://github.com/sponsors/yusufyilmazfr) で応援してください。
- リポジトリへのスターも大きな励みになります!

## コントリビュート

新しい柄、翻訳、修正を歓迎します。まず [CONTRIBUTING.md](../../CONTRIBUTING.md)(英語)をご覧ください。

## ライセンス

[MIT](../../LICENSE) © 2026 Yusuf Yılmaz

---

<sub>トラブルシューティング、アーキテクチャ、ロードマップは[英語版 README](../../README.md)をご覧ください。</sub>
