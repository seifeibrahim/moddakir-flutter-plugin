import 'session_info.dart';

class SessionInput {
  final String? requestId;
  final String? name;
  final String? gender;
  final String? email;
  final String? phone;
  final String? language;
  final String? appName;
  final String? apiKey;
  final int? callDuration;
  final String? callType;
  final bool? isDark;
  final int? primaryColor;
  final int? secondaryColor;
  final int? callBackgroundRes;
  final Map<String, dynamic>? metaData;
  final SessionInfo? sessionInfo;

  const SessionInput({
    this.requestId,
    this.name,
    this.gender,
    this.email,
    this.phone,
    this.language,
    this.appName,
    this.apiKey,
    this.callDuration,
    this.callType,
    this.isDark,
    this.primaryColor,
    this.secondaryColor,
    this.callBackgroundRes,
    this.metaData,
    this.sessionInfo,
  });

  Map<String, dynamic> toJson() => {
        'requestId': requestId,
        'name': name,
        'gender': gender,
        'email': email,
        'phone': phone,
        'language': language,
        'appName': appName,
        'apiKey': apiKey,
        'callDuration': callDuration,
        'callType': callType,
        'isDark': isDark,
        'primaryColor': primaryColor,
        'secondaryColor': secondaryColor,
        'callBackgroundRes': callBackgroundRes,
        'metaData': metaData,
        'sessionInfo': sessionInfo?.toJson(),
      };
}
