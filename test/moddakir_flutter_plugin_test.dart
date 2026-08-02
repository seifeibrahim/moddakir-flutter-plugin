import 'package:flutter_test/flutter_test.dart';
import 'package:moddakir_flutter_plugin/moddakir_flutter_plugin.dart';
import 'package:moddakir_flutter_plugin/moddakir_flutter_plugin_platform_interface.dart';
import 'package:moddakir_flutter_plugin/moddakir_flutter_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockModdakirFlutterPluginPlatform
    with MockPlatformInterfaceMixin
    implements ModdakirFlutterPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final ModdakirFlutterPluginPlatform initialPlatform = ModdakirFlutterPluginPlatform.instance;

  test('$MethodChannelModdakirFlutterPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelModdakirFlutterPlugin>());
  });

  test('getPlatformVersion', () async {
    ModdakirFlutterPlugin moddakirFlutterPlugin = ModdakirFlutterPlugin();
    MockModdakirFlutterPluginPlatform fakePlatform = MockModdakirFlutterPluginPlatform();
    ModdakirFlutterPluginPlatform.instance = fakePlatform;

    expect(await moddakirFlutterPlugin.getPlatformVersion(), '42');
  });
}
