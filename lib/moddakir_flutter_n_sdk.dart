
import 'src/platform/moddakir_platform_channel.dart';
import 'src/models/call_event.dart';

export 'src/models/call_event.dart';
export 'src/models/call_config.dart';

class ModdakirFlutterNSdk {
  static final ModdakirFlutterNSdk _instance = ModdakirFlutterNSdk._internal();
  factory ModdakirFlutterNSdk() => _instance;
  ModdakirFlutterNSdk._internal();

  static ModdakirFlutterNSdk get instance => _instance;

  final ModdakirPlatformChannel _platform = ModdakirPlatformChannel();

  /// Stream of call events (call ended, state updates, etc.)
  Stream<CallEvent> get callEvents => _platform.callEvents;

  /// Get the platform version (for debugging)
  Future<String?> getPlatformVersion() {
    return _platform.getPlatformVersion();
  }

  /// Initialize the Call SDK
  Future<bool> initializeCallSDK() async {
    return await _platform.initializeCallSDK();
  }

  /// Start a call session with user data
  /// The SDK will handle login, teacher search, and call creation internally
  Future<bool> startCallSession({
    required String name,
    required String email,
    required String phone,
    required String gender,
    required String language,
    required String appName,
    required String apiKey,
    required String callType,
    bool isDark = false,
    int? primaryColor,
    int? secondaryColor,
    Map<String, dynamic>? metaData,
    Map<String, dynamic>? sessionInfo,
    int callDuration = 30,
    String? startDate,
    int maxNumCalls = 3,
    String environment = 'sandbox',
    String? sdkSessionId,  // Session ID from /auth/protected/sdk/session API
    String? token,  // Access token from /auth/protected/sdk/session API (required for iOS)
    String? theme,  // Theme: light, dark, system
  }) async {
    return await _platform.startCallSession(
      name: name,
      email: email,
      phone: phone,
      gender: gender,
      language: language,
      appName: appName,
      apiKey: apiKey,
      callType: callType,
      isDark: isDark,
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
      metaData: metaData,
      sessionInfo: sessionInfo,
      callDuration: callDuration,
      startDate: startDate,
      maxNumCalls: maxNumCalls,
      environment: environment,
      sdkSessionId: sdkSessionId,
      token: token,
      theme: theme,
    );
  }
}
