class SessionRequestModel {
  final int callDuration;
  final String callType;
  final String email;
  final String fullName;
  final String gender;
  final String phone;
  final Map<String, dynamic>? sessionInfo;
  final String startDate;
  final String language;
  final String moddakirId;
  final String moddakirKey;

  SessionRequestModel({
    required this.callDuration,
    required this.callType,
    required this.email,
    required this.fullName,
    required this.gender,
    required this.phone,
    this.sessionInfo,
    required this.startDate,
    required this.language,
    required this.moddakirId,
    required this.moddakirKey,
  });

  Map<String, dynamic> toJson() {
    return {
      'callDuration': callDuration,
      'callType': callType,
      'email': email,
      'fullName': fullName,
      'gender': gender,
      'phone': phone,
      if (sessionInfo != null) 'sessionInfo': sessionInfo,
      'startDate': startDate,
    };
  }
}
