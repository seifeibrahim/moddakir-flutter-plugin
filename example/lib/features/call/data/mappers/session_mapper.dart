import '../../domain/entities/session_entity.dart';
import '../models/session_response_model.dart';

class SessionMapper {
  static SessionEntity toEntity(SessionResponseModel model) {
    return SessionEntity(
      token: model.token,
      sdkSessionId: model.sdkSessionId,
    );
  }

  static SessionResponseModel toModel(SessionEntity entity) {
    return SessionResponseModel(
      token: entity.token,
      sdkSessionId: entity.sdkSessionId,
    );
  }
}
