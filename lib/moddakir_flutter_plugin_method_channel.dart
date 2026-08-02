import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'moddakir_flutter_plugin_platform_interface.dart';

/// An implementation of [ModdakirFlutterPluginPlatform] that uses method channels.
class MethodChannelModdakirFlutterPlugin extends ModdakirFlutterPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('moddakir_flutter_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
