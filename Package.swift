// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RedisApi",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(name: "RedisApi", targets: ["RedisApi"]),
    ],
    dependencies: [
        // Event-driven network application framework for high performance protocol servers & clients, non-blocking.
        .package(url: "https://github.com/vapor/core.git", from: "3.0.0"),
    ],
    targets: [
        .target(name: "RedisApi", dependencies: ["Core"]),
        .testTarget(name: "RedisApiTests", dependencies: ["RedisApi"]),
    ]
)
