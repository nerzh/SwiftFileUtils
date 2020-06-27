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
        .package(name: "SwiftRegularExpression", url: "https://github.com/nerzh/swift-regular-expression.git", .upToNextMajor(from: "0.2.2")),
    ],
    targets: [
        .target(
            name: "FileUtils",
            dependencies: [
                .product(name: "SwiftRegularExpression", package: "SwiftRegularExpression"),
            ]),
        .testTarget(
            name: "FileUtilsTests",
            dependencies: ["FileUtils"]),
    ]
)
