// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "tidal-api-interchange-kit",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(name: "TidalAPIInterchangeKit",
                 targets: ["TidalAPIInterchangeKit"]),
        .library(name: "TidalAPIDataPresets",
                 targets: ["TidalAPIDataPresets"])
    ],
    dependencies: [
        .package(url: "https://github.com/antarianLogic/interchange", from: "1.0.4")
    ],
    targets: [
        .target(name: "TidalAPIInterchangeKit",
                dependencies: [.product(name: "Interchange", package: "interchange")]),
        .target(name: "TidalAPIDataPresets",
                dependencies: ["TidalAPIInterchangeKit"],
                resources: [.copy("JSON")]),
        .testTarget(name: "TidalAPIInterchangeKitTests",
                    dependencies: ["TidalAPIInterchangeKit",
                                   "TidalAPIDataPresets"])
    ]
)
