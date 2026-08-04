import 'consumer.dart';

class SdkLogin {
  final String accessToken;
  final Consumer consumer;
  final String sdkSessionId;

  const SdkLogin({
    required this.accessToken,
    required this.consumer,
    required this.sdkSessionId,
  });
}
