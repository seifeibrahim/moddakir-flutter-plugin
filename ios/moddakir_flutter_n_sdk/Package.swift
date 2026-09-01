// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "moddakir_flutter_n_sdk",

    platforms: [
        .iOS("15.0"),
        .macOS("10.15")
    ],

    products: [
        .library(
            name: "moddakir-flutter-n-sdk",
            targets: ["moddakir_flutter_n_sdk"]
        )
    ],

    dependencies: [
        .package(
            name: "FlutterFramework",
            path: "../FlutterFramework"
        ),

        .package(
            url: "https://github.com/Moddakir-App/moddakir-ios-n-sdk.git",
            branch: "main"
        )
    ],

    targets: [
        .target(
            name: "moddakir_flutter_n_sdk",

            dependencies: [
                .product(
                    name: "FlutterFramework",
                    package: "FlutterFramework"
                ),

                .product(
                    name: "ModdakirNativeSDK",
                    package: "moddakir-ios-n-sdk"
                )
            ],

            resources: [
                .process("PrivacyInfo.xcprivacy")
            ]
        )
    ]
)