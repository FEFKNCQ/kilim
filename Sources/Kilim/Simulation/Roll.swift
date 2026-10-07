import Foundation
import simd

/// Double-click: the rug rolls itself up like a carpet (pattern inwards), double-click again unrolls it.
/// While rolled / rolling the cloth is driven kinematically; unrolling hands it back to the physics, flat.
extension Cloth {
    static let rollR0: Float = 5          // radius of the core
    static let rollThickness: Float = 9   // how much the radius grows per turn

    private func theta(_ s: Float) -> Float {
        let t = Cloth.rollThickness, r0 = Cloth.rollR0
        return (-r0 + sqrtf(r0 * r0 + t * s / .pi)) / (t / (2 * .pi))
    }

    /// Starts rolling. `towardRight`: the roll ends up at the right end of the rug.
    func startRoll(towardRight: Bool) {
        pins.removeAll()
        for i in 0..<N { pinned[i] = 0 }
        let NX = Cloth.NX, NY = Cloth.NY
        // local frame of the rug as it lies now
        var c = SIMD2<Float>(0, 0)
        for i in 0..<N { c += SIMD2(X[i], Y[i]) }
        c /= Float(N)
        var left = SIMD2<Float>(0, 0), right = SIMD2<Float>(0, 0)
        for j in 0..<NY {
            left += SIMD2(X[j * NX], Y[j * NX]); right += SIMD2(X[j * NX + NX - 1], Y[j * NX + NX - 1])
        }
        var ex = (right - left) / Float(NY)
        let len = simd_length(ex)
        ex = len > 20 ? ex / len : SIMD2(1, 0)
        if ex.x < 0 { ex = -ex }
        rollC = c; rollEx = ex; rollEy = SIMD2(-ex.y, ex.x)
        rollDir = towardRight ? 1 : -1
        rollStart = (0..<N).map { SIMD3(X[$0], Y[$0], Z[$0]) }
        rollBlend = 0; rollP = 0; rollGoal = 1; rollActive = true
        settled = 0
    }

    func startUnroll() { rollGoal = 0; rollBlend = 1; settled = 0 }
    func toggleRoll(towardRight: Bool) {
        if !rollActive { startRoll(towardRight: towardRight) }
        else { rollGoal = rollGoal > 0.5 ? 0 : 1; rollBlend = 1; settled = 0 }
    }

    /// target position of a node for roll length `sf` (distance of rug rolled up so far)
    private func rollTarget(_ i: Int, _ j: Int, sf: Float) -> SIMD3<Float> {
        let NX = Cloth.NX, NY = Cloth.NY
        let Wr = width, Hr = height
        let u = (Float(i) / Float(NX - 1) - 0.5) * Wr
        let v = (Float(j) / Float(NY - 1) - 0.5) * Hr
        let a = rollDir * u
        let s = a + Wr / 2
        let exd = rollEx * rollDir
        let base = rollC + rollEy * v
        if s <= sf {
            let th = theta(s), thF = theta(sf)
            let t = Cloth.rollThickness, r0 = Cloth.rollR0
            let R = r0 + t * thF / (2 * .pi)
            let r = r0 + t * th / (2 * .pi)
            let alpha = -Float.pi / 2 - (thF - th)
            let along = (-Wr / 2 + sf) + r * cosf(alpha)
            let p = base + exd * along
            return SIMD3(p.x, p.y, R + r * sinf(alpha))
        }
        let p = base + exd * a
        return SIMD3(p.x, p.y, heightAt(p.x, p.y))
    }

    func stepRoll() {
        let dt: Float = 1.0 / 60
        let moving = rollP != rollGoal || rollBlend < 1
        if rollP < rollGoal { rollP = min(rollGoal, rollP + dt / 1.6) }
        else if rollP > rollGoal { rollP = max(rollGoal, rollP - dt / 1.3) }
        rollBlend = min(1, rollBlend + dt / 0.45)
        let e = rollP * rollP * (3 - 2 * rollP)
        let sf = width * e
        let b = rollBlend * rollBlend * (3 - 2 * rollBlend)
        let NX = Cloth.NX, NY = Cloth.NY
        for j in 0..<NY {
            for i in 0..<NX {
                let k = j * NX + i
                let t = rollTarget(i, j, sf: sf)
                if b < 1, k < rollStart.count {
                    let st = rollStart[k]
                    X[k] = st.x + (t.x - st.x) * b; Y[k] = st.y + (t.y - st.y) * b; Z[k] = st.z + (t.z - st.z) * b
                } else { X[k] = t.x; Y[k] = t.y; Z[k] = t.z }
                OX[k] = X[k]; OY[k] = Y[k]; OZ[k] = Z[k]
                H[k] = 0
            }
        }
        maxSpeed = 0
        impactSum = 0
        slideLevel = moving ? 1.6 : 0           // a bit of rustle while it rolls
        settled = moving ? 0 : settled + 1
        if rollP == 0 && rollGoal == 0 && rollBlend >= 1 {   // fully unrolled: back to physics
            rollActive = false
            for k in 0..<N { Z[k] = max(Z[k], 0) + 0.2; OZ[k] = Z[k] }
            settled = 0
        }
    }
}
