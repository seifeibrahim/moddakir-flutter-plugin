import 'package:flutter/material.dart';
import 'package:moddakir_flutter_plugin/moddakir_flutter_plugin.dart';
import '../../domain/models/call_user.dart';
import 'dart:async';

enum CallType { video, audio }

class CallProvider extends ChangeNotifier {
  final ModdakirFlutterPlugin _plugin = ModdakirFlutterPlugin.instance;
  StreamSubscription<CallEvent>? _callEventsSubscription;

  CallUser _user = CallUser(
    name: 'mariam Omar',
    gender: 'male',
    phone: '+201099034061',
    email: 'm.omar@moddakir.com',
    language: 'ar',
    sdkVersion: 'sdk_3',
    sessionId: 'ts1419-282816',
  );

  ThemeMode _themeMode = ThemeMode.dark;
  String _themeColor = 'blue';
  String? _status;
  bool _isLoading = false;

  CallUser get user => _user;
  ThemeMode get themeMode => _themeMode;
  String get themeColor => _themeColor;
  String? get status => _status;
  bool get isLoading => _isLoading;

  CallProvider() {
    _listenToCallEvents();
  }

  void _listenToCallEvents() {
    _callEventsSubscription = _plugin.callEvents.listen(
      (event) {
        if (event is CallEndedEvent) {
          _status = 'Call ended: ${event.state} (${event.duration}s)';
          _isLoading = false;
          notifyListeners();
        } else if (event is CallStateUpdatedEvent) {
          _status = 'Call state: ${event.state}';
          notifyListeners();
        }
      },
      onError: (error) {
        _status = 'Error: $error';
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  void updateUser(CallUser user) {
    _user = user;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void setThemeColor(String color) {
    _themeColor = color;
    notifyListeners();
  }

  Future<void> startCall(CallType type) async {
    _isLoading = true;
    _status = 'Starting ${type.name} call...';
    notifyListeners();

    try {
      final config = CallConfig(
        callId: 'call-${DateTime.now().millisecondsSinceEpoch}',
        userId: _user.phone,
        sessionId: _user.sessionId,
        metadata: {
          'name': _user.name,
          'gender': _user.gender,
          'email': _user.email,
          'language': _user.language,
          'sdkVersion': _user.sdkVersion,
          'callType': type.name,
        },
      );

      final success = await _plugin.startCall(config);

      if (success) {
        _status = '${type.name.toUpperCase()} call started';
      } else {
        _status = 'Failed to start call';
        _isLoading = false;
      }
    } catch (e) {
      _status = 'Error: $e';
      _isLoading = false;
    }

    notifyListeners();
  }

  Future<void> callRandomTeacher() async {
    _isLoading = true;
    _status = 'Finding random teacher...';
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    try {
      final config = CallConfig(
        callId: 'random-${DateTime.now().millisecondsSinceEpoch}',
        userId: _user.phone,
        sessionId: _user.sessionId,
        metadata: {
          'name': _user.name,
          'gender': _user.gender,
          'email': _user.email,
          'language': _user.language,
          'sdkVersion': _user.sdkVersion,
          'callType': 'random',
        },
      );

      final success = await _plugin.startCall(config);

      if (success) {
        _status = 'Connected to random teacher';
      } else {
        _status = 'No teachers available';
        _isLoading = false;
      }
    } catch (e) {
      _status = 'Error: $e';
      _isLoading = false;
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _callEventsSubscription?.cancel();
    super.dispose();
  }
}
