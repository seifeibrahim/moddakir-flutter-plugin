class CallEvent {
  final String event;
  final Map<String, dynamic> data;

  CallEvent({
    required this.event,
    required this.data,
  });

  factory CallEvent.fromMap(Map<dynamic, dynamic> map) {
    return CallEvent(
      event: map['event'] as String,
      data: Map<String, dynamic>.from(map),
    );
  }
}

class CallEndedEvent extends CallEvent {
  final String state;
  final double? duration;

  CallEndedEvent({
    required this.state,
    this.duration,
  }) : super(
          event: 'callEnded',
          data: {
            'state': state,
            'duration': duration,
          },
        );

  factory CallEndedEvent.fromMap(Map<dynamic, dynamic> map) {
    return CallEndedEvent(
      state: map['state'] as String,
      duration: map['duration'] as double?,
    );
  }
}

class CallStateUpdatedEvent extends CallEvent {
  final String state;

  CallStateUpdatedEvent({
    required this.state,
  }) : super(
          event: 'callStateUpdated',
          data: {
            'state': state,
          },
        );

  factory CallStateUpdatedEvent.fromMap(Map<dynamic, dynamic> map) {
    return CallStateUpdatedEvent(
      state: map['state'] as String,
    );
  }
}
