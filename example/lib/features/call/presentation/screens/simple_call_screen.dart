import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moddakir_flutter_n_sdk/moddakir_flutter_n_sdk.dart';
import '../../../../core/utils/error_handler.dart';
import '../viewmodels/session_viewmodel.dart';
import '../state/session_state.dart';

class SimpleCallScreen extends StatefulWidget {
  const SimpleCallScreen({super.key});

  @override
  State<SimpleCallScreen> createState() => _SimpleCallScreenState();
}

class _SimpleCallScreenState extends State<SimpleCallScreen> {
  final _nameController = TextEditingController(text: 'mariam Omar');
  final _emailController = TextEditingController(text: 'm.omar@moddakir.com');
  final _phoneController = TextEditingController(text: '+201099034061');
  final _moddakirIdController = TextEditingController(text: 'sdk_5');
  final _moddakirKeyController = TextEditingController(text: 'm15pJPd_RNwC_LId9mHweog9is4vGas-9KWBYcb0r7pY7BilcAFMnsBk');
  final _timerController = TextEditingController(text: '50');
  final _fromSurahController = TextEditingController(text: '1');
  final _fromAyahController = TextEditingController(text: '1');
  final _toSurahController = TextEditingController(text: '2');
  final _toAyahController = TextEditingController(text: '50');
  final _pathTypeController = TextEditingController(text: 'initiation');
  final _notesController = TextEditingController(text: 'Test session');

  String _selectedGender = 'male';
  String _selectedLanguage = 'ar';
  String _selectedCallType = 'Voice';
  bool _isDark = false;

  Future<void> _handleSessionSuccess(SessionSuccess state) async {
    debugPrint('✅ Step 1 Complete: Got session credentials');
    debugPrint('🚀 Step 2: Passing credentials to SDK...');


    try {
      final success = await ModdakirFlutterNSdk.instance.startCallSession(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        gender: _selectedGender,
        language: _selectedLanguage,
        appName: _moddakirIdController.text,
        apiKey: _moddakirKeyController.text,
        callType: _selectedCallType,
        token: state.session.token,
        sdkSessionId: state.session.sdkSessionId,
        sessionInfo: {
          'fromSurah': _fromSurahController.text,
          'fromAyah': _fromAyahController.text,
          'toSurah': _toSurahController.text,
          'toAyah': _toAyahController.text,
          'pathType': _pathTypeController.text,
          'notes': _notesController.text
        },
      );

      if (success) {
        debugPrint('✅ Step 2 Complete: SDK will handle the rest!');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Call session started! SDK is handling the call...'),
            ),
          );
        }
      } else {
        debugPrint('❌ Failed to start call session');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to start call')),
          );
        }
      }
    } catch (e) {
      debugPrint('❌ Error starting SDK call: $e');
      if (mounted) {
        final errorMessage = ErrorHandler.getLocalizedErrorMessage(e, _selectedLanguage);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  void _handleSessionError(SessionError state) {
    debugPrint('❌ Error getting session: ${state.message}');
    if (mounted) {
      final errorMessage = ErrorHandler.getLocalizedErrorMessage(
        Exception(state.message),
        _selectedLanguage,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: _selectedLanguage == 'ar' ? 'حسناً' : 'OK',
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _moddakirIdController.dispose();
    _moddakirKeyController.dispose();
    _timerController.dispose();
    _fromSurahController.dispose();
    _fromAyahController.dispose();
    _toSurahController.dispose();
    _toAyahController.dispose();
    _pathTypeController.dispose();
    _notesController.dispose();

    super.dispose();
  }

  Future<void> _startCall() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    debugPrint('🚀 Step 1: Getting SDK session credentials...');

    await context.read<SessionCubit>().getSdkSession(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      gender: _selectedGender,
      language: _selectedLanguage,
      moddakirId: _moddakirIdController.text,
      moddakirKey: _moddakirKeyController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SessionCubit, SessionState>(
      listener: (context, state) {
        if (state is SessionSuccess) {
          _handleSessionSuccess(state);
        } else if (state is SessionError) {
          _handleSessionError(state);
        }
      },
      child: _buildScaffold(context),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moddakir Call'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email *',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone *',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _moddakirIdController,
              decoration: const InputDecoration(
                labelText: 'Moddakir ID *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _moddakirKeyController,
              decoration: const InputDecoration(
                labelText: 'Moddakir Key *',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _timerController,
              decoration: const InputDecoration(
                labelText: 'Timer (seconds)',
                hintText: 'Default 50 sec',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _fromSurahController,
              decoration: const InputDecoration(
                labelText: 'From Surah',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _fromAyahController,
              decoration: const InputDecoration(
                labelText: 'From Ayah',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _toSurahController,
              decoration: const InputDecoration(
                labelText: 'To Surah',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _toAyahController,
              decoration: const InputDecoration(
                labelText: 'To Ayah',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedGender,
              decoration: const InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'male', child: Text('Male')),
                DropdownMenuItem(value: 'female', child: Text('Female')),
              ],
              onChanged: (value) => setState(() => _selectedGender = value!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedLanguage,
              decoration: const InputDecoration(
                labelText: 'Language',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'ar', child: Text('Arabic')),
                DropdownMenuItem(value: 'en', child: Text('English')),
              ],
              onChanged: (value) => setState(() => _selectedLanguage = value!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedCallType,
              decoration: const InputDecoration(
                labelText: 'Call Type',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Voice', child: Text('Voice')),
                DropdownMenuItem(value: 'Video', child: Text('Video')),
              ],
              onChanged: (value) => setState(() => _selectedCallType = value!),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _pathTypeController,
              decoration: const InputDecoration(
                labelText: 'Path Type',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: _isDark,
              onChanged: (value) => setState(() => _isDark = value),
            ),
            const SizedBox(height: 24),
            BlocBuilder<SessionCubit, SessionState>(
              builder: (context, state) {
                final isLoading = state is SessionLoading;
                return ElevatedButton(
                  onPressed: isLoading ? null : _startCall,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.all(16),
                  ),
                  child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Start Call',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
