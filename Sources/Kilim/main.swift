import AppKit

// Headless developer modes (--selftest, --texture, --langtest, ...) exit before any UI is created.
Diagnostics.runIfRequested()

final class AppDelegate: NSObject, NSApplicationDelegate {
    var controller: RugController?
    func applicationDidFinishLaunching(_ notification: Notification) {
        controller = RugController()
    }
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { false }
}

let app = NSApplication.shared
app.setActivationPolicy(.accessory)   // menu-bar only, no Dock icon
let delegate = AppDelegate()
app.delegate = delegate
app.run()
