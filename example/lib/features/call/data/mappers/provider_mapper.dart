import '../../domain/entities/provider.dart';
import '../models/random_provider_response.dart' as dto;

class ProviderMapper {
  static Provider toEntity(dto.RandomProviderResponse response) {
    return Provider(
      id: response.id,
      username: response.username,
      fullName: response.fullName,
      phone: response.phone,
      avatarUrl: response.avatarUrl,
      status: response.status,
    );
  }
}
