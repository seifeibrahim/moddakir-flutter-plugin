class CallSession {
  final String callId;
  final String consumerId;
  final String providerId;
  final String status;
  final String channelName;
  final CallTokens tokens;

  const CallSession({
    required this.callId,
    required this.consumerId,
    required this.providerId,
    required this.status,
    required this.channelName,
    required this.tokens,
  });
}

class CallTokens {
  final String callApiKey;
  final String hostRtcToken;
  final String guestRtcToken;
  final String hostRtmToken;
  final String guestRtmToken;

  const CallTokens({
    required this.callApiKey,
    required this.hostRtcToken,
    required this.guestRtcToken,
    required this.hostRtmToken,
    required this.guestRtmToken,
  });
}
