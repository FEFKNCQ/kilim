import AppKit
import MetalKit
import ServiceManagement
import simd

final class RugWindow: NSWindow {
    override var canBecomeKey: Bool { false }
    override var canBecomeMain: Bool { false }
}

final class RugView: MTKView {
    weak var controller: RugController?
    var offset = SIMD2<Float>(0, 0)       // this screen's origin inside the shared cloth space
    override var isFlipped: Bool { true }
    override var acceptsFirstResponder: Bool { true }
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool { true }

    private func pt(_ e: NSEvent) -> SIMD2<Float> {
        let p = convert(e.locationInWindow, from: nil)
        return SIMD2(Float(p.x), Float(p.y)) + offset
    }
    override func mouseDown(with event: NSEvent) { controller?.mouseDown(pt(event), clicks: event.clickCount) }
    override func mouseDragged(with event: NSEvent) { controller?.moveGrab(pt(event)) }
    override func mouseUp(with event: NSEvent) { controller?.endGrab() }
}

/// One transparent window + Metal view per monitor; all of them draw the same cloth.
final class Overlay {
    let screen: NSScreen
    let window: RugWindow
    let view: RugView
    let renderer: Renderer
    let offset: SIMD2<Float>
    let size: SIMD2<Float>

    init(screen: NSScreen, offset: SIMD2<Float>, device: MTLDevice, texture: MTLTexture, delegate: MTKViewDelegate, controller: RugController) {
        self.screen = screen; self.offset = offset
        let frame = screen.frame
        size = SIMD2(Float(frame.width), Float(frame.height))
        window = RugWindow(contentRect: frame, styleMask: .borderless, backing: .buffered, defer: false)
        view = RugView(frame: CGRect(origin: .zero, size: frame.size), device: device)
        renderer = Renderer(device: device, texture: texture)
        renderer.offset = offset
        renderer.resize(frame.size)

        window.isOpaque = false
        window.backgroundColor = .clear
        window.hasShadow = false
        window.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.desktopIconWindow)) + 1)
        window.collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle, .fullScreenAuxiliary]
        window.ignoresMouseEvents = true
        window.acceptsMouseMovedEvents = true
        window.isReleasedWhenClosed = false

        view.controller = controller
        view.offset = offset
        view.delegate = delegate
        view.colorPixelFormat = .bgra8Unorm
        view.depthStencilPixelFormat = .invalid     // MSAA + depth targets are owned by Renderer (memoryless)
        view.sampleCount = 1
        view.clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 0)
        view.framebufferOnly = true
        view.preferredFramesPerSecond = 60
        view.wantsLayer = true
        view.layer?.isOpaque = false
        (view.layer as? CAMetalLayer)?.isOpaque = false
        window.contentView = view
        window.orderFrontRegardless()
    }

    func close() { window.orderOut(nil); window.contentView = nil; view.delegate = nil }
}

/// Which modifier key makes the rug see-through. Holding Option while dragging a file makes Finder COPY it,
/// so Shift and Command are offered as well.
enum PeekKey: String, CaseIterable {
    case option, shift, command
    var label: String { self == .option ? "⌥ Option" : self == .shift ? "⇧ Shift" : "⌘ Command" }
    var flag: NSEvent.ModifierFlags { self == .option ? .option : self == .shift ? .shift : .command }
}

/// Invisible layer on top of the menu bar icon: drop a picture on it to weave your own rug.
final class DropView: NSView {
    var onDrop: ((URL) -> Void)?
    override init(frame: NSRect) { super.init(frame: frame); registerForDraggedTypes([.fileURL]) }
    required init?(coder: NSCoder) { fatalError() }
    override func hitTest(_ point: NSPoint) -> NSView? { nil }          // clicks still reach the button
    private func url(_ s: NSDraggingInfo) -> URL? {
        s.draggingPasteboard.readObjects(forClasses: [NSURL.self], options: [.urlReadingContentsConformToTypes: ["public.image"]])?.first as? URL
    }
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation { url(sender) == nil ? [] : .copy }
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let u = url(sender) else { return false }
        onDrop?(u); return true
    }
}

/// Rug size steps. Labels are language-neutral on purpose.
enum RugSize: String, CaseIterable {
    case small, medium, large, huge
    var factor: Float { switch self { case .small: return 0.7; case .medium: return 1; case .large: return 1.45; case .huge: return 2.0 } }
    var label: String { switch self { case .small: return "S"; case .medium: return "M"; case .large: return "L"; case .huge: return "XL" } }
}

final class RugController: NSObject, MTKViewDelegate {
    let device = MTLCreateSystemDefaultDevice()!
    var overlays: [Overlay] = []
    let cloth = Cloth()
    let icons = DesktopIcons()
    var statusItem: NSStatusItem!
    var grabbing = false
    weak var grabOverlay: Overlay?
    var hidden = false
    var lastTime = CACurrentMediaTime()
    var acc = 0.0
    var monitors: [Any] = []
    var pollTimer: Timer?
    var peekTimer: Timer?
    var lightTimer: Timer?
    let sound = RugSound()
    var theme: RugTheme = Renderer.savedTheme
    var texture: MTLTexture
    var thumps = ThumpDetector()
    var smoothSlide: Float = 0
    var lastGrabEnd = -10.0

    // Finder coordinates (primary display top-left, y down) -> shared cloth space (union of all displays)
    var unionOrigin = SIMD2<Float>(0, 0)
    var primaryMaxY: Float = 0

    // Option "peek": the rug turns into a ghost and lets clicks through to the icons below
    var peek = false
    var peekKey = PeekKey(rawValue: UserDefaults.standard.string(forKey: "peekKey") ?? "") ?? .option
    var peekAlpha: Float = 1
    static let peekTarget: Float = 0.26

    // day / night
    var rugSize = RugSize(rawValue: UserDefaults.standard.string(forKey: "rugSize") ?? "") ?? .medium
    var lightMode = LightMode(rawValue: UserDefaults.standard.string(forKey: "lightMode") ?? "") ?? .auto
    var env = LightEnv.neutral

    override init() {
        texture = Renderer.makeTexture(device: device, theme: Renderer.savedTheme)
        super.init()
        env = Lighting.env(mode: lightMode)
        rebuildOverlays(initial: true)
        resetRug()

        icons.onChange = { [weak self] pts in
            guard let self = self else { return }
            RugController.log("icons: \(pts.count)")
            let o = self.unionOrigin, w = self.cloth.viewW, h = self.cloth.viewH
            self.cloth.bumps = pts.compactMap { p in
                let q = SIMD2<Float>(p.x - o.x, p.y - o.y)
                return (q.x > -60 && q.x < w + 60 && q.y > -60 && q.y < h + 60) ? q : nil
            }
            self.wake()
        }
        icons.onPermissionProblem = { [weak self] in RugController.log("icons: PERMISSION/ERROR"); self?.updateMenu() }

        setupMonitors()
        setupStatusItem()
        icons.poll()
        pollTimer = Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { [weak self] _ in
            if self?.hidden == false && self?.grabbing == false { self?.icons.poll() }
        }
        peekTimer = Timer.scheduledTimer(withTimeInterval: 1.0 / 20, repeats: true) { [weak self] _ in self?.pollModifiers() }
        lightTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in self?.refreshLight() }
        NotificationCenter.default.addObserver(forName: NSApplication.didChangeScreenParametersNotification, object: nil, queue: .main) { [weak self] _ in
            self?.rebuildOverlays(initial: false)
        }
    }

    static func log(_ m: String) {
        guard ProcessInfo.processInfo.environment["KILIM_LOG"] != nil || FileManager.default.fileExists(atPath: "/tmp/kilim.debug") else { return }
        let line = "\(Date()) \(m)\n"
        if let h = FileHandle(forWritingAtPath: "/tmp/kilim.log") { h.seekToEndOfFile(); h.write(line.data(using: .utf8)!); try? h.close() }
        else { try? line.write(toFile: "/tmp/kilim.log", atomically: true, encoding: .utf8) }
    }

    // MARK: displays

    /// (Re)creates one overlay per screen and recomputes the shared coordinate space.
    func rebuildOverlays(initial: Bool) {
        if grabbing { cloth.endGrab(); grabbing = false; icons.suspended = false }
        let screens = NSScreen.screens
        guard let primary = screens.first else { return }
        let pMaxY = Float(primary.frame.maxY)
        var minX = Float.greatestFiniteMagnitude, minY = Float.greatestFiniteMagnitude
        var maxX = -Float.greatestFiniteMagnitude, maxY = -Float.greatestFiniteMagnitude
        for s in screens {
            let f = s.frame
            let top = pMaxY - Float(f.maxY)
            minX = min(minX, Float(f.minX)); maxX = max(maxX, Float(f.maxX))
            minY = min(minY, top); maxY = max(maxY, top + Float(f.height))
        }
        let newOrigin = SIMD2(minX, minY)
        if !initial {
            let d = unionOrigin - newOrigin       // keep the rug on the same physical spot
            cloth.translate(dx: d.x, dy: d.y)
        }
        unionOrigin = newOrigin; primaryMaxY = pMaxY
        cloth.viewW = maxX - minX; cloth.viewH = maxY - minY

        overlays.forEach { $0.close() }
        overlays = screens.map { s in
            let top = pMaxY - Float(s.frame.maxY)
            return Overlay(screen: s, offset: SIMD2(Float(s.frame.minX) - minX, top - minY), device: device,
                           texture: texture, delegate: self, controller: self)
        }
        if hidden { overlays.forEach { $0.window.orderOut(nil) } }
        RugController.log("displays: \(screens.count), union \(cloth.viewW)x\(cloth.viewH)")
        if !initial { icons.poll() }
        wake()
    }

    // MARK: rug lifecycle

    func resetRug() {
        // drop it onto the primary display
        guard let o = overlays.first else { return }
        let w = o.size.x, h = o.size.y
        cloth.reset(centerX: o.offset.x + w * 0.40, centerY: o.offset.y + h * 0.52, width: rugWidth(for: rugSize), drop: 130, angle: -0.12)
        grabbing = false
        wake()
    }

    /// Width in points for a size step: a base that follows the screen width, times the step, never wider than the screen.
    func rugWidth(for size: RugSize) -> Float {
        let w = overlays.first?.size.x ?? 1440
        let base = min(max(w * 0.36, 420), 760)
        return min(base * size.factor, w * 0.92)
    }

    func wake() {
        cloth.settled = 0
        sound.start()
        if overlays.first?.view.isPaused ?? false {      // only restart the clock when we were actually asleep
            lastTime = CACurrentMediaTime(); acc = 0
            overlays.forEach { $0.view.isPaused = false }
        }
    }

    // MARK: light

    func refreshLight() {
        let e = Lighting.env(mode: lightMode)
        if e.light != env.light || e.tint != env.tint { env = e; wake() }
    }

    // MARK: option peek

    func pollModifiers() {
        // once a click/drag has started the rug stays see-through until the button is released, so the key can be
        // let go before dropping (a held Option would make Finder copy instead of move)
        let held = NSEvent.modifierFlags.contains(peekKey.flag)
        let opt = held || (peek && NSEvent.pressedMouseButtons != 0)
        if opt != peek {
            peek = opt
            if !opt { NSCursor.arrow.set() }
            updateHit()
            wake()
        }
    }

    // MARK: mouse

    func mousePoint() -> SIMD2<Float> {
        let m = NSEvent.mouseLocation
        return SIMD2(Float(m.x) - unionOrigin.x, primaryMaxY - Float(m.y) - unionOrigin.y)
    }

    /// The overlays only catch the mouse while the pointer is over the rug; everything else falls through to Finder.
    func updateHit() {
        if grabbing {
            for o in overlays { o.window.ignoresMouseEvents = (o !== grabOverlay) }
            return
        }
        if peek || hidden || NSEvent.pressedMouseButtons != 0 {
            for o in overlays { o.window.ignoresMouseEvents = true }
            return
        }
        let p = mousePoint()
        let over = cloth.hitNode(p) != nil
        for o in overlays {
            let inside = p.x >= o.offset.x && p.x < o.offset.x + o.size.x && p.y >= o.offset.y && p.y < o.offset.y + o.size.y
            o.window.ignoresMouseEvents = !(over && inside)
        }
    }

    // dragging a Finder icon: its bump follows the pointer live
    var dragBump: Int?
    var dragOffset = SIMD2<Float>(0, 0)
    var dragStart = SIMD2<Float>(0, 0)
    var dragMoved = false

    func iconDragEvent(_ type: NSEvent.EventType) {
        let p = mousePoint()
        switch type {
        case .leftMouseDown:
            dragMoved = false; dragBump = nil
            var best: Float = 42 * 42
            for (i, b) in cloth.bumps.enumerated() {
                let d = (b.x - p.x) * (b.x - p.x) + (b.y - p.y) * (b.y - p.y)
                if d < best { best = d; dragBump = i }
            }
            if let i = dragBump { dragOffset = cloth.bumps[i] - p; dragStart = p }
        case .leftMouseDragged:
            guard let i = dragBump, i < cloth.bumps.count else { return }
            if !dragMoved {
                if simd_length(p - dragStart) < 6 { return }
                dragMoved = true; icons.suspended = true
            }
            cloth.bumps[i] = p + dragOffset
            wake()
        case .leftMouseUp:
            if dragMoved { icons.suspended = false }
            dragBump = nil; dragMoved = false
        default: break
        }
    }

    func setupMonitors() {
        let mask: NSEvent.EventTypeMask = [.mouseMoved, .leftMouseDown, .leftMouseUp, .leftMouseDragged]
        if let g = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: { [weak self] e in
            guard let self = self else { return }
            self.iconDragEvent(e.type)
            if e.type == .leftMouseUp {
                // Finder may just have dropped an icon: refresh the bumps shortly after.
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { self.icons.poll() }
            }
            self.updateHit()
        }) { monitors.append(g) }
        if let l = NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved], handler: { [weak self] e in
            self?.updateHit(); return e
        }) { monitors.append(l) }
    }

    /// single click grabs the rug, double click rolls it up / unrolls it
    func mouseDown(_ p: SIMD2<Float>, clicks: Int) {
        if clicks >= 2 {
            if grabbing { cloth.endGrab(); grabbing = false; icons.suspended = false }
            let right = cloth.rollActive ? (p.x > cloth.rollC.x) : (p.x > centreX())
            cloth.toggleRoll(towardRight: right)
            NSCursor.arrow.set()
            wake()
            return
        }
        if cloth.rollActive { return }         // a rolled rug can't be dragged, only unrolled
        beginGrab(p)
    }

    func centreX() -> Float {
        var sx: Float = 0
        for i in 0..<cloth.N { sx += cloth.X[i] }
        return sx / Float(cloth.N)
    }

    func beginGrab(_ p: SIMD2<Float>) {
        if peek { return }
        if cloth.beginGrab(at: p) {
            grabbing = true
            grabOverlay = overlays.first { o in
                p.x >= o.offset.x && p.x < o.offset.x + o.size.x && p.y >= o.offset.y && p.y < o.offset.y + o.size.y
            }
            icons.suspended = true; wake(); NSCursor.closedHand.set()
        }
    }
    func moveGrab(_ p: SIMD2<Float>) { if grabbing { cloth.moveGrab(to: p); wake() } }
    func endGrab() {
        guard grabbing else { return }
        grabbing = false
        lastGrabEnd = CACurrentMediaTime()
        icons.suspended = false
        cloth.endGrab()
        wake()
        updateHit()
    }

    // MARK: MTKViewDelegate

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}

    var lastDraw = CACurrentMediaTime()

    func draw(in view: MTKView) {
        let now = CACurrentMediaTime()
        let t0 = now
        defer {
            let end = CACurrentMediaTime()
            if grabbing {
                if t0 - lastDraw > 0.034 { RugController.log(String(format: "stall: %.0f ms between frames", (t0 - lastDraw) * 1000)) }
                if end - t0 > 0.012 { RugController.log(String(format: "slow draw: %.1f ms (cpu)", (end - t0) * 1000)) }
            }
            lastDraw = t0
        }
        // all displays share one clock, so whichever view draws first advances the simulation
        acc += min(now - lastTime, 0.05)
        lastTime = now
        var n = 0
        while acc >= 1.0 / 60.0 && n < 2 { cloth.step(); acc -= 1.0 / 60.0; n += 1 }
        if n == 2 { acc = 0 }   // behind? drop the backlog instead of spiralling
        if n > 0 { feedSound(now) }

        // fade between solid rug and Option-peek ghost
        let target: Float = peek ? RugController.peekTarget : 1
        if abs(peekAlpha - target) > 0.012 { peekAlpha += (target - peekAlpha) * 0.28; cloth.settled = 0 } else { peekAlpha = target }

        guard let o = overlays.first(where: { $0.view === view }),
              let drawable = view.currentDrawable else { return }
        let pass = o.renderer.makePass(resolvingInto: drawable.texture)
        o.renderer.alpha = peekAlpha
        o.renderer.env = env
        o.renderer.render(cloth: cloth, pass: pass, drawable: drawable)
        if !grabbing { updateHit() }
        if cloth.settled > 45 && !grabbing && peekAlpha == target {   // idle: stop burning CPU/GPU
            overlays.forEach { $0.view.isPaused = true }
            sound.stopSoon()
        }
    }

    /// Maps the physics to sound: sliding speed -> rustle, floor impacts -> a soft thump.
    func feedSound(_ now: Double) {
        let slide = min(cloth.slideLevel / 3.0, 1)
        smoothSlide += (slide * slide.squareRoot() - smoothSlide) * 0.18      // no frame-to-frame flutter
        sound.setSlide(smoothSlide)
        // carrying the rug over icons bumps it around: only real landings make a thump
        let carrying = grabbing || now - lastGrabEnd < 0.9
        if let amp = thumps.feed(cloth.impactSum, now: now, calm: carrying || cloth.settled > 20) { sound.thump(amp) }
    }

    // MARK: menu bar

    func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let b = statusItem.button {
            if let img = NSImage(systemSymbolName: "rectangle.pattern.checkered", accessibilityDescription: "Kilim") {
                img.isTemplate = true
                b.image = img
            } else { b.title = "🧶" }
            let drop = DropView(frame: b.bounds)
            drop.autoresizingMask = [.width, .height]
            drop.onDrop = { [weak self] u in self?.useCustomPicture(u) }
            b.addSubview(drop)
        }
        updateMenu()
    }

    func updateMenu() {
        let m = NSMenu()
        func add(_ t: String, _ a: Selector, key: String = "") {
            let i = NSMenuItem(title: t, action: a, keyEquivalent: key); i.target = self; m.addItem(i)
        }
        func submenu(_ title: String, _ build: (NSMenu) -> Void) {
            let item = NSMenuItem(title: title, action: nil, keyEquivalent: "")
            let sub = NSMenu(); build(sub); item.submenu = sub; m.addItem(item)
        }
        if icons.denied {
            let i = NSMenuItem(title: L10n.t(.noPermission), action: #selector(openAutomation), keyEquivalent: "")
            i.target = self; m.addItem(i); m.addItem(.separator())
        }
        add(L10n.t(hidden ? .showRug : .hideRug), #selector(toggleHidden))
        add(L10n.t(.tossRug), #selector(rethrow), key: "r")
        add(L10n.t(.rescan), #selector(rescan))
        m.addItem(.separator())

        submenu(L10n.t(.pattern)) { sub in
            for t in RugTheme.allCases where t != .custom {
                let i = NSMenuItem(title: L10n.theme(t), action: #selector(pickTheme(_:)), keyEquivalent: "")
                i.target = self; i.representedObject = t.rawValue
                i.state = (t == theme) ? .on : .off
                sub.addItem(i)
            }
            sub.addItem(.separator())
            if RugTexture.hasCustom {
                let i = NSMenuItem(title: L10n.theme(.custom), action: #selector(pickTheme(_:)), keyEquivalent: "")
                i.target = self; i.representedObject = RugTheme.custom.rawValue
                i.state = (theme == .custom) ? .on : .off
                sub.addItem(i)
            }
            let c = NSMenuItem(title: L10n.t(.customRug), action: #selector(chooseCustom), keyEquivalent: "")
            c.target = self; sub.addItem(c)
        }
        submenu(L10n.t(.light)) { sub in
            let names: [(LightMode, Str)] = [(.auto, .lightAuto), (.day, .lightDay), (.evening, .lightEvening), (.night, .lightNight)]
            for (mode, key) in names {
                let i = NSMenuItem(title: L10n.t(key), action: #selector(pickLight(_:)), keyEquivalent: "")
                i.target = self; i.representedObject = mode.rawValue
                i.state = (mode == lightMode) ? .on : .off
                sub.addItem(i)
            }
        }
        submenu(L10n.t(.size)) { sub in
            for z in RugSize.allCases {
                let i = NSMenuItem(title: z.label, action: #selector(pickSize(_:)), keyEquivalent: "")
                i.target = self; i.representedObject = z.rawValue
                i.state = (z == rugSize) ? .on : .off
                sub.addItem(i)
            }
        }
        let snd = NSMenuItem(title: L10n.t(.sounds), action: #selector(toggleSound), keyEquivalent: "")
        snd.target = self; snd.state = sound.enabled ? .on : .off
        m.addItem(snd)
        submenu(L10n.t(.language)) { sub in
            for l in L10n.menuOrder {
                let i = NSMenuItem(title: l.nativeName, action: #selector(pickLanguage(_:)), keyEquivalent: "")
                i.target = self; i.representedObject = l.rawValue
                i.state = (l == L10n.current) ? .on : .off
                sub.addItem(i)
            }
        }
        m.addItem(.separator())
        let login = NSMenuItem(title: L10n.t(.launchAtLogin), action: #selector(toggleLogin), keyEquivalent: "")
        login.target = self
        login.state = (SMAppService.mainApp.status == .enabled) ? .on : .off
        m.addItem(login)
        m.addItem(.separator())
        add(L10n.t(.sponsor), #selector(openSponsor))
        m.addItem(.separator())
        submenu(L10n.t(.peekKey)) { sub in
            for k in PeekKey.allCases {
                let i = NSMenuItem(title: k.label, action: #selector(pickPeekKey(_:)), keyEquivalent: "")
                i.target = self; i.representedObject = k.rawValue
                i.state = (k == peekKey) ? .on : .off
                sub.addItem(i)
            }
        }
        let hint = NSMenuItem(title: L10n.t(.optionHint).replacingOccurrences(of: "⌥ Option", with: peekKey.label), action: nil, keyEquivalent: "")
        hint.isEnabled = false
        m.addItem(hint)
        m.addItem(.separator())
        add(L10n.t(.quit), #selector(quit), key: "q")
        statusItem.menu = m
    }

    @objc func toggleHidden() {
        hidden.toggle()
        if hidden { overlays.forEach { $0.window.orderOut(nil) } } else { overlays.forEach { $0.window.orderFrontRegardless() }; wake() }
        updateMenu()
    }
    @objc func rethrow() { if hidden { toggleHidden() }; resetRug() }
    @objc func rescan() { icons.poll() }
    @objc func toggleSound() { sound.enabled.toggle(); updateMenu() }
    @objc func pickLanguage(_ item: NSMenuItem) {
        guard let raw = item.representedObject as? String, let l = Lang(rawValue: raw) else { return }
        L10n.current = l
        updateMenu()
    }
    @objc func pickLight(_ item: NSMenuItem) {
        guard let raw = item.representedObject as? String, let mode = LightMode(rawValue: raw) else { return }
        lightMode = mode
        UserDefaults.standard.set(raw, forKey: "lightMode")
        env = Lighting.env(mode: mode)
        updateMenu()
        wake()
    }
    @objc func pickTheme(_ item: NSMenuItem) {
        guard let raw = item.representedObject as? String, let t = RugTheme(rawValue: raw), t != theme else { return }
        applyTheme(t)
    }

    @objc func pickSize(_ sender: NSMenuItem) {
        guard let raw = sender.representedObject as? String, let z = RugSize(rawValue: raw), z != rugSize else { return }
        let before = cloth.width
        rugSize = z
        UserDefaults.standard.set(raw, forKey: "rugSize")
        if cloth.rollActive || grabbing { resetRug() }            // can't resize mid-roll or mid-drag: toss a fresh one
        else { cloth.scale(by: rugWidth(for: z) / max(before, 1)) }
        wake()
        updateMenu()
    }

    @objc func pickPeekKey(_ item: NSMenuItem) {
        guard let raw = item.representedObject as? String, let k = PeekKey(rawValue: raw) else { return }
        peekKey = k
        UserDefaults.standard.set(raw, forKey: "peekKey")
        updateMenu()
    }

    @objc func chooseCustom() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.image]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.title = L10n.theme(.custom)
        NSApp.activate(ignoringOtherApps: true)
        panel.begin { [weak self] resp in
            guard resp == .OK, let url = panel.url else { return }
            self?.useCustomPicture(url)
        }
    }

    func useCustomPicture(_ url: URL) {
        guard RugTexture.setCustom(from: url) else { NSSound.beep(); return }
        theme = .custom       // force regeneration even if the custom rug was already active
        applyTheme(.custom, force: true)
    }

    func applyTheme(_ t: RugTheme, force: Bool = false) {
        theme = t
        UserDefaults.standard.set(t.rawValue, forKey: "rugTheme")
        updateMenu()
        let device = self.device
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let tex = Renderer.makeTexture(device: device, theme: t)     // ~0.2 s, off the main thread
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.texture = tex
                self.overlays.forEach { $0.renderer.rugTex = tex }
                self.wake()
            }
        }
    }
    @objc func openSponsor() { NSWorkspace.shared.open(URL(string: "https://github.com/sponsors/yusufyilmazfr")!) }
    @objc func quit() { NSApp.terminate(nil) }
    @objc func openAutomation() {
        NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Automation")!)
    }
    @objc func toggleLogin() {
        do {
            if SMAppService.mainApp.status == .enabled { try SMAppService.mainApp.unregister() }
            else { try SMAppService.mainApp.register() }
        } catch { NSSound.beep() }
        updateMenu()
    }
}
