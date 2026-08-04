import '../repositories/call_repository.dart';

class UpdateCallUseCase {
  final CallRepository repository;

  UpdateCallUseCase(this.repository);

  Future<void> call({
    required String callId,
    required String status,
    required DateTime endDateTime,
    required int duration,
    required bool isHangupByTeacher,
    required bool isHangupByStudent,
  }) async {
    return await repository.updateCallLog(
      callId: callId,
      status: status,
      endDateTime: endDateTime,
      duration: duration,
      isHangupByTeacher: isHangupByTeacher,
      isHangupByStudent: isHangupByStudent,
    );
  }
}
