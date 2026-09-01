import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moddakir_flutter_n_sdk/moddakir_flutter_n_sdk.dart';
import 'features/call/di/call_injection.dart';
import 'features/call/presentation/screens/simple_call_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    final initialized = await ModdakirFlutterNSdk.instance.initializeCallSDK();
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
      title: 'Moddakir Flutter Native SDK',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => CallInjection.instance.sessionCubit,
        child: const SimpleCallScreen(),
      ),
    );
  }
}
