class CreateCallResponse {
  final Call call;
  final String callApiKey;
  final String callApiCertificate;
  final String hostRtcToken;
  final String guestRtcToken;
  final String hostRtmToken;
  final String guestRtmToken;
  final String callProviderType;
  final String channelName;

  const CreateCallResponse({
    required this.call,
    required this.callApiKey,
    required this.callApiCertificate,
    required this.hostRtcToken,
    required this.guestRtcToken,
    required this.hostRtmToken,
    required this.guestRtmToken,
    required this.callProviderType,
    required this.channelName,
  });

  factory CreateCallResponse.fromJson(Map<String, dynamic> json) {
    return CreateCallResponse(
      call: Call.fromJson(json['call'] as Map<String, dynamic>),
      callApiKey: json['callApiKey'] as String,
      callApiCertificate: json['callApiCertificate'] as String,
      hostRtcToken: json['hostRtcToken'] as String,
      guestRtcToken: json['guestRtcToken'] as String,
      hostRtmToken: json['hostRtmToken'] as String,
      guestRtmToken: json['guestRtmToken'] as String,
      callProviderType: json['callProviderType'] as String,
      channelName: json['channelName'] as String,
    );
  }
}

class Call {
  final String id;
  final String consumerId;
  final String providerId;
  final String status;

  const Call({
    required this.id,
    required this.consumerId,
    required this.providerId,
    required this.status,
  });

  factory Call.fromJson(Map<String, dynamic> json) {
    return Call(
      id: json['id'] as String,
      consumerId: json['consumerId'] as String,
      providerId: json['providerId'] as String,
      status: json['status'] as String,
    );
  }
}
