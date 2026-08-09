// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "moddakir_flutter_plugin",

    platforms: [
        .iOS("13.0"),
        .macOS("10.15")
    ],

    products: [
        .library(
            name: "moddakir-flutter-plugin",
            targets: ["moddakir_flutter_plugin"]
        )
    ],

    dependencies: [
        .package(
            name: "FlutterFramework",
            path: "../FlutterFramework"
        ),

        .package(
            url: "https://github.com/Moddakir-App/moddakir-ios-n-sdk.git",
            from: "1.0.1"
        )
    ],

    targets: [
        .target(
            name: "moddakir_flutter_plugin",

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