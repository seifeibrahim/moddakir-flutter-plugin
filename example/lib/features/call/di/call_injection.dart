import '../data/datasources/call_api_service.dart';
import '../data/repositories/call_repository_impl.dart';
import '../domain/repositories/call_repository.dart';
import '../domain/usecases/login_to_sdk_usecase.dart';
import '../domain/usecases/get_random_provider_usecase.dart';
import '../domain/usecases/create_call_usecase.dart';
import '../domain/usecases/update_call_usecase.dart';
import '../presentation/manager/call_flow_manager.dart';

class CallInjection {
  static CallInjection? _instance;
  static CallInjection get instance {
    _instance ??= CallInjection._();
    return _instance!;
  }

  CallInjection._();

  CallApiService? _apiService;
  CallRepository? _repository;
  LoginToSdkUseCase? _loginUseCase;
  GetRandomProviderUseCase? _getProviderUseCase;
  CreateCallUseCase? _createCallUseCase;
  UpdateCallUseCase? _updateCallUseCase;
  CallFlowManager? _flowManager;

  CallApiService get apiService {
    _apiService ??= CallApiService();
    return _apiService!;
  }

  CallRepository get repository {
    _repository ??= CallRepositoryImpl(apiService);
    return _repository!;
  }

  LoginToSdkUseCase get loginUseCase {
    _loginUseCase ??= LoginToSdkUseCase(repository);
    return _loginUseCase!;
  }

  GetRandomProviderUseCase get getProviderUseCase {
    _getProviderUseCase ??= GetRandomProviderUseCase(repository);
    return _getProviderUseCase!;
  }

  CreateCallUseCase get createCallUseCase {
    _createCallUseCase ??= CreateCallUseCase(repository);
    return _createCallUseCase!;
  }

  UpdateCallUseCase get updateCallUseCase {
    _updateCallUseCase ??= UpdateCallUseCase(repository);
    return _updateCallUseCase!;
  }

  CallFlowManager get flowManager {
    _flowManager ??= CallFlowManager(
      loginUseCase: loginUseCase,
      getProviderUseCase: getProviderUseCase,
      createCallUseCase: createCallUseCase,
      updateCallUseCase: updateCallUseCase,
    );
    return _flowManager!;
  }

  void reset() {
    _apiService?.dispose();
    _flowManager?.dispose();
    
    _apiService = null;
    _repository = null;
    _loginUseCase = null;
    _getProviderUseCase = null;
    _createCallUseCase = null;
    _updateCallUseCase = null;
    _flowManager = null;
  }
}
