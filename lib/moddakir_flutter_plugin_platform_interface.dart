import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'moddakir_flutter_plugin_method_channel.dart';

abstract class ModdakirFlutterPluginPlatform extends PlatformInterface {
  /// Constructs a ModdakirFlutterPluginPlatform.
  ModdakirFlutterPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static ModdakirFlutterPluginPlatform _instance = MethodChannelModdakirFlutterPlugin();

  /// The default instance of [ModdakirFlutterPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelModdakirFlutterPlugin].
  static ModdakirFlutterPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ModdakirFlutterPluginPlatform] when
  /// they register themselves.
  static set instance(ModdakirFlutterPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
