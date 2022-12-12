# APIKit

An experimental API Toolkit for Swift.

### Features
- Built on Swift Concurrency, Codable
- Supports OAuth1, OAuth2
- Supports other than Apple platforms! (Linux, Windows, etc.)

### Usage

##### `Package.swift`
```swift
// swift-tools-version:5.7
import PackageDescription

let package = Package(
  name: "<#PackageName#>",
  dependencies: [
    .package(
      url: "https://github.com/shizukusoft/swift-api-kit.git", 
      .upToNextMinor(from: "0.1.0") // or `.upToNextMajor
    )
  ],
  targets: [
    .target(
      name: "<#TargetName#>",
      dependencies: [
        .product(name: "APIKit", package: "APIKit")
      ]
    )
  ]
)
```
