import '../entities/call_session.dart';
import '../repositories/call_repository.dart';

class CreateCallUseCase {
  final CallRepository repository;

  CreateCallUseCase(this.repository);

  Future<CallSession> call({
    required String consumerId,
    required String providerId,
    required String consumerName,
    required String providerName,
    required String consumerCountry,
    required String consumerAvatarUrl,
    required String providerAvatarUrl,
    required String callType,
  }) async {
    return await repository.createCall(
      consumerId: consumerId,
      providerId: providerId,
      consumerName: consumerName,
      providerName: providerName,
      consumerCountry: consumerCountry,
      consumerAvatarUrl: consumerAvatarUrl,
      providerAvatarUrl: providerAvatarUrl,
      callType: callType,
    );
  }
}
