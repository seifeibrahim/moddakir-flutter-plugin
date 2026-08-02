import 'package:flutter/material.dart';
import 'package:moddakir_flutter_plugin/moddakir_flutter_plugin.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/call/presentation/providers/call_provider.dart';
import 'features/call/presentation/screens/call_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await ModdakirFlutterPlugin.instance.initializeCallSDK();
    debugPrint('✅ Moddakir Call SDK initialized successfully');
  } catch (e) {
    debugPrint('❌ Failed to initialize SDK: $e');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CallProvider(),
      child: Consumer<CallProvider>(
        builder: (context, provider, _) {
          return MaterialApp(
            title: 'Moddakir Call',
            debugShowCheckedModeBanner: false,
            themeMode: provider.themeMode,
            theme: provider.themeColor == 'red' 
                ? AppTheme.redTheme 
                : AppTheme.blueTheme,
            darkTheme: provider.themeColor == 'red'
                ? AppTheme.redTheme
                : AppTheme.darkTheme,
            home: const CallScreen(),
          );
        },
      ),
    );
  }
}
