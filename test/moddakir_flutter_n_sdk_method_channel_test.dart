import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moddakir_flutter_n_sdk/moddakir_flutter_n_sdk_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelModdakirFlutterNSdk platform = MethodChannelModdakirFlutterNSdk();
  const MethodChannel channel = MethodChannel('moddakir_flutter_n_sdk');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
