// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FeatureDiary",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "FeatureDiary",
            targets: ["FeatureDiary"])
    ],
    dependencies: [
        .package(url: "https://github.com/michelgoni/NumbersEx", branch: "main"),
        .package(url: "https://github.com/michelgoni/NumbersInjector", branch: "main"),
        .package(url: "https://github.com/michelgoni/NumbersUI", branch: "main")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "FeatureDiary",
            dependencies: [.product(name: "NumbersInjector", package: "NumbersInjector"),
                           .product(name: "NumbersUI", package: "NumbersUI"),
                           .product(name: "NumbersEx", package: "NumbersEx")
            ]),
        .testTarget(
            name: "FeatureDiaryTests",
            dependencies: ["FeatureDiary"])
    ]
)
