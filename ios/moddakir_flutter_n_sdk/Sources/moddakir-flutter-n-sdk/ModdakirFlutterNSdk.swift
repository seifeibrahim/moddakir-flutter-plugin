import Flutter
import UIKit
import ModdakirNativeSDK
import ModdakirCalls

public class ModdakirFlutterNSdk: NSObject, FlutterPlugin {

    private var eventSink: FlutterEventSink?
    private static var eventChannel: FlutterEventChannel?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "moddakir_flutter_n_sdk",
            binaryMessenger: registrar.messenger()
        )

        let instance = ModdakirFlutterNSdk()

        registrar.addMethodCallDelegate(instance, channel: channel)

        eventChannel = FlutterEventChannel(
            name: "moddakir_flutter_n_sdk/events",
            binaryMessenger: registrar.messenger()
        )

        eventChannel?.setStreamHandler(instance)

        SDKManager.shared.delegate = instance
    }

    public func handle(
        _ call: FlutterMethodCall,
        result: @escaping FlutterResult
    ) {
        switch call.method {

        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)

        case "initializeCallSDK":
            handleInitializeCallSDK(
                call: call,
                result: result
            )

        case "startCallSession":
            handleStartCallSession(
                call: call,
                result: result
            )

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - Initialize SDK

    private func handleInitializeCallSDK(
        call: FlutterMethodCall,
        result: @escaping FlutterResult
    ) {
        let args = call.arguments as? [String: Any]
        let baseUrl = args?["baseUrl"] as? String ?? ""

        print("📱 [iOS Plugin] SDK initialized with baseUrl: \(baseUrl)")

        result(true)
    }

    // MARK: - Start Call Session

    private func handleStartCallSession(
        call: FlutterMethodCall,
        result: @escaping FlutterResult
    ) {
        guard let args = call.arguments as? [String: Any] else {
            result(
                FlutterError(
                    code: "INVALID_ARGS",
                    message: "Missing arguments",
                    details: nil
                )
            )
            return
        }

        // Required Parameters
        guard
            let accessToken = args["token"] as? String,
            let sdkSessionId = args["sdkSessionId"] as? String,
            let appName = args["appName"] as? String
        else {
            result(
                FlutterError(
                    code: "MISSING_REQUIRED_PARAMS",
                    message: "Missing required parameters:  token, sdkSessionId, appName",
                    details: nil
                )
            )
            return
        }

        // Parameters
        let callTypeStr =
            args["callType"] as? String
                ?? "Voice"

        let callType: SDKCallType =
            callTypeStr.lowercased() == "video"
                ? .video
                : .voice

        let language =
            args["language"] as? String
                ?? "ar"

        let themeStr =
            args["theme"] as? String
                ?? "system"

        let theme: SDKTheme = {
            switch themeStr.lowercased() {
            case "light":
                return .light

            case "dark":
                return .dark

            default:
                return .system
            }
        }()

        // SDK Configuration
        let config = SDKConfig(
            sdkSessionId: sdkSessionId,
            accessToken: accessToken,
            appName: appName,
            callType: callType,
            language: language,
            theme: theme
        )

        print("📱 [iOS Plugin] Starting SDK")
        print("   Access Token: \(accessToken.prefix(20))...")
        print("   SDK Session ID: \(sdkSessionId)")
        print("   App Name: \(appName)")
        print("   Call Type: \(callType.rawValue)")
        print("   Language: \(language)")


        guard
            let rootViewController = UIApplication.shared
                .connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: { $0.isKeyWindow })?
                .rootViewController
        else {
            result(
                FlutterError(
                    code: "NO_VIEW_CONTROLLER",
                    message: "Could not find root view controller",
                    details: nil
                )
            )
            return
        }

        var topController = rootViewController

        while let presented = topController.presentedViewController {
            topController = presented
        }

        DispatchQueue.main.async {
            SDKManager.shared.start(
                from: topController,
                config: config
            )

            result(true)
        }
    }

    // MARK: - Helper

    private func getCurrentFormattedDate() -> String {
        let formatter = ISO8601DateFormatter()

        formatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]

        return formatter.string(from: Date())
    }
}

// MARK: - ModdakirSDKDelegate

extension ModdakirFlutterNSdk: ModdakirSDKDelegate {

    public func statusUpdate(
        sessionId: String,
        status: String
    ) {
        print(
            "📱 [iOS Plugin] Status update for session: \(sessionId) - \(status)"
        )

        eventSink?([
                       "event": "statusUpdate",
                       "sessionId": sessionId,
                       "status": status
                   ])
    }

    public func reviewUpdate(
        sessionId: String,
        review: [String: String]
    ) {
        print(
            "📱 [iOS Plugin] Review update for session: \(sessionId)"
        )

        eventSink?([
                       "event": "reviewUpdate",
                       "sessionId": sessionId,
                       "review": review
                   ])
    }

    public func onUnauthorized(
        sessionId: String
    ) {
        print(
            "📱 [iOS Plugin] Unauthorized for session: \(sessionId)"
        )

        eventSink?([
                       "event": "onUnauthorized",
                       "sessionId": sessionId
                   ])
    }

    public func onError(
        sessionId: String,
        errorMessage: String,
        errorCode: String
    ) {
        print(
            "📱 [iOS Plugin] Error for session: \(sessionId) - \(errorMessage) (\(errorCode))"
        )

        eventSink?([
                       "event": "onError",
                       "sessionId": sessionId,
                       "errorMessage": errorMessage,
                       "errorCode": errorCode
                   ])
    }

    public func onPermissionDenied(
        micGranted: Bool,
        cameraGranted: Bool
    ) {
        print(
            "📱 [iOS Plugin] Permission denied - Mic: \(micGranted), Camera: \(cameraGranted)"
        )

        eventSink?([
                       "event": "onPermissionDenied",
                       "micGranted": micGranted,
                       "cameraGranted": cameraGranted
                   ])
    }
}

// MARK: - FlutterStreamHandler

extension ModdakirFlutterNSdk: FlutterStreamHandler {

    public func onListen(
        withArguments arguments: Any?,
        eventSink events: @escaping FlutterEventSink
    ) -> FlutterError? {

        self.eventSink = events

        print("📱 [iOS Plugin] Event stream started")

        return nil
    }

    public func onCancel(
        withArguments arguments: Any?
    ) -> FlutterError? {

        self.eventSink = nil

        print("📱 [iOS Plugin] Event stream cancelled")

        return nil
    }
}