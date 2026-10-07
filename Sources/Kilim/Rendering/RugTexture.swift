import simd
import AppKit
import CoreGraphics

struct RNG {
    var s: UInt64
    init(_ seed: UInt64) { s = seed }
    mutating func next() -> Double {
        s &+= 0x9E37_79B9_7F4A_7C15
        var z = s
        z = (z ^ (z >> 30)) &* 0xBF58_476D_1CE4_E5B9
        z = (z ^ (z >> 27)) &* 0x94D0_49BB_1331_11EB
        z ^= z >> 31
        return Double(z >> 11) / Double(UInt64(1) << 53)
    }
}

private func hex(_ v: UInt32, _ a: CGFloat = 1) -> CGColor {
    CGColor(red: CGFloat((v >> 16) & 255) / 255, green: CGFloat((v >> 8) & 255) / 255,
            blue: CGFloat(v & 255) / 255, alpha: a)
}

enum RugTheme: String, CaseIterable {
    case kashan, isfahan, tebriz, turkmen, kilim, turk, kurd, egypt, khayamiya, berber, kazak, china, ayasofya, iznik, selcuklu, custom
}

private struct Palette {
    var red, red2, red3, rose, navy, navy2, teal, green, cream, ivory, gold, ink, dot: CGColor
    var fieldGrad: [CGColor]

    static func make(_ t: RugTheme) -> Palette {
        var p = Palette(red: hex(0x9A2317), red2: hex(0x6B120C), red3: hex(0xC4472C), rose: hex(0xDB8F70),
                        navy: hex(0x131A3B), navy2: hex(0x25325F), teal: hex(0x1D6A6B), green: hex(0x55794A),
                        cream: hex(0xEBDAB5), ivory: hex(0xF4EACF), gold: hex(0xD3A440), ink: hex(0x0D0A1B),
                        dot: hex(0xB9C4E8), fieldGrad: [hex(0xA82B1B), hex(0x8A1D13), hex(0x6F150E)])
        switch t {
        case .kashan: break
        case .isfahan:
            p.red = hex(0x17234F); p.red2 = hex(0x0C1536)
            p.navy = hex(0x7E1A12); p.navy2 = hex(0x5F120C)
            p.dot = hex(0xE8C4B9)
            p.fieldGrad = [hex(0x25356E), hex(0x182656), hex(0x0F1840)]
        case .tebriz:
            p.red = hex(0xCDB488); p.red2 = hex(0x7A1D13); p.red3 = hex(0xB23A24); p.rose = hex(0xC96F55)
            p.navy = hex(0x172052); p.navy2 = hex(0x22306A)
            p.cream = hex(0xF3E6C4)
            p.fieldGrad = [hex(0xDDC89E), hex(0xCBB17F), hex(0xB09560)]
        case .turkmen:
            p.red = hex(0x6E1710); p.red2 = hex(0x4A0D08); p.red3 = hex(0xB8502A)
            p.navy = hex(0x1B1E38); p.navy2 = hex(0x2B2F52); p.teal = hex(0x2D5A58)
            p.cream = hex(0xE6D8B8); p.gold = hex(0xC89A3A)
            p.fieldGrad = [hex(0x80201A), hex(0x6A150E), hex(0x4E0E09)]
        case .turk:
            p.red = hex(0x8E1A14); p.red2 = hex(0x5E100B); p.red3 = hex(0xC8402A)
            p.navy = hex(0x1A2A57); p.navy2 = hex(0x24407A); p.teal = hex(0x1F6E5A); p.green = hex(0x4F7A3A)
            p.dot = hex(0xB9C4E8); p.gold = hex(0xE0AE3E)
            p.fieldGrad = [hex(0x9C1F17), hex(0x82170F), hex(0x5E100B)]
        case .kurd:
            p.red = hex(0xB04A2B); p.red2 = hex(0x6A2A18); p.red3 = hex(0xC9633A); p.rose = hex(0xD98A8A)
            p.navy = hex(0x1B2650); p.navy2 = hex(0x2E3F7A); p.teal = hex(0x2E6F6B); p.green = hex(0x4C7A3B)
            p.cream = hex(0xEFE2C3); p.gold = hex(0xE0A526); p.ink = hex(0x15110F)
            p.fieldGrad = [hex(0x1B2650), hex(0x1B2650), hex(0x1B2650)]
        case .egypt:
            p.red = hex(0xB5301F); p.red2 = hex(0x7A1D13); p.red3 = hex(0xD6522F); p.rose = hex(0xE8A07A)
            p.navy = hex(0x14357A); p.navy2 = hex(0x1F4FA0); p.teal = hex(0x1FA6A0); p.green = hex(0x2E8B57)
            p.cream = hex(0xEAD7A3); p.ivory = hex(0xF6EDCF); p.gold = hex(0xE2B53E); p.ink = hex(0x0B0B14)
            p.fieldGrad = [hex(0xEBD9A8), hex(0xDCC48A), hex(0xC4A767)]
        case .khayamiya:
            p.red = hex(0xB3261E); p.red2 = hex(0x7C1A14); p.red3 = hex(0xCF4A32); p.rose = hex(0xE0907A)
            p.navy = hex(0x1F2D5C); p.navy2 = hex(0x2F4488); p.teal = hex(0x2D7C86); p.green = hex(0x2E6B4A)
            p.cream = hex(0xEFE3C8); p.ivory = hex(0xF7EFDA); p.gold = hex(0xD9A23B); p.ink = hex(0x14110F)
            p.fieldGrad = [hex(0xEFE3C8), hex(0xEFE3C8), hex(0xE6D8B6)]
        case .berber:
            p.cream = hex(0xEFE6D2); p.ivory = hex(0xF3ECDA); p.ink = hex(0x2B2622); p.red = hex(0x2B2622)
            p.fieldGrad = [hex(0xF1E9D6), hex(0xEADFC6), hex(0xE0D3B6)]
        case .kazak:
            p.red = hex(0xA3281D); p.red2 = hex(0x701810); p.red3 = hex(0xC24A30)
            p.navy = hex(0x1E2A5A); p.navy2 = hex(0x34518F); p.teal = hex(0x2C7A78); p.green = hex(0x3C6B3A)
            p.cream = hex(0xE9DDBE); p.ivory = hex(0xF3EAD0); p.gold = hex(0xD9A12F); p.ink = hex(0x16100D)
            p.fieldGrad = [hex(0xA3281D), hex(0xA3281D), hex(0x8A2017)]
        case .china:
            p.red = hex(0xA21E1E); p.red2 = hex(0x6E1212); p.red3 = hex(0xD2422F); p.rose = hex(0xF0B6A5)
            p.navy = hex(0x15275A); p.navy2 = hex(0x22407F); p.teal = hex(0x2C8C98); p.green = hex(0x3C7A52)
            p.cream = hex(0xF1E6C8); p.ivory = hex(0xF8F0DA); p.gold = hex(0xE0B040); p.ink = hex(0x0B0F24)
            p.fieldGrad = [hex(0x22407F), hex(0x182E66), hex(0x101E4C)]
        case .ayasofya:
            p.red = hex(0x6E1F28); p.red2 = hex(0x4A1219); p.red3 = hex(0x9A3038); p.rose = hex(0xD9B070)
            p.navy = hex(0x1C3B31); p.navy2 = hex(0x2A5646); p.teal = hex(0x2E7A68); p.green = hex(0x2F6A4A)
            p.cream = hex(0xEBD9A2); p.ivory = hex(0xF5EBC8); p.gold = hex(0xD9A93A); p.ink = hex(0x15100A)
            p.fieldGrad = [hex(0xD6A540), hex(0xC9972E), hex(0xB5841F)]
        case .iznik:
            p.red = hex(0xD2452F); p.red2 = hex(0x9C2B1C); p.red3 = hex(0xE8664A); p.rose = hex(0xF1A08C)
            p.navy = hex(0x1B4A9C); p.navy2 = hex(0x2A63BD); p.teal = hex(0x2BA8B0); p.green = hex(0x2F8F5A)
            p.cream = hex(0xF4EFE2); p.ivory = hex(0xFBF8EE); p.gold = hex(0xE3B53C); p.ink = hex(0x0F2557)
            p.fieldGrad = [hex(0xFBF8EE), hex(0xF4EFE2), hex(0xEAE3D0)]
        case .selcuklu:
            p.red = hex(0x7A2F1C); p.red2 = hex(0x4E1D10); p.red3 = hex(0xB5622F); p.rose = hex(0xD9A06A)
            p.navy = hex(0x0F2250); p.navy2 = hex(0x1B3C7E); p.teal = hex(0x22A5B0); p.green = hex(0x2A7A68)
            p.cream = hex(0xE8DDBF); p.ivory = hex(0xF3EBD2); p.gold = hex(0xD9A93A); p.ink = hex(0x0A0D1A)
            p.fieldGrad = [hex(0x1B3C7E), hex(0x142C62), hex(0x0F2250)]
        case .custom:
            if let img = RugTexture.customImage { RugTexture.applyCustomPalette(&p, from: img) }
            p.fieldGrad = [p.navy, p.navy, p.navy]
        case .kilim:
            p.red = hex(0xA6442A); p.red2 = hex(0x5C2416); p.red3 = hex(0xC25A32)
            p.navy = hex(0x23305C); p.navy2 = hex(0x34457A); p.teal = hex(0x2F6D6B)
            p.cream = hex(0xEFE2C3); p.gold = hex(0xD19A2E); p.ink = hex(0x1A1410)
            p.fieldGrad = [hex(0xD9BF8F), hex(0xD9BF8F), hex(0xD9BF8F)]
        }
        return p
    }
}

/// Procedurally painted Persian rug: Shah-Abbasi palmette border, scalloped medallion with pendants,
/// Herati field, spandrels, guard stripes and fringe. Designed in a 1280x860 space, rendered at 1.2x.
enum RugTexture {
    // ---- user's own picture ----
    static var customURL: URL {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0].appendingPathComponent("Kilim")
        try? FileManager.default.createDirectory(at: base, withIntermediateDirectories: true)
        return base.appendingPathComponent("custom.png")
    }
    static var customImage: CGImage? = {
        guard let src = CGImageSourceCreateWithURL(customURL as CFURL, nil) else { return nil }
        return CGImageSourceCreateImageAtIndex(src, 0, nil)
    }()
    static var hasCustom: Bool { customImage != nil }

    /// Loads any image file, shrinks it, stores it as the user's rug picture. Returns false if it can't be read.
    @discardableResult
    static func setCustom(from url: URL) -> Bool {
        guard let src = CGImageSourceCreateWithURL(url as CFURL, nil),
              let thumb = CGImageSourceCreateThumbnailAtIndex(src, 0, [
                kCGImageSourceCreateThumbnailFromImageAlways: true, kCGImageSourceCreateThumbnailWithTransform: true,
                kCGImageSourceThumbnailMaxPixelSize: 1400] as CFDictionary),
              let dst = CGImageDestinationCreateWithURL(customURL as CFURL, "public.png" as CFString, 1, nil) else { return false }
        CGImageDestinationAddImage(dst, thumb, nil)
        guard CGImageDestinationFinalize(dst) else { return false }
        customImage = thumb
        return true
    }

    /// Picks the colours of the border from the picture itself: average, most vivid, darkest, lightest.
    fileprivate static func applyCustomPalette(_ p: inout Palette, from img: CGImage) {
        let n = 20
        var px = [UInt8](repeating: 0, count: n * n * 4)
        let ctx = CGContext(data: &px, width: n, height: n, bitsPerComponent: 8, bytesPerRow: n * 4,
                            space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        ctx.interpolationQuality = .medium
        ctx.draw(img, in: CGRect(x: 0, y: 0, width: n, height: n))
        var avg = SIMD3<Double>(0, 0, 0)
        var vivid = SIMD3<Double>(0.6, 0.2, 0.15), vividS = -1.0
        var dark = SIMD3<Double>(0.1, 0.1, 0.15), darkL = 2.0
        var light = SIMD3<Double>(0.9, 0.85, 0.7), lightL = -1.0
        for i in 0..<(n * n) {
            let c = SIMD3(Double(px[i * 4]), Double(px[i * 4 + 1]), Double(px[i * 4 + 2])) / 255
            avg += c
            let mx = max(c.x, c.y, c.z), mn = min(c.x, c.y, c.z)
            let sat = (mx - mn) * (0.4 + mx)                       // vivid and not too dark
            let lum = 0.3 * c.x + 0.59 * c.y + 0.11 * c.z
            if sat > vividS { vividS = sat; vivid = c }
            if lum < darkL { darkL = lum; dark = c }
            if lum > lightL { lightL = lum; light = c }
        }
        avg /= Double(n * n)
        func col(_ v: SIMD3<Double>) -> CGColor { CGColor(red: CGFloat(min(max(v.x, 0), 1)), green: CGFloat(min(max(v.y, 0), 1)), blue: CGFloat(min(max(v.z, 0), 1)), alpha: 1) }
        func mix(_ a: SIMD3<Double>, _ b: SIMD3<Double>, _ t: Double) -> SIMD3<Double> { a + (b - a) * t }
        let white = SIMD3<Double>(1, 1, 1)
        p.red = col(vivid * 0.95); p.red2 = col(vivid * 0.55); p.red3 = col(mix(vivid, white, 0.3)); p.rose = col(mix(vivid, white, 0.55))
        p.navy = col(mix(dark, avg, 0.25) * 0.7); p.navy2 = col(mix(dark, avg, 0.5) * 0.9)
        p.teal = col(mix(avg, vivid, 0.4)); p.green = col(mix(avg, dark, 0.4))
        p.cream = col(mix(light, white, 0.25) * 0.97); p.ivory = col(mix(light, white, 0.6))
        p.gold = col(mix(vivid, light, 0.55)); p.ink = col(dark * 0.3)
    }

    static let W = 1536
    static let H = 1032
    static let scale: CGFloat = 1.2

    static func make(theme: RugTheme = .kashan) -> CGImage {
        let cs = CGColorSpaceCreateDeviceRGB()
        let ctx = CGContext(data: nil, width: W, height: H, bitsPerComponent: 8, bytesPerRow: W * 4,
                            space: cs, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        ctx.translateBy(x: 0, y: CGFloat(H))
        ctx.scaleBy(x: 1, y: -1)
        ctx.scaleBy(x: scale, y: scale)
        ctx.setAllowsAntialiasing(true)
        ctx.interpolationQuality = .high
        let d = Designer(g: ctx, cs: cs, theme: theme)
        d.paint()
        return ctx.makeImage()!
    }
}

private final class Designer {
    let g: CGContext
    let cs: CGColorSpace
    var rng = RNG(42)

    // design space
    let DW: CGFloat = 1280, DH: CGFloat = 860
    let X0: CGFloat = 64, X1: CGFloat = 1216
    let cx: CGFloat = 640, cy: CGFloat = 430

    // palette (per theme)
    let theme: RugTheme
    let red, red2, red3, rose, navy, navy2, teal, green, cream, ivory, gold, ink, dot: CGColor
    let fieldGrad: [CGColor]

    init(g: CGContext, cs: CGColorSpace, theme: RugTheme) {
        self.g = g; self.cs = cs; self.theme = theme
        let p = Palette.make(theme)
        red = p.red; red2 = p.red2; red3 = p.red3; rose = p.rose; navy = p.navy; navy2 = p.navy2
        teal = p.teal; green = p.green; cream = p.cream; ivory = p.ivory; gold = p.gold; ink = p.ink
        dot = p.dot; fieldGrad = p.fieldGrad
    }

    // MARK: primitives

    func at(_ x: CGFloat, _ y: CGFloat, _ a: CGFloat = 0, _ f: () -> Void) {
        g.saveGState(); g.translateBy(x: x, y: y); g.rotate(by: a); f(); g.restoreGState()
    }

    func fillStroke(_ p: CGPath, _ fill: CGColor?, _ stroke: CGColor? = nil, _ lw: CGFloat = 1.2) {
        if let f = fill { g.addPath(p); g.setFillColor(f); g.fillPath() }
        if let s = stroke { g.addPath(p); g.setStrokeColor(s); g.setLineWidth(lw); g.setLineJoin(.round); g.strokePath() }
    }

    func circle(_ x: CGFloat, _ y: CGFloat, _ r: CGFloat, _ fill: CGColor?, _ stroke: CGColor? = nil, _ lw: CGFloat = 1) {
        let p = CGPath(ellipseIn: CGRect(x: x - r, y: y - r, width: 2 * r, height: 2 * r), transform: nil)
        fillStroke(p, fill, stroke, lw)
    }

    /// pointed leaf, base at origin, tip at (0,-len)
    func lance(_ len: CGFloat, _ wid: CGFloat) -> CGPath {
        let p = CGMutablePath()
        p.move(to: .zero)
        p.addQuadCurve(to: CGPoint(x: 0, y: -len), control: CGPoint(x: wid * 2, y: -len * 0.5))
        p.addQuadCurve(to: .zero, control: CGPoint(x: -wid * 2, y: -len * 0.5))
        return p
    }

    /// round-tipped petal, base at origin, tip at (0,-len)
    func drop(_ len: CGFloat, _ wid: CGFloat) -> CGPath {
        let p = CGMutablePath()
        p.move(to: .zero)
        p.addCurve(to: CGPoint(x: 0, y: -len), control1: CGPoint(x: wid * 1.5, y: -len * 0.1), control2: CGPoint(x: wid * 1.1, y: -len))
        p.addCurve(to: .zero, control1: CGPoint(x: -wid * 1.1, y: -len), control2: CGPoint(x: -wid * 1.5, y: -len * 0.1))
        return p
    }

    func diamondP(_ r: CGFloat, _ rv: CGFloat? = nil) -> CGPath {
        let v = rv ?? r
        let p = CGMutablePath()
        p.move(to: CGPoint(x: 0, y: -v)); p.addLine(to: CGPoint(x: r, y: 0))
        p.addLine(to: CGPoint(x: 0, y: v)); p.addLine(to: CGPoint(x: -r, y: 0)); p.closeSubpath()
        return p
    }

    func leaf(_ x: CGFloat, _ y: CGFloat, _ len: CGFloat, _ wid: CGFloat, _ a: CGFloat, _ c: CGColor, _ vein: CGColor? = nil) {
        at(x, y, a) {
            fillStroke(lance(len, wid), c, ink, 0.9)
            if let v = vein {
                g.setStrokeColor(v); g.setLineWidth(0.8)
                g.move(to: CGPoint(x: 0, y: -len * 0.12)); g.addLine(to: CGPoint(x: 0, y: -len * 0.8)); g.strokePath()
            }
        }
    }

    func rosette(_ x: CGFloat, _ y: CGFloat, _ r: CGFloat, _ c1: CGColor, _ c2: CGColor, _ c3: CGColor, n: Int = 10) {
        at(x, y) {
            for k in 0..<n {
                at(0, 0, 2 * .pi * CGFloat(k) / CGFloat(n)) { fillStroke(drop(r, r * 0.27), c1, ink, 0.9) }
            }
            for k in 0..<n {
                at(0, 0, 2 * .pi * (CGFloat(k) + 0.5) / CGFloat(n)) { fillStroke(drop(r * 0.64, r * 0.17), c2) }
            }
            circle(0, 0, r * 0.34, c3, ink, 0.8)
            circle(0, 0, r * 0.14, c1)
        }
    }

    /// Shah-Abbasi palmette: fan of petals on a cup. Points towards -y before rotation.
    func palmette(_ x: CGFloat, _ y: CGFloat, _ s: CGFloat, _ a: CGFloat, _ c1: CGColor, _ c2: CGColor, _ c3: CGColor) {
        let angs: [CGFloat] = [-76, -52, -26, 0, 26, 52, 76]
        let lens: [CGFloat] = [0.52, 0.66, 0.82, 1.0, 0.82, 0.66, 0.52]
        at(x, y, a) {
            for k in 0..<7 {
                let th = angs[k] * .pi / 180
                at(0, 0, th) {
                    let L = s * lens[k]
                    fillStroke(drop(L, s * 0.15), c1, ink, 1.0)
                    g.saveGState()
                    g.translateBy(x: 0, y: -L * 0.14)
                    fillStroke(drop(L * 0.6, s * 0.075), c2)
                    g.restoreGState()
                }
            }
            let cup = CGMutablePath()
            cup.move(to: CGPoint(x: -s * 0.24, y: -s * 0.02))
            cup.addQuadCurve(to: CGPoint(x: s * 0.24, y: -s * 0.02), control: CGPoint(x: 0, y: s * 0.46))
            cup.closeSubpath()
            fillStroke(cup, c3, ink, 1.0)
            circle(0, -s * 0.02, s * 0.07, c2, ink, 0.7)
        }
    }

    func spiral(_ x: CGFloat, _ y: CGFloat, _ r0: CGFloat, _ turns: CGFloat, _ dir: CGFloat, _ a0: CGFloat, _ c: CGColor, _ lw: CGFloat = 2) {
        g.saveGState()
        g.setStrokeColor(c); g.setLineWidth(lw); g.setLineCap(.round)
        let steps = 60
        for i in 0...steps {
            let t = CGFloat(i) / CGFloat(steps)
            let r = r0 * (1 - t * 0.9)
            let th = a0 + dir * t * turns * 2 * .pi
            let p = CGPoint(x: x + r * cos(th), y: y + r * sin(th))
            if i == 0 { g.move(to: p) } else { g.addLine(to: p) }
        }
        g.strokePath()
        g.restoreGState()
    }

    func lozP(_ a: CGFloat, _ b: CGFloat, n: CGFloat = 1.25, amp: CGFloat = 0, freq: Double = 24) -> CGPath {
        let p = CGMutablePath()
        let M = 720
        let e = 2 / Double(n)
        for i in 0...M {
            let t = Double(i) / Double(M) * 2 * .pi
            let c = cos(t), s = sin(t)
            let k = 1 + amp * CGFloat(abs(cos(t * freq / 2)) - 0.5)
            let x = a * CGFloat(c < 0 ? -1 : 1) * CGFloat(pow(abs(c), e)) * k
            let y = b * CGFloat(s < 0 ? -1 : 1) * CGFloat(pow(abs(s), e)) * k
            if i == 0 { p.move(to: CGPoint(x: x, y: y)) } else { p.addLine(to: CGPoint(x: x, y: y)) }
        }
        p.closeSubpath()
        return p
    }

    /// point on the lozenge (relative to its centre) and its outward direction angle for a palmette pointing outwards
    func lozPoint(_ a: CGFloat, _ b: CGFloat, _ n: CGFloat, _ t: Double) -> (CGPoint, CGFloat) {
        let e = 2 / Double(n)
        let c = cos(t), s = sin(t)
        let x = Double(a) * (c < 0 ? -1 : 1) * pow(abs(c), e)
        let y = Double(b) * (s < 0 ? -1 : 1) * pow(abs(s), e)
        let nx = x / Double(a * a), ny = y / Double(b * b)
        let ang = atan2(nx, -ny)
        return (CGPoint(x: x, y: y), CGFloat(ang))
    }

    func sym(_ f: () -> Void) {
        for sx in [CGFloat(1), -1] {
            for sy in [CGFloat(1), -1] {
                g.saveGState()
                g.translateBy(x: cx, y: cy)
                g.scaleBy(x: sx, y: sy)
                f()
                g.restoreGState()
            }
        }
    }

    func rectInset(_ d: CGFloat, _ c: CGColor) {
        g.setFillColor(c)
        g.fill(CGRect(x: X0 + d, y: d, width: X1 - X0 - 2 * d, height: DH - 2 * d))
    }

    // MARK: painting

    func paint() {
        switch theme {
        case .kashan, .isfahan, .tebriz: classic()
        case .turkmen: turkmen()
        case .kilim: kilim()
        case .turk: turk()
        case .kurd: kurd()
        case .egypt: egypt()
        case .khayamiya: khayamiya()
        case .custom: custom()
        case .china: china()
        case .ayasofya: ayasofya()
        case .iznik: iznik()
        case .selcuklu: selcuklu()
        case .berber: berber()
        case .kazak: kazak()
        }
        wear()
        weave()
        fringe()
    }

    func classic() {
        // ---- layered borders (outside -> in) ----
        g.setFillColor(navy); g.fill(CGRect(x: X0, y: 0, width: X1 - X0, height: DH))
        rectInset(8, cream)
        rectInset(11, ink)
        rectInset(13, red2)            // guard 1 (13..33)
        rectInset(33, gold)
        rectInset(36, ink)
        rectInset(37, navy)            // main border (37..139)
        rectInset(139, ink)
        rectInset(140, gold)
        rectInset(143, teal)           // guard 2 (143..163)
        rectInset(163, ink)
        rectInset(164, cream)
        rectInset(168, ink)
        rectInset(169, red)            // field

        guardBands()
        mainBorder()
        field()
        spandrels()
        medallion()
    }

    // perimeter helper: calls f(x, y, vertical) at even steps along the rectangle inset d from the body edge
    func perimeter(inset d: CGFloat, step: CGFloat, _ f: (CGFloat, CGFloat, Bool) -> Void) {
        let l = X0 + d, r = X1 - d, t = d, b = DH - d
        let nx = Int(((r - l) / step).rounded()), ny = Int(((b - t) / step).rounded())
        for i in 0...nx { let x = l + (r - l) * CGFloat(i) / CGFloat(nx); f(x, t, false); f(x, b, false) }
        if ny > 1 { for j in 1..<ny { let y = t + (b - t) * CGFloat(j) / CGFloat(ny); f(l, y, true); f(r, y, true) } }
    }

    func guardBands() {
        // guard 1: running diamonds on dark red
        var k = 0
        perimeter(inset: 23, step: 17) { x, y, _ in
            at(x, y) {
                fillStroke(diamondP(6, 6), (k % 2 == 0) ? cream : gold, ink, 0.7)
                circle(0, 0, 1.6, (k % 2 == 0) ? red3 : navy)
            }
            k += 1
        }
        // guard 2: checker of cream / navy squares on teal
        k = 0
        perimeter(inset: 153, step: 10) { x, y, _ in
            g.setFillColor((k % 2 == 0) ? cream : navy)
            g.fill(CGRect(x: x - 4, y: y - 4, width: 8, height: 8))
            k += 1
        }
        // tiny dots on the selvage
        perimeter(inset: 4, step: 12) { x, y, _ in circle(x, y, 1.4, cream) }
    }

    func mainBorder() {
        // border band inset 37..139 -> centre line at 88, half width 51
        sym {
            let bc = -(DH / 2) + 88
            let lc = -((X1 - X0) / 2) + 88
            let runX0 = -((X1 - X0) / 2) + 139
            let runY0 = -(DH / 2) + 139
            // top run: local frame x along run, y=0 centre line, -y outer
            g.saveGState(); g.translateBy(x: runX0, y: bc)
            borderRun(length: -runX0, n: 6)
            g.restoreGState()
            // left run: swap axes so local -y is outward (-x world)
            g.saveGState()
            g.concatenate(CGAffineTransform(a: 0, b: 1, c: 1, d: 0, tx: lc, ty: runY0))
            borderRun(length: -runY0, n: 4)
            g.restoreGState()
            // corner square
            let cxs = lc, cys = bc
            let sq = CGRect(x: cxs - 49, y: cys - 49, width: 98, height: 98)
            g.setFillColor(red2); g.fill(sq)
            g.setStrokeColor(gold); g.setLineWidth(2); g.stroke(sq.insetBy(dx: 3, dy: 3))
            rosette(cxs, cys, 34, cream, red3, gold, n: 12)
            for q in 0..<4 {
                let a = CGFloat(q) * .pi / 2 + .pi / 4
                leaf(cxs + 38 * sin(a), cys - 38 * cos(a), 13, 4, a, teal)
            }
        }
    }

    func borderRun(length: CGFloat, n: Int) {
        let P = length / CGFloat(n)
        // continuous gold vine
        g.setStrokeColor(ink); g.setLineWidth(5.2); g.setLineCap(.round)
        var x: CGFloat = 0
        g.beginPath(); g.move(to: .zero)
        while x <= length { g.addLine(to: CGPoint(x: x, y: 23 * sin(x / P * .pi))); x += 2 }
        g.strokePath()
        g.setStrokeColor(gold); g.setLineWidth(3)
        x = 0
        g.beginPath(); g.move(to: .zero)
        while x <= length { g.addLine(to: CGPoint(x: x, y: 23 * sin(x / P * .pi))); x += 2 }
        g.strokePath()

        for k in 0...n {
            // rosettes at the vine crossings
            if k > 0 { rosette(CGFloat(k) * P, 0, 15, (k % 2 == 0) ? cream : rose, red3, (k % 2 == 0) ? gold : navy2, n: 10) }
        }
        for k in 0..<n {
            let xk = (CGFloat(k) + 0.5) * P
            if k % 2 == 0 {
                palmette(xk, 23, 42, 0, red3, cream, teal)          // base inside, points outward
                leaf(xk - P * 0.27, 10, 15, 4.5, -2.1, green)
                leaf(xk + P * 0.27, 10, 15, 4.5, 2.1, green)
            } else {
                palmette(xk, -23, 42, .pi, cream, red3, gold)       // base outside, points inward
                leaf(xk - P * 0.27, -10, 15, 4.5, -1.05, teal)
                leaf(xk + P * 0.27, -10, 15, 4.5, 1.05, teal)
            }
            // small blossoms on the free side of each palmette
            let side: CGFloat = (k % 2 == 0) ? 31 : -31
            circle(xk, side, 3.2, gold, ink, 0.7)
        }
        // beads along the edges
        var bx: CGFloat = 6
        while bx < length - 3 {
            circle(bx, -46, 1.6, cream); circle(bx, 46, 1.6, cream)
            bx += 11
        }
    }

    func field() {
        let fx0 = X0 + 169, fx1 = X1 - 169, fy0: CGFloat = 169, fy1 = DH - 169
        g.saveGState()
        g.clip(to: CGRect(x: fx0, y: fy0, width: fx1 - fx0, height: fy1 - fy0))
        // field ground with a gentle radial depth
        let grad = CGGradient(colorsSpace: cs, colors: fieldGrad as CFArray, locations: [0, 0.6, 1])!
        g.drawRadialGradient(grad, startCenter: CGPoint(x: cx, y: cy), startRadius: 0,
                             endCenter: CGPoint(x: cx, y: cy), endRadius: 470, options: [.drawsAfterEndLocation])

        // Herati lattice: rosette in a vine diamond with four lance leaves
        let S: CGFloat = 58
        let cols: [(CGColor, CGColor, CGColor)] = [(cream, red3, gold), (gold, navy2, cream), (rose, teal, cream)]
        for j in -9...9 {
            for i in -9...9 {
                let px = cx + CGFloat(i) * S + ((j & 1) != 0 ? S / 2 : 0)
                let py = cy + CGFloat(j) * S * 0.58
                // vine diamond
                at(px, py) {
                    g.setStrokeColor(gold.copy(alpha: 0.55)!); g.setLineWidth(1.3)
                    g.addPath(diamondP(S * 0.5, S * 0.29)); g.strokePath()
                }
                let c = cols[((i + 3 * j) % 3 + 3) % 3]
                rosette(px, py, 8.5, c.0, c.1, c.2, n: 8)
                // four diagonal lance leaves
                for q in 0..<4 {
                    let a = CGFloat(q) * .pi / 2 + .pi / 4
                    leaf(px + 11 * sin(a), py - 11 * cos(a), 13, 3.2, a, (q % 2 == 0) ? teal : navy2)
                }
                // small dots on the vine nodes
                circle(px + S / 2, py, 1.9, cream)
                circle(px, py + S * 0.29, 1.9, gold)
            }
        }
        g.restoreGState()
    }

    func spandrels() {
        let fcx = X0 + 169 - cx, fcy: CGFloat = 169 - cy
        sym {
            g.saveGState()
            g.clip(to: CGRect(x: fcx, y: fcy, width: 520, height: 330))
            let rx: CGFloat = 212, ry: CGFloat = 148, n: CGFloat = 1.3
            func quarter(_ f: CGFloat) -> CGPath {
                let p = CGMutablePath()
                p.move(to: CGPoint(x: fcx, y: fcy))
                let e = 2 / Double(n)
                var t = 0.0
                while t <= .pi / 2 + 0.001 {
                    p.addLine(to: CGPoint(x: fcx + rx * f * CGFloat(pow(cos(t), e)), y: fcy + ry * f * CGFloat(pow(sin(t), e))))
                    t += 0.02
                }
                p.closeSubpath()
                return p
            }
            fillStroke(quarter(1.0), navy, ink, 3)
            fillStroke(quarter(0.97), nil, cream, 3)
            fillStroke(quarter(0.90), navy, gold, 2)
            fillStroke(quarter(0.78), nil, dot.copy(alpha: 0.35)!, 1.4)

            // little dotted lattice
            g.saveGState()
            g.addPath(quarter(0.88)); g.clip()
            var yy = fcy + 8
            while yy < fcy + 200 {
                var xx = fcx + 8 + ((Int((yy - fcy) / 16) & 1) == 0 ? 0 : 8)
                while xx < fcx + 290 { circle(xx, yy, 0.9, dot.copy(alpha: 0.5)!); xx += 16 }
                yy += 16
            }
            g.restoreGState()

            // palmette pointing along the diagonal, tendrils and blossoms
            palmette(fcx + 40, fcy + 34, 56, .pi * 0.75, red3, cream, gold)
            spiral(fcx + 116, fcy + 28, 17, 1.6, 1, -0.4, gold, 2.2)
            spiral(fcx + 28, fcy + 106, 17, 1.6, -1, 0.4, gold, 2.2)
            leaf(fcx + 78, fcy + 18, 20, 5, 1.65, teal, cream)
            leaf(fcx + 18, fcy + 78, 20, 5, 3.35, teal, cream)
            leaf(fcx + 98, fcy + 58, 15, 4, 1.1, green)
            leaf(fcx + 58, fcy + 98, 15, 4, 2.0, green)
            rosette(fcx + 148, fcy + 46, 10, cream, red3, gold, n: 8)
            rosette(fcx + 46, fcy + 126, 10, cream, red3, gold, n: 8)
            g.restoreGState()
        }
    }

    func medallion() {
        g.saveGState()
        g.translateBy(x: cx, y: cy)

        // ---- pendants (pointed lobed lozenges with palmettes) ----
        for s in [CGFloat(-1), 1] {
            // left / right
            at(s * 372, 0) {
                fillStroke(lozP(82, 46, n: 1.1, amp: 0.05, freq: 20), cream, ink, 2)
                fillStroke(lozP(74, 40, n: 1.1, amp: 0.0), navy, ink, 1.5)
                fillStroke(lozP(60, 31, n: 1.1), red, gold, 1.8)
                palmette(-s * 8, 12, 28, s > 0 ? .pi / 2 : -.pi / 2, cream, red3, gold)
                circle(s * 22, 0, 4.5, gold, ink, 0.8)
            }
            // top / bottom
            at(0, s * 262) {
                fillStroke(lozP(56, 44, n: 1.1, amp: 0.05, freq: 18), cream, ink, 2)
                fillStroke(lozP(49, 37, n: 1.1), navy, ink, 1.5)
                fillStroke(lozP(37, 27, n: 1.1), red, gold, 1.8)
                palmette(0, s > 0 ? 12 : -12, 22, s > 0 ? 0 : .pi, cream, red3, gold)
            }
        }

        // ---- main medallion layers ----
        fillStroke(lozP(330, 226, n: 1.25, amp: 0.045, freq: 44), cream, ink, 2.5)
        fillStroke(lozP(318, 217, n: 1.25), navy, ink, 1.6)
        fillStroke(lozP(300, 205, n: 1.25), nil, gold, 2.2)
        fillStroke(lozP(292, 199, n: 1.25), navy2, ink, 1.4)

        // dotted ground in the navy band
        g.saveGState()
        g.addPath(lozP(290, 197, n: 1.25)); g.clip()
        var yy: CGFloat = -230
        while yy < 230 {
            var xx: CGFloat = -330 + ((Int((yy + 230) / 14) & 1) == 0 ? 0 : 7)
            while xx < 330 { circle(xx, yy, 0.9, dot.copy(alpha: 0.45)!); xx += 14 }
            yy += 14
        }
        g.restoreGState()

        // ring of radial palmettes + blossoms
        let N = 20
        for k in 0..<N {
            let t = (Double(k) + 0.5) * 2 * .pi / Double(N)
            let (p, a) = lozPoint(268, 182, 1.25, t)
            if k % 2 == 0 { palmette(p.x, p.y, 27, a + .pi, cream, red3, gold) }
            else { palmette(p.x, p.y, 21, a + .pi, rose, teal, cream) }
        }
        for k in 0..<N {
            let t = Double(k) * 2 * .pi / Double(N)
            let (p, _) = lozPoint(246, 168, 1.25, t)
            circle(p.x, p.y, 2.6, gold, ink, 0.6)
        }

        fillStroke(lozP(232, 158, n: 1.25, amp: 0.06, freq: 30), cream, ink, 2.2)
        fillStroke(lozP(224, 152, n: 1.25), red2, ink, 1.2)

        // mini Herati inside the red ground
        g.saveGState()
        g.addPath(lozP(222, 150, n: 1.25)); g.clip()
        let S: CGFloat = 40
        for j in -8...8 {
            for i in -9...9 {
                let px = CGFloat(i) * S + ((j & 1) != 0 ? S / 2 : 0)
                let py = CGFloat(j) * S * 0.6
                rosette(px, py, 6.5, (i + j) % 2 == 0 ? cream : gold, red3, navy, n: 8)
                for q in 0..<4 {
                    let a = CGFloat(q) * .pi / 2 + .pi / 4
                    leaf(px + 8 * sin(a), py - 8 * cos(a), 9, 2.4, a, (q % 2 == 0) ? teal : navy2)
                }
            }
        }
        g.restoreGState()

        fillStroke(lozP(160, 108, n: 1.25, amp: 0.05, freq: 26), cream, ink, 2)
        fillStroke(lozP(152, 102, n: 1.25), teal, ink, 1.4)
        fillStroke(lozP(138, 92, n: 1.25), nil, gold, 2)
        fillStroke(lozP(130, 86, n: 1.25), navy, ink, 1.4)

        // 16 point star
        let star = CGMutablePath()
        for i in 0..<32 {
            let r: CGFloat = (i % 2 == 0) ? 74 : 40
            let t = CGFloat(i) * .pi / 16
            let pt = CGPoint(x: r * cos(t) * 1.3, y: r * sin(t))
            if i == 0 { star.move(to: pt) } else { star.addLine(to: pt) }
        }
        star.closeSubpath()
        fillStroke(star, gold, ink, 1.8)
        let star2 = CGMutablePath()
        for i in 0..<32 {
            let r: CGFloat = (i % 2 == 0) ? 56 : 32
            let t = CGFloat(i) * .pi / 16 + .pi / 32
            let pt = CGPoint(x: r * cos(t) * 1.3, y: r * sin(t))
            if i == 0 { star2.move(to: pt) } else { star2.addLine(to: pt) }
        }
        star2.closeSubpath()
        fillStroke(star2, red, ink, 1.2)
        rosette(0, 0, 40, cream, red3, gold, n: 16)
        circle(0, 0, 9, navy, gold, 2)
        circle(0, 0, 3.5, cream)

        // palmettes pointing out from the star along the long axis
        for s in [CGFloat(-1), 1] {
            palmette(s * 98, 0, 30, s > 0 ? .pi / 2 : -.pi / 2, cream, red3, gold)
        }
        g.restoreGState()
    }

    // MARK: Turkmen / Bukhara: rows of octagonal guls

    func octagon(_ w: CGFloat, _ h: CGFloat, _ c: CGFloat) -> CGPath {
        let p = CGMutablePath()
        p.move(to: CGPoint(x: -w + c, y: -h)); p.addLine(to: CGPoint(x: w - c, y: -h))
        p.addLine(to: CGPoint(x: w, y: -h + c)); p.addLine(to: CGPoint(x: w, y: h - c))
        p.addLine(to: CGPoint(x: w - c, y: h)); p.addLine(to: CGPoint(x: -w + c, y: h))
        p.addLine(to: CGPoint(x: -w, y: h - c)); p.addLine(to: CGPoint(x: -w, y: -h + c))
        p.closeSubpath()
        return p
    }

    func gul(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat) {
        at(x, y) {
            let c = min(w, h) * 0.32
            fillStroke(octagon(w + 5, h + 5, c), nil, cream, 2)
            fillStroke(octagon(w, h, c), navy, ink, 2.4)
            // quartering cross
            g.setStrokeColor(cream); g.setLineWidth(3)
            g.move(to: CGPoint(x: -w, y: 0)); g.addLine(to: CGPoint(x: w, y: 0))
            g.move(to: CGPoint(x: 0, y: -h)); g.addLine(to: CGPoint(x: 0, y: h)); g.strokePath()
            // quadrant motifs
            for (sx, sy) in [(-1, -1), (1, -1), (-1, 1), (1, 1)] as [(CGFloat, CGFloat)] {
                at(sx * w * 0.5, sy * h * 0.5) {
                    fillStroke(diamondP(w * 0.26, h * 0.26), (sx * sy > 0) ? red3 : gold, ink, 1.2)
                    fillStroke(diamondP(w * 0.12, h * 0.12), (sx * sy > 0) ? cream : red2)
                    // little hooks
                    g.setFillColor(cream)
                    g.fill(CGRect(x: -2, y: -h * 0.36, width: 4, height: 6))
                    g.fill(CGRect(x: -w * 0.36, y: -2, width: 6, height: 4))
                }
            }
            fillStroke(octagon(w * 0.26, h * 0.26, c * 0.3), ivory, ink, 1.6)
            circle(0, 0, min(w, h) * 0.1, red, ink, 1)
            // teeth around the gul
            g.setFillColor(cream)
            for k in -1...1 {
                let off = CGFloat(k) * w * 0.5
                g.fill(CGRect(x: off - 3, y: -h - 13, width: 6, height: 8)); g.fill(CGRect(x: off - 3, y: h + 5, width: 6, height: 8))
                let offY = CGFloat(k) * h * 0.5
                g.fill(CGRect(x: -w - 13, y: offY - 3, width: 8, height: 6)); g.fill(CGRect(x: w + 5, y: offY - 3, width: 8, height: 6))
            }
        }
    }

    func turkmen() {
        g.setFillColor(navy); g.fill(CGRect(x: X0, y: 0, width: X1 - X0, height: DH))
        rectInset(8, cream); rectInset(11, ink); rectInset(13, red2); rectInset(33, gold); rectInset(36, ink)
        rectInset(37, red2); rectInset(139, ink); rectInset(140, cream); rectInset(143, navy)
        rectInset(163, ink); rectInset(164, cream); rectInset(168, ink); rectInset(169, red)
        guardBands()

        // main border: chain of diamonds with hooks and small crosses
        var k = 0
        perimeter(inset: 88, step: 36) { x, y, vert in
            at(x, y) {
                fillStroke(diamondP(15, 15), (k % 2 == 0) ? navy2 : red3, ink, 1.6)
                fillStroke(diamondP(8, 8), (k % 2 == 0) ? cream : gold, ink, 1)
                circle(0, 0, 2.4, ink)
                g.setFillColor(cream)
                if vert { g.fill(CGRect(x: -22, y: -2, width: 6, height: 4)); g.fill(CGRect(x: 16, y: -2, width: 6, height: 4)) }
                else { g.fill(CGRect(x: -2, y: -22, width: 4, height: 6)); g.fill(CGRect(x: -2, y: 16, width: 4, height: 6)) }
            }
            k += 1
        }
        perimeter(inset: 56, step: 12) { x, y, _ in circle(x, y, 1.8, cream) }
        perimeter(inset: 120, step: 12) { x, y, _ in circle(x, y, 1.8, gold) }

        // field
        let fx0 = X0 + 169, fx1 = X1 - 169, fy0: CGFloat = 169, fy1 = DH - 169
        g.saveGState()
        g.clip(to: CGRect(x: fx0, y: fy0, width: fx1 - fx0, height: fy1 - fy0))
        let grad = CGGradient(colorsSpace: cs, colors: fieldGrad as CFArray, locations: [0, 0.6, 1])!
        g.drawRadialGradient(grad, startCenter: CGPoint(x: cx, y: cy), startRadius: 0,
                             endCenter: CGPoint(x: cx, y: cy), endRadius: 470, options: [.drawsAfterEndLocation])
        let sx: CGFloat = 164, sy: CGFloat = 176
        // secondary motifs between the guls
        for j in -2...2 {
            for i in -3...3 {
                let px = cx + (CGFloat(i) + 0.5) * sx * 0.5 * 2 - sx / 2 + (j & 1 == 0 ? 0 : 0)
                _ = px
            }
        }
        for j in -2...2 {
            for i in -3...3 {
                let ox = cx + CGFloat(i) * sx + sx / 2
                let oy = cy + CGFloat(j) * sy + sy / 2 - (j == 0 ? 0 : 0)
                at(ox, oy) {
                    fillStroke(diamondP(20, 20), gold, ink, 1.6)
                    fillStroke(diamondP(12, 12), navy2, ink, 1)
                    g.setStrokeColor(cream); g.setLineWidth(2)
                    g.move(to: CGPoint(x: -8, y: 0)); g.addLine(to: CGPoint(x: 8, y: 0))
                    g.move(to: CGPoint(x: 0, y: -8)); g.addLine(to: CGPoint(x: 0, y: 8)); g.strokePath()
                    g.setFillColor(cream)
                    for q in 0..<4 {
                        let a = CGFloat(q) * .pi / 2
                        g.fill(CGRect(x: 25 * cos(a) - 2.5, y: 25 * sin(a) - 2.5, width: 5, height: 5))
                    }
                }
            }
        }
        // the guls: 5 columns x 3 rows
        for j in -1...1 {
            for i in -2...2 { gul(cx + CGFloat(i) * sx, cy + CGFloat(j) * sy, 56, 50) }
        }
        // tiny scattered diamonds
        for j in -6...6 {
            for i in -9...9 {
                let px = cx + CGFloat(i) * 41, py = cy + CGFloat(j) * 44
                circle(px, py + 22, 1.6, cream.copy(alpha: 0.55)!)
            }
        }
        g.restoreGState()
    }

    // MARK: Kilim: flat-woven stepped diamonds

    func kilim() {
        let cell: CGFloat = 8
        let U = Int((X1 - X0) / cell), V = Int(DH / cell) + 1
        let sand = fieldGrad[0], rust = red, indigo = navy, ochre = gold
        g.saveGState()
        g.setShouldAntialias(false)
        for v in 0..<V {
            for u in 0..<U {
                let e = min(min(u, v), min(U - 1 - u, V - 1 - v))
                var col = sand
                if e < 2 { col = indigo }
                else if e < 3 { col = cream }
                else if e < 5 { col = rust }
                else if e < 6 { col = cream }
                else if e < 14 {
                    let alongV = (u == e || u == U - 1 - e) && !(v == e || v == V - 1 - e)
                    let t = alongV ? v : u
                    let tw = abs((t % 16) - 8)
                    let b = e - 6
                    col = (b < tw) ? ochre : indigo
                    if b == tw { col = cream }
                }
                else if e < 15 { col = cream }
                else if e < 17 { col = rust }
                else if e < 18 { col = cream }
                else {
                    let dx = Double(u - U / 2) + 0.5, dy = Double(v - V / 2) + 0.5
                    var best = 1e9
                    for c in [-36.0, 0.0, 36.0] {
                        let d = abs(dx - c) + abs(dy) * (17.0 / 30.0)
                        best = min(best, d)
                    }
                    if best < 18 {
                        let ring = Int(best) / 3
                        let ringCols = [ochre, rust, cream, indigo, rust, teal]
                        col = ringCols[min(ring, 5)]
                        if ring == 0 && Int(best) == 0 { col = indigo }
                    } else {
                        // between the diamonds: little comb / dot weave
                        let m = (u + v) % 8
                        if m == 0 { col = rust }
                        else if ((u / 2) + (v / 2)) % 5 == 0 { col = indigo }
                        else if abs(dy) > 30 {
                            let z = abs((u % 12) - 6)
                            col = (z > Int(abs(dy)) - 30) ? ochre : sand
                        }
                    }
                }
                g.setFillColor(col)
                g.fill(CGRect(x: X0 + CGFloat(u) * cell, y: CGFloat(v) * cell, width: cell, height: cell))
            }
        }
        g.restoreGState()
    }

    // MARK: Turkish prayer rug (Ladik style): mihrab arch, tulips, carnations

    func tulip(_ x: CGFloat, _ y: CGFloat, _ s: CGFloat, _ a: CGFloat, _ c1: CGColor, _ c2: CGColor, stem: Bool = false) {
        at(x, y, a) {
            if stem {
                g.setStrokeColor(green); g.setLineWidth(s * 0.07); g.setLineCap(.round)
                g.move(to: CGPoint(x: 0, y: 0)); g.addLine(to: CGPoint(x: 0, y: s * 0.55)); g.strokePath()
                leaf(0, s * 0.42, s * 0.34, s * 0.07, 2.2, green)
                leaf(0, s * 0.42, s * 0.34, s * 0.07, -2.2, green)
            }
            for sgn in [CGFloat(-1), 1] {
                at(sgn * s * 0.05, 0, sgn * 0.42) { fillStroke(lance(s * 0.82, s * 0.19), c1, ink, 1.1) }
            }
            let bowl = CGMutablePath()
            bowl.move(to: CGPoint(x: -s * 0.27, y: -s * 0.30))
            bowl.addQuadCurve(to: CGPoint(x: s * 0.27, y: -s * 0.30), control: CGPoint(x: 0, y: s * 0.34))
            bowl.closeSubpath()
            fillStroke(bowl, c1, ink, 1.1)
            at(0, 0, 0) { fillStroke(lance(s * 0.98, s * 0.20), c1, ink, 1.1) }
            at(0, -s * 0.05, 0) { fillStroke(lance(s * 0.6, s * 0.08), c2) }
        }
    }

    func turk() {
        g.setFillColor(navy); g.fill(CGRect(x: X0, y: 0, width: X1 - X0, height: DH))
        rectInset(8, cream); rectInset(11, ink); rectInset(13, red2); rectInset(33, gold); rectInset(36, ink)
        rectInset(37, navy); rectInset(139, ink); rectInset(140, gold); rectInset(143, teal)
        rectInset(163, ink); rectInset(164, cream); rectInset(168, ink); rectInset(169, red)
        guardBands()

        // main border: tulips and carnations turned towards the field
        let sides: [(CGFloat, CGFloat, CGFloat, Bool)] = [(88, 0, .pi, true), (DH - 88, 0, 0, true), (X0 + 88, 0, .pi / 2, false), (X1 - 88, 0, -.pi / 2, false)]
        for (fixed, _, ang, horizontal) in sides {
            let lo: CGFloat = horizontal ? X0 + 110 : 110
            let hi: CGFloat = horizontal ? X1 - 110 : DH - 110
            let n = Int(((hi - lo) / 46).rounded())
            // thin vine behind the flowers
            g.setStrokeColor(gold); g.setLineWidth(2.4)
            if horizontal { g.move(to: CGPoint(x: lo, y: fixed)); g.addLine(to: CGPoint(x: hi, y: fixed)) }
            else { g.move(to: CGPoint(x: fixed, y: lo)); g.addLine(to: CGPoint(x: fixed, y: hi)) }
            g.strokePath()
            for i in 0...n {
                let t = lo + (hi - lo) * CGFloat(i) / CGFloat(n)
                let px = horizontal ? t : fixed, py = horizontal ? fixed : t
                at(px, py, ang) {
                    if i % 2 == 0 { at(0, 22, 0) { tulip(0, 0, 46, 0, red3, cream) } }
                    else {
                        rosette(0, 0, 14, cream, rose, gold, n: 14)
                        leaf(0, 5, 17, 5, 2.3, green); leaf(0, 5, 17, 5, -2.3, green)
                    }
                }
            }
        }
        for (px, py) in [(X0 + 88, CGFloat(88)), (X1 - 88, 88), (X0 + 88, DH - 88), (X1 - 88, DH - 88)] {
            rosette(px, py, 34, cream, red3, gold, n: 12)
            circle(px, py, 6, navy, gold, 1.5)
        }

        // field
        let fx0 = X0 + 169, fx1 = X1 - 169, fy0: CGFloat = 169, fy1 = DH - 169
        g.saveGState()
        g.clip(to: CGRect(x: fx0, y: fy0, width: fx1 - fx0, height: fy1 - fy0))
        let grad = CGGradient(colorsSpace: cs, colors: fieldGrad as CFArray, locations: [0, 0.6, 1])!
        g.drawRadialGradient(grad, startCenter: CGPoint(x: cx, y: cy), startRadius: 0,
                             endCenter: CGPoint(x: cx, y: cy), endRadius: 470, options: [.drawsAfterEndLocation])
        // small blossoms strewn over the red ground
        for j in -6...6 {
            for i in -9...9 {
                let px = cx + CGFloat(i) * 52 + ((j & 1) != 0 ? 26 : 0), py = cy + CGFloat(j) * 46
                if (i + j) & 1 == 0 { rosette(px, py, 7.5, cream, gold, red3, n: 8) } else { at(px, py) { fillStroke(diamondP(5), navy2) } }
            }
        }

        // mihrab arch
        let aw: CGFloat = 214
        func arch(_ inset: CGFloat) -> CGPath {
            let w = aw - inset
            let p = CGMutablePath()
            p.move(to: CGPoint(x: cx - w, y: fy1 + 4))
            p.addLine(to: CGPoint(x: cx - w, y: 345))
            p.addCurve(to: CGPoint(x: cx, y: fy0 + 14 + inset), control1: CGPoint(x: cx - w, y: 262), control2: CGPoint(x: cx - 50, y: 262))
            p.addCurve(to: CGPoint(x: cx + w, y: 345), control1: CGPoint(x: cx + 50, y: 262), control2: CGPoint(x: cx + w, y: 262))
            p.addLine(to: CGPoint(x: cx + w, y: fy1 + 4))
            p.closeSubpath()
            return p
        }
        fillStroke(arch(-14), cream, ink, 2.4)
        fillStroke(arch(-8), gold, ink, 1.4)
        fillStroke(arch(0), navy2, ink, 2.4)
        g.saveGState()
        g.addPath(arch(0)); g.clip()
        var yy = fy0 + 10
        while yy < fy1 {
            var xx = cx - aw + 8 + ((Int((yy - fy0) / 15) & 1) == 0 ? 0 : 7)
            while xx < cx + aw { circle(xx, yy, 0.9, dot.copy(alpha: 0.42)!); xx += 15 }
            yy += 15
        }
        g.restoreGState()
        fillStroke(arch(14), nil, hex(0xD3A440, 0.9), 1.6)
        // vines climbing the sides of the arch
        for sgn in [CGFloat(-1), 1] {
            g.setStrokeColor(gold); g.setLineWidth(2.4)
            var t: CGFloat = 0
            g.move(to: CGPoint(x: cx + sgn * (aw - 30), y: fy1))
            while t < 330 { g.addLine(to: CGPoint(x: cx + sgn * (aw - 30 + 9 * sin(t / 26)), y: fy1 - t)); t += 3 }
            g.strokePath()
            var k: CGFloat = 20
            while k < 300 {
                leaf(cx + sgn * (aw - 30 + 9 * sin(k / 26)), fy1 - k, 20, 5, sgn * 1.0, green)
                circle(cx + sgn * (aw - 46), fy1 - k - 14, 3, k.truncatingRemainder(dividingBy: 80) < 40 ? cream : rose, ink, 0.7)
                k += 40
            }
        }
        // hanging lamp
        g.setStrokeColor(gold); g.setLineWidth(2)
        g.move(to: CGPoint(x: cx, y: fy0 + 24)); g.addLine(to: CGPoint(x: cx, y: fy0 + 74)); g.strokePath()
        at(cx, fy0 + 100) {
            fillStroke(diamondP(15, 26), gold, ink, 1.6)
            fillStroke(diamondP(8, 15), cream, ink, 1)
            circle(0, 0, 3.2, red3)
            circle(0, 30, 4, gold, ink, 1)
        }
        // central medallion + row of tulips on the floor of the arch
        rosette(cx, cy + 10, 42, cream, red3, gold, n: 16)
        circle(cx, cy + 10, 9, navy, gold, 2)
        for i in -3...3 {
            let tc: [CGColor] = [red3, cream, rose, gold]
            tulip(cx + CGFloat(i) * 56, fy1 - 62, 70, 0, tc[abs(i) % 4], cream, stem: true)
        }
        g.restoreGState()
    }

    // MARK: Kurdish (Jaf) tribal rug: hexagonal medallions with arms, hooked border

    func kurd() {
        let cell: CGFloat = 6
        let U = Int((X1 - X0) / cell), V = Int(DH / cell) + 1
        let indigo = navy, rust = red, saffron = gold
        g.saveGState()
        g.setShouldAntialias(false)
        let ringCols: [CGColor] = [saffron, ink, rust, cream, navy2, saffron, ink, green]
        for v in 0..<V {
            for u in 0..<U {
                let e = min(min(u, v), min(U - 1 - u, V - 1 - v))
                var col = indigo
                if e < 2 { col = rust }
                else if e < 3 { col = cream }
                else if e < 5 { col = indigo }
                else if e < 6 { col = cream }
                else if e < 16 {
                    let alongV = (u == e || u == U - 1 - e) && !(v == e || v == V - 1 - e)
                    let t = alongV ? v : u
                    let seg = t / 14, tm = t % 14, b = e - 6
                    let d = abs(Double(tm) - 6.5) + abs(Double(b) - 4.5)
                    let even = seg % 2 == 0
                    if d < 2.2 { col = even ? saffron : cream }
                    else if d < 4.2 { col = even ? rust : green }
                    else if d < 5.2 { col = ink }
                    else { col = (tm == 13 && b % 2 == 0) ? rose : navy2 }
                }
                else if e < 17 { col = cream }
                else if e < 19 { col = rust }
                else if e < 20 { col = cream }
                else {
                    let dx = Double(u - U / 2) + 0.5, dy = Double(v - V / 2) + 0.5
                    var ndx = dx
                    var best = 1e9
                    for c in [-50.0, 0.0, 50.0] where abs(dx - c) < best { best = abs(dx - c); ndx = dx - c }
                    let ady = abs(dy), adx = abs(ndx)
                    let hexd = max(ady, adx * 0.866 + ady * 0.5)
                    if hexd < 24 {
                        let i = Int(hexd)
                        let band = i < 4 ? 0 : i < 6 ? 1 : i < 10 ? 2 : i < 12 ? 3 : i < 16 ? 4 : i < 18 ? 5 : i < 20 ? 6 : 7
                        col = ringCols[band]
                        if band == 2 && (u + v) % 4 == 0 { col = saffron }
                        if band == 4 && ((Int(ndx) % 6 == 0) && ((v) % 6 == 0)) { col = rose }
                    } else if hexd < 26 {
                        col = cream
                    } else if (ady <= 2 && adx < 32) || (adx <= 2 && ady < 32) {
                        col = ((u + v) % 4 < 2) ? rust : saffron           // arms of the medallion
                    } else {
                        // filler: small stepped crosses and dots on the indigo ground
                        let lu = (u % 16) - 8, lv = (v % 16) - 8
                        let m = abs(lu) + abs(lv)
                        if m <= 1 { col = saffron }
                        else if m == 2 && (lu == 0 || lv == 0) { col = rose }
                        else if m == 3 && (lu == 0 || lv == 0) { col = cream }
                        else if (u % 8 == 0 && v % 8 == 0) { col = navy2 }
                        if ady > 31 {                                     // zigzag bands above and below
                            let z = abs((u % 12) - 6)
                            col = (Int(ady) - 31 < z / 2 + 1) ? rust : indigo
                        }
                    }
                }
                g.setFillColor(col)
                g.fill(CGRect(x: X0 + CGFloat(u) * cell, y: CGFloat(v) * cell, width: cell, height: cell))
            }
        }
        g.restoreGState()
    }

    // MARK: Ancient Egypt: hieroglyph border, winged sun disc, cartouche and inscription columns

    func stroked(_ c: CGColor, _ lw: CGFloat, _ f: () -> Void) {
        g.saveGState(); g.setStrokeColor(c); g.setLineWidth(lw); g.setLineCap(.round); g.setLineJoin(.round); f(); g.restoreGState()
    }

    /// One hieroglyph, `s` tall, centred on (x,y); `c` is the main colour, `c2` the accent.
    func glyph(_ kind: Int, _ x: CGFloat, _ y: CGFloat, _ s: CGFloat, _ a: CGFloat, _ c: CGColor, _ c2: CGColor) {
        let lw = max(1.6, s * 0.075)
        at(x, y, a) {
            switch kind % 10 {
            case 0: // ankh
                stroked(c, lw * 1.2) {
                    g.strokeEllipse(in: CGRect(x: -s * 0.17, y: -s * 0.5, width: s * 0.34, height: s * 0.4))
                    g.move(to: CGPoint(x: 0, y: -s * 0.1)); g.addLine(to: CGPoint(x: 0, y: s * 0.5))
                    g.move(to: CGPoint(x: -s * 0.3, y: s * 0.04)); g.addLine(to: CGPoint(x: s * 0.3, y: s * 0.04)); g.strokePath()
                }
            case 1: // eye of Horus
                let w = s * 0.62
                let eye = CGMutablePath()
                eye.move(to: CGPoint(x: -w / 2, y: 0))
                eye.addQuadCurve(to: CGPoint(x: w / 2, y: 0), control: CGPoint(x: 0, y: -s * 0.46))
                eye.addQuadCurve(to: CGPoint(x: -w / 2, y: 0), control: CGPoint(x: 0, y: s * 0.26))
                fillStroke(eye, c2, c, lw)
                circle(w * 0.04, -s * 0.03, s * 0.115, c, nil)
                stroked(c, lw) {
                    g.move(to: CGPoint(x: -w / 2 - s * 0.02, y: -s * 0.06)); g.addLine(to: CGPoint(x: -w / 2 - s * 0.14, y: -s * 0.12))
                    g.move(to: CGPoint(x: -w * 0.1, y: s * 0.17)); g.addLine(to: CGPoint(x: -w * 0.1, y: s * 0.42))
                    g.move(to: CGPoint(x: w * 0.25, y: s * 0.15))
                    g.addCurve(to: CGPoint(x: w * 0.55, y: s * 0.2), control1: CGPoint(x: w * 0.4, y: s * 0.35), control2: CGPoint(x: w * 0.6, y: s * 0.4))
                    g.strokePath()
                    g.move(to: CGPoint(x: -w / 2, y: -s * 0.24)); g.addQuadCurve(to: CGPoint(x: w / 2, y: -s * 0.24), control: CGPoint(x: 0, y: -s * 0.56)); g.strokePath()
                }
            case 2: // djed pillar
                stroked(c, lw * 1.3) {
                    g.move(to: CGPoint(x: 0, y: -s * 0.5)); g.addLine(to: CGPoint(x: 0, y: s * 0.5))
                    for k in 0..<4 {
                        let yy = -s * 0.46 + CGFloat(k) * s * 0.11
                        g.move(to: CGPoint(x: -s * (0.22 - CGFloat(k) * 0.015), y: yy)); g.addLine(to: CGPoint(x: s * (0.22 - CGFloat(k) * 0.015), y: yy))
                    }
                    g.move(to: CGPoint(x: -s * 0.2, y: s * 0.5)); g.addLine(to: CGPoint(x: s * 0.2, y: s * 0.5))
                    g.strokePath()
                }
            case 3: // was sceptre
                stroked(c, lw * 1.2) {
                    g.move(to: CGPoint(x: 0, y: -s * 0.35)); g.addLine(to: CGPoint(x: 0, y: s * 0.32))
                    g.move(to: CGPoint(x: 0, y: s * 0.32)); g.addLine(to: CGPoint(x: -s * 0.16, y: s * 0.5))
                    g.move(to: CGPoint(x: 0, y: s * 0.32)); g.addLine(to: CGPoint(x: s * 0.16, y: s * 0.5))
                    g.move(to: CGPoint(x: 0, y: -s * 0.35)); g.addQuadCurve(to: CGPoint(x: s * 0.24, y: -s * 0.5), control: CGPoint(x: s * 0.0, y: -s * 0.52))
                    g.strokePath()
                }
                circle(s * 0.08, -s * 0.4, s * 0.05, c2, c, 1)
            case 4: // water
                stroked(c, lw) {
                    for r in 0..<3 {
                        let yy = -s * 0.22 + CGFloat(r) * s * 0.22
                        g.move(to: CGPoint(x: -s * 0.38, y: yy + s * 0.07))
                        g.addLine(to: CGPoint(x: -s * 0.19, y: yy - s * 0.07)); g.addLine(to: CGPoint(x: 0, y: yy + s * 0.07))
                        g.addLine(to: CGPoint(x: s * 0.19, y: yy - s * 0.07)); g.addLine(to: CGPoint(x: s * 0.38, y: yy + s * 0.07))
                    }
                    g.strokePath()
                }
            case 5: // feather of Maat
                at(0, s * 0.5) { fillStroke(lance(s, s * 0.11), c2, c, lw * 0.8) }
                stroked(c, lw * 0.7) {
                    g.move(to: CGPoint(x: 0, y: s * 0.5)); g.addLine(to: CGPoint(x: 0, y: -s * 0.48))
                    for k in 0..<5 {
                        let yy = -s * 0.36 + CGFloat(k) * s * 0.16
                        g.move(to: CGPoint(x: 0, y: yy + s * 0.06)); g.addLine(to: CGPoint(x: s * 0.13, y: yy - s * 0.04))
                        g.move(to: CGPoint(x: 0, y: yy + s * 0.06)); g.addLine(to: CGPoint(x: -s * 0.13, y: yy - s * 0.04))
                    }
                    g.strokePath()
                }
            case 6: // scarab
                stroked(c, lw * 0.9) {
                    for k in 0..<3 {
                        let yy = -s * 0.02 + CGFloat(k) * s * 0.16
                        g.move(to: CGPoint(x: -s * 0.2, y: yy)); g.addLine(to: CGPoint(x: -s * 0.4, y: yy + s * 0.1))
                        g.move(to: CGPoint(x: s * 0.2, y: yy)); g.addLine(to: CGPoint(x: s * 0.4, y: yy + s * 0.1))
                    }
                    g.strokePath()
                }
                fillStroke(CGPath(ellipseIn: CGRect(x: -s * 0.24, y: -s * 0.2, width: s * 0.48, height: s * 0.62), transform: nil), c, c, lw * 0.6)
                circle(0, -s * 0.3, s * 0.12, c, c, 1)
                stroked(c2, lw * 0.6) { g.move(to: CGPoint(x: 0, y: -s * 0.18)); g.addLine(to: CGPoint(x: 0, y: s * 0.4)); g.strokePath() }
                stroked(c, lw) {
                    g.move(to: CGPoint(x: -s * 0.1, y: -s * 0.38)); g.addLine(to: CGPoint(x: -s * 0.18, y: -s * 0.5))
                    g.move(to: CGPoint(x: s * 0.1, y: -s * 0.38)); g.addLine(to: CGPoint(x: s * 0.18, y: -s * 0.5)); g.strokePath()
                }
            case 7: // cobra
                let body = CGMutablePath()
                body.move(to: CGPoint(x: -s * 0.1, y: s * 0.5))
                body.addCurve(to: CGPoint(x: s * 0.14, y: s * 0.18), control1: CGPoint(x: s * 0.3, y: s * 0.5), control2: CGPoint(x: s * 0.3, y: s * 0.3))
                body.addCurve(to: CGPoint(x: 0, y: -s * 0.05), control1: CGPoint(x: s * 0.0, y: s * 0.08), control2: CGPoint(x: s * 0.0, y: s * 0.0))
                stroked(c, lw * 1.5) { g.addPath(body); g.strokePath() }
                let hood = CGMutablePath()
                hood.move(to: CGPoint(x: 0, y: -s * 0.05))
                hood.addQuadCurve(to: CGPoint(x: -s * 0.2, y: -s * 0.3), control: CGPoint(x: -s * 0.28, y: -s * 0.05))
                hood.addQuadCurve(to: CGPoint(x: s * 0.1, y: -s * 0.5), control: CGPoint(x: -s * 0.12, y: -s * 0.55))
                hood.addQuadCurve(to: CGPoint(x: s * 0.1, y: -s * 0.05), control: CGPoint(x: s * 0.2, y: -s * 0.3))
                hood.closeSubpath()
                fillStroke(hood, c2, c, lw)
            case 8: // sun disc with rays
                circle(0, 0, s * 0.2, c2, c, lw)
                circle(0, 0, s * 0.07, c, nil)
                stroked(c, lw * 0.9) {
                    for k in 0..<8 {
                        let th = CGFloat(k) * .pi / 4
                        g.move(to: CGPoint(x: cos(th) * s * 0.3, y: sin(th) * s * 0.3)); g.addLine(to: CGPoint(x: cos(th) * s * 0.46, y: sin(th) * s * 0.46))
                    }
                    g.strokePath()
                }
            default: // lotus
                for sgn in [CGFloat(-1), 1] { at(0, s * 0.3, sgn * 0.62) { fillStroke(lance(s * 0.62, s * 0.11), c2, c, lw * 0.8) } }
                at(0, s * 0.3, 0) { fillStroke(lance(s * 0.8, s * 0.12), c, c, lw * 0.8) }
                stroked(c, lw) { g.move(to: CGPoint(x: 0, y: s * 0.3)); g.addLine(to: CGPoint(x: 0, y: s * 0.5)); g.strokePath() }
            }
        }
    }

    func egypt() {
        g.setFillColor(navy); g.fill(CGRect(x: X0, y: 0, width: X1 - X0, height: DH))
        rectInset(8, cream); rectInset(11, ink); rectInset(13, red); rectInset(33, gold); rectInset(36, ink)
        rectInset(37, navy); rectInset(139, gold); rectInset(141, ink); rectInset(143, teal)
        rectInset(163, ink); rectInset(164, gold); rectInset(168, ink); rectInset(169, fieldGrad[1])
        guardBands()
        // chequered outer strip
        perimeter(inset: 23, step: 14) { x, y, _ in at(x, y, .pi / 4) { fillStroke(CGPath(rect: CGRect(x: -4, y: -4, width: 8, height: 8), transform: nil), gold, ink, 0.6) } }

        // hieroglyph border
        let sides: [(CGFloat, CGFloat, Bool)] = [(88, 0, true), (DH - 88, .pi, true), (X0 + 88, -.pi / 2, false), (X1 - 88, .pi / 2, false)]
        let cols: [CGColor] = [gold, ivory, teal, gold, rose, ivory]
        var gi = 0
        for (fixed, ang, horizontal) in sides {
            let lo: CGFloat = horizontal ? X0 + 140 : 140
            let hi: CGFloat = horizontal ? X1 - 140 : DH - 140
            let n = Int(((hi - lo) / 52).rounded())
            for i in 0...n {
                let t = lo + (hi - lo) * CGFloat(i) / CGFloat(n)
                let px = horizontal ? t : fixed, py = horizontal ? fixed : t
                // each glyph sits on a small carnelian cartouche tile
                at(px, py, ang) {
                    fillStroke(CGPath(roundedRect: CGRect(x: -20, y: -33, width: 40, height: 66), cornerWidth: 10, cornerHeight: 10, transform: nil), navy2, gold, 1.2)
                }
                glyph(gi * 7 + gi / 3, px, py, 50, ang, cols[gi % cols.count], red3)
                gi += 1
            }
        }
        for (px, py) in [(X0 + 88, CGFloat(88)), (X1 - 88, 88), (X0 + 88, DH - 88), (X1 - 88, DH - 88)] {
            circle(px, py, 38, gold, ink, 1.6); circle(px, py, 30, navy, ink, 1)
            glyph(6, px, py, 44, 0, gold, red3)
        }

        // field
        let fx0 = X0 + 169, fx1 = X1 - 169, fy0: CGFloat = 169, fy1 = DH - 169
        g.saveGState()
        g.clip(to: CGRect(x: fx0, y: fy0, width: fx1 - fx0, height: fy1 - fy0))
        let grad = CGGradient(colorsSpace: cs, colors: fieldGrad as CFArray, locations: [0, 0.55, 1])!
        g.drawRadialGradient(grad, startCenter: CGPoint(x: cx, y: cy), startRadius: 0,
                             endCenter: CGPoint(x: cx, y: cy), endRadius: 520, options: [.drawsAfterEndLocation])
        // papyrus fibres
        g.setStrokeColor(hex(0x9B7B3C, 0.10)); g.setLineWidth(1)
        var yy = fy0 + 5
        while yy < fy1 { g.move(to: CGPoint(x: fx0, y: yy)); g.addLine(to: CGPoint(x: fx1, y: yy)); yy += 7 }
        g.strokePath()
        g.setStrokeColor(hex(0x9B7B3C, 0.08))
        var xx = fx0
        while xx < fx1 { g.move(to: CGPoint(x: xx, y: fy0)); g.addLine(to: CGPoint(x: xx, y: fy1)); xx += 23 }
        g.strokePath()

        // winged sun disc
        let wy = fy0 + 98
        for s in [CGFloat(-1), 1] {
            let tiers: [(CGFloat, CGFloat, CGColor, CGFloat)] = [(122, 15, navy, 30), (96, 13, red, 16), (68, 11, teal, 4), (40, 8, gold, -6)]
            for (len, wid, col, dy) in tiers {
                for k in 0..<8 {
                    let bx = cx + s * (46 + CGFloat(k) * 29)
                    let by = wy + dy - CGFloat(k) * 2.5
                    at(bx, by, s * (1.92 + CGFloat(k) * 0.03)) { fillStroke(drop(len * (1 - CGFloat(k) * 0.035), wid), col, ink, 1.1) }
                }
            }
        }
        circle(cx, wy, 40, gold, ink, 2); circle(cx, wy, 31, red3, ink, 1.4); circle(cx, wy, 11, gold, ink, 1)
        for s in [CGFloat(-1), 1] { glyph(7, cx + s * 66, wy + 4, 52, 0, gold, red3) }
        // bar under the disc
        fillStroke(CGPath(roundedRect: CGRect(x: cx - 275, y: wy + 66, width: 550, height: 8), cornerWidth: 4, cornerHeight: 4, transform: nil), navy, ink, 1.2)

        // large eyes of Horus at both ends, facing the centre
        for s in [CGFloat(-1), 1] {
            at(cx + s * 355, cy + 70) { g.scaleBy(x: -s, y: 1); glyph(1, 0, 0, 120, 0, navy, ivory) }
        }
        // inscription columns
        let colX: [CGFloat] = [-150, -205, -260, 150, 205, 260]
        for (ci, dx) in colX.enumerated() {
            for r in 0..<6 {
                let px = cx + dx, py = cy - 46 + CGFloat(r) * 42
                let k = ci * 3 + r * 4 + (ci % 2)
                glyph(k, px, py, 36, 0, [navy, red, ink, teal][(r + ci) % 4], gold)
            }
        }
        for dx in [CGFloat(-232), -177, 177, 232] {
            g.setStrokeColor(hex(0x7A5A22, 0.55)); g.setLineWidth(1.2)
            g.move(to: CGPoint(x: cx + dx, y: cy - 70)); g.addLine(to: CGPoint(x: cx + dx, y: cy + 180)); g.strokePath()
        }
        // central cartouche
        let cw: CGFloat = 108, ch: CGFloat = 262, ccy = cy + 46
        let cart = CGPath(roundedRect: CGRect(x: cx - cw / 2, y: ccy - ch / 2, width: cw, height: ch), cornerWidth: cw / 2, cornerHeight: cw / 2, transform: nil)
        fillStroke(CGPath(roundedRect: CGRect(x: cx - cw / 2 - 8, y: ccy - ch / 2 - 8, width: cw + 16, height: ch + 16), cornerWidth: cw / 2 + 8, cornerHeight: cw / 2 + 8, transform: nil), gold, ink, 2)
        fillStroke(cart, ivory, ink, 2)
        fillStroke(CGPath(rect: CGRect(x: cx - cw / 2 - 18, y: ccy + ch / 2 - 8, width: cw + 36, height: 10), transform: nil), gold, ink, 1.4)
        let stack = [8, 5, 0, 6, 2]
        for (i, k) in stack.enumerated() {
            glyph(k, cx, ccy - ch / 2 + 38 + CGFloat(i) * 47, 40, 0, [navy, red, navy, ink, red][i], gold)
        }
        // Nile water and lotus frieze along the bottom
        g.setStrokeColor(teal); g.setLineWidth(3.2); g.setLineJoin(.round)
        for row in 0..<2 {
            let by = fy1 - 26 + CGFloat(row) * 12
            var x = fx0 + CGFloat(row) * 10
            g.move(to: CGPoint(x: x, y: by))
            while x < fx1 { g.addLine(to: CGPoint(x: x + 10, y: by - 6)); g.addLine(to: CGPoint(x: x + 20, y: by)); x += 20 }
        }
        g.strokePath()
        var lx = fx0 + 50
        var li = 0
        while lx < fx1 - 30 {
            glyph(9, lx, fy1 - 62, 38, 0, li % 2 == 0 ? green : navy, li % 2 == 0 ? rose : gold)
            lx += 82; li += 1
        }
        g.restoreGState()
    }

    // MARK: Egyptian Khayamiya (tentmaker appliqué): stars, lobed medallions, black outlines

    func starP(_ n: Int, _ r1: CGFloat, _ r2: CGFloat, rot: CGFloat = 0) -> CGPath {
        let p = CGMutablePath()
        for i in 0..<(2 * n) {
            let r = i % 2 == 0 ? r1 : r2
            let th = rot - .pi / 2 + CGFloat(i) * .pi / CGFloat(n)
            let q = CGPoint(x: r * cos(th), y: r * sin(th))
            if i == 0 { p.move(to: q) } else { p.addLine(to: q) }
        }
        p.closeSubpath()
        return p
    }

    func lobedP(_ n: Int, _ r: CGFloat, _ depth: CGFloat) -> CGPath {
        let p = CGMutablePath()
        let M = 360
        for i in 0...M {
            let t = CGFloat(i) / CGFloat(M) * 2 * .pi
            let rr = r * (1 + depth * cos(CGFloat(n) * t))
            let q = CGPoint(x: rr * cos(t), y: rr * sin(t))
            if i == 0 { p.move(to: q) } else { p.addLine(to: q) }
        }
        p.closeSubpath()
        return p
    }

    func khayamiya() {
        g.setFillColor(cream); g.fill(CGRect(x: X0, y: 0, width: X1 - X0, height: DH))
        rectInset(8, ink); rectInset(11, cream); rectInset(14, red); rectInset(30, ink); rectInset(33, cream)
        rectInset(36, ink); rectInset(139, ink); rectInset(143, navy); rectInset(150, cream); rectInset(154, navy)
        rectInset(161, ink); rectInset(163, red); rectInset(167, ink); rectInset(169, cream)
        g.setFillColor(ink); g.fill(CGRect(x: X0 + 37, y: 37, width: X1 - X0 - 74, height: 102))
        // black main border: continuous strip, patterns appliquéd on top
        rectInset(37, ink); rectInset(139, cream); rectInset(143, navy); rectInset(150, cream); rectInset(154, navy)
        rectInset(161, ink); rectInset(163, red); rectInset(167, ink); rectInset(169, cream)

        let sides: [(CGFloat, CGFloat, Bool)] = [(88, 0, true), (DH - 88, .pi, true), (X0 + 88, -.pi / 2, false), (X1 - 88, .pi / 2, false)]
        for (fixed, ang, horizontal) in sides {
            let lo: CGFloat = horizontal ? X0 + 125 : 125
            let hi: CGFloat = horizontal ? X1 - 125 : DH - 125
            let n = Int(((hi - lo) / 72).rounded())
            for i in 0...n {
                let t = lo + (hi - lo) * CGFloat(i) / CGFloat(n)
                let px = horizontal ? t : fixed, py = horizontal ? fixed : t
                at(px, py, ang) {
                    if i % 2 == 0 {
                        fillStroke(lozP(26, 40, n: 1.6), red, cream, 1.6)
                        fillStroke(lozP(15, 24, n: 1.6), cream, ink, 1)
                        at(0, 0) { fillStroke(starP(8, 9, 4.5), gold, ink, 0.8) }
                    } else {
                        for sgn in [CGFloat(-1), 1] {
                            at(sgn * 12, 20, sgn * 0.45) { fillStroke(drop(46, 11), sgn < 0 ? gold : cream, cream.copy(alpha: 0.0), 0.1) }
                            at(sgn * 12, -20, .pi + sgn * 0.45) { fillStroke(drop(46, 11), sgn < 0 ? cream : gold, nil) }
                        }
                        circle(0, 0, 6, red, cream, 1)
                    }
                }
            }
        }
        for (px, py) in [(X0 + 88, CGFloat(88)), (X1 - 88, 88), (X0 + 88, DH - 88), (X1 - 88, DH - 88)] {
            at(px, py) {
                fillStroke(starP(8, 46, 30), gold, cream, 1.6)
                fillStroke(starP(8, 30, 20), red, ink, 1.2)
                circle(0, 0, 9, cream, ink, 1)
            }
        }

        // field
        let fx0 = X0 + 169, fx1 = X1 - 169, fy0: CGFloat = 169, fy1 = DH - 169
        g.saveGState()
        g.clip(to: CGRect(x: fx0, y: fy0, width: fx1 - fx0, height: fy1 - fy0))
        g.setFillColor(cream); g.fill(CGRect(x: fx0, y: fy0, width: fx1 - fx0, height: fy1 - fy0))

        func medal(_ x: CGFloat, _ y: CGFloat, _ k: CGFloat, _ c1: CGColor, _ c2: CGColor, _ c3: CGColor) {
            at(x, y) {
                fillStroke(starP(16, 215 * k, 168 * k, rot: .pi / 16), ink, nil)
                fillStroke(starP(16, 205 * k, 160 * k, rot: .pi / 16), c1, cream, 1.4)
                fillStroke(lobedP(12, 135 * k, 0.09), c2, ink, 2)
                fillStroke(starP(12, 115 * k, 78 * k), cream, ink, 1.6)
                fillStroke(starP(8, 82 * k, 52 * k, rot: .pi / 8), c3, ink, 1.4)
                for j in 0..<8 { at(0, 0, CGFloat(j) * .pi / 4) { at(0, -68 * k) { fillStroke(drop(30 * k, 7 * k), c1, ink, 1) } } }
                circle(0, 0, 25 * k, cream, ink, 1.6)
                fillStroke(starP(8, 20 * k, 10 * k), gold, ink, 1)
            }
        }
        medal(cx, cy, 1.0, red, navy, gold)

        // side pendants (lozenge with lobes)
        for s in [CGFloat(-1), 1] {
            at(cx + s * 318, cy) {
                fillStroke(lozP(92, 150, n: 1.7), ink, nil)
                fillStroke(lozP(86, 143, n: 1.7), navy, cream, 1.6)
                fillStroke(lozP(60, 106, n: 1.7), cream, ink, 1.4)
                fillStroke(lobedP(8, 36, 0.12), red, ink, 1.4)
                at(0, 0) { fillStroke(starP(8, 22, 11), gold, ink, 1) }
                for sy in [CGFloat(-1), 1] { at(0, sy * 92) { fillStroke(starP(6, 18, 9), gold, ink, 1) } }
            }
        }
        // half-medallions at top & bottom, quarter ones in corners
        medal(cx, fy0 - 20, 0.62, green, navy, gold)
        medal(cx, fy1 + 20, 0.62, green, navy, gold)
        for (qx, qy) in [(fx0, fy0), (fx1, fy0), (fx0, fy1), (fx1, fy1)] {
            at(qx, qy) {
                fillStroke(starP(12, 140, 104), ink, nil)
                fillStroke(starP(12, 134, 98), red, cream, 1.4)
                fillStroke(starP(8, 84, 54, rot: .pi / 8), cream, ink, 1.4)
                fillStroke(starP(8, 52, 28), navy, ink, 1.2)
                circle(0, 0, 12, gold, ink, 1)
            }
        }
        // scattered small stars on the plain ground
        var gx = fx0 + 30
        var row = 0
        while gx < fx1 {
            var gy = fy0 + (row % 2 == 0 ? 26 : 58)
            while gy < fy1 {
                let d1 = hypot(gx - cx, gy - cy)
                let dc = min(hypot(gx - fx0, gy - fy0), hypot(gx - fx1, gy - fy0), hypot(gx - fx0, gy - fy1), hypot(gx - fx1, gy - fy1))
                let dp = min(abs(gx - (cx - 318)), abs(gx - (cx + 318))) / 100 + abs(gy - cy) / 160
                let dt = min(hypot(gx - cx, gy - fy0), hypot(gx - cx, gy - fy1))
                if d1 > 225 && dc > 150 && dp > 1.05 && dt > 150 {
                    at(gx, gy) {
                        fillStroke(starP(8, 11, 5), (row % 3 == 0) ? red : ((row % 3 == 1) ? navy : gold), ink, 0.9)
                    }
                }
                gy += 64
            }
            gx += 64; row += 1
        }
        g.restoreGState()
    }

    // MARK: Moroccan Beni Ourain: ivory wool, hand-drawn charcoal diamond lattice

    /// polyline with a gentle hand-made wobble
    func wobbleLine(_ a: CGPoint, _ b: CGPoint, _ amp: CGFloat) {
        let len = hypot(b.x - a.x, b.y - a.y)
        let n = max(2, Int(len / 16))
        let nx = -(b.y - a.y) / len, ny = (b.x - a.x) / len
        var off: CGFloat = 0
        for i in 0...n {
            let t = CGFloat(i) / CGFloat(n)
            off = off * 0.6 + (CGFloat(rng.next()) - 0.5) * amp
            let p = CGPoint(x: a.x + (b.x - a.x) * t + nx * off, y: a.y + (b.y - a.y) * t + ny * off)
            if i == 0 { g.move(to: p) } else { g.addLine(to: p) }
        }
    }

    func berber() {
        g.setFillColor(cream); g.fill(CGRect(x: X0, y: 0, width: X1 - X0, height: DH))
        // soft dyed-wool clouds
        for _ in 0..<40 {
            let bx = X0 + CGFloat(rng.next()) * (X1 - X0), by = CGFloat(rng.next()) * DH
            let br = 40 + CGFloat(rng.next()) * 130
            let c = (rng.next() < 0.5 ? hex(0xD9CBAA, 0.16) : hex(0xFFFBEF, 0.22))
            g.setFillColor(c); g.fillEllipse(in: CGRect(x: bx - br, y: by - br * 0.7, width: br * 2, height: br * 1.4))
        }
        g.saveGState()
        g.clip(to: CGRect(x: X0 + 40, y: 40, width: X1 - X0 - 80, height: DH - 80))
        let a: CGFloat = 112, b: CGFloat = 125
        g.setStrokeColor(ink); g.setLineCap(.round); g.setLineJoin(.round)
        // diamond lattice: lines u = 2m and v = 2n, with u = x/a + y/b and v = x/a - y/b
        g.setLineWidth(7)
        for m in -8...8 {
            let u = CGFloat(m) * 2
            // x/a + y/b = u  ->  y = b (u - x/a)
            let x0 = cx - 700, x1 = cx + 700
            wobbleLine(CGPoint(x: x0, y: cy + b * (u - (x0 - cx) / a)), CGPoint(x: x1, y: cy + b * (u - (x1 - cx) / a)), 4)
            wobbleLine(CGPoint(x: x0, y: cy + b * ((x0 - cx) / a - u)), CGPoint(x: x1, y: cy + b * ((x1 - cx) / a - u)), 4)
        }
        g.strokePath()
        // small diamonds in the cells
        g.setLineWidth(4.5)
        for m in -7...7 {
            for n in -7...7 {
                let u = CGFloat(m) * 2 + 1, v = CGFloat(n) * 2 + 1
                let px = cx + a * (u + v) / 2, py = cy + b * (u - v) / 2
                if px < X0 + 60 || px > X1 - 60 || py < 50 || py > DH - 50 { continue }
                let kind = (m + n + 16) % 3
                if kind == 0 {
                    let k: CGFloat = 0.42
                    wobbleLine(CGPoint(x: px, y: py - b * k), CGPoint(x: px + a * k, y: py), 2.5)
                    wobbleLine(CGPoint(x: px + a * k, y: py), CGPoint(x: px, y: py + b * k), 2.5)
                    wobbleLine(CGPoint(x: px, y: py + b * k), CGPoint(x: px - a * k, y: py), 2.5)
                    wobbleLine(CGPoint(x: px - a * k, y: py), CGPoint(x: px, y: py - b * k), 2.5)
                } else if kind == 1 {
                    wobbleLine(CGPoint(x: px - 16, y: py), CGPoint(x: px + 16, y: py), 2)
                    wobbleLine(CGPoint(x: px, y: py - 16), CGPoint(x: px, y: py + 16), 2)
                }
            }
        }
        g.strokePath()
        g.restoreGState()
        // two hand-drawn edge lines
        g.setStrokeColor(ink); g.setLineCap(.round)
        for (inset, lw) in [(CGFloat(24), CGFloat(7)), (CGFloat(40), CGFloat(3.5))] {
            g.setLineWidth(lw)
            wobbleLine(CGPoint(x: X0 + inset, y: inset), CGPoint(x: X1 - inset, y: inset), 2.5)
            wobbleLine(CGPoint(x: X1 - inset, y: inset), CGPoint(x: X1 - inset, y: DH - inset), 2.5)
            wobbleLine(CGPoint(x: X1 - inset, y: DH - inset), CGPoint(x: X0 + inset, y: DH - inset), 2.5)
            wobbleLine(CGPoint(x: X0 + inset, y: DH - inset), CGPoint(x: X0 + inset, y: inset), 2.5)
            g.strokePath()
        }
    }

    // MARK: Caucasian Kazak: bold hooked medallions on a red field, stepped border

    func octP(_ r: CGFloat) -> CGPath {
        let p = CGMutablePath()
        for i in 0..<8 {
            let th = CGFloat(i) * .pi / 4 + .pi / 8
            let q = CGPoint(x: r * cos(th), y: r * sin(th))
            if i == 0 { p.move(to: q) } else { p.addLine(to: q) }
        }
        p.closeSubpath(); return p
    }

    /// diamond with little square hooks on its four points
    func hookDiamond(_ x: CGFloat, _ y: CGFloat, _ r: CGFloat, _ c1: CGColor, _ c2: CGColor, _ c3: CGColor) {
        at(x, y) {
            for k in 0..<4 {
                at(0, 0, CGFloat(k) * .pi / 2) {
                    fillStroke(CGPath(rect: CGRect(x: -r * 0.16, y: -r * 1.42, width: r * 0.32, height: r * 0.42), transform: nil), c3, ink, 1)
                    fillStroke(CGPath(rect: CGRect(x: -r * 0.42, y: -r * 1.42, width: r * 0.26, height: r * 0.2), transform: nil), c3, ink, 1)
                }
            }
            fillStroke(diamondP(r), c1, ink, 1.6)
            fillStroke(diamondP(r * 0.58), c2, ink, 1.2)
            fillStroke(diamondP(r * 0.24), c3, ink, 1)
        }
    }

    func kazakMedal(_ x: CGFloat, _ y: CGFloat, _ r: CGFloat, _ c1: CGColor, _ c2: CGColor, _ c3: CGColor, _ c4: CGColor) {
        at(x, y) {
            // hooked arms
            for k in 0..<4 {
                at(0, 0, CGFloat(k) * .pi / 2) {
                    fillStroke(CGPath(rect: CGRect(x: -r * 0.2, y: -r * 1.34, width: r * 0.4, height: r * 0.5), transform: nil), c3, ink, 1.4)
                    fillStroke(CGPath(rect: CGRect(x: r * 0.2, y: -r * 1.34, width: r * 0.3, height: r * 0.2), transform: nil), c3, ink, 1.4)
                    fillStroke(CGPath(rect: CGRect(x: -r * 0.5, y: -r * 1.34, width: r * 0.3, height: r * 0.2), transform: nil), c3, ink, 1.4)
                    fillStroke(CGPath(rect: CGRect(x: -r * 0.08, y: -r * 1.2, width: r * 0.16, height: r * 0.3), transform: nil), c4, ink, 1)
                }
            }
            fillStroke(octP(r * 1.0), ink, nil)
            fillStroke(octP(r * 0.96), c1, cream, 1.6)
            fillStroke(octP(r * 0.72), c2, ink, 1.4)
            fillStroke(starP(8, r * 0.62, r * 0.36, rot: .pi / 8), c3, ink, 1.4)
            for k in 0..<4 {
                at(0, 0, CGFloat(k) * .pi / 2) {
                    fillStroke(CGPath(rect: CGRect(x: -r * 0.07, y: -r * 0.9, width: r * 0.14, height: r * 0.14), transform: nil), c4, ink, 0.8)
                }
            }
            fillStroke(diamondP(r * 0.26), c1, ink, 1.2)
            fillStroke(diamondP(r * 0.1), c4, ink, 0.8)
        }
    }

    func kazak() {
        g.setFillColor(red); g.fill(CGRect(x: X0, y: 0, width: X1 - X0, height: DH))
        rectInset(8, ink); rectInset(10, cream); rectInset(14, red2); rectInset(30, ink); rectInset(33, cream)
        rectInset(36, ink); rectInset(37, navy); rectInset(139, ink); rectInset(141, cream); rectInset(147, ink); rectInset(149, red)

        // stepped border: hooked diamonds and little blocks
        let sides: [(CGFloat, CGFloat, Bool)] = [(88, 0, true), (DH - 88, .pi, true), (X0 + 88, -.pi / 2, false), (X1 - 88, .pi / 2, false)]
        for (fixed, ang, horizontal) in sides {
            let lo: CGFloat = horizontal ? X0 + 112 : 112
            let hi: CGFloat = horizontal ? X1 - 112 : DH - 112
            let n = Int(((hi - lo) / 84).rounded())
            let cols: [(CGColor, CGColor, CGColor)] = [(cream, red, gold), (red, cream, navy2), (green, cream, gold)]
            for i in 0...n {
                let t = lo + (hi - lo) * CGFloat(i) / CGFloat(n)
                let px = horizontal ? t : fixed, py = horizontal ? fixed : t
                let c = cols[i % 3]
                hookDiamond(px, py, 26, c.0, c.1, c.2)
                if i < n {
                    let mx = horizontal ? t + (hi - lo) / CGFloat(n) / 2 : fixed
                    let my = horizontal ? fixed : t + (hi - lo) / CGFloat(n) / 2
                    at(mx, my, ang) {
                        fillStroke(CGPath(rect: CGRect(x: -9, y: -9, width: 18, height: 18), transform: nil), gold, ink, 1)
                        fillStroke(CGPath(rect: CGRect(x: -4, y: -4, width: 8, height: 8), transform: nil), red, nil)
                    }
                }
            }
        }
        for (px, py) in [(X0 + 88, CGFloat(88)), (X1 - 88, 88), (X0 + 88, DH - 88), (X1 - 88, DH - 88)] {
            at(px, py) { fillStroke(starP(8, 40, 22, rot: .pi / 8), gold, ink, 1.6); fillStroke(starP(8, 22, 12), red, ink, 1); circle(0, 0, 5, cream, ink, 1) }
        }
        // thin zigzag in the ivory stripe
        g.setStrokeColor(red); g.setLineWidth(2.4); g.setLineJoin(.miter)
        perimeter(inset: 144, step: 18) { x, y, _ in circle(x, y, 1.8, red) }

        // field
        let fx0 = X0 + 149, fx1 = X1 - 149, fy0: CGFloat = 149, fy1 = DH - 149
        g.saveGState()
        g.clip(to: CGRect(x: fx0, y: fy0, width: fx1 - fx0, height: fy1 - fy0))
        let medalX: [CGFloat] = [cx - 292, cx, cx + 292]
        let palette: [(CGColor, CGColor, CGColor, CGColor)] = [(navy, cream, green, gold), (green, cream, navy, gold), (navy, cream, green, gold)]
        for (i, mx) in medalX.enumerated() {
            let c = palette[i]
            kazakMedal(mx, cy, i == 1 ? 100 : 82, c.0, c.1, c.2, c.3)
        }
        // small hooked diamonds above, below and between
        for gx in stride(from: cx - 393, through: cx + 393, by: 131) {
            hookDiamond(gx, fy0 + 52, 17, ivory, navy2, gold)
            hookDiamond(gx, fy1 - 52, 17, ivory, navy2, gold)
        }
        for (i, mx) in [cx - 146, cx + 146].enumerated() {
            for sy in [CGFloat(-1), 1] {
                hookDiamond(mx, cy + sy * 150, 15, i == 0 ? cream : gold, red2, navy2)
            }
            at(mx, cy + 96) { fillStroke(starP(8, 14, 7, rot: .pi / 8), cream, ink, 1); }
            at(mx, cy - 96) { fillStroke(starP(8, 14, 7, rot: .pi / 8), cream, ink, 1); }
        }
        // corner half-stars and scattered blocks
        for (qx, qy) in [(fx0, fy0), (fx1, fy0), (fx0, fy1), (fx1, fy1)] {
            at(qx, qy) { fillStroke(octP(64), ink, nil); fillStroke(octP(60), navy, cream, 1.4); fillStroke(octP(36), gold, ink, 1.2); fillStroke(octP(16), red, ink, 1) }
        }
        for _ in 0..<60 {
            let px = fx0 + 30 + CGFloat(rng.next()) * (fx1 - fx0 - 60), py = fy0 + 30 + CGFloat(rng.next()) * (fy1 - fy0 - 60)
            if abs(py - cy) < 140 && min(abs(px - medalX[0]), abs(px - medalX[1]), abs(px - medalX[2])) < 130 { continue }
            if py < fy0 + 90 || py > fy1 - 90 { continue }
            at(px, py) { fillStroke(CGPath(rect: CGRect(x: -4, y: -4, width: 8, height: 8), transform: nil), rng.next() < 0.5 ? cream : gold, ink, 0.8) }
        }
        g.restoreGState()
    }

    // MARK: shared helpers for the newer designs

    func drawText(_ str: String, _ x: CGFloat, _ y: CGFloat, _ size: CGFloat, _ color: CGColor, font: String) {
        let f = CTFontCreateWithName(font as CFString, size, nil)
        let attrs: [NSAttributedString.Key: Any] = [.font: f, NSAttributedString.Key(kCTForegroundColorAttributeName as String): color]
        let line = CTLineCreateWithAttributedString(NSAttributedString(string: str, attributes: attrs))
        let b = CTLineGetBoundsWithOptions(line, [.useGlyphPathBounds])
        g.saveGState()
        g.translateBy(x: x - b.midX, y: y + b.midY)
        g.scaleBy(x: 1, y: -1)
        g.textPosition = .zero
        CTLineDraw(line, g)
        g.restoreGState()
    }

    func sidesLoop(_ lo0: CGFloat, step: CGFloat, centre: CGFloat = 88, _ f: (CGFloat, CGFloat, CGFloat, Int) -> Void) {
        let sides: [(CGFloat, CGFloat, Bool)] = [(centre, 0, true), (DH - centre, .pi, true), (X0 + centre, -.pi / 2, false), (X1 - centre, .pi / 2, false)]
        for (fixed, ang, horizontal) in sides {
            let lo: CGFloat = horizontal ? X0 + lo0 : lo0
            let hi: CGFloat = horizontal ? X1 - lo0 : DH - lo0
            let n = Int(((hi - lo) / step).rounded())
            for i in 0...n {
                let t = lo + (hi - lo) * CGFloat(i) / CGFloat(n)
                f(horizontal ? t : fixed, horizontal ? fixed : t, ang, i)
            }
        }
    }

    var cornerPoints: [(CGFloat, CGFloat)] { [(X0 + 88, 88), (X1 - 88, 88), (X0 + 88, DH - 88), (X1 - 88, DH - 88)] }

    func fieldClip(_ inset: CGFloat) -> CGRect {
        let r = CGRect(x: X0 + inset, y: inset, width: X1 - X0 - 2 * inset, height: DH - 2 * inset)
        g.saveGState(); g.clip(to: r); return r
    }

    // MARK: Chinese silk: key-fret border, peony medallion with shou, ruyi clouds, waves

    func ruyi(_ x: CGFloat, _ y: CGFloat, _ s: CGFloat, _ a: CGFloat, _ c: CGColor, _ c2: CGColor) {
        at(x, y, a) {
            for dx in [CGFloat(-1), 0, 1] {
                circle(dx * s * 0.34, -abs(dx) * s * 0.0 - (dx == 0 ? s * 0.12 : 0), s * 0.26, c, ink, 1.1)
            }
            fillStroke(CGPath(rect: CGRect(x: -s * 0.55, y: -s * 0.02, width: s * 1.1, height: s * 0.2), transform: nil), c, nil)
            for dx in [CGFloat(-1), 0, 1] { circle(dx * s * 0.34, (dx == 0 ? -s * 0.12 : 0), s * 0.13, c2, ink, 0.8) }
            spiral(-s * 0.25, s * 0.22, s * 0.16, 1.4, 1, 0, c2, 2.2)
            spiral(s * 0.25, s * 0.22, s * 0.16, 1.4, -1, .pi, c2, 2.2)
        }
    }

    func china() {
        g.setFillColor(red); g.fill(CGRect(x: X0, y: 0, width: X1 - X0, height: DH))
        rectInset(8, gold); rectInset(11, ink); rectInset(13, red2); rectInset(36, gold); rectInset(38, ink)
        rectInset(39, red); rectInset(139, gold); rectInset(141, ink); rectInset(143, navy2)
        rectInset(163, ink); rectInset(164, gold); rectInset(168, ink); rectInset(169, navy)
        guardBands()
        // key-fret (meander) border in gold
        sidesLoop(112, step: 46) { x, y, ang, i in
            at(x, y, ang) {
                stroked(gold, 5.5) {
                    g.move(to: CGPoint(x: -20, y: 20)); g.addLine(to: CGPoint(x: -20, y: -20)); g.addLine(to: CGPoint(x: 20, y: -20))
                    g.addLine(to: CGPoint(x: 20, y: 14)); g.addLine(to: CGPoint(x: -8, y: 14)); g.addLine(to: CGPoint(x: -8, y: -8))
                    g.addLine(to: CGPoint(x: 8, y: -8)); g.addLine(to: CGPoint(x: 8, y: 2)); g.strokePath()
                }
                stroked(ink, 1) { g.stroke(CGRect(x: -23, y: -23, width: 46, height: 46)) }
            }
        }
        for (px, py) in cornerPoints {
            circle(px, py, 40, gold, ink, 1.6); circle(px, py, 32, red2, ink, 1)
            drawText("囍", px, py, 44, gold, font: "Songti SC")
        }

        let r = fieldClip(169)
        let grad = CGGradient(colorsSpace: cs, colors: fieldGrad as CFArray, locations: [0, 0.6, 1])!
        g.drawRadialGradient(grad, startCenter: CGPoint(x: cx, y: cy), startRadius: 0, endCenter: CGPoint(x: cx, y: cy), endRadius: 470, options: [.drawsAfterEndLocation])
        // waves at the bottom and top
        for k in 0..<5 {
            let wy = r.maxY - 8 - CGFloat(k) * 15
            for sgn in [CGFloat(1)] {
                var wx = r.minX - 20 + CGFloat(k % 2) * 17
                while wx < r.maxX + 20 {
                    stroked(k % 2 == 0 ? teal : cream, 3) { g.addArc(center: CGPoint(x: wx, y: wy + 6 * sgn), radius: 17, startAngle: .pi, endAngle: 0, clockwise: false); g.strokePath() }
                    wx += 34
                }
            }
        }
        // medallion: peony with shou
        circle(cx, cy - 8, 196, ink, nil); circle(cx, cy - 8, 190, gold, nil); circle(cx, cy - 8, 184, red, ink, 1.4)
        for k in 0..<16 { at(cx, cy - 8, CGFloat(k) * .pi / 8) { at(0, -160) { fillStroke(drop(34, 8), k % 2 == 0 ? gold : cream, ink, 0.8) } } }
        rosette(cx, cy - 8, 140, cream, rose, gold, n: 14)
        rosette(cx, cy - 8, 96, rose, cream, red3, n: 12)
        circle(cx, cy - 8, 52, red2, gold, 3)
        drawText("寿", cx, cy - 8, 70, gold, font: "Songti SC")
        // clouds and bats
        let cloudSpots: [(CGFloat, CGFloat, CGFloat)] = [(-330, -110, -0.4), (330, -110, 0.4), (-330, 110, 0.5), (330, 110, -0.5), (-250, -205, 0.1), (250, -205, -0.1)]
        for (dx, dy, a) in cloudSpots { ruyi(cx + dx, cy + dy, 74, a, teal, cream) }
        for sgn in [CGFloat(-1), 1] { at(cx + sgn * 330, cy) { fillStroke(starP(8, 22, 11), gold, ink, 1); circle(0, 0, 5, red, ink, 0.8) } }
        g.restoreGState()
    }

    // MARK: Hagia Sophia: gold mosaic, 40-rib dome, calligraphic roundels, porphyry & green marble

    func ayasofya() {
        let golds: [CGColor] = [hex(0xD9A93A), hex(0xC9972E), hex(0xE3B94B), hex(0xB98A26), hex(0xD1A035), hex(0xEAC561)]
        func mosaic(_ r: CGRect) {
            let t: CGFloat = 7
            var y = r.minY
            while y < r.maxY {
                var x = r.minX
                while x < r.maxX {
                    g.setFillColor(golds[Int(rng.next() * Double(golds.count))])
                    g.fill(CGRect(x: x, y: y, width: t - 0.8, height: t - 0.8))
                    x += t
                }
                y += t
            }
        }
        g.setFillColor(ink); g.fill(CGRect(x: X0, y: 0, width: X1 - X0, height: DH))
        rectInset(8, gold); rectInset(11, ink); rectInset(13, red); rectInset(33, ink); rectInset(35, gold)
        rectInset(37, navy); rectInset(139, ink); rectInset(141, gold); rectInset(145, red2); rectInset(161, ink); rectInset(163, gold); rectInset(167, ink)
        // marble roundels in the green border
        sidesLoop(120, step: 62) { x, y, ang, i in
            at(x, y, ang) {
                circle(0, 0, 30, ink, nil); circle(0, 0, 27, gold, nil); circle(0, 0, 22, i % 2 == 0 ? red : navy2, ink, 1)
                fillStroke(starP(8, 15, 8, rot: .pi / 8), cream, ink, 0.8)
            }
            at(x, y, ang) {
                for sgn in [CGFloat(-1), 1] { at(sgn * 31, 0) { fillStroke(diamondP(7, 12), gold, ink, 0.8) } }
            }
        }
        for (px, py) in cornerPoints { fillStroke(CGPath(rect: CGRect(x: px - 48, y: py - 48, width: 96, height: 96), transform: nil), ink, nil)
            at(px, py) { fillStroke(starP(8, 44, 24, rot: .pi / 8), gold, ink, 1.5); fillStroke(starP(8, 24, 12), red, ink, 1); circle(0, 0, 5, cream, ink, 0.8) } }

        let fx0 = X0 + 169, fx1 = X1 - 169, fy0: CGFloat = 169, fy1 = DH - 169
        let field = CGRect(x: fx0, y: fy0, width: fx1 - fx0, height: fy1 - fy0)
        g.saveGState(); g.clip(to: field)
        mosaic(field)
        // central dome
        let dc = CGPoint(x: cx, y: cy)
        circle(dc.x, dc.y, 196, ink, nil); circle(dc.x, dc.y, 190, red, nil); circle(dc.x, dc.y, 178, gold, ink, 1.4)
        circle(dc.x, dc.y, 170, navy, ink, 1.2)
        for k in 0..<40 {
            at(dc.x, dc.y, CGFloat(k) * .pi / 20) {
                at(0, -120) {
                    let w: CGFloat = 8
                    let arch = CGMutablePath()
                    arch.move(to: CGPoint(x: -w, y: 40)); arch.addLine(to: CGPoint(x: -w, y: 8))
                    arch.addQuadCurve(to: CGPoint(x: w, y: 8), control: CGPoint(x: 0, y: -14)); arch.addLine(to: CGPoint(x: w, y: 40)); arch.closeSubpath()
                    fillStroke(arch, k % 2 == 0 ? gold : cream, ink, 0.8)
                }
            }
        }
        circle(dc.x, dc.y, 104, ink, nil)
        for k in 0..<40 { at(dc.x, dc.y, CGFloat(k) * .pi / 20) { g.setStrokeColor(gold); g.setLineWidth(1); g.move(to: CGPoint(x: 0, y: -50)); g.addLine(to: CGPoint(x: 0, y: -100)); g.strokePath() } }
        circle(dc.x, dc.y, 98, hex(0xE3B94B), ink, 1.4)
        at(dc.x, dc.y) {
            fillStroke(starP(16, 92, 62), red, ink, 1.2)
            fillStroke(starP(8, 60, 36, rot: .pi / 8), green, ink, 1.2)
            fillStroke(starP(8, 36, 18), cream, ink, 1)
            circle(0, 0, 11, red, ink, 1)
        }
        // calligraphic roundels (levha)
        let words = ["الله", "محمد", "عثمان", "علي"]
        let spots: [(CGFloat, CGFloat)] = [(fx0 + 112, fy0 + 112), (fx1 - 112, fy0 + 112), (fx0 + 112, fy1 - 112), (fx1 - 112, fy1 - 112)]
        for (i, (px, py)) in spots.enumerated() {
            circle(px, py, 92, ink, nil); circle(px, py, 88, gold, ink, 1.4); circle(px, py, 80, navy, ink, 1.2); circle(px, py, 72, nil, gold, 1.6)
            drawText(words[i], px, py, 58, gold, font: "Geeza Pro Bold")
            for k in 0..<12 { at(px, py, CGFloat(k) * .pi / 6) { at(0, -84) { fillStroke(diamondP(3.5, 5.5), red, nil) } } }
        }
        for sgn in [CGFloat(-1), 1] { at(cx + sgn * 346, cy) { fillStroke(starP(8, 42, 22, rot: .pi / 8), red, ink, 1.4); fillStroke(starP(8, 22, 11), cream, ink, 1) } }
        g.restoreGState()
    }

    // MARK: Iznik tiles (Sultanahmet): cobalt, turquoise and coral tulips, carnations and saz leaves on white

    func carnation(_ x: CGFloat, _ y: CGFloat, _ r: CGFloat, _ c1: CGColor, _ c2: CGColor) {
        at(x, y) {
            fillStroke(starP(12, r, r * 0.62), c1, ink, 1)
            fillStroke(starP(10, r * 0.62, r * 0.4, rot: .pi / 10), c2, ink, 0.8)
            circle(0, 0, r * 0.14, c1, ink, 0.6)
        }
    }

    func iznik() {
        g.setFillColor(navy); g.fill(CGRect(x: X0, y: 0, width: X1 - X0, height: DH))
        rectInset(8, ivory); rectInset(11, ink); rectInset(13, red); rectInset(33, ivory); rectInset(35, ink)
        rectInset(37, navy); rectInset(139, ivory); rectInset(141, ink); rectInset(143, teal)
        rectInset(163, ink); rectInset(164, ivory); rectInset(168, ink); rectInset(169, ivory)
        // tulip / carnation chain on cobalt
        sidesLoop(120, step: 58) { x, y, ang, i in
            at(x, y, ang) { at(0, 24) { tulip(0, 0, 52, 0, i % 2 == 0 ? red : ivory, i % 2 == 0 ? ivory : red) } }
            if i % 2 == 0 {
                at(x, y, ang) { leaf(0, 4, 18, 5, 1.0, teal); leaf(0, 4, 18, 5, -1.0, teal) }
            }
        }
        for (px, py) in cornerPoints {
            circle(px, py, 42, ink, nil); circle(px, py, 39, ivory, nil)
            carnation(px, py, 36, red, gold); circle(px, py, 8, navy, ink, 1)
        }
        let fx0 = X0 + 169, fx1 = X1 - 169, fy0: CGFloat = 169, fy1 = DH - 169
        let field = CGRect(x: fx0, y: fy0, width: fx1 - fx0, height: fy1 - fy0)
        g.saveGState(); g.clip(to: field)
        g.setFillColor(ivory); g.fill(field)
        // faint tile grid
        g.setStrokeColor(hex(0x2A63BD, 0.18)); g.setLineWidth(1.2)
        var tx = fx0; while tx < fx1 { g.move(to: CGPoint(x: tx, y: fy0)); g.addLine(to: CGPoint(x: tx, y: fy1)); tx += 87 }
        var ty = fy0; while ty < fy1 { g.move(to: CGPoint(x: fx0, y: ty)); g.addLine(to: CGPoint(x: fx1, y: ty)); ty += 87 }
        g.strokePath()
        // sprays in the four corners: saz leaves, tulip, carnation
        for sx in [CGFloat(-1), 1] {
            for sy in [CGFloat(-1), 1] {
                let ox = cx + sx * 262, oy = cy + sy * 128
                let dir = atan2(sx * 0.8, -sy * 0.75)
                for k in [CGFloat(-0.65), 0.65, 0] {
                    at(ox, oy, dir + k) { fillStroke(lance(k == 0 ? 92 : 112, k == 0 ? 14 : 17), k == 0 ? navy2 : teal, ink, 1.4)
                        g.setStrokeColor(ink); g.setLineWidth(1); g.move(to: CGPoint(x: 0, y: -10)); g.addLine(to: CGPoint(x: 0, y: -(k == 0 ? 80 : 98))); g.strokePath() }
                }
                let tx2 = ox + sin(dir) * 70, ty2 = oy - cos(dir) * 70
                at(tx2, ty2, dir) { tulip(0, 0, 76, 0, red, ivory) }
                carnation(ox + sin(dir - 1.0) * 62, oy - cos(dir - 1.0) * 62, 22, red3, gold)
                carnation(ox + sin(dir + 1.0) * 62, oy - cos(dir + 1.0) * 62, 22, navy2, ivory)
            }
        }
        // central medallion
        at(cx, cy) {
            fillStroke(lobedP(10, 178, 0.06), ink, nil)
            fillStroke(lobedP(10, 172, 0.06), teal, ink, 1.6)
            fillStroke(lobedP(10, 148, 0.05), ivory, ink, 1.4)
            for k in 0..<10 { at(0, 0, CGFloat(k) * .pi / 5) { at(0, -118) { fillStroke(drop(40, 11), navy2, ink, 1) } } }
        }
        rosette(cx, cy, 96, red, ivory, navy, n: 12)
        rosette(cx, cy, 58, navy2, ivory, gold, n: 8)
        for k in 0..<4 { at(cx, cy, CGFloat(k) * .pi / 2 + .pi / 4) { at(0, -122) { tulip(0, 0, 44, 0, k % 2 == 0 ? red : navy2, ivory) } } }
        g.restoreGState()
    }

    // MARK: Seljuk (Konya): star-and-cross tile tessellation, turquoise / cobalt / black, gold line work

    func selcuklu() {
        g.setFillColor(navy); g.fill(CGRect(x: X0, y: 0, width: X1 - X0, height: DH))
        rectInset(8, gold); rectInset(11, ink); rectInset(13, teal); rectInset(33, ink); rectInset(35, gold)
        rectInset(37, ink); rectInset(139, gold); rectInset(141, ink); rectInset(145, teal); rectInset(161, ink); rectInset(163, gold); rectInset(167, ink)
        // interlaced circle strapwork in the border
        let band = CGRect(x: X0 + 40, y: 40, width: X1 - X0 - 80, height: DH - 80)
        g.saveGState(); g.clip(to: band)
        sidesLoop(60, step: 36, centre: 88) { x, y, ang, i in
            for (r, c, lw) in [(CGFloat(36), teal, CGFloat(5)), (CGFloat(36), gold, CGFloat(1.4))] {
                stroked(c, lw) { g.strokeEllipse(in: CGRect(x: x - r, y: y - r, width: 2 * r, height: 2 * r)) }
            }
            at(x, y, ang) { fillStroke(starP(8, 9, 4.5, rot: .pi / 8), i % 2 == 0 ? gold : cream, ink, 0.6) }
        }
        g.restoreGState()
        g.setFillColor(ink)
        for (px, py) in cornerPoints { fillStroke(CGPath(rect: CGRect(x: px - 52, y: py - 52, width: 104, height: 104), transform: nil), ink, nil)
            at(px, py) { fillStroke(starP(8, 48, 30, rot: .pi / 8), teal, gold, 1.6); fillStroke(starP(8, 28, 14), navy2, ink, 1); circle(0, 0, 6, gold, ink, 1) } }

        let fx0 = X0 + 169, fx1 = X1 - 169, fy0: CGFloat = 169, fy1 = DH - 169
        let field = CGRect(x: fx0, y: fy0, width: fx1 - fx0, height: fy1 - fy0)
        g.saveGState(); g.clip(to: field)
        g.setFillColor(navy); g.fill(field)
        let S: CGFloat = 86
        for j in -8...8 {
            for i in -12...12 {
                let px = cx + CGFloat(i) * S, py = cy + CGFloat(j) * S
                // 8-point star on the lattice
                at(px, py) {
                    fillStroke(starP(8, 44, 24, rot: .pi / 8), teal, gold, 1.4)
                    fillStroke(starP(8, 27, 14), navy2, ink, 1)
                    circle(0, 0, 4.5, gold, ink, 0.7)
                }
                // crosses between the stars
                at(px + S / 2, py + S / 2) {
                    for k in 0..<4 { at(0, 0, CGFloat(k) * .pi / 2) { at(0, -14) { fillStroke(diamondP(8, 16), (i + j) % 2 == 0 ? cream : gold, ink, 0.8) } } }
                    circle(0, 0, 4, red3, ink, 0.6)
                }
                // lozenges on the edges
                at(px + S / 2, py) { fillStroke(diamondP(10, 10), ink, gold, 1) }
                at(px, py + S / 2) { fillStroke(diamondP(10, 10), ink, gold, 1) }
            }
        }
        // central medallion
        at(cx, cy) {
            fillStroke(starP(16, 210, 168, rot: .pi / 16), ink, nil)
            fillStroke(starP(16, 202, 160, rot: .pi / 16), gold, ink, 1.6)
            fillStroke(starP(16, 186, 148, rot: .pi / 16), navy, ink, 1.2)
            fillStroke(starP(8, 150, 96, rot: .pi / 8), teal, gold, 1.6)
            fillStroke(starP(8, 104, 62), navy2, ink, 1.4)
            fillStroke(starP(8, 62, 30, rot: .pi / 8), gold, ink, 1.2)
            circle(0, 0, 20, red3, ink, 1.4); circle(0, 0, 8, cream, nil)
        }
        g.restoreGState()
    }

    // MARK: the user's own picture, woven into a rug (coarse thread grid, few colours, bordered)

    func custom() {
        g.setFillColor(navy); g.fill(CGRect(x: X0, y: 0, width: X1 - X0, height: DH))
        rectInset(8, cream); rectInset(11, ink); rectInset(13, red); rectInset(33, cream); rectInset(36, ink)
        rectInset(37, navy); rectInset(139, ink); rectInset(141, cream); rectInset(147, ink); rectInset(149, red2); rectInset(153, ink); rectInset(155, cream); rectInset(157, ink)
        // chain of diamonds in the main border
        sidesLoop(112, step: 34) { x, y, ang, i in
            at(x, y, ang) {
                fillStroke(diamondP(12, 17), i % 2 == 0 ? cream : red3, ink, 1)
                fillStroke(diamondP(5, 8), i % 2 == 0 ? red : navy2, nil)
            }
        }
        for (px, py) in cornerPoints {
            at(px, py) { fillStroke(starP(8, 44, 24, rot: .pi / 8), cream, ink, 1.6); fillStroke(starP(8, 24, 12), red, ink, 1.2); circle(0, 0, 5, gold, ink, 1) }
        }
        // picture field
        let field = CGRect(x: X0 + 159, y: 159, width: X1 - X0 - 318, height: DH - 318)
        g.saveGState(); g.clip(to: field)
        let cell: CGFloat = 5.5
        let cols = Int(field.width / cell), rows = Int(field.height / cell)
        var px = [UInt8](repeating: 0, count: cols * rows * 4)
        if let img = RugTexture.customImage {
            let bm = CGContext(data: &px, width: cols, height: rows, bitsPerComponent: 8, bytesPerRow: cols * 4,
                               space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
            bm.interpolationQuality = .high
            let sc = max(CGFloat(cols) / CGFloat(img.width), CGFloat(rows) / CGFloat(img.height))   // aspect fill
            let w = CGFloat(img.width) * sc, h = CGFloat(img.height) * sc
            bm.draw(img, in: CGRect(x: (CGFloat(cols) - w) / 2, y: (CGFloat(rows) - h) / 2, width: w, height: h))
        } else {
            for r in 0..<rows { for c in 0..<cols {            // no picture yet: a soft placeholder
                let i = (r * cols + c) * 4
                px[i] = UInt8(60 + 150 * c / cols); px[i + 1] = UInt8(80 + 80 * r / rows); px[i + 2] = 150; px[i + 3] = 255
            } }
        }
        let levels: Double = 6          // few thread colours per channel: looks woven, not printed
        g.setFillColor(ink); g.fill(field)
        for r in 0..<rows {
            for c in 0..<cols {
                let i = (r * cols + c) * 4
                var v = SIMD3(Double(px[i]), Double(px[i + 1]), Double(px[i + 2])) / 255
                let l = 0.3 * v.x + 0.59 * v.y + 0.11 * v.z
                v = SIMD3(repeating: l) + (v - SIMD3(repeating: l)) * 1.18          // a little more colour, like dyed wool
                v = simd_clamp(v, SIMD3(repeating: 0), SIMD3(repeating: 1))
                v = SIMD3((v.x * (levels - 1)).rounded(), (v.y * (levels - 1)).rounded(), (v.z * (levels - 1)).rounded()) / (levels - 1)
                g.setFillColor(CGColor(red: v.x, green: v.y, blue: v.z, alpha: 1))
                g.fill(CGRect(x: field.minX + CGFloat(c) * cell, y: field.minY + CGFloat(r) * cell, width: cell - 0.7, height: cell - 0.7))
            }
        }
        g.restoreGState()
    }

    // MARK: finishing

    func wear() {
        for _ in 0..<30 {
            let bx = X0 + CGFloat(rng.next()) * (X1 - X0), by = CGFloat(rng.next()) * DH
            let br = 50 + CGFloat(rng.next()) * 150
            let dark = rng.next() < 0.55
            let col = dark ? CGColor(red: 0.1, green: 0.03, blue: 0.0, alpha: 0.10)
                           : CGColor(red: 1, green: 0.85, blue: 0.6, alpha: 0.07)
            let gr = CGGradient(colorsSpace: cs, colors: [col, col.copy(alpha: 0)!] as CFArray, locations: [0, 1])!
            g.saveGState()
            g.clip(to: CGRect(x: X0, y: 0, width: X1 - X0, height: DH))
            g.drawRadialGradient(gr, startCenter: CGPoint(x: bx, y: by), startRadius: 0,
                                 endCenter: CGPoint(x: bx, y: by), endRadius: br, options: [])
            g.restoreGState()
        }
    }

    func weave() {
        guard let data = g.data?.assumingMemoryBound(to: UInt8.self) else { return }
        let W = RugTexture.W, H = RugTexture.H
        let s = RugTexture.scale
        let x0 = Int(X0 * s), x1 = Int(X1 * s)
        for y in 0..<H {
            for x in x0..<x1 {
                let o = (y * W + x) * 4
                var n = (rng.next() - 0.5) * 18
                n += (y & 1 == 0) ? 4 : -4
                n += (((x >> 1) + (y >> 1)) & 1 == 0) ? 3 : -3
                let d = Int(n)
                data[o] = UInt8(max(0, min(255, Int(data[o]) + d)))
                data[o + 1] = UInt8(max(0, min(255, Int(data[o + 1]) + d)))
                data[o + 2] = UInt8(max(0, min(255, Int(data[o + 2]) + d)))
            }
        }
    }

    func fringe() {
        var y: CGFloat = 3
        while y < DH {
            for side in [CGFloat(-1), 1] {
                let base = side < 0 ? X0 + 3 : X1 - 3
                let len = 36 + CGFloat(rng.next()) * 24
                let sway = (CGFloat(rng.next()) - 0.5) * 14
                let l = 0.86 + CGFloat(rng.next()) * 0.14
                g.setStrokeColor(CGColor(red: 0.93 * l, green: 0.86 * l, blue: 0.71 * l, alpha: 1))
                g.setLineWidth(3.1)
                g.setLineCap(.round)
                g.beginPath()
                g.move(to: CGPoint(x: base, y: y))
                g.addCurve(to: CGPoint(x: base + side * len, y: y + sway),
                           control1: CGPoint(x: base + side * len * 0.35, y: y + sway * 0.1),
                           control2: CGPoint(x: base + side * len * 0.7, y: y + sway * 0.7))
                g.strokePath()
            }
            y += 5.6
        }
    }
}
