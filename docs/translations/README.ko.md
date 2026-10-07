<div align="center">

<img src="../images/icon.png" width="96" alt="Kilim">

# Kilim

**macOS 바탕화면을 위한 천 물리 시뮬레이션 러그.**
끌고, 접고, 말아 보세요 – 어수선한 바탕화면 아이콘을 러그 아래로 쓸어 넣을 수 있어요.

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](../../LICENSE)
![macOS 13+](https://img.shields.io/badge/macOS-13%2B-black?logo=apple)
[![Sponsor](https://img.shields.io/badge/sponsor-%E2%99%A5-ea4aaa?logo=githubsponsors)](https://github.com/sponsors/yusufyilmazfr)

[최신 버전 다운로드](https://github.com/yusufyilmazfr/kilim/releases/latest)

[Türkçe](README.tr.md) · [English](../../README.md) · [Kurdî](README.ku.md) · [Español](README.es.md) · [Français](README.fr.md) · [Deutsch](README.de.md) · [Português](README.pt.md) · [Italiano](README.it.md) · [Nederlands](README.nl.md) · [Polski](README.pl.md) · [Русский](README.ru.md) · [中文](README.zh.md) · [日本語](README.ja.md) · **한국어** · [हिन्दी](README.hi.md) · [বাংলা](README.bn.md) · [العربية](README.ar.md) · [فارسی](README.fa.md) · [اردو](README.ur.md) · [Bahasa Indonesia](README.id.md) · [Tiếng Việt](README.vi.md)

<img src="../images/demo-fold.jpg" width="32%" alt=""> <img src="../images/demo-roll.jpg" width="32%" alt=""> <img src="../images/demo-night.jpg" width="32%" alt="">

</div>

---

## 기능

- **진짜 천 물리** – 러그를 잡고, 당기고, 접고, 던질 수 있습니다.
- **바탕화면 아이콘 숨기기** – 아이콘이 있는 곳에 볼록한 자국이 생기고, 아이콘을 끌면 따라 움직입니다.
- **엿보기 모드** – ⌥ Option(변경 가능)을 누르고 있으면 러그가 투명해져 아래 아이콘을 클릭할 수 있습니다.
- **말기** – 더블클릭하면 러그가 돌돌 말리고, 다시 더블클릭하면 펴집니다.
- **16가지 무늬** – 페르시아, 튀르키예, 쿠르드, 이집트, 베르베르, 카자흐, 중국, 아야 소피아, 이즈니크, 셀주크… 그리고 **내 사진**으로 짠 러그.
- **낮과 밤 조명** – 시간대에 따라 색과 그림자가 바뀝니다.
- 실시간 생성되는 천 스치는 소리와 착지음(오디오 파일 없음), 다중 모니터, 21개 언어.
- 가볍고 프라이버시 친화적: 네트워크 접근과 분석이 없습니다.

## 러그 무늬

모든 무늬는 실행 시 코드로 그려지며 이미지 파일이 포함되어 있지 않습니다. **나만의 러그…**로 어떤 사진이든 테두리가 있는 러그로 짤 수 있습니다.

<div align="center">
<img src="../images/rugs/kashan.jpg" width="19%" alt="Kashan"> <img src="../images/rugs/turk.jpg" width="19%" alt="Turkish"> <img src="../images/rugs/kurd.jpg" width="19%" alt="Kurdish"> <img src="../images/rugs/egypt.jpg" width="19%" alt="Egypt"> <img src="../images/rugs/iznik.jpg" width="19%" alt="Iznik">
</div>

## 설치

```sh
curl -fsSL https://raw.githubusercontent.com/yusufyilmazfr/kilim/main/Scripts/install.sh | bash
```

1. [Releases](https://github.com/yusufyilmazfr/kilim/releases/latest)에서 `Kilim-<버전>.zip`을 다운로드합니다.
2. 압축을 풀고 **Kilim.app**을 `응용 프로그램`으로 옮깁니다.
3. 처음 실행할 때 **오른쪽 클릭 → 열기**(공증되지 않은 앱) 또는 `xattr -dr com.apple.quarantine /Applications/Kilim.app`을 실행하세요.
4. Kilim은 메뉴 막대에서 실행됩니다(Dock 아이콘 없음). macOS가 **Finder** 제어 권한을 물으면 **확인**을 누르세요. 바탕화면 아이콘 위치를 읽는 데만 사용됩니다.

소스에서 빌드하려면 macOS 13+와 Xcode 명령줄 도구만 있으면 됩니다:

```sh
git clone https://github.com/yusufyilmazfr/kilim.git
cd kilim
make run
```

## 사용법

| 동작 | 결과 |
|---|---|
| 러그 끌기 | 잡고, 옮기고, 접기 |
| 더블클릭 | 말기 / 펴기 |
| ⌥ Option 누르고 있기 | 엿보기: 러그가 투명해지고 클릭이 아이콘으로 전달됨 |
| 이미지를 메뉴 막대 아이콘에 놓기 | 나만의 러그 짜기 |
| 메뉴 막대 아이콘 | 무늬, 조명, 소리, 언어, 로그인 시 실행, 엿보기 키 |

## 개인정보 및 권한

- 네트워크 접근, 원격 측정, 계정이 없습니다.
- **자동화 → Finder** 권한은 아이콘 위치를 읽는 데만 쓰이며, 허용하지 않아도 러그는 동작하지만 볼록한 자국은 생기지 않습니다.
- 내 러그 이미지는 로컬에만 저장됩니다(`~/Library/Application Support/Kilim/`).

## 지원

- 버그 및 제안: [Issues](https://github.com/yusufyilmazfr/kilim/issues/new/choose)
- 질문 및 아이디어: [Discussions](https://github.com/yusufyilmazfr/kilim/discussions)
- Kilim은 무료입니다. 마음에 드셨다면 [GitHub Sponsors](https://github.com/sponsors/yusufyilmazfr)로 응원해 주세요.
- 저장소에 별을 눌러 주시는 것도 큰 힘이 됩니다!

## 기여하기

새 무늬, 번역, 버그 수정을 환영합니다. 먼저 [CONTRIBUTING.md](../../CONTRIBUTING.md)(영어)를 읽어 주세요.

## 라이선스

[MIT](../../LICENSE) © 2026 Yusuf Yılmaz

---

<sub>문제 해결, 아키텍처, 로드맵은 [영어 README](../../README.md)를 참고하세요.</sub>
