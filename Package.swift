// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "BreadDiary",
    platforms: [
        .iOS(.v16)
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "BreadDiary",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .testTarget(
            name: "BreadDiaryTests",
            dependencies: ["BreadDiary"]
        )
    ]
)
