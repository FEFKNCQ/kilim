import AppKit

/// Developer-facing command-line modes. They run headless, print a report (or write PNGs) and exit.
///
///     Kilim --selftest [dir]    render physics / lighting / roll scenarios to PNG files
///     Kilim --texture           render every rug pattern to /tmp/kilim-tex-<theme>.png
///     Kilim --custom <image>    weave a custom rug from a picture (writes /tmp/kilim-tex-custom.png)
///     Kilim --langtest          verify that every language is complete
///     Kilim --audiotest         numerically sanity-check the procedural sound synth
enum Diagnostics {
    /// Runs the requested diagnostic mode, if any, and terminates the process afterwards.
    static func runIfRequested(_ args: [String] = CommandLine.arguments) {
        if args.contains("--audiotest") { audioTest(); exit(0) }
        if args.contains("--langtest") { languageTest(); exit(0) }
        if let i = args.firstIndex(of: "--custom"), i + 1 < args.count { customTest(path: args[i + 1]); exit(0) }
        if args.contains("--texture") { textureTest(); exit(0) }
        if let i = args.firstIndex(of: "--icon"), i + 1 < args.count { iconTest(theme: args[i + 1], out: args.count > i + 2 ? args[i + 2] : "/tmp/kilim-icon.png"); exit(0) }
        if args.contains("--selftest") {
            let outDir = args.last { !$0.hasPrefix("-") && $0 != args[0] } ?? "/tmp/kilim-test"
            runSelfTest(outDir: outDir)
            exit(0)
        }
    }

    // MARK: Audio

    private static func audioTest() {
        let syn = SoundSynth()
        func run(_ label: String, slide: Float, thump: Float, secs: Float) {
            syn.params[0] = slide; if thump > 0 { syn.params[1] = thump }
            let n = Int(44100 * secs)
            var buf = [Float](repeating: 0, count: n)
            buf.withUnsafeMutableBufferPointer { syn.render(n, $0.baseAddress!) }
            let peak = buf.map { abs($0) }.max() ?? 0
            let rms = (buf.map { $0 * $0 }.reduce(0, +) / Float(n)).squareRoot()
            let nan = buf.contains { !$0.isFinite }
            if label.hasSuffix("slide") {   // loudness wobble in 10 ms windows: ticking would show up as a large spread
                let w = 441; var rmsList: [Float] = []
                var k = n / 4
                while k + w < n { rmsList.append((buf[k..<k + w].map { $0 * $0 }.reduce(0, +) / Float(w)).squareRoot()); k += w }
                let m = rmsList.reduce(0, +) / Float(rmsList.count)
                let sd = (rmsList.map { ($0 - m) * ($0 - m) }.reduce(0, +) / Float(rmsList.count)).squareRoot()
                print("   loudness wobble (std/mean): \(String(format: "%.2f", sd / max(m, 1e-6)))")
            }
            print("\(label): peak=\(String(format: "%.3f", peak)) rms=\(String(format: "%.4f", rms)) nan=\(nan)")
        }
        run("silence", slide: 0, thump: 0, secs: 0.5)
        run("slow slide", slide: 0.2, thump: 0, secs: 1)
        run("fast slide", slide: 1, thump: 0, secs: 1)
        run("soft thump", slide: 0, thump: 0.1, secs: 0.6)
        run("hard thump", slide: 0, thump: 0.9, secs: 0.6)
    }

    // MARK: Localization

    /// Exits with a non-zero status when a language is missing strings, so scripts can catch it.
    private static func languageTest() {
        let bad = L10n.validate()
        print(bad.isEmpty ? "all \(Lang.allCases.count) languages complete (\(Str.allCases.count) strings each)" : "INCOMPLETE: \(bad)")
        for l in Lang.allCases { L10n.current = l; print(l.rawValue, "|", L10n.t(.tossRug), "|", L10n.theme(.turk)) }
        UserDefaults.standard.removeObject(forKey: "language")
        if !bad.isEmpty { exit(1) }
    }

    // MARK: Textures

    private static func customTest(path: String) {
        let ok = RugTexture.setCustom(from: URL(fileURLWithPath: path))
        let img = RugTexture.make(theme: .custom)
        try? NSBitmapImageRep(cgImage: img).representation(using: .png, properties: [:])?.write(to: URL(fileURLWithPath: "/tmp/kilim-tex-custom.png"))
        print("custom: loaded=\(ok)")
    }

    /// Renders the 1024 px master app icon: the centre of a rug on a rounded macOS-style tile.
    /// `Scripts/make-icon.sh` turns it into `Resources/AppIcon.icns`.
    private static func iconTest(theme: String, out: String) {
        let t = RugTheme(rawValue: theme) ?? .kashan
        let tex = RugTexture.make(theme: t)
        let S = 1024, tile: CGFloat = 824, inset: CGFloat = 100
        let cs = CGColorSpaceCreateDeviceRGB()
        guard let ctx = CGContext(data: nil, width: S, height: S, bitsPerComponent: 8, bytesPerRow: 0, space: cs,
                                  bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else { return }
        let rect = CGRect(x: inset, y: inset, width: tile, height: tile)
        let path = CGPath(roundedRect: rect, cornerWidth: 185, cornerHeight: 185, transform: nil)
        // soft drop shadow
        ctx.saveGState()
        ctx.setShadow(offset: CGSize(width: 0, height: -14), blur: 28, color: CGColor(gray: 0, alpha: 0.38))
        ctx.addPath(path); ctx.setFillColor(CGColor(gray: 0.1, alpha: 1)); ctx.fillPath()
        ctx.restoreGState()
        // rug, centre square crop
        ctx.saveGState()
        ctx.addPath(path); ctx.clip()
        let side = CGFloat(min(tex.width, tex.height))
        let crop = CGRect(x: (CGFloat(tex.width) - side) / 2, y: (CGFloat(tex.height) - side) / 2, width: side, height: side)
        if let sq = tex.cropping(to: crop) { ctx.draw(sq, in: rect) }
        // gentle top-left light, bottom-right shade
        let grad = CGGradient(colorsSpace: cs, colors: [CGColor(gray: 1, alpha: 0.28), CGColor(gray: 1, alpha: 0),
                                                        CGColor(gray: 0, alpha: 0.30)] as CFArray, locations: [0, 0.5, 1])!
        ctx.drawLinearGradient(grad, start: CGPoint(x: rect.minX, y: rect.maxY), end: CGPoint(x: rect.maxX, y: rect.minY), options: [])
        ctx.restoreGState()
        // hairline edge
        ctx.addPath(path); ctx.setStrokeColor(CGColor(gray: 0, alpha: 0.35)); ctx.setLineWidth(3); ctx.strokePath()
        if let img = ctx.makeImage() {
            try? NSBitmapImageRep(cgImage: img).representation(using: .png, properties: [:])?.write(to: URL(fileURLWithPath: out))
            print("icon: \(out)")
        }
    }

    private static func textureTest() {
        for t in RugTheme.allCases {
            let t0 = CFAbsoluteTimeGetCurrent()
            let img = RugTexture.make(theme: t)
            let rep = NSBitmapImageRep(cgImage: img)
            try? rep.representation(using: .png, properties: [:])?.write(to: URL(fileURLWithPath: "/tmp/kilim-tex-\(t.rawValue).png"))
            print("\(t.rawValue): \(Int((CFAbsoluteTimeGetCurrent() - t0) * 1000)) ms")
        }
    }
}
