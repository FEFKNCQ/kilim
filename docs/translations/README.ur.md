<div dir="rtl">

<div align="center">

<img src="../images/icon.png" width="96" alt="Kilim">

# Kilim

**آپ کے macOS ڈیسک ٹاپ کے لیے کپڑے کی طبیعیات والا قالین۔**
اسے کھینچیں، تہہ کریں، لپیٹیں – اور بکھرے ہوئے ڈیسک ٹاپ آئیکن اس کے نیچے سمیٹ دیں۔

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](../../LICENSE)
![macOS 13+](https://img.shields.io/badge/macOS-13%2B-black?logo=apple)
[![Sponsor](https://img.shields.io/badge/sponsor-%E2%99%A5-ea4aaa?logo=githubsponsors)](https://github.com/sponsors/yusufyilmazfr)

[تازہ ترین ورژن ڈاؤن لوڈ کریں](https://github.com/yusufyilmazfr/kilim/releases/latest)

[Türkçe](README.tr.md) · [English](../../README.md) · [Kurdî](README.ku.md) · [Español](README.es.md) · [Français](README.fr.md) · [Deutsch](README.de.md) · [Português](README.pt.md) · [Italiano](README.it.md) · [Nederlands](README.nl.md) · [Polski](README.pl.md) · [Русский](README.ru.md) · [中文](README.zh.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [हिन्दी](README.hi.md) · [বাংলা](README.bn.md) · [العربية](README.ar.md) · [فارسی](README.fa.md) · **اردو** · [Bahasa Indonesia](README.id.md) · [Tiếng Việt](README.vi.md)

<img src="../images/demo-fold.jpg" width="32%" alt=""> <img src="../images/demo-roll.jpg" width="32%" alt=""> <img src="../images/demo-night.jpg" width="32%" alt="">

</div>

---

## خصوصیات

- **حقیقی کپڑے کی طبیعیات** – قالین کو پکڑیں، کھینچیں، تہہ کریں اور اچھالیں۔
- **ڈیسک ٹاپ آئیکن چھپاتا ہے** – جہاں آئیکن ہوں وہاں ابھار بنتے ہیں، اور آئیکن کھینچنے پر ابھار بھی ساتھ چلتا ہے۔
- **جھانکنے کا موڈ** – ⌥ Option (قابلِ تبدیلی) دبائے رکھیں: قالین شفاف ہو جاتا ہے اور آپ نیچے کے آئیکن پر کلک کر سکتے ہیں۔
- **لپیٹنا** – ڈبل کلک سے قالین لپٹ جاتا ہے، دوبارہ ڈبل کلک سے کھل جاتا ہے۔
- **16 ڈیزائن** – فارسی، ترکی، کرد، مصری، بربر، قازق، چینی، آیا صوفیہ، ازنک، سلجوقی… اور **آپ کی اپنی تصویر** سے بُنا ہوا قالین۔
- **دن اور رات کی روشنی** – رنگ اور سایہ دن کے وقت کے مطابق بدلتے ہیں۔
- کوڈ سے بنی سرسراہٹ اور دھمک کی آوازیں (کوئی آڈیو فائل نہیں)، ایک سے زیادہ مانیٹر، 21 زبانیں۔
- ہلکا اور نجی: نہ نیٹ ورک تک رسائی، نہ تجزیات۔

## قالین کے ڈیزائن

تمام ڈیزائن آغاز کے وقت کوڈ سے بنائے جاتے ہیں؛ پیکیج میں کوئی تصویری فائل نہیں۔ **میرا قالین…** سے کسی بھی تصویر کو کنارے والے قالین میں بُنیں۔

<div align="center">
<img src="../images/rugs/kashan.jpg" width="19%" alt="Kashan"> <img src="../images/rugs/turk.jpg" width="19%" alt="Turkish"> <img src="../images/rugs/kurd.jpg" width="19%" alt="Kurdish"> <img src="../images/rugs/egypt.jpg" width="19%" alt="Egypt"> <img src="../images/rugs/iznik.jpg" width="19%" alt="Iznik">
</div>

## انسٹالیشن

```sh
curl -fsSL https://raw.githubusercontent.com/yusufyilmazfr/kilim/main/Scripts/install.sh | bash
```

1. [Releases](https://github.com/yusufyilmazfr/kilim/releases/latest) سے `Kilim-<ورژن>.zip` ڈاؤن لوڈ کریں۔
2. زپ کھولیں اور **Kilim.app** کو `Applications` میں کھینچ لیں۔
3. پہلی بار **رائٹ کلک ← Open** کریں (ایپ نوٹرائزڈ نہیں ہے) یا چلائیں: `xattr -dr com.apple.quarantine /Applications/Kilim.app`
4. Kilim مینو بار میں رہتا ہے (Dock میں آئیکن نہیں)۔ جب macOS **Finder** کو کنٹرول کرنے کی اجازت مانگے تو **OK** دبائیں – یہ صرف آئیکنز کی جگہ پڑھنے کے لیے ہے۔

سورس سے بنانے کے لیے macOS 13+ اور Xcode Command Line Tools کافی ہیں:

```sh
git clone https://github.com/yusufyilmazfr/kilim.git
cd kilim
make run
```

## استعمال

| عمل | نتیجہ |
|---|---|
| قالین کھینچنا | پکڑنا، لے جانا یا تہہ کرنا |
| ڈبل کلک | لپیٹنا / کھولنا |
| ⌥ Option دبائے رکھنا | جھانکنا: قالین شفاف، کلک آئیکنز تک پہنچتے ہیں |
| مینو بار آئیکن پر تصویر چھوڑنا | اپنا قالین بُننا |
| مینو بار آئیکن | ڈیزائن، روشنی، آواز، زبان، لاگ اِن پر آغاز، جھانکنے کی کلید |

## رازداری اور اجازتیں

- نہ نیٹ ورک رسائی، نہ ٹیلی میٹری، نہ اکاؤنٹ۔
- **Automation ← Finder** کی اجازت صرف آئیکنز کی جگہ پڑھنے کے لیے ہے؛ اس کے بغیر بھی قالین چلتا ہے مگر ابھار نہیں بنتے۔
- آپ کے قالین کی تصویر صرف مقامی طور پر محفوظ ہوتی ہے (`~/Library/Application Support/Kilim/`)۔

## معاونت

- خرابیاں اور تجاویز: [Issues](https://github.com/yusufyilmazfr/kilim/issues/new/choose)
- سوالات اور خیالات: [Discussions](https://github.com/yusufyilmazfr/kilim/discussions)
- Kilim مفت ہے۔ پسند آئے تو [GitHub Sponsors](https://github.com/sponsors/yusufyilmazfr) پر حمایت کریں۔
- ریپوزٹری کو اسٹار دینا بھی بہت مددگار ہے!

## حصہ ڈالیں

نئے ڈیزائن، تراجم اور اصلاحات کا خیرمقدم ہے۔ پہلے [CONTRIBUTING.md](../../CONTRIBUTING.md) (انگریزی) پڑھیں۔

## لائسنس

[MIT](../../LICENSE) © 2026 Yusuf Yılmaz

---

<sub>مسائل کے حل، ساخت اور روڈ میپ کے لیے [انگریزی README](../../README.md) دیکھیں۔</sub>

</div>
