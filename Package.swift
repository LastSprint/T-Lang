// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "T-Lang",
    products: [
        .library(
            name: "Lexer",
            targets: ["Lexer"]
        ),
    ],
    targets: [
        .target(
            name: "Lexer",
            dependencies: ["Common"]
        ),
        .target(
            name: "Common",
            dependencies: []
        ),
        .testTarget(
            name: "LexerTests",
            dependencies: ["Lexer"]
        ),
    ]
)
