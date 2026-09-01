import '../../domain/entities/session_entity.dart';
import '../../domain/repositories/session_repository.dart';
import '../datasources/call_api_service.dart';
import '../mappers/session_mapper.dart';
import '../models/session_request_model.dart';

class SessionRepositoryImpl implements SessionRepository {
  final SessionRemoteDataSource remoteDataSource;

  SessionRepositoryImpl({required this.remoteDataSource});

  @override
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
  }) async {
    final request = SessionRequestModel(
      callDuration: callDuration,
      callType: 'Voice',
      email: email,
      fullName: name,
      gender: gender,
      phone: phone,
      sessionInfo: sessionInfo,
      startDate: DateTime.now().toIso8601String(),
      language: language,
      moddakirId: moddakirId,
      moddakirKey: moddakirKey,
    );

    final response = await remoteDataSource.getSdkSession(request);
    return SessionMapper.toEntity(response);
  }
}
