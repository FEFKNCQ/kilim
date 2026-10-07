import AppKit
import MetalKit
import simd

private let shaderSource = """
#include <metal_stdlib>
using namespace metal;

struct U {
    float2 view;
    float2 center;
    float  K;
    float  pad;
    float2 texel;
    float2 offset;
    float  alpha;
    float  pad2;
    float4 light;
    float4 tint;
    float4 shadow;
};

struct RugOut {
    float4 pos [[position]];
    float2 uv;
    float3 nor;
    float  ao;
};

vertex RugOut rugVS(uint vid [[vertex_id]],
                    const device float* vb [[buffer(0)]],
                    constant U& u [[buffer(1)]]) {
    const device float* v = vb + vid * 9;
    float3 p = float3(v[0], v[1], v[2]);
    float2 s = p.xy + (p.xy - u.center) * p.z * u.K - u.offset;
    RugOut o;
    o.pos = float4(s.x / u.view.x * 2.0 - 1.0, 1.0 - s.y / u.view.y * 2.0,
                   clamp(0.5 - p.z / 800.0, 0.0, 1.0), 1.0);
    o.uv = float2(v[3], v[4]);
    o.nor = float3(v[5], v[6], v[7]);
    o.ao = v[8];
    return o;
}

fragment float4 rugFS(RugOut in [[stage_in]],
                      bool front [[front_facing]],
                      texture2d<float> tex [[texture(0)]],
                      constant U& u [[buffer(1)]]) {
    constexpr sampler smp(filter::linear, mip_filter::linear, address::clamp_to_edge, max_anisotropy(4));
    float4 t = tex.sample(smp, in.uv);
    if (t.a < 0.4) discard_fragment();
    float3 N = normalize(in.nor);
    if (!front) N = -N;
    float3 col = t.rgb;
    if (!front) {
        // underside of a rug: same pattern seen through the weave, duller and a bit darker
        float g = dot(col, float3(0.3, 0.59, 0.11));
        col = mix(col, float3(g), 0.38) * 0.80 + float3(0.035, 0.025, 0.01);
    }
    float3 L = normalize(u.light.xyz);
    float d = max(dot(N, L), 0.0);
    float lit = 0.42 + 0.58 * clamp(d / L.z, 0.0, 1.4);
    lit = mix(0.62, lit, u.light.w);
    float3 Hh = normalize(L + float3(0.0, 0.0, 1.0));
    float spec = pow(max(dot(N, Hh), 0.0), 28.0) * 0.10 * u.light.w;
    col = col * lit * in.ao * u.tint.rgb + spec * float3(1.0, 0.92, 0.8);
    return float4(col * u.alpha, u.alpha);
}

// ---- shadow ----
struct ShOut { float4 pos [[position]]; float2 uv; float inten; };

vertex ShOut shadowVS(uint vid [[vertex_id]],
                      const device float* vb [[buffer(0)]],
                      constant U& u [[buffer(1)]]) {
    const device float* v = vb + vid * 9;
    float3 p = float3(v[0], v[1], v[2]);
    float2 s = p.xy - u.offset + u.shadow.xy * p.z + u.shadow.zw;
    ShOut o;
    o.pos = float4(s.x / u.view.x * 2.0 - 1.0, 1.0 - s.y / u.view.y * 2.0, 0.0, 1.0);
    o.uv = float2(v[3], v[4]);
    o.inten = exp(-p.z / 55.0);
    return o;
}

fragment float4 shadowFS(ShOut in [[stage_in]], texture2d<float> tex [[texture(0)]]) {
    constexpr sampler smp(filter::linear, mip_filter::linear, address::clamp_to_edge);
    float a = tex.sample(smp, in.uv).a;
    if (a < 0.35) discard_fragment();
    return float4(in.inten, in.inten, in.inten, in.inten);
}

struct FsOut { float4 pos [[position]]; float2 uv; };

vertex FsOut fsVS(uint vid [[vertex_id]]) {
    float2 p = float2((vid << 1) & 2, vid & 2);
    FsOut o;
    o.pos = float4(p * 2.0 - 1.0, 0.0, 1.0);
    o.uv = float2(p.x, 1.0 - p.y);
    return o;
}

fragment float4 compFS(FsOut in [[stage_in]],
                       texture2d<float> sh [[texture(0)]],
                       constant U& u [[buffer(1)]]) {
    constexpr sampler smp(filter::linear, address::clamp_to_edge);
    float a = sh.sample(smp, in.uv).r * 0.20;
    const int N = 12;
    float w = 0.20;
    for (int i = 0; i < N; i++) {
        float ang = float(i) * 0.5235988;           // 30 degrees
        float r = (i % 2 == 0) ? 1.6 : 3.2;
        float2 off = float2(cos(ang), sin(ang)) * r * u.texel;
        float wt = (i % 2 == 0) ? 0.10 : 0.05;
        a += sh.sample(smp, in.uv + off).r * wt;
        w += wt;
    }
    a = a / w;
    a = min(a * 0.62 * u.tint.w, 0.62) * u.alpha;
    return float4(0.0, 0.0, 0.0, a);
}
"""

struct Uniforms {
    var view: SIMD2<Float>
    var center: SIMD2<Float>
    var K: Float
    var pad: Float = 0
    var texel: SIMD2<Float>
    var offset: SIMD2<Float> = .zero
    var alpha: Float = 1
    var pad2: Float = 0
    var light: SIMD4<Float>
    var tint: SIMD4<Float>
    var shadow: SIMD4<Float>
}

final class Renderer {
    static let sampleCount = 4

    let device: MTLDevice
    let queue: MTLCommandQueue
    let rugPSO: MTLRenderPipelineState
    let shadowPSO: MTLRenderPipelineState
    let compPSO: MTLRenderPipelineState
    let depthOn: MTLDepthStencilState
    let depthOff: MTLDepthStencilState
    var rugTex: MTLTexture
    var shadowTex: MTLTexture?
    let indexBuf: MTLBuffer
    let indexCount: Int
    var vbufs: [MTLBuffer] = []
    var frame = 0
    let sem = DispatchSemaphore(value: 3)
    var viewSize = SIMD2<Float>(1440, 900)
    /// where this screen's top-left corner sits in the shared cloth coordinates
    var offset = SIMD2<Float>(0, 0)
    var alpha: Float = 1
    var env = LightEnv.neutral

    init(device: MTLDevice, texture: MTLTexture? = nil) {
        self.device = device
        queue = device.makeCommandQueue()!

        let lib: MTLLibrary
        do { lib = try device.makeLibrary(source: shaderSource, options: nil) }
        catch { fatalError("Shader compile error: \(error)") }

        func pso(_ vs: String, _ fs: String, color: MTLPixelFormat, depth: Bool, samples: Int,
                 blend: (MTLRenderPipelineColorAttachmentDescriptor) -> Void) -> MTLRenderPipelineState {
            let d = MTLRenderPipelineDescriptor()
            d.vertexFunction = lib.makeFunction(name: vs)
            d.fragmentFunction = lib.makeFunction(name: fs)
            d.colorAttachments[0].pixelFormat = color
            if depth { d.depthAttachmentPixelFormat = .depth32Float }
            d.rasterSampleCount = samples
            blend(d.colorAttachments[0])
            return try! device.makeRenderPipelineState(descriptor: d)
        }
        let premult: (MTLRenderPipelineColorAttachmentDescriptor) -> Void = {
            $0.isBlendingEnabled = true
            $0.sourceRGBBlendFactor = .one; $0.sourceAlphaBlendFactor = .one
            $0.destinationRGBBlendFactor = .oneMinusSourceAlpha; $0.destinationAlphaBlendFactor = .oneMinusSourceAlpha
        }
        rugPSO = pso("rugVS", "rugFS", color: .bgra8Unorm, depth: true, samples: Renderer.sampleCount) { _ in }
        compPSO = pso("fsVS", "compFS", color: .bgra8Unorm, depth: true, samples: Renderer.sampleCount, blend: premult)
        shadowPSO = pso("shadowVS", "shadowFS", color: .bgra8Unorm, depth: false, samples: 1) {
            $0.isBlendingEnabled = true
            $0.rgbBlendOperation = .max; $0.alphaBlendOperation = .max
            $0.sourceRGBBlendFactor = .one; $0.sourceAlphaBlendFactor = .one
            $0.destinationRGBBlendFactor = .one; $0.destinationAlphaBlendFactor = .one
        }

        let dOn = MTLDepthStencilDescriptor()
        dOn.depthCompareFunction = .less; dOn.isDepthWriteEnabled = true
        depthOn = device.makeDepthStencilState(descriptor: dOn)!
        let dOff = MTLDepthStencilDescriptor()
        dOff.depthCompareFunction = .always; dOff.isDepthWriteEnabled = false
        depthOff = device.makeDepthStencilState(descriptor: dOff)!

        rugTex = texture ?? Renderer.makeTexture(device: device, theme: Renderer.savedTheme)

        let idx = Cloth.makeIndices()
        indexCount = idx.count
        indexBuf = device.makeBuffer(bytes: idx, length: idx.count * 2, options: .storageModeShared)!
        let vlen = Cloth.NX * Cloth.NY * 9 * 4
        for _ in 0..<3 { vbufs.append(device.makeBuffer(length: vlen, options: .storageModeShared)!) }
    }

    static var savedTheme: RugTheme { RugTheme(rawValue: UserDefaults.standard.string(forKey: "rugTheme") ?? "") ?? .kashan }

    static func makeTexture(device: MTLDevice, theme: RugTheme) -> MTLTexture {
        let img = RugTexture.make(theme: theme)
        return try! MTKTextureLoader(device: device).newTexture(cgImage: img, options: [
            .generateMipmaps: true, .SRGB: false,
            .origin: MTKTextureLoader.Origin.topLeft,
            .textureUsage: MTLTextureUsage.shaderRead.rawValue,
        ])
    }

    func resize(_ size: CGSize) {
        viewSize = SIMD2(Float(size.width), Float(size.height))
        let d = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .bgra8Unorm,
                                                         width: max(8, Int(size.width * 0.3)),
                                                         height: max(8, Int(size.height * 0.3)), mipmapped: false)
        d.usage = [.renderTarget, .shaderRead]
        d.storageMode = .private
        shadowTex = device.makeTexture(descriptor: d)
    }

    private var msaaColor: MTLTexture?
    private var msaaDepth: MTLTexture?

    /// Pass that draws into 4x MSAA colour + depth targets and resolves into `target` (the drawable).
    /// On Apple GPUs the MSAA targets are *memoryless*: they live in tile memory only, so they cost no RAM.
    /// (Letting MTKView own them instead costs ~120 MB per 2560x1440 display.)
    func makePass(resolvingInto target: MTLTexture) -> MTLRenderPassDescriptor {
        let w = target.width, h = target.height
        if msaaColor?.width != w || msaaColor?.height != h {
            let storage: MTLStorageMode = device.supportsFamily(.apple1) ? .memoryless : .private
            func make(_ fmt: MTLPixelFormat) -> MTLTexture {
                let d = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: fmt, width: w, height: h, mipmapped: false)
                d.textureType = .type2DMultisample; d.sampleCount = Renderer.sampleCount
                d.usage = .renderTarget; d.storageMode = storage
                return device.makeTexture(descriptor: d)!
            }
            msaaColor = make(.bgra8Unorm)
            msaaDepth = make(.depth32Float)
        }
        let pass = MTLRenderPassDescriptor()
        pass.colorAttachments[0].texture = msaaColor
        pass.colorAttachments[0].resolveTexture = target
        pass.colorAttachments[0].loadAction = .clear
        pass.colorAttachments[0].clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 0)
        pass.colorAttachments[0].storeAction = .multisampleResolve
        pass.depthAttachment.texture = msaaDepth
        pass.depthAttachment.loadAction = .clear
        pass.depthAttachment.clearDepth = 1
        pass.depthAttachment.storeAction = .dontCare
        return pass
    }

    func render(cloth: Cloth, pass: MTLRenderPassDescriptor, drawable: MTLDrawable?, completion: (() -> Void)? = nil) {
        guard let shadowTex = shadowTex else { return }
        // GPU still busy with 3 frames? skip this one instead of blocking the main thread
        if drawable != nil {
            if sem.wait(timeout: .now() + .milliseconds(4)) == .timedOut { return }
        } else { sem.wait() }
        let cmd = queue.makeCommandBuffer()!
        let sem = self.sem
        cmd.addCompletedHandler { _ in sem.signal(); completion?() }

        let vb = vbufs[frame % 3]; frame += 1
        cloth.fillVertices(vb.contents().assumingMemoryBound(to: Float.self))

        var u = Uniforms(view: viewSize, center: SIMD2(cloth.viewW, cloth.viewH) / 2, K: cloth.K,
                         texel: SIMD2(1 / Float(shadowTex.width), 1 / Float(shadowTex.height)),
                         offset: offset, alpha: alpha, light: env.light, tint: env.tint, shadow: env.shadow)

        // 1) shadow map (low-res, max-blended)
        let sp = MTLRenderPassDescriptor()
        sp.colorAttachments[0].texture = shadowTex
        sp.colorAttachments[0].loadAction = .clear
        sp.colorAttachments[0].clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 0)
        sp.colorAttachments[0].storeAction = .store
        let e1 = cmd.makeRenderCommandEncoder(descriptor: sp)!
        e1.setRenderPipelineState(shadowPSO)
        e1.setVertexBuffer(vb, offset: 0, index: 0)
        e1.setVertexBytes(&u, length: MemoryLayout<Uniforms>.stride, index: 1)
        e1.setFragmentTexture(rugTex, index: 0)
        e1.drawIndexedPrimitives(type: .triangle, indexCount: indexCount, indexType: .uint16, indexBuffer: indexBuf, indexBufferOffset: 0)
        e1.endEncoding()

        // 2) blurred shadow + rug
        let e2 = cmd.makeRenderCommandEncoder(descriptor: pass)!
        e2.setDepthStencilState(depthOff)
        e2.setRenderPipelineState(compPSO)
        e2.setFragmentTexture(shadowTex, index: 0)
        e2.setFragmentBytes(&u, length: MemoryLayout<Uniforms>.stride, index: 1)
        // only blur/blend shadow where the rug (plus its shadow) can be
        var minX: Float = 1e9, minY: Float = 1e9, maxX: Float = -1e9, maxY: Float = -1e9
        for i in 0..<cloth.N {
            let sx = cloth.SX[i] - offset.x, sy = cloth.SY[i] - offset.y
            minX = min(minX, sx); maxX = max(maxX, sx)
            minY = min(minY, sy); maxY = max(maxY, sy)
        }
        let sc = Float(pass.colorAttachments[0].texture?.width ?? 1) / viewSize.x
        let m: Float = 90
        let x0 = max(0, Int((minX - m) * sc)), y0 = max(0, Int((minY - m) * sc))
        let tw = pass.colorAttachments[0].texture?.width ?? 1, th = pass.colorAttachments[0].texture?.height ?? 1
        let x1 = min(tw, Int((maxX + m) * sc)), y1 = min(th, Int((maxY + m) * sc))
        if x1 > x0 && y1 > y0 {
            e2.setScissorRect(MTLScissorRect(x: x0, y: y0, width: x1 - x0, height: y1 - y0))
            e2.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
            e2.setScissorRect(MTLScissorRect(x: 0, y: 0, width: tw, height: th))
        }

        e2.setDepthStencilState(depthOn)
        e2.setRenderPipelineState(rugPSO)
        e2.setFrontFacing(.clockwise)
        e2.setCullMode(.none)
        e2.setVertexBuffer(vb, offset: 0, index: 0)
        e2.setVertexBytes(&u, length: MemoryLayout<Uniforms>.stride, index: 1)
        e2.setFragmentBytes(&u, length: MemoryLayout<Uniforms>.stride, index: 1)
        e2.setFragmentTexture(rugTex, index: 0)
        e2.drawIndexedPrimitives(type: .triangle, indexCount: indexCount, indexType: .uint16, indexBuffer: indexBuf, indexBufferOffset: 0)
        e2.endEncoding()

        if let d = drawable { cmd.present(d) }
        cmd.commit()
    }

    // MARK: offscreen (self test)

    func renderOffscreen(cloth: Cloth, width: Int, height: Int) -> [UInt8] {
        func tex(_ fmt: MTLPixelFormat, ms: Bool, usage: MTLTextureUsage, storage: MTLStorageMode) -> MTLTexture {
            let d = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: fmt, width: width, height: height, mipmapped: false)
            if ms { d.textureType = .type2DMultisample; d.sampleCount = Renderer.sampleCount }
            d.usage = usage; d.storageMode = storage
            return device.makeTexture(descriptor: d)!
        }
        let msaa = tex(.bgra8Unorm, ms: true, usage: .renderTarget, storage: .private)
        let resolve = tex(.bgra8Unorm, ms: false, usage: [.renderTarget, .shaderRead], storage: .shared)
        let depth = tex(.depth32Float, ms: true, usage: .renderTarget, storage: .private)
        let pass = MTLRenderPassDescriptor()
        pass.colorAttachments[0].texture = msaa
        pass.colorAttachments[0].resolveTexture = resolve
        pass.colorAttachments[0].loadAction = .clear
        pass.colorAttachments[0].clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 0)
        pass.colorAttachments[0].storeAction = .multisampleResolve
        pass.depthAttachment.texture = depth
        pass.depthAttachment.loadAction = .clear
        pass.depthAttachment.clearDepth = 1
        pass.depthAttachment.storeAction = .dontCare
        let done = DispatchSemaphore(value: 0)
        render(cloth: cloth, pass: pass, drawable: nil) { done.signal() }
        done.wait()
        var bytes = [UInt8](repeating: 0, count: width * height * 4)
        resolve.getBytes(&bytes, bytesPerRow: width * 4, from: MTLRegionMake2D(0, 0, width, height), mipmapLevel: 0)
        return bytes
    }
}
