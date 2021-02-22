// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Regex",
    products: [
        .library(
            name: "Regex",
            targets: ["Regex"]),
    ],
    targets: [
        .target(
            name: "Regex",
            dependencies: []),
        .testTarget(
            name: "RegexTests",
            dependencies: ["Regex"]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
