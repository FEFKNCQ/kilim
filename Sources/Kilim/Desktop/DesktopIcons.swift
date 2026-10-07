import AppKit

/// Reads the positions of the real Finder desktop icons (needs Automation permission for Finder).
/// Runs `osascript` as a separate process so a slow Finder can never block the UI thread.
final class DesktopIcons {
    var onChange: (([SIMD2<Float>]) -> Void)?
    var onPermissionProblem: (() -> Void)?
    var suspended = false               // set while the user drags the rug
    private let queue = DispatchQueue(label: "app.kilim.desktop-icons", qos: .utility)
    private var busy = false
    private var last: [Int] = []
    private(set) var denied = false

    func poll() {
        if busy || suspended { return }
        busy = true
        queue.async { [weak self] in
            let p = Process()
            p.executableURL = URL(fileURLWithPath: "/usr/bin/osascript")
            p.arguments = ["-e", "tell application \"Finder\" to get desktop position of every item of desktop"]
            let out = Pipe(), err = Pipe()
            p.standardOutput = out
            p.standardError = err
            var failed = false
            var flat: [Int] = []
            do {
                try p.run()
                let data = out.fileHandleForReading.readDataToEndOfFile()
                p.waitUntilExit()
                if p.terminationStatus != 0 { failed = true }
                else if let s = String(data: data, encoding: .utf8) {
                    flat = s.split(whereSeparator: { $0 == "," || $0.isWhitespace })
                        .compactMap { Int($0) }
                }
            } catch { failed = true }
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.busy = false
                if failed {
                    if !self.denied { self.denied = true; self.onPermissionProblem?() }
                    return
                }
                self.denied = false
                if flat != self.last {
                    self.last = flat
                    var pts: [SIMD2<Float>] = []
                    var i = 0
                    while i + 1 < flat.count { pts.append(SIMD2(Float(flat[i]), Float(flat[i + 1]))); i += 2 }
                    self.onChange?(pts)
                }
            }
        }
    }
}
