import '../../domain/entities/call_flow_state.dart';

class CallUiState {
  final bool isLoading;
  final String statusMessage;
  final CallFlowState flowState;
  final String? errorMessage;

  const CallUiState({
    required this.isLoading,
    required this.statusMessage,
    required this.flowState,
    this.errorMessage,
  });

  factory CallUiState.initial() {
    return const CallUiState(
      isLoading: false,
      statusMessage: 'Ready to start',
      flowState: IdleState(),
    );
  }

  factory CallUiState.fromFlowState(CallFlowState flowState) {
    if (flowState is IdleState) {
      return CallUiState(
        isLoading: false,
        statusMessage: 'Ready to start',
        flowState: flowState,
      );
    } else if (flowState is SearchingState) {
      return CallUiState(
        isLoading: true,
        statusMessage: '🔍 Searching... (${flowState.attempt}/${flowState.maxAttempts})',
        flowState: flowState,
      );
    } else if (flowState is ReadyToCallState) {
      return CallUiState(
        isLoading: true,
        statusMessage: '📞 Teacher found! Connecting...',
        flowState: flowState,
      );
    } else if (flowState is CallingState) {
      return CallUiState(
        isLoading: true,
        statusMessage: '📞 In call...',
        flowState: flowState,
      );
    } else if (flowState is EndedState) {
      return CallUiState(
        isLoading: false,
        statusMessage: _getEndMessage(flowState.reason),
        flowState: flowState,
        errorMessage: flowState.reason != EndReason.completed
            ? _getEndMessage(flowState.reason)
            : null,
      );
    }
    return CallUiState.initial();
  }

  static String _getEndMessage(EndReason reason) {
    switch (reason) {
      case EndReason.completed:
        return '✅ Call completed successfully';
      case EndReason.noTeachers:
        return '❌ No teachers available';
      case EndReason.canceled:
        return '🚫 Call canceled';
      case EndReason.networkError:
        return '📡 Network error';
      case EndReason.serverError:
        return '⚠️ Server error';
    }
  }

  CallUiState copyWith({
    bool? isLoading,
    String? statusMessage,
    CallFlowState? flowState,
    String? errorMessage,
  }) {
    return CallUiState(
      isLoading: isLoading ?? this.isLoading,
      statusMessage: statusMessage ?? this.statusMessage,
      flowState: flowState ?? this.flowState,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
