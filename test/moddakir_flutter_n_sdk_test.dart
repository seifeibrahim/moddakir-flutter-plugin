import 'package:flutter_test/flutter_test.dart';
import 'package:moddakir_flutter_n_sdk/moddakir_flutter_n_sdk.dart';
import 'package:moddakir_flutter_n_sdk/moddakir_flutter_n_sdk_platform_interface.dart';
import 'package:moddakir_flutter_n_sdk/moddakir_flutter_n_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockModdakirFlutterNSdkPlatform
    with MockPlatformInterfaceMixin
    implements ModdakirFlutterNSdkPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final ModdakirFlutterNSdkPlatform initialPlatform = ModdakirFlutterNSdkPlatform.instance;

  test('$MethodChannelModdakirFlutterNSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelModdakirFlutterNSdk>());
  });

  test('getPlatformVersion', () async {
    ModdakirFlutterNSdk moddakirFlutterNSdk = ModdakirFlutterNSdk();
    MockModdakirFlutterNSdkPlatform fakePlatform = MockModdakirFlutterNSdkPlatform();
    ModdakirFlutterNSdkPlatform.instance = fakePlatform;

    expect(await moddakirFlutterNSdk.getPlatformVersion(), '42');
  });
}
