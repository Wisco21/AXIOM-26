// screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../providers/rule_provider.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  // Track if there was an error during initialization
  bool _hasError = false;
  String _errorMessage = '';

  

  @override
  void initState() {
    super.initState();
    
    _initializeApp();
  }

  
  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _initializeApp() async {
    // Start timing for minimum display duration
    final startTime = DateTime.now();
    const minimumDuration = Duration(seconds: 2);

    try {
      // Wait for RuleProvider to initialize
      final ruleProvider = Provider.of<RuleProvider>(
        context,
        listen: false,
      );
      
      // If init hasn't been called yet (shouldn't happen but safe)
      if (!ruleProvider.isInitialized && !ruleProvider.isInitializing) {
        await ruleProvider.init();
      }
      
      // Wait for initialization to complete
      await ruleProvider.initializationDone;
      
      // Calculate remaining time for minimum display
      final elapsed = DateTime.now().difference(startTime);
      if (elapsed < minimumDuration) {
        await Future.delayed(minimumDuration - elapsed);
      }
      
      // Navigate to HomeScreen
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const HomeScreen(),
          ),
        );
      }
    } catch (error, stackTrace) {
      // Handle initialization error
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = error.toString();
        });
        
        // Show error for a while, then retry or show home
        await Future.delayed(const Duration(seconds: 3));
        
        // Try to navigate anyway, app might work with partial initialization
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const HomeScreen(),
            ),
          );
        }
      }
    }
  }

  void _retryInitialization() {
    if (mounted) {
      setState(() {
        _hasError = false;
        _errorMessage = '';
      });
      _initializeApp();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _hasError
              ? [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 64,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Initialization Error',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      _errorMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                        fontFamily: 'Inter',
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _retryInitialization,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                    ),
                    child: const Text(
                      'Retry',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ]
              : [
                  // App name with animated opacity
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 1000),
                    opacity: 1.0,
                    child: Text(
                      'AXIOM-26',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Inter',
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Animated loading indicator
                  _buildLoadingIndicator(),
                  const SizedBox(height: 20),
                  // Loading text with fade animation
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 800),
                    opacity: 0.8,
                    child: Text(
                      'Preparing your daily insights...',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ],
        ),
      ),
    );
  }


// Widget _buildLoadingIndicator() {
//   return SizedBox(
//     width: 150,
//     height: 150,
//     child: Lottie.asset(
//       'assets/animation/loading1.json', // Your Lottie animation file
//       fit: BoxFit.contain,
//       repeat: true,
//       animate: true,
//       controller: _controller,
//       onLoaded: (composition) {
//           _controller.repeat(); // loop
//         }
//     ),

//   );
// }


Widget _buildLoadingIndicator() {
  return SizedBox(
    width: 150,
    height: 150,
    child: Stack(
      children: [
        // Background glow
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
        ),
        // Center(
        //   child: TweenAnimationBuilder<double>(
        //         tween: Tween(begin: 0.0, end: 1.0),
        //         duration: const Duration(milliseconds: 1500),
        //         builder: (context, value, child) {
        //           return Opacity(
        //             opacity: 1 - value,
        //             child: Transform.translate(
        //               offset: Offset(15, -40 * value),
        //               child:Image.asset(
        //                 'assets/splash2.png',
        //                 width: 25,
        //                 height: 25,
        //                 color: Colors.amber.withOpacity(0.9),
        //               ),
        //             ),
        //           );
        //         },
        //         // repeat: true,
        //       ),
        // ),
            Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 1500),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: Image.asset(
                        'assets/splash.png',
                        width:80,
                        height: 80,
                        // color: Colors.blueGrey,
                        color: Colors.amber.withOpacity(0.9),
                      ),
                    ),
                  );
                },
                // repeat: true,
              ),
            ),
          
        
      
     
      ],
    ),
  );
}
}