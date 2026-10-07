<div align="center">

<img src="../images/icon.png" width="96" alt="Kilim">

# Kilim

**Karpet dengan fisika kain untuk desktop macOS Anda.**
Seret, lipat, gulung – dan sapu ikon desktop yang berantakan ke bawahnya.

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](../../LICENSE)
![macOS 13+](https://img.shields.io/badge/macOS-13%2B-black?logo=apple)
[![Sponsor](https://img.shields.io/badge/sponsor-%E2%99%A5-ea4aaa?logo=githubsponsors)](https://github.com/sponsors/yusufyilmazfr)

[Unduh versi terbaru](https://github.com/yusufyilmazfr/kilim/releases/latest)

[Türkçe](README.tr.md) · [English](../../README.md) · [Kurdî](README.ku.md) · [Español](README.es.md) · [Français](README.fr.md) · [Deutsch](README.de.md) · [Português](README.pt.md) · [Italiano](README.it.md) · [Nederlands](README.nl.md) · [Polski](README.pl.md) · [Русский](README.ru.md) · [中文](README.zh.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [हिन्दी](README.hi.md) · [বাংলা](README.bn.md) · [العربية](README.ar.md) · [فارسی](README.fa.md) · [اردو](README.ur.md) · **Bahasa Indonesia** · [Tiếng Việt](README.vi.md)

<img src="../images/demo-fold.jpg" width="32%" alt=""> <img src="../images/demo-roll.jpg" width="32%" alt=""> <img src="../images/demo-night.jpg" width="32%" alt="">

</div>

---

## Fitur

- **Fisika kain yang nyata** – pegang, tarik, lipat, dan lempar karpetnya.
- **Menyembunyikan ikon desktop** – muncul tonjolan di tempat ikon berada dan mengikuti ikon saat diseret.
- **Mode mengintip** – tahan ⌥ Option (dapat diubah): karpet menjadi transparan dan Anda bisa mengeklik ikon di bawahnya.
- **Gulung** – klik dua kali untuk menggulung karpet, klik dua kali lagi untuk membukanya.
- **16 motif** – Persia, Turki, Kurdi, Mesir, Berber, Kazakh, Tiongkok, Hagia Sophia, İznik, Seljuk… dan **foto Anda sendiri** yang ditenun menjadi karpet.
- **Cahaya siang dan malam** – warna dan bayangan mengikuti waktu.
- Suara gesekan dan benturan yang dihasilkan secara prosedural (tanpa berkas audio), multi-monitor, 21 bahasa.
- Ringan dan privat: tanpa akses jaringan, tanpa analitik.

## Motif karpet

Semua motif dilukis lewat kode saat aplikasi dibuka; tidak ada berkas gambar yang disertakan. Dengan **Karpet Saya…** Anda bisa menenun foto apa pun menjadi karpet berbingkai.

<div align="center">
<img src="../images/rugs/kashan.jpg" width="19%" alt="Kashan"> <img src="../images/rugs/turk.jpg" width="19%" alt="Turkish"> <img src="../images/rugs/kurd.jpg" width="19%" alt="Kurdish"> <img src="../images/rugs/egypt.jpg" width="19%" alt="Egypt"> <img src="../images/rugs/iznik.jpg" width="19%" alt="Iznik">
</div>

## Instalasi

```sh
curl -fsSL https://raw.githubusercontent.com/yusufyilmazfr/kilim/main/Scripts/install.sh | bash
```

1. Unduh `Kilim-<versi>.zip` dari [Releases](https://github.com/yusufyilmazfr/kilim/releases/latest).
2. Ekstrak lalu seret **Kilim.app** ke `Applications`.
3. Saat pertama dibuka, **klik kanan → Open** (aplikasi belum dinotarisasi) atau jalankan: `xattr -dr com.apple.quarantine /Applications/Kilim.app`
4. Kilim berada di bilah menu (tanpa ikon Dock). Jika macOS meminta izin mengontrol **Finder**, klik **OK** – hanya dipakai untuk membaca posisi ikon.

Untuk membangun dari sumber cukup macOS 13+ dan Xcode Command Line Tools:

```sh
git clone https://github.com/yusufyilmazfr/kilim.git
cd kilim
make run
```

## Penggunaan

| Tindakan | Hasil |
|---|---|
| Seret karpet | Pegang, bawa, atau lipat |
| Klik dua kali | Gulung / buka gulungan |
| Tahan ⌥ Option | Mengintip: karpet transparan, klik menembus ke ikon |
| Jatuhkan gambar ke ikon bilah menu | Tenun karpet Anda sendiri |
| Ikon bilah menu | Motif, cahaya, suara, bahasa, buka saat login, tombol mengintip |

## Privasi dan izin

- Tanpa akses jaringan, tanpa telemetri, tanpa akun.
- Izin **Automasi → Finder** hanya untuk membaca posisi ikon; tanpa izin karpet tetap berfungsi, hanya tanpa tonjolan.
- Gambar karpet kustom Anda hanya disimpan secara lokal (`~/Library/Application Support/Kilim/`).

## Dukungan

- Bug dan permintaan fitur: [Issues](https://github.com/yusufyilmazfr/kilim/issues/new/choose)
- Pertanyaan dan ide: [Discussions](https://github.com/yusufyilmazfr/kilim/discussions)
- Kilim gratis. Jika Anda menyukainya, dukung lewat [GitHub Sponsors](https://github.com/sponsors/yusufyilmazfr).
- Memberi bintang pada repositori juga sangat membantu!

## Berkontribusi

Motif baru, terjemahan, dan perbaikan bug sangat diterima. Baca dulu [CONTRIBUTING.md](../../CONTRIBUTING.md) (bahasa Inggris).

## Lisensi

[MIT](../../LICENSE) © 2026 Yusuf Yılmaz

---

<sub>Untuk pemecahan masalah, arsitektur, dan peta jalan, lihat [README bahasa Inggris](../../README.md).</sub>
