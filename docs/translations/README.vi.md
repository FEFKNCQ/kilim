<div align="center">

<img src="../images/icon.png" width="96" alt="Kilim">

# Kilim

**Một tấm thảm mô phỏng vật lý vải cho màn hình nền macOS của bạn.**
Kéo nó, gấp nó, cuộn nó – và quét những biểu tượng bừa bộn trên màn hình nền xuống dưới thảm.

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](../../LICENSE)
![macOS 13+](https://img.shields.io/badge/macOS-13%2B-black?logo=apple)
[![Sponsor](https://img.shields.io/badge/sponsor-%E2%99%A5-ea4aaa?logo=githubsponsors)](https://github.com/sponsors/yusufyilmazfr)

[Tải phiên bản mới nhất](https://github.com/yusufyilmazfr/kilim/releases/latest)

[Türkçe](README.tr.md) · [English](../../README.md) · [Kurdî](README.ku.md) · [Español](README.es.md) · [Français](README.fr.md) · [Deutsch](README.de.md) · [Português](README.pt.md) · [Italiano](README.it.md) · [Nederlands](README.nl.md) · [Polski](README.pl.md) · [Русский](README.ru.md) · [中文](README.zh.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [हिन्दी](README.hi.md) · [বাংলা](README.bn.md) · [العربية](README.ar.md) · [فارسی](README.fa.md) · [اردو](README.ur.md) · [Bahasa Indonesia](README.id.md) · **Tiếng Việt**

<img src="../images/demo-fold.jpg" width="32%" alt=""> <img src="../images/demo-roll.jpg" width="32%" alt=""> <img src="../images/demo-night.jpg" width="32%" alt="">

</div>

---

## Tính năng

- **Vật lý vải thực tế** – nắm, kéo, gấp và quăng tấm thảm.
- **Giấu biểu tượng màn hình nền** – chỗ có biểu tượng sẽ nhô lên và đi theo biểu tượng khi bạn kéo.
- **Chế độ nhìn trộm** – giữ ⌥ Option (có thể đổi): thảm trở nên trong suốt và bạn có thể bấm vào các biểu tượng bên dưới.
- **Cuộn thảm** – nhấp đúp để cuộn thảm lại, nhấp đúp lần nữa để trải ra.
- **16 hoa văn** – Ba Tư, Thổ Nhĩ Kỳ, người Kurd, Ai Cập, Berber, Kazakh, Trung Hoa, Hagia Sophia, İznik, Seljuk… và **ảnh của chính bạn** được dệt thành thảm.
- **Ánh sáng ngày và đêm** – màu sắc và bóng đổ thay đổi theo giờ.
- Âm thanh sột soạt và va chạm được tạo bằng mã (không có tệp âm thanh), nhiều màn hình, 21 ngôn ngữ.
- Nhẹ và riêng tư: không truy cập mạng, không phân tích dữ liệu.

## Hoa văn thảm

Mọi hoa văn được vẽ bằng mã khi khởi động; không có tệp ảnh đi kèm. Với **Thảm của tôi…** bạn có thể dệt bất kỳ bức ảnh nào thành tấm thảm có viền.

<div align="center">
<img src="../images/rugs/kashan.jpg" width="19%" alt="Kashan"> <img src="../images/rugs/turk.jpg" width="19%" alt="Turkish"> <img src="../images/rugs/kurd.jpg" width="19%" alt="Kurdish"> <img src="../images/rugs/egypt.jpg" width="19%" alt="Egypt"> <img src="../images/rugs/iznik.jpg" width="19%" alt="Iznik">
</div>

## Cài đặt

```sh
curl -fsSL https://raw.githubusercontent.com/yusufyilmazfr/kilim/main/Scripts/install.sh | bash
```

1. Tải `Kilim-<phiên bản>.zip` từ [Releases](https://github.com/yusufyilmazfr/kilim/releases/latest).
2. Giải nén và kéo **Kilim.app** vào thư mục `Applications`.
3. Lần đầu mở, **nhấp chuột phải → Open** (ứng dụng chưa được công chứng) hoặc chạy: `xattr -dr com.apple.quarantine /Applications/Kilim.app`
4. Kilim chạy trên thanh menu (không có biểu tượng Dock). Nếu macOS hỏi quyền điều khiển **Finder**, hãy bấm **OK** – quyền này chỉ để đọc vị trí biểu tượng.

Để tự biên dịch từ mã nguồn, chỉ cần macOS 13+ và Xcode Command Line Tools:

```sh
git clone https://github.com/yusufyilmazfr/kilim.git
cd kilim
make run
```

## Cách dùng

| Thao tác | Kết quả |
|---|---|
| Kéo tấm thảm | Nắm, mang hoặc gấp |
| Nhấp đúp | Cuộn / trải thảm |
| Giữ ⌥ Option | Nhìn trộm: thảm trong suốt, cú nhấp xuyên xuống biểu tượng |
| Thả ảnh lên biểu tượng thanh menu | Dệt thảm của riêng bạn |
| Biểu tượng thanh menu | Hoa văn, ánh sáng, âm thanh, ngôn ngữ, mở khi đăng nhập, phím nhìn trộm |

## Quyền riêng tư và quyền truy cập

- Không truy cập mạng, không thu thập dữ liệu, không tài khoản.
- Quyền **Automation → Finder** chỉ để đọc vị trí biểu tượng; nếu không cấp, thảm vẫn chạy nhưng không có chỗ nhô lên.
- Ảnh thảm tùy chỉnh của bạn chỉ được lưu cục bộ (`~/Library/Application Support/Kilim/`).

## Hỗ trợ

- Lỗi và đề xuất: [Issues](https://github.com/yusufyilmazfr/kilim/issues/new/choose)
- Câu hỏi và ý tưởng: [Discussions](https://github.com/yusufyilmazfr/kilim/discussions)
- Kilim miễn phí. Nếu bạn thích, hãy ủng hộ qua [GitHub Sponsors](https://github.com/sponsors/yusufyilmazfr).
- Tặng sao cho kho mã cũng giúp ích rất nhiều!

## Đóng góp

Chào đón hoa văn mới, bản dịch và sửa lỗi. Vui lòng đọc [CONTRIBUTING.md](../../CONTRIBUTING.md) (tiếng Anh) trước.

## Giấy phép

[MIT](../../LICENSE) © 2026 Yusuf Yılmaz

---

<sub>Xem khắc phục sự cố, kiến trúc và lộ trình trong [README tiếng Anh](../../README.md).</sub>
