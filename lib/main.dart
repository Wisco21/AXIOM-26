import 'package:axiom/screens/splash_screen.dart';
import 'package:axiom/widgets/error_boundary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/rule_provider.dart';
import 'services/storage_service.dart';
import 'services/notification_service.dart';
import 'services/audio_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Force portrait orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    ErrorBoundary(
      errorBuilder: (context, error) {
        // Fallback error screen
        return MaterialApp(
          home: Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Text(
                'App failed to initialize\n$error',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => RuleProvider(
              StorageService(),
              NotificationService(),
              AudioService(),
            )..init(),
          ),
          ChangeNotifierProvider(create: (_) => MindChangeProvider()),
        ],
        child: const AXIOM26(),
      ),
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
      home: const SplashScreen(),
    );
  }
}