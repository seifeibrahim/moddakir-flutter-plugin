import 'package:flutter/material.dart';
import 'package:moddakir_flutter_plugin/moddakir_flutter_plugin.dart';
import 'features/call/presentation/screens/simple_call_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    final initialized = await ModdakirFlutterPlugin.instance.initializeCallSDK();
    debugPrint('✅ Moddakir Call SDK initialized: $initialized');
  } catch (e) {
    debugPrint('❌ Failed to initialize Moddakir Call SDK: $e');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moddakir Call Plugin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const SimpleCallScreen(),
    );
  }
}
