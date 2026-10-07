<div dir="rtl">

<div align="center">

<img src="../images/icon.png" width="96" alt="Kilim">

# Kilim

**سجادة بفيزياء القماش لسطح مكتب macOS.**
اسحبها، اطوِها، لُفّها – واكنس أيقونات سطح المكتب المبعثرة تحتها.

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](../../LICENSE)
![macOS 13+](https://img.shields.io/badge/macOS-13%2B-black?logo=apple)
[![Sponsor](https://img.shields.io/badge/sponsor-%E2%99%A5-ea4aaa?logo=githubsponsors)](https://github.com/sponsors/yusufyilmazfr)

[تنزيل أحدث إصدار](https://github.com/yusufyilmazfr/kilim/releases/latest)

[Türkçe](README.tr.md) · [English](../../README.md) · [Kurdî](README.ku.md) · [Español](README.es.md) · [Français](README.fr.md) · [Deutsch](README.de.md) · [Português](README.pt.md) · [Italiano](README.it.md) · [Nederlands](README.nl.md) · [Polski](README.pl.md) · [Русский](README.ru.md) · [中文](README.zh.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [हिन्दी](README.hi.md) · [বাংলা](README.bn.md) · **العربية** · [فارسی](README.fa.md) · [اردو](README.ur.md) · [Bahasa Indonesia](README.id.md) · [Tiếng Việt](README.vi.md)

<img src="../images/demo-fold.jpg" width="32%" alt=""> <img src="../images/demo-roll.jpg" width="32%" alt=""> <img src="../images/demo-night.jpg" width="32%" alt="">

</div>

---

## المزايا

- **فيزياء قماش حقيقية** – أمسك السجادة، اسحبها، اطوِها وارمِها.
- **تُخفي أيقونات سطح المكتب** – تظهر نتوءات حيث توجد الأيقونات وتتبعها عند سحبها.
- **وضع الإطلالة** – اضغط مطولًا على ⌥ Option (قابل للتغيير) فتصبح السجادة شفافة ويمكنك النقر على الأيقونات.
- **اللف** – انقر مرتين لتلفّ السجادة وانقر مرتين مجددًا لتنفرد.
- **16 نقشة** – فارسية، تركية، كردية، مصرية، أمازيغية، كازاخية، صينية، آيا صوفيا، إزنيق، سلجوقية… و**صورتك الخاصة** منسوجة كسجادة.
- **إضاءة النهار والليل** – يتغير اللون والظل بحسب الوقت.
- أصوات احتكاك وارتطام مولّدة برمجيًا (بلا ملفات صوتية)، دعم عدة شاشات، 21 لغة.
- خفيف وخاص: بلا اتصال بالشبكة وبلا تحليلات.

## نقوش السجاد

تُرسم جميع النقوش بالشيفرة عند التشغيل ولا توجد صور مضمّنة. عبر **سجادتي…** يمكنك نسج أي صورة في سجادة ذات إطار.

<div align="center">
<img src="../images/rugs/kashan.jpg" width="19%" alt="Kashan"> <img src="../images/rugs/turk.jpg" width="19%" alt="Turkish"> <img src="../images/rugs/kurd.jpg" width="19%" alt="Kurdish"> <img src="../images/rugs/egypt.jpg" width="19%" alt="Egypt"> <img src="../images/rugs/iznik.jpg" width="19%" alt="Iznik">
</div>

## التثبيت

```sh
curl -fsSL https://raw.githubusercontent.com/yusufyilmazfr/kilim/main/Scripts/install.sh | bash
```

1. نزّل `Kilim-<الإصدار>.zip` من صفحة [Releases](https://github.com/yusufyilmazfr/kilim/releases/latest).
2. فك الضغط واسحب **Kilim.app** إلى مجلد `التطبيقات`.
3. عند أول تشغيل: **انقر بزر الفأرة الأيمن ← فتح** (التطبيق غير موثّق) أو نفّذ: `xattr -dr com.apple.quarantine /Applications/Kilim.app`
4. يعمل Kilim من شريط القوائم (بلا أيقونة في Dock). إذا طلب macOS إذنًا للتحكم في **Finder** فاضغط **موافق** – يُستخدم فقط لقراءة مواضع الأيقونات.

للبناء من المصدر يكفي macOS 13+ وأدوات سطر أوامر Xcode:

```sh
git clone https://github.com/yusufyilmazfr/kilim.git
cd kilim
make run
```

## الاستخدام

| الإجراء | النتيجة |
|---|---|
| سحب السجادة | الإمساك بها أو حملها أو طيّها |
| نقر مزدوج | لفّ / فرد |
| الضغط مطولًا على ⌥ Option | إطلالة: السجادة شفافة والنقرات تصل إلى الأيقونات |
| إفلات صورة على أيقونة شريط القوائم | نسج سجادتك الخاصة |
| أيقونة شريط القوائم | النقشة، الإضاءة، الصوت، اللغة، التشغيل عند الدخول، مفتاح الإطلالة |

## الخصوصية والأذونات

- لا وصول إلى الشبكة ولا قياس عن بُعد ولا حسابات.
- إذن **الأتمتة ← Finder** مخصص لقراءة مواضع الأيقونات فقط؛ بدونه تعمل السجادة لكن دون نتوءات.
- تُحفظ صورة سجادتك الخاصة محليًا فقط (`~/Library/Application Support/Kilim/`).

## الدعم

- الأخطاء والاقتراحات: [Issues](https://github.com/yusufyilmazfr/kilim/issues/new/choose)
- الأسئلة والأفكار: [Discussions](https://github.com/yusufyilmazfr/kilim/discussions)
- Kilim مجاني. إن أعجبك فيمكنك دعمه عبر [GitHub Sponsors](https://github.com/sponsors/yusufyilmazfr).
- نجمة على المستودع تساعد كثيرًا أيضًا!

## المساهمة

نرحّب بالنقوش والترجمات والإصلاحات الجديدة. اقرأ أولًا [CONTRIBUTING.md](../../CONTRIBUTING.md) (بالإنجليزية).

## الترخيص

[MIT](../../LICENSE) © 2026 Yusuf Yılmaz

---

<sub>لاستكشاف الأخطاء والبنية وخارطة الطريق راجع [README بالإنجليزية](../../README.md).</sub>

</div>
