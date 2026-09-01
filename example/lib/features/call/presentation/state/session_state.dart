import 'package:equatable/equatable.dart';
import '../../domain/entities/session_entity.dart';

sealed class SessionState extends Equatable {
  const SessionState();

  @override
  List<Object?> get props => [];
}

final class SessionInitial extends SessionState {
  const SessionInitial();
}

final class SessionLoading extends SessionState {
  const SessionLoading();
}

final class SessionSuccess extends SessionState {
  final SessionEntity session;

  const SessionSuccess(this.session);

  @override
  List<Object?> get props => [session];
}

final class SessionError extends SessionState {
  final String message;

  const SessionError(this.message);

  @override
  List<Object?> get props => [message];
}
