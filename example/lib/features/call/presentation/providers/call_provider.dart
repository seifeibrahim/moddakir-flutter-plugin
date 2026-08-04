import 'package:flutter/material.dart';
import '../../domain/models/call_user.dart';
import '../../domain/entities/session_input.dart';
import '../../di/call_injection.dart';
import '../viewmodels/call_viewmodel.dart';
import '../state/call_ui_state.dart';

enum CallType { video, audio }

class CallProvider extends ChangeNotifier {
  late final CallViewModel _viewModel;

  final CallUser _user = CallUser(
    name: 'mariam Omar',
    gender: 'male',
    phone: '+201099034061',
    email: 'm.omar@moddakir.com',
    language: 'ar',
    sdkVersion: 'sdk_3',
    sessionId: 'ts1419-282816',
  );

  CallUser get user => _user;

  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  String _themeColor = 'blue';
  String get themeColor => _themeColor;

  CallProvider() {
    _viewModel = CallViewModel(flowManager: CallInjection.instance.flowManager);
    _viewModel.addListener(_onViewModelChanged);
  }

  void _onViewModelChanged() {
    notifyListeners();
  }

  // Expose ViewModel state
  CallUiState get uiState => CallUiState.fromFlowState(_viewModel.currentState);
  bool get isLoading => _viewModel.isLoading;
  String get status => _viewModel.statusMessage;
  bool get isIdle => _viewModel.isIdle;
  bool get isSearching => _viewModel.isSearching;
  bool get isCalling => _viewModel.isCalling;
  bool get isEnded => _viewModel.isEnded;

  Future<void> startCall(CallType type) async {
    final sessionInput = SessionInput(
      name: _user.name,
      gender: _user.gender,
      phone: _user.phone,
      email: _user.email,
      language: _user.language,
      callType: type.name,
      isDark: _themeMode == ThemeMode.dark,
    );

    await _viewModel.startCall(sessionInput);
  }

  Future<void> callRandomTeacher() async {
    await startCall(CallType.video);
  }

  void cancelCall() {
    _viewModel.cancelCall();
  }

  void resetCall() {
    _viewModel.reset();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void setThemeColor(String color) {
    _themeColor = color;
    notifyListeners();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }
}
