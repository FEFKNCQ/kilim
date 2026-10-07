import Foundation

enum Lang: String, CaseIterable {
    case en, zh, hi, es, ar, fr, bn, pt, ru, ur, id, de, ja, ko, it, vi, fa, pl, nl, tr, ku

    var nativeName: String {
        switch self {
        case .en: return "English"
        case .zh: return "中文 (简体)"
        case .hi: return "हिन्दी"
        case .es: return "Español"
        case .ar: return "العربية"
        case .fr: return "Français"
        case .bn: return "বাংলা"
        case .pt: return "Português"
        case .ru: return "Русский"
        case .ur: return "اردو"
        case .id: return "Bahasa Indonesia"
        case .de: return "Deutsch"
        case .ja: return "日本語"
        case .ko: return "한국어"
        case .it: return "Italiano"
        case .vi: return "Tiếng Việt"
        case .fa: return "فارسی"
        case .pl: return "Polski"
        case .nl: return "Nederlands"
        case .tr: return "Türkçe"
        case .ku: return "Kurdî"
        }
    }
}

/// Order matters: every language below lists its strings in exactly this order.
enum Str: Int, CaseIterable {
    case hideRug, showRug, tossRug, rescan, pattern, light, sounds, language, launchAtLogin, quit
    case noPermission, optionHint
    case lightAuto, lightDay, lightEvening, lightNight
    case themeTurk, themeKurd, themeEgypt, themeKhaya
    case sponsor, customRug, peekKey, size
}

enum L10n {
    /// Language menu order: Turkish, English, Kurdish, then the rest.
    static let menuOrder: [Lang] = [.tr, .en, .ku] + Lang.allCases.filter { ![.tr, .en, .ku].contains($0) }

    static var current: Lang = {
        if let raw = UserDefaults.standard.string(forKey: "language"), let l = Lang(rawValue: raw) { return l }
        for pref in Locale.preferredLanguages {
            let code = pref.lowercased().split(whereSeparator: { $0 == "-" || $0 == "_" }).first.map(String.init) ?? ""
            let mapped = (code == "ckb" || code == "kmr") ? "ku" : (code == "in" ? "id" : code)
            if let l = Lang(rawValue: mapped) { return l }
        }
        return .en
    }() {
        didSet { UserDefaults.standard.set(current.rawValue, forKey: "language") }
    }

    static func t(_ s: Str) -> String {
        if let a = table[current], s.rawValue < a.count { return a[s.rawValue] }
        return table[.en]![s.rawValue]
    }

    /// Place names (Kashan, Isfahan, Tabriz, ...) stay Latin everywhere; Turkish, English and Kurdish get descriptions.
    static func theme(_ t: RugTheme) -> String {
        switch t {
        case .turk: return L10n.t(.themeTurk)
        case .kurd: return L10n.t(.themeKurd)
        case .egypt: return L10n.t(.themeEgypt)
        case .khayamiya: return L10n.t(.themeKhaya)
        case .custom:
            return L10n.t(.customRug).replacingOccurrences(of: "…", with: "")
        case .china:
            return [Lang.tr: "Çin (ipek, şou)", .en: "Chinese (silk, shou)", .ku: "Çînî (hevrîşim)", .zh: "中国丝毯(寿)", .ja: "中国シルク(寿)"][current] ?? "Chinese silk (寿)"
        case .ayasofya:
            return [Lang.tr: "Ayasofya (mozaik)", .en: "Hagia Sophia (mosaic)", .ku: "Ayasofya (mozaîk)", .ar: "آيا صوفيا (فسيفساء)", .fa: "ایاصوفیه (موزاییک)", .de: "Hagia Sophia (Mosaik)", .ru: "Айя-София (мозаика)"][current] ?? "Hagia Sophia"
        case .iznik:
            return [Lang.tr: "İznik çinisi (Sultanahmet)", .en: "Iznik tiles (Blue Mosque)", .ku: "Çînîyên Îznîkê (Sultanahmet)"][current] ?? "Iznik (Sultanahmet)"
        case .selcuklu:
            return [Lang.tr: "Selçuklu (Konya)", .en: "Seljuk (Konya)", .ku: "Selçûqî (Konya)", .de: "Seldschuken (Konya)", .fr: "Seldjoukide (Konya)", .es: "Selyúcida (Konya)", .ru: "Сельджукский (Конья)", .ar: "سلجوقي (قونية)", .fa: "سلجوقی (قونیه)"][current] ?? "Seljuk (Konya)"
        case .berber:
            return [Lang.tr: "Fas Berberi (Beni Ourain)", .en: "Moroccan (Beni Ourain)", .ku: "Fasî (Beni Ourain)"][current] ?? "Beni Ourain (Morocco)"
        case .kazak:
            return [Lang.tr: "Kafkas (Kazak)", .en: "Caucasian (Kazak)", .ku: "Qefqasî (Kazak)"][current] ?? "Kazak (Caucasus)"
        default: break
        }
        switch current {
        case .tr:
            return ["kashan": "Kaşan (kırmızı)", "isfahan": "İsfahan (lacivert)", "tebriz": "Tebriz (bej)",
                    "turkmen": "Türkmen / Buhara", "kilim": "Kilim"][t.rawValue] ?? t.rawValue
        case .en:
            return ["kashan": "Kashan (red)", "isfahan": "Isfahan (navy)", "tebriz": "Tabriz (beige)",
                    "turkmen": "Turkmen / Bukhara", "kilim": "Kilim"][t.rawValue] ?? t.rawValue
        case .ku:
            return ["kashan": "Kaşan (sor)", "isfahan": "Îsfehan (şîn)", "tebriz": "Tebrîz (bej)",
                    "turkmen": "Tirkmen / Bûxara", "kilim": "Kilîm"][t.rawValue] ?? t.rawValue
        default:
            return ["kashan": "Kashan", "isfahan": "Isfahan", "tebriz": "Tabriz",
                    "turkmen": "Turkmen / Bukhara", "kilim": "Kilim"][t.rawValue] ?? t.rawValue
        }
    }

    /// Debug: every language must provide every string.
    static func validate() -> [String] {
        Lang.allCases.compactMap { l in
            let n = table[l]?.count ?? 0
            return n == Str.allCases.count ? nil : "\(l.rawValue): \(n) of \(Str.allCases.count)"
        }
    }

    private static let table: [Lang: [String]] = [
        .en: ["Hide Rug", "Show Rug", "Toss / Straighten Rug", "Rescan Desktop", "Rug Pattern", "Lighting", "Sounds", "Language",
              "Launch at Login", "Quit", "⚠︎ No Finder permission: bumps are off",
              "Hold ⌥ Option: rug turns see-through, click the icons",
              "Automatic (time of day)", "Day", "Evening", "Night", "Turkish (Ladik prayer rug)", "Kurdish (Jaf)",
              "Ancient Egypt (hieroglyphs)", "Egyptian Khayamiya (tentmaker)",
              "Sponsor on GitHub ♥",
              "Custom Rug from Image…",
              "Peek Key",
              "Size"
        ],
        .zh: ["隐藏地毯", "显示地毯", "抛出 / 摊平地毯", "重新扫描桌面", "地毯图案", "光照", "声音", "语言",
              "登录时启动", "退出", "⚠︎ 没有 Finder 权限:凸起已关闭",
              "按住 ⌥ Option:地毯变透明,可点击下方图标",
              "自动(随时间)", "白天", "傍晚", "夜晚", "土耳其(拉迪克祈祷毯)", "库尔德(贾夫)",
              "古埃及(象形文字)", "埃及哈雅米亚(帐篷布艺)",
              "在 GitHub 上赞助 ♥",
              "用图片制作地毯…",
              "透视按键",
              "大小"
        ],
        .hi: ["गलीचा छिपाएँ", "गलीचा दिखाएँ", "गलीचा फेंकें / सीधा करें", "डेस्कटॉप फिर स्कैन करें", "गलीचे का डिज़ाइन", "रोशनी", "ध्वनि", "भाषा",
              "लॉगिन पर शुरू करें", "बंद करें", "⚠︎ Finder की अनुमति नहीं: उभार बंद हैं",
              "⌥ Option दबाए रखें: गलीचा पारदर्शी होगा, आइकन पर क्लिक करें",
              "स्वचालित (समय के अनुसार)", "दिन", "शाम", "रात", "तुर्की (लादिक नमाज़ी गलीचा)", "कुर्दी (जाफ़)",
              "प्राचीन मिस्र (चित्रलिपि)", "मिस्री ख़यामिया (तंबू कारीगरी)",
              "GitHub पर प्रायोजित करें ♥",
              "अपनी तस्वीर से गलीचा…",
              "झलक कुंजी",
              "आकार"
        ],
        .es: ["Ocultar alfombra", "Mostrar alfombra", "Lanzar / alisar alfombra", "Volver a escanear escritorio", "Diseño de alfombra", "Iluminación", "Sonidos", "Idioma",
              "Abrir al iniciar sesión", "Salir", "⚠︎ Sin permiso de Finder: relieves desactivados",
              "Mantén ⌥ Option: la alfombra se vuelve transparente, haz clic en los iconos",
              "Automático (según la hora)", "Día", "Tarde", "Noche", "Turca (alfombra de oración Ladik)", "Kurda (Jaf)",
              "Antiguo Egipto (jeroglíficos)", "Khayamiya egipcia (toldos)",
              "Patrocinar en GitHub ♥",
              "Alfombra propia (desde imagen)…",
              "Tecla para ver debajo",
              "Tamaño"
        ],
        .ar: ["إخفاء السجادة", "إظهار السجادة", "رمي / تسوية السجادة", "إعادة فحص سطح المكتب", "نقش السجادة", "الإضاءة", "الأصوات", "اللغة",
              "التشغيل عند تسجيل الدخول", "إنهاء", "⚠︎ لا يوجد إذن Finder: النتوءات متوقفة",
              "اضغط مع الاستمرار على ⌥ Option: تصبح السجادة شفافة، انقر على الأيقونات",
              "تلقائي (حسب الوقت)", "نهار", "مساء", "ليل", "تركية (سجادة صلاة لاديك)", "كردية (جاف)",
              "مصر القديمة (هيروغليفية)", "خيامية مصرية (سرادق)",
              "ادعم على GitHub ♥",
              "سجادة من صورتك…",
              "مفتاح الإظهار",
              "الحجم"
        ],
        .fr: ["Masquer le tapis", "Afficher le tapis", "Jeter / lisser le tapis", "Réanalyser le bureau", "Motif du tapis", "Éclairage", "Sons", "Langue",
              "Ouvrir à la connexion", "Quitter", "⚠︎ Pas d'autorisation Finder : reliefs désactivés",
              "Maintenez ⌥ Option : le tapis devient transparent, cliquez sur les icônes",
              "Automatique (selon l'heure)", "Jour", "Soir", "Nuit", "Turc (tapis de prière Ladik)", "Kurde (Djaf)",
              "Égypte antique (hiéroglyphes)", "Khayamiya égyptienne (tentes)",
              "Sponsoriser sur GitHub ♥",
              "Tapis personnalisé (image)…",
              "Touche d'aperçu",
              "Taille"
        ],
        .bn: ["কার্পেট লুকান", "কার্পেট দেখান", "কার্পেট ছুড়ুন / সোজা করুন", "ডেস্কটপ আবার স্ক্যান করুন", "কার্পেটের নকশা", "আলো", "শব্দ", "ভাষা",
              "লগইনে চালু করুন", "বন্ধ করুন", "⚠︎ Finder-এর অনুমতি নেই: উঁচু অংশ বন্ধ",
              "⌥ Option ধরে রাখুন: কার্পেট স্বচ্ছ হবে, আইকনে ক্লিক করুন",
              "স্বয়ংক্রিয় (সময় অনুযায়ী)", "দিন", "সন্ধ্যা", "রাত", "তুর্কি (লাদিক জায়নামাজ)", "কুর্দি (জাফ)",
              "প্রাচীন মিশর (চিত্রলিপি)", "মিশরীয় খায়ামিয়া (তাঁবু শিল্প)",
              "GitHub-এ স্পনসর করুন ♥",
              "ছবি থেকে নিজের কার্পেট…",
              "উঁকি কী",
              "আকার"
        ],
        .pt: ["Ocultar tapete", "Mostrar tapete", "Lançar / alisar tapete", "Verificar área de trabalho novamente", "Padrão do tapete", "Iluminação", "Sons", "Idioma",
              "Abrir ao iniciar sessão", "Sair", "⚠︎ Sem permissão do Finder: relevos desativados",
              "Segure ⌥ Option: o tapete fica transparente, clique nos ícones",
              "Automático (pela hora)", "Dia", "Entardecer", "Noite", "Turco (tapete de oração Ladik)", "Curdo (Jaf)",
              "Egito Antigo (hieróglifos)", "Khayamiya egípcia (tendas)",
              "Patrocinar no GitHub ♥",
              "Tapete próprio (da imagem)…",
              "Tecla de espiar",
              "Tamanho"
        ],
        .ru: ["Скрыть ковёр", "Показать ковёр", "Бросить / разгладить ковёр", "Пересканировать рабочий стол", "Узор ковра", "Освещение", "Звуки", "Язык",
              "Запускать при входе", "Выйти", "⚠︎ Нет доступа к Finder: неровности отключены",
              "Удерживайте ⌥ Option: ковёр станет прозрачным, нажимайте на значки",
              "Автоматически (по времени)", "День", "Вечер", "Ночь", "Турецкий (молитвенный ковёр Ладик)", "Курдский (джаф)",
              "Древний Египет (иероглифы)", "Египетская хаямия (палаточная)",
              "Поддержать на GitHub ♥",
              "Свой ковёр из картинки…",
              "Клавиша просмотра",
              "Размер"
        ],
        .ur: ["قالین چھپائیں", "قالین دکھائیں", "قالین پھینکیں / سیدھا کریں", "ڈیسک ٹاپ دوبارہ اسکین کریں", "قالین کا نقش", "روشنی", "آوازیں", "زبان",
              "لاگ اِن پر شروع کریں", "بند کریں", "⚠︎ Finder کی اجازت نہیں: ابھار بند ہیں",
              "⌥ Option دبائے رکھیں: قالین شفاف ہو جائے گا، آئیکنز پر کلک کریں",
              "خودکار (وقت کے مطابق)", "دن", "شام", "رات", "ترکی (لادک جائے نماز)", "کردی (جاف)",
              "قدیم مصر (ہیروگلیف)", "مصری خیامیہ (خیمہ دوزی)",
              "GitHub پر سپانسر کریں ♥",
              "اپنی تصویر سے قالین…",
              "جھانکنے کی کلید",
              "سائز"
        ],
        .id: ["Sembunyikan Karpet", "Tampilkan Karpet", "Lempar / Ratakan Karpet", "Pindai Ulang Desktop", "Motif Karpet", "Pencahayaan", "Suara", "Bahasa",
              "Buka saat Login", "Keluar", "⚠︎ Tanpa izin Finder: tonjolan nonaktif",
              "Tahan ⌥ Option: karpet jadi transparan, klik ikon di bawahnya",
              "Otomatis (sesuai waktu)", "Siang", "Sore", "Malam", "Turki (sajadah Ladik)", "Kurdi (Jaf)",
              "Mesir Kuno (hieroglif)", "Khayamiya Mesir (tenda)",
              "Sponsori di GitHub ♥",
              "Karpet sendiri dari gambar…",
              "Tombol Intip",
              "Ukuran"
        ],
        .de: ["Teppich ausblenden", "Teppich einblenden", "Teppich werfen / glätten", "Schreibtisch neu scannen", "Teppichmuster", "Beleuchtung", "Töne", "Sprache",
              "Beim Anmelden öffnen", "Beenden", "⚠︎ Keine Finder-Berechtigung: Erhebungen aus",
              "⌥ Option halten: Teppich wird durchsichtig, Symbole anklicken",
              "Automatisch (nach Uhrzeit)", "Tag", "Abend", "Nacht", "Türkisch (Ladik-Gebetsteppich)", "Kurdisch (Jaf)",
              "Altes Ägypten (Hieroglyphen)", "Ägyptische Khayamiya (Zeltstoff)",
              "Auf GitHub sponsern ♥",
              "Eigener Teppich aus Bild…",
              "Spähtaste",
              "Größe"
        ],
        .ja: ["ラグを隠す", "ラグを表示", "ラグを投げる / 整える", "デスクトップを再スキャン", "ラグの柄", "照明", "サウンド", "言語",
              "ログイン時に開く", "終了", "⚠︎ Finderの権限がありません: 凹凸はオフ",
              "⌥ Optionを押し続ける: ラグが透けてアイコンをクリックできます",
              "自動(時刻に合わせる)", "昼", "夕方", "夜", "トルコ(ラディク礼拝用ラグ)", "クルド(ジャフ)",
              "古代エジプト(ヒエログリフ)", "エジプトのハヤミーヤ(テント布)",
              "GitHubでスポンサーになる ♥",
              "画像からオリジナルラグ…",
              "のぞき見キー",
              "サイズ"
        ],
        .ko: ["러그 숨기기", "러그 보이기", "러그 던지기 / 펴기", "데스크탑 다시 검색", "러그 무늬", "조명", "소리", "언어",
              "로그인 시 실행", "종료", "⚠︎ Finder 권한 없음: 요철 꺼짐",
              "⌥ Option 누르기: 러그가 투명해져 아이콘을 클릭할 수 있습니다",
              "자동(시간에 따라)", "낮", "저녁", "밤", "튀르키예(라딕 기도 러그)", "쿠르드(자프)",
              "고대 이집트(상형문자)", "이집트 카야미야(텐트 아플리케)",
              "GitHub에서 후원하기 ♥",
              "이미지로 나만의 러그…",
              "미리보기 키",
              "크기"
        ],
        .it: ["Nascondi tappeto", "Mostra tappeto", "Lancia / stendi tappeto", "Riscansiona scrivania", "Motivo del tappeto", "Illuminazione", "Suoni", "Lingua",
              "Apri al login", "Esci", "⚠︎ Nessun permesso Finder: rilievi disattivati",
              "Tieni premuto ⌥ Option: il tappeto diventa trasparente, clicca sulle icone",
              "Automatico (in base all'ora)", "Giorno", "Sera", "Notte", "Turco (tappeto da preghiera Ladik)", "Curdo (Jaf)",
              "Antico Egitto (geroglifici)", "Khayamiya egiziana (tende)",
              "Sponsorizza su GitHub ♥",
              "Tappeto personalizzato da immagine…",
              "Tasto anteprima",
              "Dimensione"
        ],
        .vi: ["Ẩn thảm", "Hiện thảm", "Ném / Làm phẳng thảm", "Quét lại màn hình nền", "Hoa văn thảm", "Ánh sáng", "Âm thanh", "Ngôn ngữ",
              "Mở khi đăng nhập", "Thoát", "⚠︎ Không có quyền Finder: tắt độ nổi",
              "Giữ ⌥ Option: thảm trong suốt, bấm vào các biểu tượng",
              "Tự động (theo giờ)", "Ban ngày", "Buổi tối", "Ban đêm", "Thổ Nhĩ Kỳ (thảm cầu nguyện Ladik)", "Người Kurd (Jaf)",
              "Ai Cập cổ đại (chữ tượng hình)", "Khayamiya Ai Cập (vải lều)",
              "Tài trợ trên GitHub ♥",
              "Thảm riêng từ hình ảnh…",
              "Phím xem trộm",
              "Kích thước"
        ],
        .fa: ["پنهان کردن فرش", "نمایش فرش", "پرتاب / صاف کردن فرش", "اسکن دوباره دسکتاپ", "طرح فرش", "نورپردازی", "صداها", "زبان",
              "اجرا هنگام ورود", "خروج", "⚠︎ مجوز Finder وجود ندارد: برجستگی‌ها خاموش است",
              "⌥ Option را نگه دارید: فرش شفاف می‌شود، روی آیکن‌ها کلیک کنید",
              "خودکار (بر اساس ساعت)", "روز", "غروب", "شب", "ترکی (سجاده لادیک)", "کردی (جاف)",
              "مصر باستان (هیروگلیف)", "خیامیه مصری (چادردوزی)",
              "حمایت در GitHub ♥",
              "فرش شخصی از تصویر…",
              "کلید نمایش زیر",
              "اندازه"
        ],
        .pl: ["Ukryj dywan", "Pokaż dywan", "Rzuć / wygładź dywan", "Skanuj pulpit ponownie", "Wzór dywanu", "Oświetlenie", "Dźwięki", "Język",
              "Uruchamiaj przy logowaniu", "Zakończ", "⚠︎ Brak uprawnień Finder: wybrzuszenia wyłączone",
              "Przytrzymaj ⌥ Option: dywan stanie się przezroczysty, klikaj ikony",
              "Automatyczne (wg pory dnia)", "Dzień", "Wieczór", "Noc", "Turecki (dywanik modlitewny Ladik)", "Kurdyjski (Jaf)",
              "Starożytny Egipt (hieroglify)", "Egipska chajamija (namiotowa)",
              "Wesprzyj na GitHubie ♥",
              "Własny dywan z obrazu…",
              "Klawisz podglądu",
              "Rozmiar"
        ],
        .nl: ["Kleed verbergen", "Kleed tonen", "Kleed gooien / gladstrijken", "Bureaublad opnieuw scannen", "Kleedpatroon", "Verlichting", "Geluiden", "Taal",
              "Openen bij inloggen", "Stop", "⚠︎ Geen Finder-toestemming: bulten uit",
              "Houd ⌥ Option ingedrukt: het kleed wordt doorzichtig, klik op de iconen",
              "Automatisch (naar tijd)", "Dag", "Avond", "Nacht", "Turks (Ladik-gebedskleed)", "Koerdisch (Jaf)",
              "Oud-Egypte (hiërogliefen)", "Egyptische khayamiya (tentstof)",
              "Sponsor op GitHub ♥",
              "Eigen kleed van afbeelding…",
              "Gluurtoets",
              "Grootte"
        ],
        .tr: ["Halıyı Gizle", "Halıyı Göster", "Halıyı At / Düzelt", "Masaüstünü Yeniden Tara", "Halı Deseni", "Işık", "Sesler", "Dil",
              "Girişte Başlat", "Çıkış", "⚠︎ Finder izni yok: tümsekler kapalı",
              "⌥ Option basılı tut: halı şeffaflaşır, ikonlara tıkla",
              "Otomatik (saate göre)", "Gündüz", "Akşam", "Gece", "Türk (Ladik seccade)", "Kürt (Caf)",
              "Antik Mısır (hiyeroglif)", "Mısır Hayameya (çadırcı)",
              "Sponsor Ol ♥",
              "Kendi Halın (resimden)…",
              "Göz Atma Tuşu",
              "Boyut"
        ],
        .ku: ["Xalîçeyê Veşêre", "Xalîçeyê Nîşan Bide", "Xalîçeyê Biavêje / Rast Bike", "Sermaseyê Dîsa Bigere", "Nexşa Xalîçeyê", "Ronahî", "Deng", "Ziman",
              "Di Têketinê de Dest Pê Bike", "Derkeve", "⚠︎ Destûra Finder tune: bilindahî girtî ne",
              "⌥ Option bigire: xalîçe zelal dibe, li îkonan bitikîne",
              "Otomatîk (li gorî saetê)", "Roj", "Êvar", "Şev", "Tirk (Ladîk, secade)", "Kurdî (Caf)",
              "Misira Kevin (hîyeroglîf)", "Xeyamiya Misirî (konî)",
              "Li ser GitHub Piştgirî bike ♥",
              "Xalîçeya Xwe (ji wêne)…",
              "Bişkoka Dîtinê",
              "Mezinahî"
        ],
    ]
}
