
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

  /// Initialize the Moddakir Call SDK
  /// Must be called before starting any calls
  Future<bool> initializeCallSDK() {
    return _platform.initializeCallSDK();
  }

  /// Start a call with the given configuration
  Future<bool> startCall(CallConfig config) {
    return _platform.startCall(config.toMap());
  }

  /// Start a call with simple parameters (convenience method)
  Future<bool> startCallSimple({
    required String callId,
    String? userId,
    String? sessionId,
    Map<String, dynamic>? additionalParams,
  }) {
    final params = {
      'callId': callId,
      if (userId != null) 'userId': userId,
      if (sessionId != null) 'sessionId': sessionId,
      ...?additionalParams,
    };
    return _platform.startCall(params);
  }
}
