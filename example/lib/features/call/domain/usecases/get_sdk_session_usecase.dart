import '../entities/session_entity.dart';
import '../repositories/session_repository.dart';

class GetSdkSessionUseCase {
  final SessionRepository repository;

  GetSdkSessionUseCase({required this.repository});

  Future<SessionEntity> call({
    required String name,
    required String email,
    required String phone,
    required String gender,
    required String language,
    required String moddakirId,
    required String moddakirKey,
    int callDuration = 30,
    Map<String, dynamic>? sessionInfo,
  }) async {
    return await repository.getSdkSession(
      name: name,
      email: email,
      phone: phone,
      gender: gender,
      language: language,
      moddakirId: moddakirId,
      moddakirKey: moddakirKey,
      callDuration: callDuration,
      sessionInfo: sessionInfo,
    );
  }
}
