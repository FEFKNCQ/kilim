import Foundation
import simd

enum LightMode: String, CaseIterable {
    case auto, day, evening, night
}

/// Everything the shaders need to know about the light and the "camera exposure".
struct LightEnv {
    var light: SIMD4<Float>     // xyz: direction towards the light (x right, y down, z up), w: direct light strength
    var tint: SIMD4<Float>      // rgb: colour multiplier, a: shadow strength
    var shadow: SIMD4<Float>    // xy: shadow offset per unit of height, zw: constant offset (contact shadow)

    static let neutral = LightEnv(light: SIMD4(-0.45, -0.55, 0.75, 1), tint: SIMD4(1, 1, 1, 1), shadow: SIMD4(0.5, 0.7, 1.5, 3))
}

/// A simple sun model: the sun walks left -> right across the screen during the day, shadows get long and warm
/// in the morning/evening, short at noon, and at night the light turns cool and dim with soft shadows.
enum Lighting {
    static func hour(_ date: Date) -> Double {
        let c = Calendar.current.dateComponents([.hour, .minute], from: date)
        return Double(c.hour ?? 12) + Double(c.minute ?? 0) / 60
    }

    static func env(mode: LightMode, date: Date = Date()) -> LightEnv {
        let h: Double
        switch mode {
        case .auto: h = hour(date)
        case .day: h = 12.5
        case .evening: h = 18.0
        case .night: h = 23.0
        }
        return env(hour: h)
    }

    static func env(hour h: Double) -> LightEnv {
        let sunrise = 6.0, sunset = 19.0
        let elev: Double = (h > sunrise && h < sunset) ? sin(.pi * (h - sunrise) / (sunset - sunrise)) : -0.3
        func smooth(_ a: Double, _ b: Double, _ x: Double) -> Double {
            let t = min(max((x - a) / (b - a), 0), 1); return t * t * (3 - 2 * t)
        }
        let day = smooth(-0.02, 0.22, elev)                          // 0 at night, 1 in daylight
        let az = min(max((h - 12.5) / 6.5, -1), 1)                   // -1 morning ... +1 evening

        // direction towards the light
        let sun = SIMD3<Double>(az * 0.95, -0.35, max(0.2, elev) * 1.2)
        let moon = SIMD3<Double>(-0.35, -0.5, 0.8)
        let l = simd_normalize(simd_mix(moon, sun, SIMD3(repeating: day)))
        let strength = 0.30 + 0.70 * day

        // colour: warm near the horizon, cool and dim at night
        let warmth = (1 - min(max(elev / 0.55, 0), 1)) * day
        let dayTint = simd_mix(SIMD3<Double>(1.0, 0.99, 0.96), SIMD3<Double>(1.0, 0.80, 0.58), SIMD3(repeating: warmth))
        let nightTint = SIMD3<Double>(0.50, 0.58, 0.84)
        let tint = simd_mix(nightTint, dayTint, SIMD3(repeating: day))

        // shadows: long when the sun is low, always pointing away from the light
        let sx = min(max(-l.x / l.z * 0.55, -1.7), 1.7)
        let sy = min(max(-l.y / l.z * 0.55, -1.7), 1.7)
        let shadowStrength = 0.45 + 0.55 * day
        return LightEnv(
            light: SIMD4(Float(l.x), Float(l.y), Float(l.z), Float(strength)),
            tint: SIMD4(Float(tint.x), Float(tint.y), Float(tint.z), Float(shadowStrength)),
            shadow: SIMD4(Float(sx), Float(sy), Float(sx * 2.6 + 0.4), Float(sy * 2.6 + 2.0)))
    }
}
