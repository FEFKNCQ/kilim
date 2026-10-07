// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Kilim",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(
            name: "Kilim",
            path: "Sources/Kilim",
            swiftSettings: [.unsafeFlags(["-Ounchecked"])]
        )
    ]
)
