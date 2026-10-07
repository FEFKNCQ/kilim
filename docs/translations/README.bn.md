<div align="center">

<img src="../images/icon.png" width="96" alt="Kilim">

# Kilim

**আপনার macOS ডেস্কটপের জন্য কাপড়ের পদার্থবিদ্যায় চলা কার্পেট।**
টানুন, ভাঁজ করুন, গুটিয়ে ফেলুন – আর এলোমেলো ডেস্কটপ আইকনগুলো ঝাঁট দিয়ে তার নিচে লুকিয়ে ফেলুন।

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](../../LICENSE)
![macOS 13+](https://img.shields.io/badge/macOS-13%2B-black?logo=apple)
[![Sponsor](https://img.shields.io/badge/sponsor-%E2%99%A5-ea4aaa?logo=githubsponsors)](https://github.com/sponsors/yusufyilmazfr)

[সর্বশেষ সংস্করণ ডাউনলোড করুন](https://github.com/yusufyilmazfr/kilim/releases/latest)

[Türkçe](README.tr.md) · [English](../../README.md) · [Kurdî](README.ku.md) · [Español](README.es.md) · [Français](README.fr.md) · [Deutsch](README.de.md) · [Português](README.pt.md) · [Italiano](README.it.md) · [Nederlands](README.nl.md) · [Polski](README.pl.md) · [Русский](README.ru.md) · [中文](README.zh.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [हिन्दी](README.hi.md) · **বাংলা** · [العربية](README.ar.md) · [فارسی](README.fa.md) · [اردو](README.ur.md) · [Bahasa Indonesia](README.id.md) · [Tiếng Việt](README.vi.md)

<img src="../images/demo-fold.jpg" width="32%" alt=""> <img src="../images/demo-roll.jpg" width="32%" alt=""> <img src="../images/demo-night.jpg" width="32%" alt="">

</div>

---

## বৈশিষ্ট্য

- **বাস্তব কাপড়ের পদার্থবিদ্যা** – কার্পেট ধরুন, টানুন, ভাঁজ করুন, ছুড়ে দিন।
- **ডেস্কটপ আইকন লুকায়** – আইকনের জায়গায় উঁচু ঢিবি তৈরি হয়, আইকন টানলে ঢিবিও সঙ্গে সরে।
- **উঁকি মোড** – ⌥ Option (পরিবর্তনযোগ্য) চেপে ধরুন: কার্পেট স্বচ্ছ হয়ে যায় এবং নিচের আইকনে ক্লিক করা যায়।
- **গুটানো** – ডাবল-ক্লিকে কার্পেট গুটিয়ে যায়, আবার ডাবল-ক্লিকে খুলে যায়।
- **১৬টি নকশা** – ফার্সি, তুর্কি, কুর্দি, মিশরীয়, বার্বার, কাজাখ, চীনা, আয়া সোফিয়া, ইজনিক, সেলজুক… এবং **আপনার নিজের ছবি** থেকে বোনা কার্পেট।
- **দিন-রাতের আলো** – রং ও ছায়া দিনের সময় অনুযায়ী বদলায়।
- কোড থেকে তৈরি খসখস ও ধপ শব্দ (কোনো অডিও ফাইল নেই), একাধিক মনিটর, ২১টি ভাষা।
- হালকা ও গোপনীয়তা-বান্ধব: নেটওয়ার্ক অ্যাক্সেস নেই, অ্যানালিটিক্স নেই।

## কার্পেটের নকশা

সব নকশা চালুর সময় কোড দিয়ে আঁকা হয়; প্যাকেজে কোনো ছবির ফাইল নেই। **আমার কার্পেট…** দিয়ে যেকোনো ছবিকে পাড়যুক্ত কার্পেটে বুনতে পারবেন।

<div align="center">
<img src="../images/rugs/kashan.jpg" width="19%" alt="Kashan"> <img src="../images/rugs/turk.jpg" width="19%" alt="Turkish"> <img src="../images/rugs/kurd.jpg" width="19%" alt="Kurdish"> <img src="../images/rugs/egypt.jpg" width="19%" alt="Egypt"> <img src="../images/rugs/iznik.jpg" width="19%" alt="Iznik">
</div>

## ইনস্টলেশন

```sh
curl -fsSL https://raw.githubusercontent.com/yusufyilmazfr/kilim/main/Scripts/install.sh | bash
```

1. [Releases](https://github.com/yusufyilmazfr/kilim/releases/latest) থেকে `Kilim-<সংস্করণ>.zip` ডাউনলোড করুন।
2. আনজিপ করে **Kilim.app** কে `Applications` ফোল্ডারে টেনে নিন।
3. প্রথমবার **রাইট-ক্লিক → Open** করুন (অ্যাপটি নোটারাইজড নয়) অথবা চালান: `xattr -dr com.apple.quarantine /Applications/Kilim.app`
4. Kilim মেনু বারে থাকে (Dock-এ আইকন নেই)। macOS **Finder** নিয়ন্ত্রণের অনুমতি চাইলে **OK** দিন – এটি শুধু আইকনের অবস্থান পড়ার জন্য।

সোর্স থেকে বানাতে macOS 13+ এবং Xcode Command Line Tools-ই যথেষ্ট:

```sh
git clone https://github.com/yusufyilmazfr/kilim.git
cd kilim
make run
```

## ব্যবহার

| কাজ | ফল |
|---|---|
| কার্পেট টানা | ধরা, বহন করা বা ভাঁজ করা |
| ডাবল-ক্লিক | গুটানো / খোলা |
| ⌥ Option চেপে ধরা | উঁকি: কার্পেট স্বচ্ছ, ক্লিক আইকনে পৌঁছায় |
| মেনু বার আইকনে ছবি ফেলা | নিজের কার্পেট বোনা |
| মেনু বার আইকন | নকশা, আলো, শব্দ, ভাষা, লগইনে চালু, উঁকি কী |

## গোপনীয়তা ও অনুমতি

- কোনো নেটওয়ার্ক অ্যাক্সেস, টেলিমেট্রি বা অ্যাকাউন্ট নেই।
- **Automation → Finder** অনুমতি শুধু আইকনের অবস্থান পড়তে লাগে; না দিলেও কার্পেট চলে, শুধু ঢিবি হয় না।
- আপনার কার্পেটের ছবি শুধু স্থানীয়ভাবে সংরক্ষিত থাকে (`~/Library/Application Support/Kilim/`)।

## সহায়তা

- বাগ ও অনুরোধ: [Issues](https://github.com/yusufyilmazfr/kilim/issues/new/choose)
- প্রশ্ন ও ধারণা: [Discussions](https://github.com/yusufyilmazfr/kilim/discussions)
- Kilim বিনামূল্যে। ভালো লাগলে [GitHub Sponsors](https://github.com/sponsors/yusufyilmazfr)-এ সমর্থন করুন।
- রিপোজিটরিতে একটি স্টার দিলেও অনেক সাহায্য হয়!

## অবদান

নতুন নকশা, অনুবাদ ও বাগ-সংশোধন স্বাগত। আগে [CONTRIBUTING.md](../../CONTRIBUTING.md) (ইংরেজি) পড়ে নিন।

## লাইসেন্স

[MIT](../../LICENSE) © 2026 Yusuf Yılmaz

---

<sub>সমস্যা সমাধান, আর্কিটেকচার ও রোডম্যাপের জন্য [ইংরেজি README](../../README.md) দেখুন।</sub>
