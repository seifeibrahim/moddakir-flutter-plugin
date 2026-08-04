import 'package:flutter/material.dart';
import 'package:moddakir_flutter_plugin/moddakir_flutter_plugin.dart';
import '../../../../core/api/session_api.dart';

class SimpleCallScreen extends StatefulWidget {
  const SimpleCallScreen({super.key});

  @override
  State<SimpleCallScreen> createState() => _SimpleCallScreenState();
}

class _SimpleCallScreenState extends State<SimpleCallScreen> {
  final _nameController = TextEditingController(text: 'mariam Omar');
  final _emailController = TextEditingController(text: 'm.omar@moddakir.com');
  final _phoneController = TextEditingController(text: '+201099034061');
  final _moddakirIdController = TextEditingController(text: 'sdk5');
  final _moddakirKeyController = TextEditingController(text: 'GMD2ZvgCzYC8_NNkxjLe2D9TOkEnn7JIBMWstww-sAMJLzbURdZaKIAY');
  
  String _selectedGender = 'male';
  String _selectedLanguage = 'ar';
  String _selectedCallType = 'Voice';
  bool _isDark = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _moddakirIdController.dispose();
    _moddakirKeyController.dispose();
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

    setState(() => _isLoading = true);

    try {
      debugPrint('🚀 Step 1: Getting SDK session credentials...');
      
      // Step 1: Get session credentials from API
      // This is the ONLY API call we make from Flutter
      final sessionData = await SessionApi.getSdkSession(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        gender: _selectedGender,
        language: _selectedLanguage,
        moddakirId: _moddakirIdController.text,
        moddakirKey: _moddakirKeyController.text,
        sessionInfo: {
          'fromSurah': 'البقرة',
          'fromAyah': '1',
          'toSurah': 'البقرة',
          'toAyah': '50',
        },
      );
      
      debugPrint('✅ Step 1 Complete: Got session credentials');
      debugPrint('🚀 Step 2: Passing credentials to Android SDK...');
      
      // Step 2: Pass credentials to Android SDK
      // The SDK will handle everything else (login, search, create call, etc.)
      final success = await ModdakirFlutterPlugin.instance.startCallSession(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        gender: _selectedGender,
        language: _selectedLanguage,
        appName: _moddakirIdController.text,
        apiKey: _moddakirKeyController.text,
        callType: _selectedCallType,
        isDark: _isDark,
        // Pass session credentials to SDK
        sessionInfo: {
          'token': sessionData['token'],
          'sdkSessionId': sessionData['sdkSessionId'],
        },
      );

      if (success) {
        debugPrint('✅ Step 2 Complete: SDK will handle the rest!');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Call session started! SDK is handling the call...')),
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
      debugPrint('❌ Error starting call: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
            DropdownButtonFormField<String>(
              value: _selectedGender,
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
              value: _selectedLanguage,
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
              value: _selectedCallType,
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
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: _isDark,
              onChanged: (value) => setState(() => _isDark = value),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _startCall,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.all(16),
              ),
              child: _isLoading
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
            ),
          ],
        ),
      ),
    );
  }
}
