import '../entities/provider.dart';
import '../repositories/call_repository.dart';

class GetRandomProviderUseCase {
  final CallRepository repository;

  GetRandomProviderUseCase(this.repository);

  Future<Provider> call() async {
    return await repository.getRandomProvider();
  }
}
