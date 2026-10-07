import Foundation
import simd

/// Verlet / position-based cloth, 3D, viewed from the top.
/// Coordinates: x right, y down (screen points), z up towards the viewer.
final class Cloth {
    static let NX = 44
    static let NY = 30
    let N = Cloth.NX * Cloth.NY

    // ---- tuning ----
    var substeps = 1
    var iterations = 22
    var gravity: Float = 0.30
    var damp: Float = 0.965
    var dampZ: Float = 0.90
    var friction: Float = 0.85      // Coulomb-ish: px/substep removed from sliding speed
    var contactDamp: Float = 0.93
    var selfT: Float = 10           // self collision thickness
    var selfK: Float = 0.7
    var maxPinStep: Float = 22      // px per step the grabbed cloth may travel (keeps flicks tame)
    var maxNodeSpeed: Float = 14
    var liftH: Float = 28
    var grabR: Float = 26
    let K: Float = 0.0009           // perspective strength (lifted cloth shifts away from centre)
    var bumpR: Float = 48, bumpR0: Float = 14, bumpH: Float = 20, bumpCap: Float = 110

    // ---- state ----
    let X, Y, Z, OX, OY, OZ, H: UnsafeMutablePointer<Float>
    let SX, SY: UnsafeMutablePointer<Float>
    let pinned: UnsafeMutablePointer<UInt8>
    var cA: UnsafeMutablePointer<Int32>, cB: UnsafeMutablePointer<Int32>
    var cR: UnsafeMutablePointer<Float>, cS: UnsafeMutablePointer<Float>
    var cN = 0
    let head = UnsafeMutablePointer<Int32>.allocate(capacity: 4096)
    let nxt: UnsafeMutablePointer<Int32>

    var viewW: Float = 1440, viewH: Float = 900
    var width: Float = 600, height: Float = 400
    var bumps: [SIMD2<Float>] = []

    struct Pin { var i: Int; var dx: Float; var dy: Float; var lift: Float }
    var pins: [Pin] = []
    var pointerW = SIMD2<Float>(0, 0)
    var maxSpeed: Float = 0
    var slideLevel: Float = 0      // mean sliding speed of nodes touching the floor (px/step)
    var impactSum: Float = 0       // how hard nodes hit the floor this step
    private var slideAccum: Float = 0
    var settled = 0

    // ---- roll (kinematic pose: rolling up, rolled, unrolling) ----
    var rollActive = false
    var rollP: Float = 0            // progress 0 (flat) ... 1 (rolled)
    var rollGoal: Float = 0
    var rollBlend: Float = 1        // 0 -> 1: blends from the pose we had when the roll started
    var rollDir: Float = 1
    var rollC = SIMD2<Float>(0, 0), rollEx = SIMD2<Float>(1, 0), rollEy = SIMD2<Float>(0, 1)
    var rollStart: [SIMD3<Float>] = []

    init() {
        func alloc<T>(_ n: Int, _ v: T) -> UnsafeMutablePointer<T> {
            let p = UnsafeMutablePointer<T>.allocate(capacity: n); p.initialize(repeating: v, count: n); return p
        }
        let n = Cloth.NX * Cloth.NY
        X = alloc(n, 0); Y = alloc(n, 0); Z = alloc(n, 0)
        OX = alloc(n, 0); OY = alloc(n, 0); OZ = alloc(n, 0)
        H = alloc(n, 0); SX = alloc(n, 0); SY = alloc(n, 0)
        pinned = alloc(n, 0)
        nxt = alloc(n, -1)
        let maxC = n * 8
        cA = alloc(maxC, 0); cB = alloc(maxC, 0); cR = alloc(maxC, 0); cS = alloc(maxC, 0)
    }

    // MARK: setup

    /// keeps the rug where it is on the real desktop when the shared coordinate origin moves (monitor layout change)
    func translate(dx: Float, dy: Float) {
        for i in 0..<N { X[i] += dx; OX[i] += dx; Y[i] += dy; OY[i] += dy }
        rollC += SIMD2(dx, dy)
        for k in 0..<rollStart.count { rollStart[k].x += dx; rollStart[k].y += dy }
    }

    /// Resizes the rug in place around its centre (folds and bumps are kept). Not valid while rolled or grabbed.
    func scale(by f: Float) {
        guard !rollActive, pins.isEmpty, f > 0 else { return }
        var cx: Float = 0, cy: Float = 0
        for i in 0..<N { cx += X[i]; cy += Y[i] }
        cx /= Float(N); cy /= Float(N)
        for i in 0..<N {
            X[i] = cx + (X[i] - cx) * f;  OX[i] = cx + (OX[i] - cx) * f
            Y[i] = cy + (Y[i] - cy) * f;  OY[i] = cy + (OY[i] - cy) * f
        }
        width *= f; height *= f
        buildConstraints()
        settled = 0
    }

    func reset(centerX: Float, centerY: Float, width w: Float, drop: Float, angle: Float) {
        let NX = Cloth.NX, NY = Cloth.NY
        width = w
        height = w * Float(RugTexture.H) / Float(RugTexture.W)
        let dx = width / Float(NX - 1), dy = height / Float(NY - 1)
        let ca = cos(angle), sa = sin(angle)
        var rng = RNG(UInt64(Date().timeIntervalSince1970 * 1000) & 0xFFFF)
        for j in 0..<NY {
            for i in 0..<NX {
                let k = j * NX + i
                let lx = (Float(i) - Float(NX - 1) / 2) * dx
                let ly = (Float(j) - Float(NY - 1) / 2) * dy
                X[k] = centerX + lx * ca - ly * sa
                Y[k] = centerY + lx * sa + ly * ca
                Z[k] = drop + Float(rng.next()) * 0.6
                OX[k] = X[k]; OY[k] = Y[k]; OZ[k] = Z[k] + drop * 0.0
                H[k] = 0
                pinned[k] = 0
            }
        }
        pins.removeAll()
        buildConstraints()
        rollActive = false; rollP = 0; rollGoal = 0
        settled = 0
    }

    private func buildConstraints() {
        let NX = Cloth.NX, NY = Cloth.NY
        let dx = width / Float(NX - 1), dy = height / Float(NY - 1)
        struct C { var a: Int32; var b: Int32; var r: Float; var s: Float; var color: Int }
        var list: [C] = []
        func add(_ i1: Int, _ j1: Int, _ i2: Int, _ j2: Int, _ s: Float, _ color: Int) {
            guard i1 < NX, j1 < NY, i2 < NX, j2 < NY, i1 >= 0, j1 >= 0, i2 >= 0, j2 >= 0 else { return }
            list.append(C(a: Int32(j1 * NX + i1), b: Int32(j2 * NX + i2),
                          r: hypotf(Float(i2 - i1) * dx, Float(j2 - j1) * dy), s: s, color: color))
        }
        // Colors group constraints that share no node, so the CPU can work on a whole batch in parallel.
        for j in 0..<NY {
            for i in 0..<NX {
                add(i, j, i + 1, j, 1.0, i & 1)
                add(i, j, i, j + 1, 1.0, 2 + (j & 1))
                add(i, j, i + 1, j + 1, 0.55, 4 + (i & 1) + 2 * (j & 1))
                add(i + 1, j, i, j + 1, 0.55, 8 + (i & 1) + 2 * (j & 1))
                add(i, j, i + 2, j, 0.14, 12 + (i & 3))
                add(i, j, i, j + 2, 0.14, 16 + (j & 3))
            }
        }
        list.sort { $0.color < $1.color }
        cN = list.count
        for (k, c) in list.enumerated() { cA[k] = c.a; cB[k] = c.b; cR[k] = c.r; cS[k] = c.s }
    }

    // MARK: projection helpers

    @inline(__always) func project(_ x: Float, _ y: Float, _ z: Float) -> SIMD2<Float> {
        SIMD2(x + (x - viewW / 2) * z * K, y + (y - viewH / 2) * z * K)
    }
    func invProject(_ s: SIMD2<Float>, z: Float) -> SIMD2<Float> {
        let k = K * z
        return (s + SIMD2(viewW / 2, viewH / 2) * k) / (1 + k)
    }

    // MARK: height field from desktop icons

    @inline(__always) func heightAt(_ x: Float, _ y: Float) -> Float {
        var h: Float = 0
        let r2 = bumpR * bumpR
        for b in bumps {
            let dx = x - b.x, dy = y - b.y
            let d2 = dx * dx + dy * dy
            if d2 < r2 {
                let d = sqrtf(d2)
                var t: Float = 1
                if d > bumpR0 {
                    let u = (d - bumpR0) / (bumpR - bumpR0)
                    t = 1 - u * u * (3 - 2 * u)
                }
                h += bumpH * t
            }
        }
        return min(h, bumpCap)
    }

    // MARK: simulation

    func step() {
        if rollActive { stepRoll(); return }
        maxSpeed = 0
        slideAccum = 0
        impactSum = 0
        for _ in 0..<substeps { substep() }
        slideLevel = slideAccum / Float(N * substeps)
        if maxSpeed < 0.15 && pins.isEmpty { settled += 1 } else { settled = 0 }
    }

    private func substep() {
        applyPins()
        integrate()
        computeHeights(); floorClamp()
        selfCollide()
        for it in 0..<iterations {
            solve(reverse: it & 1 == 1)
            if it % 6 == 5 { floorClamp() }
        }
        selfCollide()                       // once more after the solver so layers end up apart
        computeHeights(); floorClamp()
        let lo: Float = -200, hiX = viewW + 200, hiY = viewH + 200
        for i in 0..<N {
            if X[i] < lo { X[i] = lo } else if X[i] > hiX { X[i] = hiX }
            if Y[i] < lo { Y[i] = lo } else if Y[i] > hiY { Y[i] = hiY }
        }
    }

    private func applyPins() {
        for p in pins {
            let i = p.i
            var mx = (pointerW.x + p.dx - X[i]) * 0.7
            var my = (pointerW.y + p.dy - Y[i]) * 0.7
            let ml = sqrtf(mx * mx + my * my)
            if ml > maxPinStep { mx *= maxPinStep / ml; my *= maxPinStep / ml }
            X[i] += mx; Y[i] += my
            Z[i] += (p.lift - Z[i]) * 0.2
            OX[i] = X[i]; OY[i] = Y[i]; OZ[i] = Z[i]
        }
    }

    private func integrate() {
        for i in 0..<N where pinned[i] == 0 {
            var vx = (X[i] - OX[i]) * damp
            var vy = (Y[i] - OY[i]) * damp
            let vz = (Z[i] - OZ[i]) * dampZ
            if Z[i] - H[i] < 0.8 {
                let s = sqrtf(vx * vx + vy * vy)
                if s > 0.25 { slideAccum += s }
                if s <= friction { vx = 0; vy = 0 }
                else { let f = (s - friction) / s * contactDamp; vx *= f; vy *= f }
            }
            var sp = sqrtf(vx * vx + vy * vy)
            if sp > maxNodeSpeed { let f = maxNodeSpeed / sp; vx *= f; vy *= f; sp = maxNodeSpeed }
            sp = max(sp, abs(vz))
            if sp > maxSpeed { maxSpeed = sp }
            OX[i] = X[i]; OY[i] = Y[i]; OZ[i] = Z[i]
            X[i] += vx; Y[i] += vy; Z[i] += vz - gravity
        }
    }

    private func computeHeights() {
        if bumps.isEmpty { for i in 0..<N { H[i] = 0 }; return }
        for i in 0..<N { H[i] = heightAt(X[i], Y[i]) }
    }

    private func floorClamp() {
        for i in 0..<N where Z[i] < H[i] {
            let v = OZ[i] - Z[i]                      // downward speed at the moment of contact
            Z[i] = H[i]
            if v > 0.6 { impactSum += v - 0.6; OZ[i] = H[i] }   // real landing: count it once, kill the bounce
            else if OZ[i] < H[i] { OZ[i] = H[i] }
        }
    }

    private func solve(reverse: Bool) {
        let X = self.X, Y = self.Y, Z = self.Z, pinned = self.pinned
        let cA = self.cA, cB = self.cB, cR = self.cR, cS = self.cS
        let n = cN
        for k in 0..<n {
            let c = reverse ? n - 1 - k : k
            let a = Int(cA[c]), b = Int(cB[c])
            let dx = X[b] - X[a], dy = Y[b] - Y[a], dz = Z[b] - Z[a]
            let d2 = dx * dx + dy * dy + dz * dz + 1e-12
            let d = d2.squareRoot()
            let diff = cS[c] * (1 - cR[c] / d)
            let wa: Float = pinned[a] == 0 ? 1 : 0
            let wb: Float = pinned[b] == 0 ? 1 : 0
            let w = wa + wb
            if w == 0 { continue }
            let f = diff / w
            let ka = f * wa, kb = f * wb
            X[a] += dx * ka; Y[a] += dy * ka; Z[a] += dz * ka
            X[b] -= dx * kb; Y[b] -= dy * kb; Z[b] -= dz * kb
        }
    }

    @inline(__always) private func hash(_ x: Int, _ y: Int, _ z: Int) -> Int {
        ((x &* 73856093) ^ (y &* 19349663) ^ (z &* 83492791)) & 4095
    }

    private func selfCollide() {
        let NX = Cloth.NX
        for i in 0..<4096 { head[i] = -1 }
        let inv = 1 / selfT
        for i in 0..<N {
            let h = hash(Int(floorf(X[i] * inv)), Int(floorf(Y[i] * inv)), Int(floorf(Z[i] * inv)))
            nxt[i] = head[h]; head[h] = Int32(i)
        }
        let T2 = selfT * selfT
        for i in 0..<N {
            let cx = Int(floorf(X[i] * inv)), cy = Int(floorf(Y[i] * inv)), cz = Int(floorf(Z[i] * inv))
            let ii = i % NX, ij = i / NX
            for dz in -1...1 { for dy in -1...1 { for dx in -1...1 {
                var jn = head[hash(cx + dx, cy + dy, cz + dz)]
                while jn >= 0 {
                    let j = Int(jn); jn = nxt[j]
                    if j <= i { continue }
                    let ex = X[i] - X[j], ey = Y[i] - Y[j], ez = Z[i] - Z[j]
                    let d2 = ex * ex + ey * ey + ez * ez
                    if d2 >= T2 { continue }
                    if abs(ii - j % NX) <= 2 && abs(ij - j / NX) <= 2 { continue }
                    let wi: Float = pinned[i] == 1 ? 0 : 1, wj: Float = pinned[j] == 1 ? 0 : 1
                    let w = wi + wj
                    if w == 0 { continue }
                    var d = sqrtf(d2)
                    var nx = ex, ny = ey, nz = ez
                    if d < 1e-4 { nx = 0; ny = 0; nz = 1; d = 0 } else { nx /= d; ny /= d; nz /= d }
                    let corr = (selfT - d) * selfK
                    let ci = corr * wi / w, cj = corr * wj / w
                    X[i] += nx * ci; Y[i] += ny * ci; Z[i] += nz * ci
                    X[j] -= nx * cj; Y[j] -= ny * cj; Z[j] -= nz * cj
                }
            }}}
        }
    }

    // MARK: interaction

    /// Finds the top-most mesh triangle under a screen point and returns the nearest vertex.
    func hitNode(_ p: SIMD2<Float>) -> Int? {
        let NX = Cloth.NX, NY = Cloth.NY
        var bestZ: Float = -1e9
        var best: Int? = nil
        for j in 0..<(NY - 1) {
            for i in 0..<(NX - 1) {
                let a = j * NX + i, b = a + 1, c = a + NX, d = c + 1
                let minx = min(min(SX[a], SX[b]), min(SX[c], SX[d]))
                let maxx = max(max(SX[a], SX[b]), max(SX[c], SX[d]))
                if p.x < minx || p.x > maxx { continue }
                let miny = min(min(SY[a], SY[b]), min(SY[c], SY[d]))
                let maxy = max(max(SY[a], SY[b]), max(SY[c], SY[d]))
                if p.y < miny || p.y > maxy { continue }
                for tri in [(a, b, c), (b, d, c)] {
                    if inTri(p, tri.0, tri.1, tri.2) {
                        let z = (Z[tri.0] + Z[tri.1] + Z[tri.2]) / 3
                        if z > bestZ {
                            bestZ = z
                            var bi = tri.0, bd = distSq(p, tri.0)
                            for v in [tri.1, tri.2] { let dd = distSq(p, v); if dd < bd { bd = dd; bi = v } }
                            best = bi
                        }
                    }
                }
            }
        }
        return best
    }

    private func distSq(_ p: SIMD2<Float>, _ i: Int) -> Float {
        let dx = SX[i] - p.x, dy = SY[i] - p.y
        return dx * dx + dy * dy
    }

    private func inTri(_ p: SIMD2<Float>, _ a: Int, _ b: Int, _ c: Int) -> Bool {
        func s(_ ax: Float, _ ay: Float, _ bx: Float, _ by: Float) -> Float {
            (p.x - bx) * (ay - by) - (ax - bx) * (p.y - by)
        }
        let d1 = s(SX[a], SY[a], SX[b], SY[b])
        let d2 = s(SX[b], SY[b], SX[c], SY[c])
        let d3 = s(SX[c], SY[c], SX[a], SY[a])
        let neg = d1 < 0 || d2 < 0 || d3 < 0
        let pos = d1 > 0 || d2 > 0 || d3 > 0
        return !(neg && pos)
    }

    func beginGrab(at p: SIMD2<Float>) -> Bool {
        guard let c = hitNode(p) else { return false }
        endGrab()
        pointerW = invProject(p, z: liftH)
        let cx = X[c], cy = Y[c], cz = Z[c]
        let baseLift = max(liftH, cz + 6)
        for i in 0..<N {
            let dx = X[i] - cx, dy = Y[i] - cy
            let d = sqrtf(dx * dx + dy * dy)
            if d < grabR && abs(Z[i] - cz) < 25 {
                pins.append(Pin(i: i, dx: X[i] - pointerW.x, dy: Y[i] - pointerW.y,
                                lift: baseLift * (1 - 0.6 * d / grabR)))
                pinned[i] = 1
            }
        }
        settled = 0
        return true
    }

    func moveGrab(to p: SIMD2<Float>) {
        guard !pins.isEmpty else { return }
        let q = SIMD2(min(max(p.x, 0), viewW), min(max(p.y, 0), viewH))
        pointerW = invProject(q, z: liftH)
        settled = 0
    }

    func endGrab() {
        // let go calmly: keep only a little of the motion so the rug doesn't skate away
        for i in 0..<N {
            OX[i] = X[i] - (X[i] - OX[i]) * 0.1
            OY[i] = Y[i] - (Y[i] - OY[i]) * 0.1
        }
        for p in pins { pinned[p.i] = 0 }
        pins.removeAll()
        settled = 0
    }

    // MARK: vertex output

    /// Writes 9 floats per vertex: pos(3) uv(2) normal(3) ao(1) and refreshes screen-space positions.
    func fillVertices(_ out: UnsafeMutablePointer<Float>) {
        let NX = Cloth.NX, NY = Cloth.NY
        let zs: Float = 2.6
        for j in 0..<NY {
            for i in 0..<NX {
                let idx = j * NX + i
                let ip = min(i + 1, NX - 1), im = max(i - 1, 0)
                let jp = min(j + 1, NY - 1), jm = max(j - 1, 0)
                let a = j * NX + ip, b = j * NX + im, c = jp * NX + i, d = jm * NX + i
                let t1 = SIMD3<Float>(X[a] - X[b], Y[a] - Y[b], (Z[a] - Z[b]) * zs)
                let t2 = SIMD3<Float>(X[c] - X[d], Y[c] - Y[d], (Z[c] - Z[d]) * zs)
                var n = simd_cross(t1, t2)
                let l = simd_length(n)
                n = l > 1e-6 ? n / l : SIMD3<Float>(0, 0, 1)
                let lap = (Z[a] + Z[b] + Z[c] + Z[d]) * 0.25 - Z[idx]
                let ao = 1 - min(max(lap * 0.06, 0), 0.5)
                let o = idx * 9
                out[o] = X[idx]; out[o + 1] = Y[idx]; out[o + 2] = Z[idx]
                out[o + 3] = Float(i) / Float(NX - 1); out[o + 4] = Float(j) / Float(NY - 1)
                out[o + 5] = n.x; out[o + 6] = n.y; out[o + 7] = n.z
                out[o + 8] = ao
                let s = project(X[idx], Y[idx], Z[idx])
                SX[idx] = s.x; SY[idx] = s.y
            }
        }
    }

    static func makeIndices() -> [UInt16] {
        var idx: [UInt16] = []
        for j in 0..<(NY - 1) {
            for i in 0..<(NX - 1) {
                let a = UInt16(j * NX + i), b = a + 1, c = a + UInt16(NX), d = c + 1
                idx += [a, b, c, b, d, c]
            }
        }
        return idx
    }
}
