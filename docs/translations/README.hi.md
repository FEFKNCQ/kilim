<div align="center">

<img src="../images/icon.png" width="96" alt="Kilim">

# Kilim

**आपके macOS डेस्कटॉप के लिए कपड़े की भौतिकी वाला क़ालीन।**
उसे खींचिए, मोड़िए, लपेटिए – और डेस्कटॉप के बिखरे आइकन उसके नीचे समेट दीजिए।

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](../../LICENSE)
![macOS 13+](https://img.shields.io/badge/macOS-13%2B-black?logo=apple)
[![Sponsor](https://img.shields.io/badge/sponsor-%E2%99%A5-ea4aaa?logo=githubsponsors)](https://github.com/sponsors/yusufyilmazfr)

[नवीनतम संस्करण डाउनलोड करें](https://github.com/yusufyilmazfr/kilim/releases/latest)

[Türkçe](README.tr.md) · [English](../../README.md) · [Kurdî](README.ku.md) · [Español](README.es.md) · [Français](README.fr.md) · [Deutsch](README.de.md) · [Português](README.pt.md) · [Italiano](README.it.md) · [Nederlands](README.nl.md) · [Polski](README.pl.md) · [Русский](README.ru.md) · [中文](README.zh.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · **हिन्दी** · [বাংলা](README.bn.md) · [العربية](README.ar.md) · [فارسی](README.fa.md) · [اردو](README.ur.md) · [Bahasa Indonesia](README.id.md) · [Tiếng Việt](README.vi.md)

<img src="../images/demo-fold.jpg" width="32%" alt=""> <img src="../images/demo-roll.jpg" width="32%" alt=""> <img src="../images/demo-night.jpg" width="32%" alt="">

</div>

---

## विशेषताएँ

- **असली कपड़े की भौतिकी** – क़ालीन को पकड़िए, खींचिए, मोड़िए और उछालिए।
- **डेस्कटॉप आइकन छिपाता है** – जहाँ आइकन हैं वहाँ उभार बनते हैं, और आइकन खींचने पर उभार उसके साथ चलता है।
- **झाँकने का मोड** – ⌥ Option (बदला जा सकता है) दबाए रखें: क़ालीन पारदर्शी हो जाता है और आप नीचे के आइकन पर क्लिक कर सकते हैं।
- **लपेटना** – डबल-क्लिक से क़ालीन लिपट जाता है, फिर डबल-क्लिक से खुल जाता है।
- **16 डिज़ाइन** – फ़ारसी, तुर्की, कुर्दी, मिस्री, बर्बर, कज़ाख़, चीनी, अया सोफ़िया, इज़निक, सलजूक़ी… और **आपकी अपनी तस्वीर** से बुना क़ालीन।
- **दिन-रात की रोशनी** – रंग और छाया दिन के समय के अनुसार बदलते हैं।
- कोड से बनी सरसराहट और थप की आवाज़ें (कोई ऑडियो फ़ाइल नहीं), एकाधिक मॉनिटर, 21 भाषाएँ।
- हल्का और निजी: कोई नेटवर्क एक्सेस नहीं, कोई एनालिटिक्स नहीं।

## क़ालीन के डिज़ाइन

सभी डिज़ाइन शुरू होते समय कोड से बनाए जाते हैं; पैकेज में कोई चित्र फ़ाइल नहीं है। **मेरा क़ालीन…** से किसी भी फ़ोटो को किनारी वाले क़ालीन में बुनें।

<div align="center">
<img src="../images/rugs/kashan.jpg" width="19%" alt="Kashan"> <img src="../images/rugs/turk.jpg" width="19%" alt="Turkish"> <img src="../images/rugs/kurd.jpg" width="19%" alt="Kurdish"> <img src="../images/rugs/egypt.jpg" width="19%" alt="Egypt"> <img src="../images/rugs/iznik.jpg" width="19%" alt="Iznik">
</div>

## इंस्टॉल करना

```sh
curl -fsSL https://raw.githubusercontent.com/yusufyilmazfr/kilim/main/Scripts/install.sh | bash
```

1. [Releases](https://github.com/yusufyilmazfr/kilim/releases/latest) से `Kilim-<संस्करण>.zip` डाउनलोड करें।
2. ज़िप खोलें और **Kilim.app** को `Applications` में खींचें।
3. पहली बार **राइट-क्लिक → Open** करें (ऐप नोटराइज़्ड नहीं है) या चलाएँ: `xattr -dr com.apple.quarantine /Applications/Kilim.app`
4. Kilim मेन्यू बार में रहता है (Dock में आइकन नहीं)। जब macOS **Finder** को नियंत्रित करने की अनुमति माँगे तो **OK** दबाएँ – यह केवल आइकन की स्थिति पढ़ने के लिए है।

सोर्स से बनाने के लिए macOS 13+ और Xcode Command Line Tools काफ़ी हैं:

```sh
git clone https://github.com/yusufyilmazfr/kilim.git
cd kilim
make run
```

## उपयोग

| क्रिया | परिणाम |
|---|---|
| क़ालीन खींचना | पकड़ना, ले जाना या मोड़ना |
| डबल-क्लिक | लपेटना / खोलना |
| ⌥ Option दबाए रखना | झाँकना: क़ालीन पारदर्शी, क्लिक आइकन तक पहुँचते हैं |
| मेन्यू बार आइकन पर चित्र छोड़ना | अपना क़ालीन बुनना |
| मेन्यू बार आइकन | डिज़ाइन, रोशनी, ध्वनि, भाषा, लॉगिन पर शुरू, झाँकने की कुंजी |

## गोपनीयता और अनुमतियाँ

- कोई नेटवर्क एक्सेस, टेलीमेट्री या खाता नहीं।
- **Automation → Finder** अनुमति केवल आइकन की स्थिति पढ़ने के लिए है; इसके बिना भी क़ालीन चलता है, बस उभार नहीं बनते।
- आपके क़ालीन की तस्वीर केवल स्थानीय रूप से सहेजी जाती है (`~/Library/Application Support/Kilim/`)।

## सहायता

- बग और सुझाव: [Issues](https://github.com/yusufyilmazfr/kilim/issues/new/choose)
- प्रश्न और विचार: [Discussions](https://github.com/yusufyilmazfr/kilim/discussions)
- Kilim मुफ़्त है। पसंद आए तो [GitHub Sponsors](https://github.com/sponsors/yusufyilmazfr) पर सहयोग करें।
- रिपॉज़िटरी को स्टार देना भी बहुत मदद करता है!

## योगदान

नए डिज़ाइन, अनुवाद और सुधारों का स्वागत है। पहले [CONTRIBUTING.md](../../CONTRIBUTING.md) (अंग्रेज़ी) पढ़ें।

## लाइसेंस

[MIT](../../LICENSE) © 2026 Yusuf Yılmaz

---

<sub>समस्या-निवारण, आर्किटेक्चर और रोडमैप के लिए [अंग्रेज़ी README](../../README.md) देखें।</sub>
