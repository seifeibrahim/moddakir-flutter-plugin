import 'package:moddakir_flutter_n_sdk/moddakir_flutter_n_sdk.dart';

sealed class CallFlowState {
  const CallFlowState();
}

class IdleState extends CallFlowState {
  const IdleState();
}

class SearchingState extends CallFlowState {
  final int attempt;
  final int maxAttempts;

  const SearchingState({
    required this.attempt,
    required this.maxAttempts,
  });
}

class ReadyToCallState extends CallFlowState {
  final CallConfig callConfig;
  final Map<String, dynamic> response;

  const ReadyToCallState({
    required this.callConfig,
    required this.response,
  });
}

class CallingState extends CallFlowState {
  final CallConfig callConfig;

  const CallingState({required this.callConfig});
}

class EndedState extends CallFlowState {
  final EndReason reason;

  const EndedState({required this.reason});
}

enum EndReason {
  completed,
  noTeachers,
  canceled,
  networkError,
  serverError,
}

extension EndReasonExtension on EndReason {
  String get message {
    switch (this) {
      case EndReason.completed:
        return 'Call completed successfully';
      case EndReason.noTeachers:
        return 'No teachers available';
      case EndReason.canceled:
        return 'Call canceled';
      case EndReason.networkError:
        return 'Network error occurred';
      case EndReason.serverError:
        return 'Server error occurred';
    }
  }
}
