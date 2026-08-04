class UpdateCallRequest {
  final String callId;
  final String status;
  final String endDateTime;
  final int duration;
  final bool isHangupByTeacher;
  final bool isHangupByStudent;
  final bool isPackageEnded;
  final bool isSilenceTimeout;

  const UpdateCallRequest({
    required this.callId,
    required this.status,
    required this.endDateTime,
    required this.duration,
    required this.isHangupByTeacher,
    required this.isHangupByStudent,
    required this.isPackageEnded,
    required this.isSilenceTimeout,
  });

  Map<String, dynamic> toJson() => {
        'callId': callId,
        'status': status,
        'endDateTime': endDateTime,
        'duration': duration,
        'isHangupByTeacher': isHangupByTeacher,
        'isHangupByStudent': isHangupByStudent,
        'isPackageEnded': isPackageEnded,
        'isSilenceTimeout': isSilenceTimeout,
      };
}
