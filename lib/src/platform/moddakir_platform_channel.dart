import 'package:flutter/foundation.dart';
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
    try {
      debugPrint('📱 [Platform] Getting platform version...');
      final version = await _methodChannel.invokeMethod<String>('getPlatformVersion');
      debugPrint('📱 [Platform] Platform version: $version');
      return version;
    } catch (e, stackTrace) {
      debugPrint('❌ [Platform] Error getting platform version: $e');
      debugPrint('📍 [Platform] Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<bool> initializeCallSDK() async {
    try {
      debugPrint('🔧 [Platform] Initializing Call SDK...');
      final result = await _methodChannel.invokeMethod<bool>('initializeCallSDK');
      debugPrint('🔧 [Platform] SDK initialization result: $result');
      return result ?? false;
    } catch (e, stackTrace) {
      debugPrint('❌ [Platform] Failed to initialize Call SDK: $e');
      debugPrint('📍 [Platform] Stack trace: $stackTrace');
      throw Exception('Failed to initialize Call SDK: $e');
    }
  }

  Future<bool> startCallSession({
    required String name,
    required String email,
    required String phone,
    required String gender,
    required String language,
    required String appName,
    required String apiKey,
    String callType = 'audio',
    bool isDark = false,
    int? primaryColor,
    int? secondaryColor,
    Map<String, dynamic>? metaData,
    Map<String, dynamic>? sessionInfo,
  }) async {
    try {
      final params = {
        'name': name,
        'email': email,
        'phone': phone,
        'gender': gender,
        'language': language,
        'appName': appName,
        'apiKey': apiKey,
        'callType': callType,
        'isDark': isDark,
        if (primaryColor != null) 'primaryColor': primaryColor,
        if (secondaryColor != null) 'secondaryColor': secondaryColor,
        if (metaData != null) 'metaData': metaData,
        if (sessionInfo != null) 'sessionInfo': sessionInfo,
      };
      
      debugPrint('📞 [Platform] Starting call session with params: $params');
      final result = await _methodChannel.invokeMethod<bool>('startCallSession', params);
      debugPrint('📞 [Platform] Start call session result: $result');
      return result ?? false;
    } catch (e, stackTrace) {
      debugPrint('❌ [Platform] Failed to start call session: $e');
      debugPrint('📍 [Platform] Stack trace: $stackTrace');
      throw Exception('Failed to start call session: $e');
    }
  }
}
