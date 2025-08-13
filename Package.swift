// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FormlyNative",
    platforms: [
        .iOS(.v16),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "FormlyNative",
            targets: ["FormlyNative"]),
    ],
    dependencies: [
        // Core dependencies
        .package(url: "https://github.com/ggerganov/llama.cpp.git", from: "0.2.0"),
        .package(url: "https://github.com/weichsel/ZIPFoundation.git", from: "0.9.0"),
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "4.2.0"),
        
        // Optional: Alternative to Core Data
        .package(url: "https://github.com/groue/GRDB.swift.git", from: "6.0.0"),
        
        // Testing dependencies
        .package(url: "https://github.com/Quick/Quick.git", from: "7.0.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "13.0.0"),
    ],
    targets: [
        .target(
            name: "FormlyNative",
            dependencies: [
                .product(name: "llama", package: "llama.cpp"),
                "ZIPFoundation",
                "KeychainAccess",
                .product(name: "GRDB", package: "GRDB.swift")
            ],
            resources: [
                .process("Resources/Templates"),
                .process("Resources/Localization"),
                .process("Resources/Assets")
            ]),
        .testTarget(
            name: "FormlyNativeTests",
            dependencies: [
                "FormlyNative",
                "Quick",
                "Nimble"
            ]),
    ]
)
