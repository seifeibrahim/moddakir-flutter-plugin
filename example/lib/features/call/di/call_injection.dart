import 'package:http/http.dart' as http;
import '../data/datasources/call_api_service.dart';
import '../data/repositories/session_repository_impl.dart';
import '../domain/repositories/session_repository.dart';
import '../domain/usecases/get_sdk_session_usecase.dart';
import '../presentation/viewmodels/session_viewmodel.dart';

class CallInjection {
  static CallInjection? _instance;
  static CallInjection get instance {
    _instance ??= CallInjection._();
    return _instance!;
  }

  CallInjection._();

  http.Client? _httpClient;
  SessionRemoteDataSource? _sessionDataSource;
  SessionRepository? _sessionRepository;
  GetSdkSessionUseCase? _getSdkSessionUseCase;
  SessionCubit? _sessionCubit;

  http.Client get httpClient {
    _httpClient ??= http.Client();
    return _httpClient!;
  }

  SessionRemoteDataSource get sessionDataSource {
    _sessionDataSource ??= SessionRemoteDataSourceImpl(client: httpClient);
    return _sessionDataSource!;
  }

  SessionRepository get sessionRepository {
    _sessionRepository ??= SessionRepositoryImpl(remoteDataSource: sessionDataSource);
    return _sessionRepository!;
  }

  GetSdkSessionUseCase get getSdkSessionUseCase {
    _getSdkSessionUseCase ??= GetSdkSessionUseCase(repository: sessionRepository);
    return _getSdkSessionUseCase!;
  }

  SessionCubit get sessionCubit {
    _sessionCubit ??= SessionCubit(getSdkSessionUseCase: getSdkSessionUseCase);
    return _sessionCubit!;
  }

  void reset() {
    _httpClient?.close();
    _sessionCubit?.close();
    
    _httpClient = null;
    _sessionDataSource = null;
    _sessionRepository = null;
    _getSdkSessionUseCase = null;
    _sessionCubit = null;
  }
}
