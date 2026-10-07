import AppKit
import Metal

/// Headless visual test: fakes a desktop, drops the rug, drags it over the icons and dumps PNGs.
func runSelfTest(outDir: String) {
    try? FileManager.default.createDirectory(atPath: outDir, withIntermediateDirectories: true)
    let W = 1440, H = 900
    let device = MTLCreateSystemDefaultDevice()!
    let renderer = Renderer(device: device)
    renderer.resize(CGSize(width: W, height: H))
    let cloth = Cloth()
    cloth.viewW = Float(W); cloth.viewH = Float(H)

    // fake icon grid on the right, like a messy Finder desktop
    var rng = RNG(5)
    var icons: [SIMD2<Float>] = []
    for i in 0..<14 {
        icons.append(SIMD2(1150 + Float(rng.next()) * 150, 150 + Float(i) * 38 + Float(rng.next()) * 40))
    }
    for _ in 0..<10 { icons.append(SIMD2(980 + Float(rng.next()) * 120, 300 + Float(rng.next()) * 220)) }
    cloth.bumps = icons

    if CommandLine.arguments.contains("--bench") {
        // realistic desktop: ~75 icons, 2560x1440 target
        var r2 = RNG(9)
        cloth.bumps = (0..<75).map { _ in SIMD2(Float(r2.next()) * 2560, Float(r2.next()) * 1440) }
        cloth.viewW = 2560; cloth.viewH = 1440
        cloth.reset(centerX: 1000, centerY: 700, width: 760, drop: 130, angle: -0.1)
        do {   // how often does the thump logic fire while the rug drops, rests, is dragged over bumps?
            var det = ThumpDetector()
            var fires: [(Double, Float)] = []
            func feed(_ k: Int) {
                if let a = det.feed(cloth.impactSum, now: Double(k) / 60, calm: cloth.settled > 20) { fires.append((Double(k) / 60, a)) }
            }
            for k in 0..<1200 { cloth.step(); feed(k) }
            print("drop + rest (20 s): thumps at", fires.map { String(format: "%.1fs amp %.2f", $0.0, $0.1) })
            fires.removeAll()
            // long idle
            for k in 1200..<3600 { cloth.step(); feed(k) }
            print("idle (40 s): \(fires.count) thumps")
            // drag across the bumps and let go
            fires.removeAll()
            let sp = SIMD2<Float>(cloth.SX[Cloth.NX * 15 + 22], cloth.SY[Cloth.NX * 15 + 22])
            if cloth.beginGrab(at: sp) {
                for k in 0..<240 {
                    cloth.moveGrab(to: sp + SIMD2(Float(k) * 3, Float(sinf(Float(k) / 20)) * 80))
                    cloth.step(); feed(3600 + k)
                }
                cloth.endGrab()
                var mx: Float = 0; for k in 0..<600 { cloth.step(); feed(3840 + k); mx = max(mx, cloth.impactSum) }; print("max impactSum after release: \(mx)")
            }
            print("drag over bumps + release: thumps at", fires.map { String(format: "%.1fs amp %.2f", $0.0 - 60, $0.1) })
            cloth.reset(centerX: 1000, centerY: 700, width: 760, drop: 130, angle: -0.1)
        }
        for chunk in 0..<10 {
            for _ in 0..<60 { cloth.step() }
            print("  settle t+\((chunk + 1) * 60): maxSpeed=\(cloth.maxSpeed) settled=\(cloth.settled)")
        }
        var t0 = CFAbsoluteTimeGetCurrent()
        for _ in 0..<300 { cloth.step() }
        print(String(format: "sim step: %.2f ms (75 bumps)", (CFAbsoluteTimeGetCurrent() - t0) / 300 * 1000))
        cloth.bumps = []
        t0 = CFAbsoluteTimeGetCurrent()
        for _ in 0..<300 { cloth.step() }
        print(String(format: "sim step: %.2f ms (no bumps)", (CFAbsoluteTimeGetCurrent() - t0) / 300 * 1000))
        do {
            cloth.iterations = 0
            var t = CFAbsoluteTimeGetCurrent()
            for _ in 0..<300 { cloth.step() }
            print(String(format: "  without solver: %.2f ms", (CFAbsoluteTimeGetCurrent() - t) / 300 * 1000))
            cloth.iterations = 14; cloth.selfK = 0; cloth.selfT = 0.001
            t = CFAbsoluteTimeGetCurrent()
            for _ in 0..<300 { cloth.step() }
            print(String(format: "  without selfcollide: %.2f ms", (CFAbsoluteTimeGetCurrent() - t) / 300 * 1000))
            cloth.selfK = 0.5; cloth.selfT = 8
        }
        renderer.resize(CGSize(width: 2560, height: 1440))
        _ = renderer.renderOffscreen(cloth: cloth, width: 2560, height: 1440)
        t0 = CFAbsoluteTimeGetCurrent()
        for _ in 0..<20 { _ = renderer.renderOffscreen(cloth: cloth, width: 2560, height: 1440) }
        print(String(format: "render+readback 2560x1440: %.2f ms", (CFAbsoluteTimeGetCurrent() - t0) / 20 * 1000))
        let t1 = CFAbsoluteTimeGetCurrent()
        for _ in 0..<200 { _ = cloth.hitNode(SIMD2(1000, 700)) }
        print(String(format: "hitNode: %.3f ms", (CFAbsoluteTimeGetCurrent() - t1) / 200 * 1000))
        exit(0)
    }

    func background() -> CGContext {
        let ctx = CGContext(data: nil, width: W, height: H, bitsPerComponent: 8, bytesPerRow: W * 4,
                            space: CGColorSpaceCreateDeviceRGB(),
                            bitmapInfo: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue)!
        ctx.translateBy(x: 0, y: CGFloat(H)); ctx.scaleBy(x: 1, y: -1)
        let g = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                           colors: [CGColor(red: 0.16, green: 0.30, blue: 0.55, alpha: 1),
                                    CGColor(red: 0.45, green: 0.30, blue: 0.62, alpha: 1)] as CFArray, locations: [0, 1])!
        ctx.drawLinearGradient(g, start: .zero, end: CGPoint(x: W, y: H), options: [])
        for p in icons {
            ctx.setFillColor(CGColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1))
            ctx.fill(CGRect(x: CGFloat(p.x) - 22, y: CGFloat(p.y) - 28, width: 44, height: 56))
            ctx.setFillColor(CGColor(red: 0.1, green: 0.4, blue: 0.9, alpha: 1))
            ctx.fill(CGRect(x: CGFloat(p.x) - 28, y: CGFloat(p.y) + 30, width: 56, height: 12))
        }
        return ctx
    }

    func snapshot(_ name: String) {
        let bytes = renderer.renderOffscreen(cloth: cloth, width: W, height: H)
        let bg = background()
        let data = Data(bytes) as CFData
        let provider = CGDataProvider(data: data)!
        let rug = CGImage(width: W, height: H, bitsPerComponent: 8, bitsPerPixel: 32, bytesPerRow: W * 4,
                          space: CGColorSpaceCreateDeviceRGB(),
                          bitmapInfo: CGBitmapInfo(rawValue: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue),
                          provider: provider, decode: nil, shouldInterpolate: true, intent: .defaultIntent)!
        bg.saveGState()
        bg.translateBy(x: 0, y: CGFloat(H)); bg.scaleBy(x: 1, y: -1)
        bg.draw(rug, in: CGRect(x: 0, y: 0, width: W, height: H))
        bg.restoreGState()
        let out = bg.makeImage()!
        let rep = NSBitmapImageRep(cgImage: out)
        try? rep.representation(using: .png, properties: [:])?.write(to: URL(fileURLWithPath: "\(outDir)/\(name).png"))
        print("wrote \(name).png  (settled=\(cloth.settled) maxSpeed=\(cloth.maxSpeed))")
    }

    func run(_ n: Int) { for _ in 0..<n { cloth.step() } }

    cloth.reset(centerX: 520, centerY: 460, width: 560, drop: 130, angle: -0.12)
    if CommandLine.arguments.contains("--debug") {
        func bbox(_ l: String) {
            var mnx: Float = 1e9, mxx: Float = -1e9, mny: Float = 1e9, mxy: Float = -1e9, mnz: Float = 1e9, mxz: Float = -1e9
            for i in 0..<cloth.N { mnx = min(mnx, cloth.X[i]); mxx = max(mxx, cloth.X[i]); mny = min(mny, cloth.Y[i]); mxy = max(mxy, cloth.Y[i]); mnz = min(mnz, cloth.Z[i]); mxz = max(mxz, cloth.Z[i]) }
            print(l, "x", mnx, mxx, "y", mny, mxy, "z", mnz, mxz, "cN", cloth.cN)
        }
        bbox("init")
        for k in 0..<6 { cloth.step(); bbox("step\(k)") }
        exit(0)
    }
    run(5);   snapshot("0_falling")
    run(240); snapshot("1_landed")

    // grab the right edge and drag it over the icons
    let tgt = SIMD2<Float>(1100, 470)
    var p = SIMD2<Float>(760, 470)
    if cloth.beginGrab(at: p) {
        print("grabbed")
        for k in 0..<120 {
            let t = Float(k) / 119
            p = SIMD2(760 + (tgt.x - 760) * t, 470 + 40 * sinf(t * 3))
            cloth.moveGrab(to: p)
            cloth.step()
        }
        snapshot("2_dragged")
        cloth.endGrab()
        for chunk in 0..<8 {
            run(60)
            var cx: Float = 0, cz: Float = 0, mz: Float = 0
            for i in 0..<cloth.N { cx += cloth.X[i]; cz += cloth.Z[i]; mz = max(mz, cloth.Z[i]) }
            print("  t+\((chunk+1)*60): maxSpeed=\(cloth.maxSpeed) meanX=\(cx/Float(cloth.N)) meanZ=\(cz/Float(cloth.N)) maxZ=\(mz) pins=\(cloth.pins.count)")
        }
        snapshot("3_covering_icons")
        for (name, mode) in [("day", LightMode.day), ("evening", .evening), ("night", .night)] {
            renderer.env = Lighting.env(mode: mode); snapshot("5_light_\(name)")
        }
        renderer.env = Lighting.env(mode: .day); renderer.alpha = 0.26; snapshot("6_peek"); renderer.alpha = 1
        renderer.env = LightEnv.neutral
    } else { print("grab FAILED") }

    // fold it back: grab near the right edge and bring it over the rug
    cloth.reset(centerX: 520, centerY: 460, width: 560, drop: 40, angle: -0.1)
    run(200)
    snapshot("4a_flat_again")
    let edge = (Cloth.NY / 2) * Cloth.NX + Cloth.NX - 5
    p = SIMD2<Float>(cloth.SX[edge], cloth.SY[edge])
    if cloth.beginGrab(at: p) {
        print("fold grab ok at \(p)")
        for k in 0..<110 {
            let t = Float(k) / 109
            cloth.moveGrab(to: SIMD2(p.x - 400 * t, p.y + 70 * t))
            cloth.step()
        }
        snapshot("4_folding")
        cloth.endGrab()
        run(300)
        snapshot("5_folded_settled")
    } else { print("fold grab FAILED") }

    // rug dropped right on top of the icon mess: bumps should show
    cloth.reset(centerX: 1120, centerY: 360, width: 620, drop: 120, angle: 0.08)
    run(400)
    snapshot("6_over_icons")

    // roll up and unroll again
    cloth.reset(centerX: 560, centerY: 440, width: 620, drop: 30, angle: -0.08)
    run(200)
    cloth.startRoll(towardRight: true)
    run(40);  snapshot("7_roll_a")
    run(50);  snapshot("7_roll_b")
    run(60);  snapshot("7_roll_c")
    run(120); snapshot("7_roll_done")
    cloth.startUnroll()
    run(50);  snapshot("7_unroll_mid")
    run(160); snapshot("7_unrolled")

    // live resize: grow the settled rug, then shrink it
    cloth.reset(centerX: 640, centerY: 450, width: 480, drop: 30, angle: -0.08)
    run(200)
    cloth.scale(by: 2.0); run(120); snapshot("8_size_xl")
    cloth.scale(by: 0.35); run(120); snapshot("8_size_s")
}
