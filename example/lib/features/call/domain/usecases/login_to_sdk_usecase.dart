import '../entities/sdk_login.dart';
import '../entities/session_input.dart';
import '../repositories/call_repository.dart';

class LoginToSdkUseCase {
  final CallRepository repository;

  LoginToSdkUseCase(this.repository);

  Future<SdkLogin> call(SessionInput sessionInput) async {
    return await repository.loginToSdk(sessionInput);
  }
}
