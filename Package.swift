// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "CBOR",
    products: [
        .library(
            name: "CBOR",
            targets: ["CBOR"]),
    ],
    targets: [
        .target(
            name: "CBOR",
            dependencies: []),
        .testTarget(
            name: "CBORTests",
            dependencies: ["CBOR"]),
    ]
)
