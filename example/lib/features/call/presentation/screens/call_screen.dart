import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/call_provider.dart';
import '../widgets/call_text_field.dart';
import '../widgets/call_button.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({super.key});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  late TextEditingController _nameController;
  late TextEditingController _genderController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _languageController;
  late TextEditingController _sdkVersionController;
  late TextEditingController _sessionIdController;

  @override
  void initState() {
    super.initState();
    final user = context.read<CallProvider>().user;
    _nameController = TextEditingController(text: user.name);
    _genderController = TextEditingController(text: user.gender);
    _phoneController = TextEditingController(text: user.phone);
    _emailController = TextEditingController(text: user.email);
    _languageController = TextEditingController(text: user.language);
    _sdkVersionController = TextEditingController(text: user.sdkVersion);
    _sessionIdController = TextEditingController(text: user.sessionId);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _genderController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _languageController.dispose();
    _sdkVersionController.dispose();
    _sessionIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              CallTextField(controller: _nameController),
              const SizedBox(height: 20),
              CallTextField(controller: _genderController),
              const SizedBox(height: 20),
              CallTextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              CallTextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              CallTextField(controller: _languageController),
              const SizedBox(height: 20),
              CallTextField(controller: _sdkVersionController),
              const SizedBox(height: 20),
              CallTextField(controller: _sessionIdController),
              const SizedBox(height: 30),
              Consumer<CallProvider>(
                builder: (context, provider, _) => Column(
                  children: [
                    CallButton(
                      label: 'VIDEO CALL',
                      onPressed: () => provider.startCall(CallType.video),
                      isLoading: provider.isLoading,
                    ),
                    const SizedBox(height: 16),
                    CallButton(
                      label: 'AUDIO CALL',
                      onPressed: () => provider.startCall(CallType.audio),
                      isLoading: provider.isLoading,
                    ),
                    const SizedBox(height: 16),
                    CallButton(
                      label: 'DARK THEME',
                      onPressed: () => provider.setThemeMode(ThemeMode.dark),
                    ),
                    const SizedBox(height: 16),
                    CallButton(
                      label: 'LIGHT THEME',
                      onPressed: () => provider.setThemeMode(ThemeMode.light),
                    ),
                    const SizedBox(height: 16),
                    CallButton(
                      label: 'RED',
                      onPressed: () => provider.setThemeColor('red'),
                      backgroundColor: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    CallButton(
                      label: 'BLUE',
                      onPressed: () => provider.setThemeColor('blue'),
                      backgroundColor: Colors.blue,
                    ),
                    const SizedBox(height: 16),
                    CallButton(
                      label: 'CALL RANDOM TEACHER',
                      onPressed: () => provider.callRandomTeacher(),
                      isLoading: provider.isLoading,
                    ),
                    if (provider.status != null) ...[
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Text(
                          provider.status!,
                          style: const TextStyle(color: Colors.blue),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
