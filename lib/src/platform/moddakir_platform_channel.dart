import 'package:flutter/services.dart';
import '../models/call_event.dart';

class ModdakirPlatformChannel {
  static const MethodChannel _methodChannel =
      MethodChannel('moddakir_flutter_plugin');
  
  static const EventChannel _eventChannel =
      EventChannel('moddakir_flutter_plugin/events');

  Stream<CallEvent>? _eventStream;

  Stream<CallEvent> get callEvents {
    _eventStream ??= _eventChannel.receiveBroadcastStream().map((event) {
      if (event is Map) {
        final eventType = event['event'] as String?;
        switch (eventType) {
          case 'callEnded':
            return CallEndedEvent.fromMap(event);
          case 'callStateUpdated':
            return CallStateUpdatedEvent.fromMap(event);
          default:
            return CallEvent.fromMap(event);
        }
      }
      throw Exception('Invalid event format');
    });
    return _eventStream!;
  }

  Future<String?> getPlatformVersion() async {
    final version = await _methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  Future<bool> initializeCallSDK() async {
    try {
      final result = await _methodChannel.invokeMethod<bool>('initializeCallSDK');
      return result ?? false;
    } catch (e) {
      throw Exception('Failed to initialize Call SDK: $e');
    }
  }

  Future<bool> startCall(Map<String, dynamic> params) async {
    try {
      final result = await _methodChannel.invokeMethod<bool>('startCall', params);
      return result ?? false;
    } catch (e) {
      throw Exception('Failed to start call: $e');
    }
  }
}
