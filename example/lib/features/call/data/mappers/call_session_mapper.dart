import '../../domain/entities/call_session.dart';
import '../models/create_call_response.dart' as dto;

class CallSessionMapper {
  static CallSession toEntity(dto.CreateCallResponse response) {
    return CallSession(
      callId: response.call.id,
      consumerId: response.call.consumerId,
      providerId: response.call.providerId,
      status: response.call.status,
      channelName: response.channelName,
      tokens: CallTokens(
        callApiKey: response.callApiKey,
        hostRtcToken: response.hostRtcToken,
        guestRtcToken: response.guestRtcToken,
        hostRtmToken: response.hostRtmToken,
        guestRtmToken: response.guestRtmToken,
      ),
    );
  }
}
