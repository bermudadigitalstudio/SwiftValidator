// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "SwiftValidator",
    products: [
        .library(name: "SwiftValidator", targets: ["SwiftValidator"])
    ],
    targets:[
        .target(name:"SwiftValidator", dependencies: []),
        .testTarget(name: "SwiftValidatorTests", dependencies: ["SwiftValidator"])
    ]
)