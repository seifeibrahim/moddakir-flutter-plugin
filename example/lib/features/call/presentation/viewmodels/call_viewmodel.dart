import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../domain/entities/call_flow_state.dart';
import '../../domain/entities/session_input.dart';
import '../manager/call_flow_manager.dart';

class CallViewModel extends ChangeNotifier {
  final CallFlowManager flowManager;

  CallViewModel({required this.flowManager}) {
    _init();
  }

  StreamSubscription<CallFlowState>? _stateSubscription;

  CallFlowState _currentState = const IdleState();
  CallFlowState get currentState => _currentState;

  bool get isIdle => _currentState is IdleState;
  bool get isSearching => _currentState is SearchingState;
  bool get isReadyToCall => _currentState is ReadyToCallState;
  bool get isCalling => _currentState is CallingState;
  bool get isEnded => _currentState is EndedState;

  bool get isLoading => isSearching || isReadyToCall || isCalling;

  String get statusMessage {
    final state = _currentState;
    if (state is IdleState) {
      return 'Ready to start';
    } else if (state is SearchingState) {
      return '🔍 Searching for teacher... (${state.attempt}/${state.maxAttempts})';
    } else if (state is ReadyToCallState) {
      return '📞 Teacher found! Connecting...';
    } else if (state is CallingState) {
      return '📞 In call...';
    } else if (state is EndedState) {
      return _getEndMessage(state.reason);
    }
    return '';
  }

  String _getEndMessage(EndReason reason) {
    switch (reason) {
      case EndReason.completed:
        return '✅ Call completed successfully';
      case EndReason.noTeachers:
        return '❌ No teachers available at the moment';
      case EndReason.canceled:
        return '🚫 Call canceled';
      case EndReason.networkError:
        return '📡 Network error occurred';
      case EndReason.serverError:
        return '⚠️ Server error occurred';
    }
  }

  int? get currentAttempt {
    final state = _currentState;
    if (state is SearchingState) {
      return state.attempt;
    }
    return null;
  }

  int? get maxAttempts {
    final state = _currentState;
    if (state is SearchingState) {
      return state.maxAttempts;
    }
    return null;
  }

  EndReason? get endReason {
    final state = _currentState;
    if (state is EndedState) {
      return state.reason;
    }
    return null;
  }

  void _init() {
    flowManager.init();
    _listenToStateChanges();
  }

  void _listenToStateChanges() {
    _stateSubscription?.cancel();
    _stateSubscription = flowManager.stateStream.listen((state) {
      _currentState = state;
      notifyListeners();
    });
  }

  Future<void> startCall(SessionInput sessionInput) async {
    try {
      await flowManager.startSession(sessionInput);
    } catch (e) {
      debugPrint('Error starting call: $e');
    }
  }

  void cancelCall() {
    flowManager.reset();
  }

  void reset() {
    flowManager.reset();
  }

  @override
  void dispose() {
    _stateSubscription?.cancel();
    super.dispose();
  }
}
