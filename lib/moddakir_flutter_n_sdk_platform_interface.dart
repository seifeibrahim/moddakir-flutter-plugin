import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'moddakir_flutter_n_sdk_method_channel.dart';

abstract class ModdakirFlutterNSdkPlatform extends PlatformInterface {
  /// Constructs a ModdakirFlutterNSdkPlatform.
  ModdakirFlutterNSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static ModdakirFlutterNSdkPlatform _instance = MethodChannelModdakirFlutterNSdk();

  /// The default instance of [ModdakirFlutterNSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelModdakirFlutterNSdk].
  static ModdakirFlutterNSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ModdakirFlutterNSdkPlatform] when
  /// they register themselves.
  static set instance(ModdakirFlutterNSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
