class SessionResponseModel {
  final String token;
  final String sdkSessionId;

  SessionResponseModel({
    required this.token,
    required this.sdkSessionId,
  });

  factory SessionResponseModel.fromJson(Map<String, dynamic> json) {
    return SessionResponseModel(
      token: json['token'] as String,
      sdkSessionId: json['sdkSessionId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'sdkSessionId': sdkSessionId,
    };
  }
}
