import '../entities/sdk_login.dart';
import '../entities/provider.dart';
import '../entities/call_session.dart';
import '../entities/session_input.dart';

abstract class CallRepository {
  Future<SdkLogin> loginToSdk(SessionInput sessionInput);
  
  Future<Provider> getRandomProvider();
  
  Future<CallSession> createCall({
    required String consumerId,
    required String providerId,
    required String consumerName,
    required String providerName,
    required String consumerCountry,
    required String consumerAvatarUrl,
    required String providerAvatarUrl,
    required String callType,
  });
  
  Future<void> updateCallLog({
    required String callId,
    required String status,
    required DateTime endDateTime,
    required int duration,
    required bool isHangupByTeacher,
    required bool isHangupByStudent,
  });
  
  Future<void> joinAgoraSignaling({
    required String channelName,
    required bool voip,
    required bool huawei,
  });
}
