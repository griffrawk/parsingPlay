// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "parsingPlay",
    platforms: [.macOS(.v10_15)],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-parsing", from: "0.7.0"),
        ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "parsingPlay",
            dependencies: [.product(name: "Parsing", package: "swift-parsing")]
        )
    ]
)
