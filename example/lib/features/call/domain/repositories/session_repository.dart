import '../entities/session_entity.dart';

abstract class SessionRepository {
  Future<SessionEntity> getSdkSession({
    required String name,
    required String email,
    required String phone,
    required String gender,
    required String language,
    required String moddakirId,
    required String moddakirKey,
    int callDuration = 30,
    Map<String, dynamic>? sessionInfo,
  });
}
