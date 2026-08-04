class SdkLoginRequest {
  final String? fullName;
  final String? email;
  final String? phone;
  final String? gender;
  final String? callType;
  final int? callDuration;
  final String? startDate;
  final Map<String, dynamic>? sessionInfo;
  final Map<String, dynamic>? metaData;

  const SdkLoginRequest({
    this.fullName,
    this.email,
    this.phone,
    this.gender,
    this.callType,
    this.callDuration,
    this.startDate,
    this.sessionInfo,
    this.metaData,
  });

  Map<String, dynamic> toJson() => {
        if (fullName != null) 'fullName': fullName,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        if (gender != null) 'gender': gender,
        if (callType != null) 'callType': callType,
        if (callDuration != null) 'callDuration': callDuration,
        if (startDate != null) 'startDate': startDate,
        if (sessionInfo != null) 'sessionInfo': sessionInfo,
        if (metaData != null) 'metaData': metaData,
      };
}
