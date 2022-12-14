// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "APIKit",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .watchOS(.v6),
        .tvOS(.v13),
        .macCatalyst(.v13),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "APIKit",
            targets: ["APIKit"]),
        .library(
            name: "APIKitURL",
            targets: ["APIKitURL"]),
        .library(
            name: "APIKitOAuth1",
            targets: ["APIKitOAuth1"]),
        .library(
            name: "APIKitOAuth2",
            targets: ["APIKitOAuth2"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-crypto.git", "1.0.0" ..< "3.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "APIKit",
            dependencies: ["APIKitURL", "APIKitOAuth1", "APIKitOAuth2"]),
        .target(
            name: "APIKitCore",
            dependencies: []),
        .testTarget(
            name: "APIKitCoreTests",
            dependencies: ["APIKitCore"]),
        .target(
            name: "APIKitURL",
            dependencies: ["APIKitCore"]),
        .target(
            name: "APIKitOAuth1",
            dependencies: [
                "APIKitURL",
                .product(name: "Crypto", package: "swift-crypto"),
            ]),
        .testTarget(
            name: "APIKitOAuth1Tests",
            dependencies: ["APIKitURL", "APIKitOAuth1"]),
        .target(
            name: "APIKitOAuth2",
            dependencies: ["APIKitURL"]),
    ]
)
