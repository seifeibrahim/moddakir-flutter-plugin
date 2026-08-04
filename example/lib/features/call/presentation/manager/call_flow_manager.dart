import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:moddakir_flutter_plugin/moddakir_flutter_plugin.dart';
import '../../domain/entities/call_flow_state.dart';
import '../../domain/entities/session_input.dart';
import '../../domain/entities/sdk_login.dart';
import '../../domain/entities/provider.dart' as domain;
import '../../domain/entities/call_session.dart';
import '../../domain/usecases/login_to_sdk_usecase.dart';
import '../../domain/usecases/get_random_provider_usecase.dart';
import '../../domain/usecases/create_call_usecase.dart';
import '../../domain/usecases/update_call_usecase.dart';

class CallFlowManager {
  final LoginToSdkUseCase loginUseCase;
  final GetRandomProviderUseCase getProviderUseCase;
  final CreateCallUseCase createCallUseCase;
  final UpdateCallUseCase updateCallUseCase;

  CallFlowManager({
    required this.loginUseCase,
    required this.getProviderUseCase,
    required this.createCallUseCase,
    required this.updateCallUseCase,
  });

  static const int _retryIntervalSeconds = 10;
  static const int _defaultMaxAttempts = 3;

  final _stateController = StreamController<CallFlowState>.broadcast();
  Stream<CallFlowState> get stateStream => _stateController.stream;

  CallFlowState _currentState = const IdleState();
  CallFlowState get currentState => _currentState;

  SessionInput? _sessionInput;
  SdkLogin? _loginResponse;
  domain.Provider? _provider;
  CallSession? _callSession;
  int _attempt = 0;
  int _maxAttempts = _defaultMaxAttempts;
  Timer? _retryTimer;
  StreamSubscription<CallEvent>? _callEventsSubscription;

  void init() {
    _listenToCallEvents();
  }

  void _listenToCallEvents() {
    _callEventsSubscription?.cancel();
    _callEventsSubscription = ModdakirFlutterPlugin.instance.callEvents.listen(
      (event) {
        if (event is CallEndedEvent) {
          _onCallEnded(event);
        }
      },
    );
  }

  Future<void> startSession(SessionInput sessionInput) async {
    debugPrint('🚀 [CallFlow] Starting session');
    debugPrint('   Input: ${sessionInput.toJson()}');
    reset();
    _sessionInput = sessionInput;
    _attempt = 1;
    _maxAttempts = _defaultMaxAttempts;

    try {
      await _runFlow();
    } catch (e, stackTrace) {
      debugPrint('❌ [CallFlow] Fatal error in startSession: $e');
      debugPrint('📍 [CallFlow] Stack trace: $stackTrace');
      _updateState(const EndedState(reason: EndReason.serverError));
    }
  }

  Future<void> _runFlow() async {
    debugPrint('🔄 [CallFlow] Running flow - Attempt $_attempt/$_maxAttempts');
    _updateState(SearchingState(attempt: _attempt, maxAttempts: _maxAttempts));

    // Step 1: Login to SDK
    if (_loginResponse == null) {
      debugPrint('🔐 [CallFlow] Step 1: Logging in to SDK...');
      try {
        _loginResponse = await _login();
        if (_loginResponse == null) {
          debugPrint('❌ [CallFlow] Login failed: null response');
          _updateState(const EndedState(reason: EndReason.serverError));
          return;
        }
        debugPrint('✅ [CallFlow] Login successful: sessionId=${_loginResponse!.sdkSessionId}');
      } catch (e, stackTrace) {
        debugPrint('❌ [CallFlow] Login error: $e');
        debugPrint('📍 [CallFlow] Stack trace: $stackTrace');
        _updateState(const EndedState(reason: EndReason.networkError));
        return;
      }
    } else {
      debugPrint('ℹ️ [CallFlow] Already logged in, skipping login step');
    }

    // Step 2: Search for teacher
    debugPrint('🔍 [CallFlow] Step 2: Starting teacher search loop...');
    await _searchLoop();
  }

  Future<SdkLogin?> _login() async {
    final session = _sessionInput;
    if (session == null) {
      debugPrint('❌ [CallFlow] Login failed: session input is null');
      return null;
    }

    try {
      debugPrint('📤 [CallFlow] Sending login request...');
      final result = await loginUseCase.call(session);
      if (result != null) {
        debugPrint('📥 [CallFlow] Login response received');
        debugPrint('   Session ID: ${result.sdkSessionId}');
        debugPrint('   Consumer ID: ${result.consumer.id}');
      }
      return result;
    } catch (e, stackTrace) {
      debugPrint('❌ [CallFlow] SDK Login failed: $e');
      debugPrint('📍 [CallFlow] Stack trace: $stackTrace');
      return null;
    }
  }

  Future<void> _searchLoop() async {
    while (_attempt <= _maxAttempts) {
      debugPrint('🔍 [CallFlow] Search attempt $_attempt/$_maxAttempts');
      _updateState(SearchingState(attempt: _attempt, maxAttempts: _maxAttempts));

      try {
        // Get random teacher
        debugPrint('📤 [CallFlow] Requesting random teacher...');
        _provider = await getProviderUseCase.call();

        if (_provider != null) {
          debugPrint('✅ [CallFlow] Teacher found: ${_provider!.fullName} (ID: ${_provider!.id})');
          // Create call
          await _createCall();
          return;
        } else {
          debugPrint('⚠️ [CallFlow] No teacher available in this attempt');
        }
      } catch (e, stackTrace) {
        debugPrint('❌ [CallFlow] Search error: $e');
        debugPrint('📍 [CallFlow] Stack trace: $stackTrace');
      }

      if (_attempt >= _maxAttempts) {
        debugPrint('❌ [CallFlow] Max attempts reached, no teachers found');
        _updateState(const EndedState(reason: EndReason.noTeachers));
        return;
      }

      _attempt++;
      debugPrint('⏳ [CallFlow] Waiting $_retryIntervalSeconds seconds before retry...');
      await Future.delayed(const Duration(seconds: _retryIntervalSeconds));
    }
  }

  Future<void> _createCall() async {
    debugPrint('📞 [CallFlow] Creating call session...');
    final consumer = _loginResponse?.consumer;
    final provider = _provider;

    if (consumer == null || provider == null) {
      debugPrint('❌ [CallFlow] Cannot create call: consumer or provider is null');
      _updateState(const EndedState(reason: EndReason.serverError));
      return;
    }

    try {
      debugPrint('📤 [CallFlow] Sending create call request...');
      debugPrint('   Consumer: ${consumer.fullName} (${consumer.id})');
      debugPrint('   Provider: ${provider.fullName} (${provider.id})');
      debugPrint('   Call Type: ${_sessionInput?.callType ?? "Voice"}');
      
      _callSession = await createCallUseCase.call(
        consumerId: consumer.id,
        providerId: provider.id,
        consumerName: consumer.fullName ?? '',
        providerName: provider.fullName,
        consumerCountry: consumer.country ?? '',
        consumerAvatarUrl: consumer.avatarUrl ?? '',
        providerAvatarUrl: provider.avatarUrl,
        callType: _sessionInput?.callType ?? 'Voice',
      );

      debugPrint('✅ [CallFlow] Call session created');
      debugPrint('   Call ID: ${_callSession!.callId}');
      debugPrint('   Channel: ${_callSession!.channelName}');

      final callConfig = CallConfig(
        callId: _callSession!.callId,
        userId: consumer.id,
        sessionId: _loginResponse!.sdkSessionId,
      );

      debugPrint('📋 [CallFlow] Call config: ${callConfig.toMap()}');

      _updateState(ReadyToCallState(
        callConfig: callConfig,
        response: {},
      ));

      // Start the call
      debugPrint('🚀 [CallFlow] Starting native call with SDK...');
      try {
        final success = await ModdakirFlutterPlugin.instance.startCall(callConfig);
        debugPrint('📥 [CallFlow] Start call result: $success');
        if (success) {
          debugPrint('✅ [CallFlow] Call started successfully');
          markCalling();
        } else {
          debugPrint('❌ [CallFlow] Start call returned false');
          _updateState(const EndedState(reason: EndReason.serverError));
        }
      } catch (e, stackTrace) {
        debugPrint('❌ [CallFlow] Error starting native call: $e');
        debugPrint('📍 [CallFlow] Stack trace: $stackTrace');
        _updateState(const EndedState(reason: EndReason.serverError));
      }
    } catch (e, stackTrace) {
      debugPrint('❌ [CallFlow] Create call error: $e');
      debugPrint('📍 [CallFlow] Stack trace: $stackTrace');
      _updateState(const EndedState(reason: EndReason.serverError));
    }
  }

  void markCalling() {
    if (_currentState is ReadyToCallState) {
      final readyState = _currentState as ReadyToCallState;
      _updateState(CallingState(callConfig: readyState.callConfig));
    }
  }

  void _onCallEnded(CallEndedEvent event) {
    debugPrint('📞 [CallFlow] Call ended event received');
    final state = event.state.toLowerCase();
    debugPrint('   State: $state');
    debugPrint('   Duration: ${event.duration} seconds');

    if (state.contains('no_answer') || state.contains('denied')) {
      debugPrint('⚠️ [CallFlow] Teacher did not answer - will retry');
      // Teacher didn't answer - update call log and retry
      _updateCallLog(
        status: 'DENIED',
        duration: event.duration?.toInt() ?? 0,
        isHangupByTeacher: true,
        isHangupByStudent: false,
      );

      if (_attempt < _maxAttempts) {
        _attempt++;
        debugPrint('🔄 [CallFlow] Retrying search (attempt $_attempt/$_maxAttempts)...');
        _searchLoop();
      } else {
        debugPrint('❌ [CallFlow] Max retries reached, ending call');
        _updateState(const EndedState(reason: EndReason.noTeachers));
      }
    } else if (state.contains('hung_up') || state.contains('completed')) {
      debugPrint('✅ [CallFlow] Call completed successfully');
      // Call completed successfully
      _updateCallLog(
        status: 'HUNG_UP',
        duration: event.duration?.toInt() ?? 0,
        isHangupByTeacher: false,
        isHangupByStudent: false,
      );
      _updateState(const EndedState(reason: EndReason.completed));
    } else if (state.contains('canceled')) {
      debugPrint('🚫 [CallFlow] Call was canceled');
      _updateCallLog(
        status: 'CANCELED',
        duration: event.duration?.toInt() ?? 0,
        isHangupByTeacher: false,
        isHangupByStudent: true,
      );
      _updateState(const EndedState(reason: EndReason.canceled));
    } else {
      debugPrint('ℹ️ [CallFlow] Call ended with unknown state: $state');
      _updateState(const EndedState(reason: EndReason.completed));
    }
  }

  Future<void> _updateCallLog({
    required String status,
    required int duration,
    required bool isHangupByTeacher,
    required bool isHangupByStudent,
  }) async {
    final callSession = _callSession;
    if (callSession == null) {
      debugPrint('⚠️ [CallFlow] Cannot update call log: callSession is null');
      return;
    }

    try {
      debugPrint('📝 [CallFlow] Updating call log...');
      debugPrint('   Call ID: ${callSession.callId}');
      debugPrint('   Status: $status');
      debugPrint('   Duration: $duration seconds');
      debugPrint('   Hangup by teacher: $isHangupByTeacher');
      debugPrint('   Hangup by student: $isHangupByStudent');
      
      await updateCallUseCase.call(
        callId: callSession.callId,
        status: status,
        endDateTime: DateTime.now(),
        duration: duration,
        isHangupByTeacher: isHangupByTeacher,
        isHangupByStudent: isHangupByStudent,
      );
      debugPrint('✅ [CallFlow] Call log updated successfully');
    } catch (e, stackTrace) {
      debugPrint('❌ [CallFlow] Failed to update call log: $e');
      debugPrint('📍 [CallFlow] Stack trace: $stackTrace');
    }
  }

  void reset() {
    _retryTimer?.cancel();
    _retryTimer = null;
    _sessionInput = null;
    _loginResponse = null;
    _provider = null;
    _callSession = null;
    _attempt = 0;
    _maxAttempts = _defaultMaxAttempts;
    _updateState(const IdleState());
  }

  void _updateState(CallFlowState newState) {
    _currentState = newState;
    _stateController.add(newState);
  }

  void dispose() {
    _retryTimer?.cancel();
    _callEventsSubscription?.cancel();
    _stateController.close();
  }
}
