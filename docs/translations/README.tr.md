<div align="center">

<img src="../images/icon.png" width="96" alt="Kilim">

# Kilim

**macOS masaüstün için kumaş fiziğiyle çalışan bir halı.**
Sürükle, katla, rulo yap – ve dağınık masaüstü ikonlarını halının altına süpür.

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](../../LICENSE)
![macOS 13+](https://img.shields.io/badge/macOS-13%2B-black?logo=apple)
[![Sponsor](https://img.shields.io/badge/sponsor-%E2%99%A5-ea4aaa?logo=githubsponsors)](https://github.com/sponsors/yusufyilmazfr)

[Son sürümü indir](https://github.com/yusufyilmazfr/kilim/releases/latest)

**Türkçe** · [English](../../README.md) · [Kurdî](README.ku.md) · [Español](README.es.md) · [Français](README.fr.md) · [Deutsch](README.de.md) · [Português](README.pt.md) · [Italiano](README.it.md) · [Nederlands](README.nl.md) · [Polski](README.pl.md) · [Русский](README.ru.md) · [中文](README.zh.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [हिन्दी](README.hi.md) · [বাংলা](README.bn.md) · [العربية](README.ar.md) · [فارسی](README.fa.md) · [اردو](README.ur.md) · [Bahasa Indonesia](README.id.md) · [Tiếng Việt](README.vi.md)

<img src="../images/demo-fold.jpg" width="32%" alt=""> <img src="../images/demo-roll.jpg" width="32%" alt=""> <img src="../images/demo-night.jpg" width="32%" alt="">

</div>

---

## Özellikler

- **Gerçek kumaş fiziği** – halıyı tut, çek, katla, savur.
- **Masaüstü ikonlarını gizler** – ikonların olduğu yerde tümsekler oluşur, ikonu sürüklerken tümsek de onu takip eder.
- **Göz atma modu** – ⌥ Option tuşunu (değiştirilebilir) basılı tut; halı şeffaflaşır ve ikonlara tıklayabilirsin.
- **Rulo** – çift tıkla halı rulo olur, tekrar çift tıkla açılır.
- **16 desen** – İran, Türk, Kürt, Mısır, Berber, Kazak, Çin, Ayasofya, İznik, Selçuklu… ve **kendi resminden dokunan halı**.
- **Gece/gündüz ışığı** – gün saatine göre renk ve gölge değişir.
- Kumaş hışırtısı ve inme sesleri (üretilir, ses dosyası yok), çoklu monitör, 21 dil.
- Hafif ve gizlilik dostu: ağ erişimi yok, analitik yok.

## Halı desenleri

Tüm desenler açılışta kodla çizilir; pakette görsel dosya yoktur. Menüden **Kendi Halın…** ile herhangi bir fotoğrafı bordürlü bir halıya dokutabilirsin.

<div align="center">
<img src="../images/rugs/kashan.jpg" width="19%" alt="Kashan"> <img src="../images/rugs/turk.jpg" width="19%" alt="Turkish"> <img src="../images/rugs/kurd.jpg" width="19%" alt="Kurdish"> <img src="../images/rugs/egypt.jpg" width="19%" alt="Egypt"> <img src="../images/rugs/iznik.jpg" width="19%" alt="Iznik">
</div>

## Kurulum

```sh
curl -fsSL https://raw.githubusercontent.com/yusufyilmazfr/kilim/main/Scripts/install.sh | bash
```

1. [Releases](https://github.com/yusufyilmazfr/kilim/releases/latest) sayfasından `Kilim-<sürüm>.zip` dosyasını indir.
2. Zip'i aç ve **Kilim.app**'i `Uygulamalar` klasörüne sürükle.
3. İlk açılışta **sağ tık → Aç** de (uygulama noter onaylı değil) ya da: `xattr -dr com.apple.quarantine /Applications/Kilim.app`
4. Kilim menü çubuğunda yaşar (Dock'ta ikon yok). macOS **Finder**'ı kontrol izni sorarsa **Tamam** de – yalnızca masaüstü ikonlarının konumunu okumak için kullanılır.

Kaynaktan derlemek için macOS 13+ ve Xcode Komut Satırı Araçları yeterli:

```sh
git clone https://github.com/yusufyilmazfr/kilim.git
cd kilim
make run
```

## Kullanım

| Eylem | Sonuç |
|---|---|
| Halıyı sürükle | Tut, taşı veya katla |
| Çift tıkla | Rulo yap / aç |
| ⌥ Option basılı tut | Göz atma: halı şeffaflaşır, tıklamalar ikonlara geçer |
| Resmi menü çubuğu ikonuna bırak | Kendi halını dokut |
| Menü çubuğu ikonu | Desen, ışık, ses, dil, girişte başlat, göz atma tuşu |

## Gizlilik ve izinler

- Ağ erişimi yok, telemetri yok, hesap yok.
- **Otomasyon → Finder** izni yalnızca masaüstü ikonlarının konumunu okumak içindir; izin vermezsen halı yine çalışır, sadece tümsek olmaz.
- Kendi halın için seçtiğin resim yalnızca yerelde saklanır (`~/Library/Application Support/Kilim/`).

## Destek

- Hata ve istekler: [Issues](https://github.com/yusufyilmazfr/kilim/issues/new/choose)
- Soru ve fikirler: [Discussions](https://github.com/yusufyilmazfr/kilim/discussions)
- Kilim ücretsizdir. Beğendiysen [GitHub Sponsors](https://github.com/sponsors/yusufyilmazfr) üzerinden destek olabilirsin.
- Depoya yıldız vermek de çok yardımcı olur!

## Katkı

Yeni halı desenleri, çeviriler ve hata düzeltmeleri çok değerli. Başlamadan önce [CONTRIBUTING.md](../../CONTRIBUTING.md) (İngilizce) dosyasına göz at.

## Lisans

[MIT](../../LICENSE) © 2026 Yusuf Yılmaz

---

<sub>Sorun giderme, mimari ve yol haritası için [İngilizce README](../../README.md) dosyasına bak.</sub>
