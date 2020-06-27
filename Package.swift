// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FileUtils",
    products: [
        .library(
            name: "FileUtils",
            targets: ["FileUtils"]),
    ],
    dependencies: [
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "FileUtils",
            dependencies: []),
        .testTarget(
            name: "FileUtilsTests",
            dependencies: ["FileUtils"]),
    ]
)
