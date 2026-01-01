import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/rule_provider.dart';
import 'services/storage_service.dart';
import 'services/notification_service.dart';
import 'services/audio_service.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Force portrait orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Initialize services
  final storage = StorageService();
  final notification = NotificationService();
  final audio = AudioService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RuleProvider(storage, notification, audio)..init(),
        ),
        ChangeNotifierProvider(
          create: (_) => MindChangeProvider(),
        ),
      ],
      child: const AXIOM26(),
    ),
  );
}

class AXIOM26 extends StatelessWidget {
  const AXIOM26({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AXIOM-26',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF000000),
        fontFamily: 'Inter',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}