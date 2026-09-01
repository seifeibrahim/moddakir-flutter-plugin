import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_sdk_session_usecase.dart';
import '../state/session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  final GetSdkSessionUseCase getSdkSessionUseCase;

  SessionCubit({required this.getSdkSessionUseCase}) : super(const SessionInitial());

  bool get isLoading => state is SessionLoading;
  bool get isSuccess => state is SessionSuccess;
  bool get isError => state is SessionError;

  Future<void> getSdkSession({
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
    emit(const SessionLoading());

    try {
      final session = await getSdkSessionUseCase.call(
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

      emit(SessionSuccess(session));
    } catch (e) {
      debugPrint('❌ [Cubit] Error getting SDK session: $e');
      emit(SessionError(e.toString()));
    }
  }

  void reset() {
    emit(const SessionInitial());
  }
}
