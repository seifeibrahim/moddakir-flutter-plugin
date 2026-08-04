import '../../domain/entities/sdk_login.dart';
import '../../domain/entities/consumer.dart';
import '../models/sdk_login_response.dart' as dto;

class SdkLoginMapper {
  static SdkLogin toEntity(dto.SdkLoginResponse response) {
    return SdkLogin(
      accessToken: response.accessToken,
      consumer: _consumerToEntity(response.consumer),
      sdkSessionId: response.sdkSessionId,
    );
  }

  static Consumer _consumerToEntity(dto.Consumer consumer) {
    return Consumer(
      id: consumer.id,
      username: consumer.username,
      gender: consumer.gender,
      email: consumer.email,
      fullName: consumer.fullName,
      phone: consumer.phone,
      avatarUrl: consumer.avatarUrl,
      country: consumer.country,
    );
  }
}
