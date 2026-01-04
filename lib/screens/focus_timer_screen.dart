// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import '../models/focus_models.dart';
// import '../providers/focus_provider.dart';

// class FocusTimerScreen extends StatefulWidget {
//   final FocusChunkModel chunk;

//   const FocusTimerScreen({super.key, required this.chunk});

//   @override
//   State<FocusTimerScreen> createState() => _FocusTimerScreenState();
// }

// class _FocusTimerScreenState extends State<FocusTimerScreen>
//     with WidgetsBindingObserver {
//   Timer? _exitHoldTimer;
//   bool _isExiting = false;
//   bool _hasPopped = false; // Track if we've already popped

//   // Track exit button state
//   bool _isShowingExitConfirmation = false;
//   bool _isHoldingExitButton = false;
//   int _exitHoldProgress = 0; // 0-100 percentage
//   Timer? _exitHoldProgressTimer;
//   Completer<void>? _completionCompleter;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
//   }

//   @override
//   void dispose() {
//     _exitHoldTimer?.cancel();
//     _exitHoldProgressTimer?.cancel();
//     WidgetsBinding.instance.removeObserver(this);
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     // Timer continues even when app is backgrounded
//   }

//   void _showExitConfirmation() {
//     if (!mounted || _isShowingExitConfirmation) return;

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) {
//         setState(() {
//           _isShowingExitConfirmation = true;
//           _exitHoldProgress = 0;
//         });
//       }
//     });
//   }

//   void _startExitHold() {
//     if (!mounted || _isHoldingExitButton) return;

//     setState(() {
//       _isHoldingExitButton = true;
//       _exitHoldProgress = 0;
//     });

//     // Cancel any existing timer
//     _exitHoldProgressTimer?.cancel();

//     // Start progress timer
//     _exitHoldProgressTimer = Timer.periodic(const Duration(milliseconds: 100), (
//       timer,
//     ) {
//       if (!mounted) {
//         timer.cancel();
//         return;
//       }

//       setState(() {
//         _exitHoldProgress += 3; // 100/33.33 = ~3 seconds
//       });

//       if (_exitHoldProgress >= 100) {
//         timer.cancel();
//         _confirmExit();
//       }
//     });
//   }

//   void _cancelExitHold() {
//     if (!mounted) return;

//     _exitHoldProgressTimer?.cancel();
//     _exitHoldProgressTimer = null;

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) {
//         setState(() {
//           _isShowingExitConfirmation = false;
//           _isHoldingExitButton = false;
//           _exitHoldProgress = 0;
//         });
//       }
//     });
//   }

//   void _safePop() {
//     if (!mounted || _hasPopped) return;

//     _hasPopped = true;
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) {
//         Navigator.of(context).pop();
//       }
//     });
//   }

//   String _formatTime(int seconds) {
//     final mins = seconds ~/ 60;
//     final secs = seconds % 60;
//     return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
//   }

// // In _handleTimerCompletion method, simplify:
// Future<void> _handleTimerCompletion() async {
//   if (_completionCompleter != null) {
//     await _completionCompleter!.future;
//     return;
//   }

//   _completionCompleter = Completer<void>();

//   try {
//     final provider = context.read<FocusProvider>();
//     await provider.completeChunk();

//     // Just pop without showing anything
//     if (mounted && !_hasPopped) {
//       _safePop();
//     }
//   } catch (e) {
//     print('Error completing chunk: $e');

//     if (!mounted || _hasPopped) {
//       _completionCompleter?.complete();
//       return;
//     }

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Error completing chunk: $e'),
//         backgroundColor: Colors.red,
//       ),
//     );

//     if (mounted && !_hasPopped) {
//       _safePop();
//     }
//   } finally {
//     _completionCompleter?.complete();
//     _completionCompleter = null;
//   }
// }

// // Also remove the dialog code from _confirmExit method
// Future<void> _confirmExit() async {
//   if (!mounted || _isExiting || _hasPopped) return;

//   setState(() {
//     _isExiting = true;
//   });

//   final provider = context.read<FocusProvider>();

//   try {
//     await provider.exitEarly(); // This now handles showing penalty dialog

//     if (mounted && !_hasPopped) {
//       _safePop();
//     }
//   } catch (e) {
//     if (!mounted || _hasPopped) return;

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Error exiting: $e'),
//         backgroundColor: Colors.red,
//       ),
//     );

//     setState(() {
//       _isExiting = false;
//     });

//     // Wait a bit and then safely exit
//     await Future.delayed(const Duration(seconds: 1));
//     if (mounted && !_hasPopped) {
//       _safePop();
//     }
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         // Prevent back button navigation
//         return false;
//       },
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         body: Consumer<FocusProvider>(
//           builder: (context, provider, _) {
//             final remaining = provider.remainingSeconds;
//             final isChunkActive = provider.isChunkActive;

//             // Handle timer completion
//             if (remaining == 0 && isChunkActive) {
//               WidgetsBinding.instance.addPostFrameCallback((_) {
//                 if (mounted && !_hasPopped) {
//                   _handleTimerCompletion();
//                 }
//               });

//               return const Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     CircularProgressIndicator(color: Colors.amber),
//                     SizedBox(height: 20),
//                     Text(
//                       'Completing chunk...',
//                       style: TextStyle(color: Colors.white, fontSize: 16),
//                     ),
//                   ],
//                 ),
//               );
//             }

//             // If chunk is no longer active and we haven't already popped
//             if (!isChunkActive && !_hasPopped && !_isExiting) {
//               WidgetsBinding.instance.addPostFrameCallback((_) {
//                 if (mounted && !_hasPopped) {
//                   _safePop();
//                 }
//               });

//               return const Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     CircularProgressIndicator(color: Colors.amber),
//                     SizedBox(height: 20),
//                     Text(
//                       'Returning to home...',
//                       style: TextStyle(color: Colors.white, fontSize: 16),
//                     ),
//                   ],
//                 ),
//               );
//             }

//             // If we're in the process of exiting, show a simple loading indicator
//             if (_isExiting) {
//               return const Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     CircularProgressIndicator(color: Colors.amber),
//                     SizedBox(height: 20),
//                     Text(
//                       'Processing exit...',
//                       style: TextStyle(color: Colors.white, fontSize: 16),
//                     ),
//                   ],
//                 ),
//               );
//             }

//             final progress =
//                 1 - (remaining / (widget.chunk.plannedDurationMinutes * 60));

//             return Stack(
//               children: [
//                 // Main timer display
//                 Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       // Task name
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 40),
//                         child: Text(
//                           widget.chunk.taskDescription.toUpperCase(),
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             letterSpacing: 2,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 60),

//                       // Circular progress
//                       SizedBox(
//                         width: 280,
//                         height: 280,
//                         child: Stack(
//                           alignment: Alignment.center,
//                           children: [
//                             // Background circle
//                             Container(
//                               width: 280,
//                               height: 280,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 border: Border.all(
//                                   color: Colors.white.withOpacity(0.1),
//                                   width: 8,
//                                 ),
//                               ),
//                             ),

//                             // Progress circle
//                             SizedBox(
//                               width: 280,
//                               height: 280,
//                               child: CircularProgressIndicator(
//                                 value: progress,
//                                 strokeWidth: 8,
//                                 backgroundColor: Colors.transparent,
//                                 valueColor: const AlwaysStoppedAnimation<Color>(
//                                   Colors.amber,
//                                 ),
//                               ),
//                             ),

//                             // Time display
//                             Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Text(
//                                   _formatTime(remaining),
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 64,
//                                     fontWeight: FontWeight.bold,
//                                     fontFamily: 'monospace',
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   'REMAINING',
//                                   style: TextStyle(
//                                     color: Colors.white.withOpacity(0.6),
//                                     fontSize: 14,
//                                     letterSpacing: 2,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),

//                       const SizedBox(height: 60),

//                       // Warning text
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 40),
//                         child: Text(
//                           'Timer continues in background.\nExiting early incurs 2× penalty.',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             color: Colors.white.withOpacity(0.5),
//                             fontSize: 13,
//                             height: 1.5,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // Exit button (bottom)
//                 Positioned(
//                   bottom: 40,
//                   left: 40,
//                   right: 40,
//                   child: _isShowingExitConfirmation
//                       ? Column(
//                           children: [
//                             Text(
//                               _isHoldingExitButton
//                                   ? 'Hold to confirm exit (${(3 - (_exitHoldProgress / 100 * 3)).toStringAsFixed(1)}s)'
//                                   : 'Hold the red button for 3 seconds',
//                               style: const TextStyle(
//                                 color: Colors.red,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 12),
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: GestureDetector(
//                                     onLongPress: _startExitHold,
//                                     child: Stack(
//                                       children: [
//                                         // Progress background
//                                         Container(
//                                           height: 56,
//                                           decoration: BoxDecoration(
//                                             color: Colors.red.withOpacity(0.2),
//                                             borderRadius: BorderRadius.circular(
//                                               12,
//                                             ),
//                                           ),
//                                         ),
//                                         // Progress fill
//                                         AnimatedContainer(
//                                           duration: const Duration(
//                                             milliseconds: 100,
//                                           ),
//                                           height: 56,
//                                           width:
//                                               MediaQuery.of(
//                                                 context,
//                                               ).size.width *
//                                               (_exitHoldProgress / 100),
//                                           decoration: BoxDecoration(
//                                             color: Colors.red,
//                                             borderRadius: BorderRadius.circular(
//                                               12,
//                                             ),
//                                           ),
//                                         ),
//                                         // Button text
//                                         Container(
//                                           height: 56,
//                                           decoration: BoxDecoration(
//                                             borderRadius: BorderRadius.circular(
//                                               12,
//                                             ),
//                                             border: Border.all(
//                                               color: Colors.red.withOpacity(
//                                                 0.5,
//                                               ),
//                                               width: 2,
//                                             ),
//                                           ),
//                                           child: Center(
//                                             child: Text(
//                                               _isHoldingExitButton
//                                                   ? 'HOLDING... ${_exitHoldProgress}%'
//                                                   : 'HOLD TO EXIT',
//                                               style: const TextStyle(
//                                                 color: Colors.white,
//                                                 fontSize: 16,
//                                                 fontWeight: FontWeight.bold,
//                                                 letterSpacing: 1,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(width: 12),
//                                 GestureDetector(
//                                   onTap: _cancelExitHold,
//                                   child: Container(
//                                     padding: const EdgeInsets.all(16),
//                                     decoration: BoxDecoration(
//                                       border: Border.all(color: Colors.white30),
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                     child: const Icon(
//                                       Icons.close,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         )
//                       : GestureDetector(
//                           onTap: _showExitConfirmation,
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(vertical: 16),
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                 color: Colors.red.withOpacity(0.5),
//                               ),
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 'EXIT EARLY',
//                                 style: TextStyle(
//                                   color: Colors.red,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   letterSpacing: 1,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../models/focus_models.dart';
import '../providers/focus_provider.dart';

class FocusTimerScreen extends StatefulWidget {
  final FocusChunkModel chunk;

  const FocusTimerScreen({super.key, required this.chunk});

  @override
  State<FocusTimerScreen> createState() => _FocusTimerScreenState();
}

class _FocusTimerScreenState extends State<FocusTimerScreen>
    with WidgetsBindingObserver {
  Timer? _exitHoldTimer;
  bool _isExiting = false;
  bool _hasPopped = false;
  bool _isShowingExitConfirmation = false;
  bool _isHoldingExitButton = false;
  int _exitHoldProgress = 0;
  Timer? _exitHoldProgressTimer;
  Completer<void>? _completionCompleter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _exitHoldTimer?.cancel();
    _exitHoldProgressTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Timer continues even when app is backgrounded
  }

  void _showExitConfirmation() {
    if (!mounted || _isShowingExitConfirmation) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _isShowingExitConfirmation = true;
          _exitHoldProgress = 0;
          _isHoldingExitButton = false;
        });
      }
    });
  }

  void _startExitHold() {
    if (!mounted || _isHoldingExitButton) return;

    setState(() {
      _isHoldingExitButton = true;
      _exitHoldProgress = 0;
    });

    _exitHoldProgressTimer?.cancel();
    _exitHoldProgressTimer = Timer.periodic(const Duration(milliseconds: 50), (
      timer,
    ) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        _exitHoldProgress += 1.66
            .toInt(); // 100% over 3 seconds (3000ms / 50ms = 60 steps)
      });

      if (_exitHoldProgress >= 100) {
        timer.cancel();
        _confirmExit();
      }
    });
  }

  void _stopExitHold() {
    if (!mounted) return;

    _exitHoldProgressTimer?.cancel();
    _exitHoldProgressTimer = null;

    setState(() {
      _isHoldingExitButton = false;
    });
  }

  void _resetExitHold() {
    if (!mounted) return;

    _exitHoldProgressTimer?.cancel();
    _exitHoldProgressTimer = null;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _isShowingExitConfirmation = false;
          _isHoldingExitButton = false;
          _exitHoldProgress = 0;
        });
      }
    });
  }

  void _safePop() {
    if (!mounted || _hasPopped) return;

    _hasPopped = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Future<void> _handleTimerCompletion() async {
    if (_completionCompleter != null) {
      await _completionCompleter!.future;
      return;
    }

    _completionCompleter = Completer<void>();

    try {
      final provider = context.read<FocusProvider>();
      await provider.completeChunk();
      
      if (mounted && !_hasPopped) {
        _safePop();
      }
    } catch (e) {
      print('Error completing chunk: $e');

      if (!mounted || _hasPopped) {
        _completionCompleter?.complete();
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Iconsax.close_circle,
                color: Color(0xFFFF5555),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text('Error completing chunk: $e'),
            ],
          ),
          backgroundColor: Colors.black,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Color(0xFFFF5555), width: 1),
          ),
        ),
      );

      if (mounted && !_hasPopped) {
        await Future.delayed(const Duration(seconds: 1));
        _safePop();
      }
    } finally {
      _completionCompleter?.complete();
      _completionCompleter = null;
    }
  }

  Future<void> _confirmExit() async {
    if (!mounted || _isExiting || _hasPopped) return;

    setState(() {
      _isExiting = true;
    });

    final provider = context.read<FocusProvider>();

    try {
      await provider.exitEarly();

      if (mounted && !_hasPopped) {
        _safePop();
      }
    } catch (e) {
      if (!mounted || _hasPopped) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Iconsax.close_circle,
                color: Color(0xFFFF5555),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text('Error exiting: $e'),
            ],
          ),
          backgroundColor: Colors.black,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Color(0xFFFF5555), width: 1),
          ),
        ),
      );

      setState(() {
        _isExiting = false;
      });
      
      await Future.delayed(const Duration(seconds: 1));
      if (mounted && !_hasPopped) {
        _safePop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _showExitConfirmation();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Consumer<FocusProvider>(
          builder: (context, provider, _) {
            final remaining = provider.remainingSeconds;
            final isChunkActive = provider.isChunkActive;

            // Handle timer completion
            if (remaining == 0 && isChunkActive) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted && !_hasPopped) {
                  _handleTimerCompletion();
                }
              });

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: const CircularProgressIndicator(
                        color: Color(0xFF00CCCC),
                        strokeWidth: 3,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Completing focus chunk...',
                      style: TextStyle(color: Color(0xFF888888), fontSize: 14),
                    ),
                  ],
                ),
              );
            }

            // If chunk is no longer active
            if (!isChunkActive && !_hasPopped && !_isExiting) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted && !_hasPopped) {
                  _safePop();
                }
              });

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: const CircularProgressIndicator(
                        color: Color(0xFF00CCCC),
                        strokeWidth: 3,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Returning to home...',
                      style: TextStyle(color: Color(0xFF888888), fontSize: 14),
                    ),
                  ],
                ),
              );
            }

            // If we're in the process of exiting
            if (_isExiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: const CircularProgressIndicator(
                        color: Color(0xFF00CCCC),
                        strokeWidth: 3,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Processing exit...',
                      style: TextStyle(color: Color(0xFF888888), fontSize: 14),
                    ),
                  ],
                ),
              );
            }

            final progress =
                1 - (remaining / (widget.chunk.plannedDurationMinutes * 60));

            return Stack(
              children: [
                // Main timer display
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Task name
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 32),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0xFF1A1A1A),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xFF00CCCC).withOpacity(0.1),
                                border: Border.all(
                                  color: const Color(
                                    0xFF00CCCC,
                                  ).withOpacity(0.2),
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  Iconsax.timer_1,
                                  color: Color(0xFF00CCCC),
                                  size: 18,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CURRENT TASK',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.6),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    widget.chunk.taskDescription,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Circular progress timer
                      SizedBox(
                        width: 280,
                        height: 280,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Background circle
                            Container(
                              width: 280,
                              height: 280,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.05),
                                  width: 8,
                                ),
                              ),
                            ),

                            // Progress circle
                            SizedBox(
                              width: 280,
                              height: 280,
                              child: CircularProgressIndicator(
                                value: progress,
                                strokeWidth: 8,
                                backgroundColor: Colors.transparent,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xFF00CCCC),
                                ),
                              ),
                            ),

                            // Time display
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _formatTime(remaining),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 56,
                                    fontWeight: FontWeight.w800,
                                    fontFamily: 'monospace',
                                    letterSpacing: 2,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'REMAINING',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.4),
                                    fontSize: 12,
                                    letterSpacing: 3,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Progress info
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0xFF1A1A1A),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.05),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF00CCCC).withOpacity(0.1),
                                border: Border.all(
                                  color: const Color(
                                    0xFF00CCCC,
                                  ).withOpacity(0.2),
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  Iconsax.timer,
                                  color: Color(0xFF00CCCC),
                                  size: 12,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${widget.chunk.plannedDurationMinutes} minutes • ${(progress * 100).toStringAsFixed(0)}% complete',
                              style: const TextStyle(
                                color: Color(0xFF888888),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Warning at top
                Positioned(
                  top: 40,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: const Color(0xFFFF5555).withOpacity(0.05),
                      border: Border.all(
                        color: const Color(0xFFFF5555).withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFFF5555).withOpacity(0.1),
                            border: Border.all(
                              color: const Color(0xFFFF5555).withOpacity(0.2),
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Iconsax.warning_2,
                              color: Color(0xFFFF5555),
                              size: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Timer runs in background. Early exit incurs 2× penalty.',
                            style: TextStyle(
                              color: Color(0xFFFF5555),
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Exit button (bottom)
                Positioned(
                  bottom: 40,
                  left: 20,
                  right: 20,
                  child: _isShowingExitConfirmation
                      ? Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: const Color(0xFF1A1A1A),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.1),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: const Color(
                                            0xFFFF5555,
                                          ).withOpacity(0.1),
                                          border: Border.all(
                                            color: const Color(
                                              0xFFFF5555,
                                            ).withOpacity(0.2),
                                          ),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Iconsax.warning_2,
                                            color: Color(0xFFFF5555),
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      const Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'EARLY EXIT',
                                            style: TextStyle(
                                              color: Color(0xFFFF5555),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            'Hold to confirm exit',
                                            style: TextStyle(
                                              color: Color(0xFF888888),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  // Hold progress bar - FIXED GESTURE DETECTION
                                  Listener(
                                    onPointerDown: (_) => _startExitHold(),
                                    onPointerUp: (_) => _stopExitHold(),
                                    onPointerCancel: (_) => _stopExitHold(),
                                    child: Container(
                                      height: 56,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.2),
                                        ),
                                      ),
                                      child: Stack(
                                        children: [
                                          // Progress background
                                          Container(
                                            height: 56,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: Colors.white.withOpacity(
                                                0.05,
                                              ),
                                            ),
                                          ),
                                          // Progress fill
                                          AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 50,
                                            ),
                                            height: 56,
                                            width:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                (_exitHoldProgress / 100),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: const Color(0xFFFF5555),
                                            ),
                                          ),
                                          // Button text
                                          Container(
                                            height: 56,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: Colors.transparent,
                                            ),
                                            child: Center(
                                              child: Text(
                                                _isHoldingExitButton
                                                    ? 'HOLDING... ${_exitHoldProgress}%'
                                                    : 'PRESS & HOLD FOR 3 SECONDS',
                                                style: TextStyle(
                                                  color: _isHoldingExitButton
                                                      ? Colors.white
                                                      : const Color(0xFFFF5555),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  GestureDetector(
                                    onTap: _resetExitHold,
                                    child: Container(
                                      height: 56,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: const Color(0xFF1A1A1A),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.1),
                                        ),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'CANCEL',
                                          style: TextStyle(
                                            color: Color(0xFF888888),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : GestureDetector(
                          onTap: _showExitConfirmation,
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: const Color(0xFFFF5555),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFFFF5555,
                                  ).withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Iconsax.logout,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'EXIT EARLY',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
