class CallConfig {
  final String callId;
  final String? userId;
  final String? sessionId;
  final String? teacherId;
  final String? studentId;
  final bool? enableVideo;
  final bool? enableAudio;
  final Map<String, dynamic>? metadata;

  CallConfig({
    required this.callId,
    this.userId,
    this.sessionId,
    this.teacherId,
    this.studentId,
    this.enableVideo = true,
    this.enableAudio = true,
    this.metadata,
  });

  Map<String, dynamic> toMap() {
    return {
      'callId': callId,
      if (userId != null) 'userId': userId,
      if (sessionId != null) 'sessionId': sessionId,
      if (teacherId != null) 'teacherId': teacherId,
      if (studentId != null) 'studentId': studentId,
      if (enableVideo != null) 'enableVideo': enableVideo,
      if (enableAudio != null) 'enableAudio': enableAudio,
      if (metadata != null) ...metadata!,
    };
  }
}
