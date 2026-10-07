import AVFoundation

/// Tiny procedural synth (no audio files): cloth rustle that follows the sliding speed,
/// plus a soft low "thump" when the rug lands or is let go.
final class SoundSynth {
    // [0] slide target 0...1, [1] thump amplitude trigger (audio thread clears it), [2] master volume
    let params = UnsafeMutablePointer<Float>.allocate(capacity: 4)
    var sr: Float = 44100

    private var s1: Float = 0, s2: Float = 0, slide: Float = 0
    private var rng: UInt32 = 0x1234_5678
    private var grain: Float = 0.6, grainTarget: Float = 0.6, grainCount = 0
    private var phase: Float = 0, env: Float = 0, amp: Float = 0, clickLP: Float = 0

    init() { params.initialize(repeating: 0, count: 4); params[2] = 0.7 }

    @inline(__always) private func noise() -> Float {
        rng = rng &* 1_664_525 &+ 1_013_904_223
        return Float(Int32(bitPattern: rng)) / 2_147_483_648
    }

    func render(_ frames: Int, _ out: UnsafeMutablePointer<Float>) {
        let vol = params[2]
        for i in 0..<frames {
            slide += (params[0] - slide) * 0.0006
            if grainCount <= 0 {
                grainTarget = 0.75 + 0.25 * abs(noise())
                grainCount = Int(sr / (0.8 + 1.6 * abs(noise())))
            }
            grainCount -= 1
            grain += (grainTarget - grain) * 0.00035

            // rustle: band-limited noise, brighter when faster
            let n = noise()
            s1 += (n - s1) * (0.05 + 0.32 * slide)
            s2 += (n - s2) * 0.006
            let rustle = (s1 - s2) * 1.05 * powf(slide, 1.15) * (0.82 + 0.18 * grain)

            // thump
            if params[1] > 0 { amp = params[1]; params[1] = 0; env = 1; phase = 0 }
            var thump: Float = 0
            if env > 0.0004 {
                let f = 38 + 52 * env * env
                phase += 2 * .pi * f / sr
                if phase > 2 * .pi { phase -= 2 * .pi }
                clickLP += (noise() - clickLP) * 0.07
                let e6 = env * env * env * env * env * env
                thump = (sinf(phase) * env * 0.9 + clickLP * e6 * 0.8) * amp
                env *= 0.99984
            }
            let y = (rustle + thump) * vol
            out[i] = tanhf(y)   // soft clip, keeps loud hits from distorting
        }
    }
}

/// Decides when a landing is worth a "thump": needs a big, sudden impact, never fires while the rug is
/// settled, and mutes itself if something keeps re-triggering (a few thumps in a few seconds = jitter).
struct ThumpDetector {
    private var window = 0
    private var total: Float = 0
    private var last = -10.0
    private var recent: [Double] = []

    mutating func feed(_ impact: Float, now: Double, calm: Bool) -> Float? {
        if impact > 150 && window == 0 && !calm { window = 6; total = 0 }
        guard window > 0 else { return nil }
        total += impact
        window -= 1
        guard window == 0 else { return nil }
        defer { total = 0 }
        recent.removeAll { now - $0 > 4 }
        guard now - last > 0.6, total > 250, recent.count < 3 else { return nil }
        last = now
        recent.append(now)
        return powf(min(total / 3000, 1), 0.6) * 0.9
    }
}

final class RugSound {
    let engine = AVAudioEngine()
    let synth = SoundSynth()
    private var node: AVAudioSourceNode!
    private var stopWork: DispatchWorkItem?
    var enabled: Bool {
        didSet {
            UserDefaults.standard.set(enabled, forKey: "soundEnabled")
            if !enabled { synth.params[0] = 0; engine.pause() }
        }
    }

    init() {
        enabled = UserDefaults.standard.object(forKey: "soundEnabled") as? Bool ?? true
        let sr = engine.outputNode.outputFormat(forBus: 0).sampleRate
        synth.sr = Float(sr > 0 ? sr : 44100)
        let fmt = AVAudioFormat(standardFormatWithSampleRate: Double(synth.sr), channels: 1)!
        let synth = self.synth
        node = AVAudioSourceNode(format: fmt) { _, _, frames, abl -> OSStatus in
            let list = UnsafeMutableAudioBufferListPointer(abl)
            for b in list {
                if let p = b.mData?.assumingMemoryBound(to: Float.self) { synth.render(Int(frames), p) }
            }
            return noErr
        }
        engine.attach(node)
        engine.connect(node, to: engine.mainMixerNode, format: fmt)
    }

    func start() {
        stopWork?.cancel()
        guard enabled, !engine.isRunning else { return }
        try? engine.start()
    }

    /// Called when the rug goes idle: let the tail ring out, then park the audio engine.
    func stopSoon() {
        synth.params[0] = 0
        stopWork?.cancel()
        let w = DispatchWorkItem { [weak self] in self?.engine.pause() }
        stopWork = w
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2, execute: w)
    }

    func setSlide(_ v: Float) { if enabled { synth.params[0] = min(max(v, 0), 1) } }
    func thump(_ a: Float) { if enabled { start(); synth.params[1] = min(max(a, 0), 1) } }
}
