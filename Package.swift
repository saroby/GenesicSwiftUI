// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GenesicSwiftUI",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "GenesicSwiftUI",
            targets: ["GenesicSwiftUI"]
        ),
    ],
    targets: [
        .target(
            name: "GenesicSwiftUI"
//            ,
//            resources: [
//                .process("Resources/Assets.xcassets"),
//            ]
        ),
        .testTarget(
            name: "GenesicSwiftUITest",
            dependencies: ["GenesicSwiftUI"],
            path: "Tests/GenesicSwiftUITest"
        ),
    ],
    swiftLanguageModes: [.v6]
)
