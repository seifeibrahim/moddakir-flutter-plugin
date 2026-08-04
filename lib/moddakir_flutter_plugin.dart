
import 'src/platform/moddakir_platform_channel.dart';
import 'src/models/call_event.dart';
import 'src/models/call_config.dart';

export 'src/models/call_event.dart';
export 'src/models/call_config.dart';

class ModdakirFlutterPlugin {
  static final ModdakirFlutterPlugin _instance = ModdakirFlutterPlugin._internal();
  factory ModdakirFlutterPlugin() => _instance;
  ModdakirFlutterPlugin._internal();

  static ModdakirFlutterPlugin get instance => _instance;

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
    );
  }
}
