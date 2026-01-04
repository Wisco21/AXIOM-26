
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool _hasPopped = false; // Track if we've already popped

  // Track exit button state
  bool _isShowingExitConfirmation = false;
  bool _isHoldingExitButton = false;
  int _exitHoldProgress = 0; // 0-100 percentage
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

    // Cancel any existing timer
    _exitHoldProgressTimer?.cancel();

    // Start progress timer
    _exitHoldProgressTimer = Timer.periodic(const Duration(milliseconds: 100), (
      timer,
    ) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        _exitHoldProgress += 3; // 100/33.33 = ~3 seconds
      });

      if (_exitHoldProgress >= 100) {
        timer.cancel();
        _confirmExit();
      }
    });
  }

  void _cancelExitHold() {
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

// In _handleTimerCompletion method, simplify:
Future<void> _handleTimerCompletion() async {
  if (_completionCompleter != null) {
    await _completionCompleter!.future;
    return;
  }

  _completionCompleter = Completer<void>();

  try {
    final provider = context.read<FocusProvider>();
    await provider.completeChunk();
    
    // Just pop without showing anything
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
        content: Text('Error completing chunk: $e'),
        backgroundColor: Colors.red,
      ),
    );

    if (mounted && !_hasPopped) {
      _safePop();
    }
  } finally {
    _completionCompleter?.complete();
    _completionCompleter = null;
  }
}

// Also remove the dialog code from _confirmExit method
Future<void> _confirmExit() async {
  if (!mounted || _isExiting || _hasPopped) return;
  
  setState(() {
    _isExiting = true;
  });

  final provider = context.read<FocusProvider>();
  
  try {
    await provider.exitEarly(); // This now handles showing penalty dialog
    
    if (mounted && !_hasPopped) {
      _safePop();
    }
  } catch (e) {
    if (!mounted || _hasPopped) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error exiting: $e'),
        backgroundColor: Colors.red,
      ),
    );
    
    setState(() {
      _isExiting = false;
    });
    
    // Wait a bit and then safely exit
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
        // Prevent back button navigation
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

              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.amber),
                    SizedBox(height: 20),
                    Text(
                      'Completing chunk...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              );
            }

            // If chunk is no longer active and we haven't already popped
            if (!isChunkActive && !_hasPopped && !_isExiting) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted && !_hasPopped) {
                  _safePop();
                }
              });

              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.amber),
                    SizedBox(height: 20),
                    Text(
                      'Returning to home...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              );
            }

            // If we're in the process of exiting, show a simple loading indicator
            if (_isExiting) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.amber),
                    SizedBox(height: 20),
                    Text(
                      'Processing exit...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          widget.chunk.taskDescription.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),

                      // Circular progress
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
                                  color: Colors.white.withOpacity(0.1),
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
                                  Colors.amber,
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
                                    fontSize: 64,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'REMAINING',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 14,
                                    letterSpacing: 2,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 60),

                      // Warning text
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          'Timer continues in background.\nExiting early incurs 2× penalty.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Exit button (bottom)
                Positioned(
                  bottom: 40,
                  left: 40,
                  right: 40,
                  child: _isShowingExitConfirmation
                      ? Column(
                          children: [
                            Text(
                              _isHoldingExitButton
                                  ? 'Hold to confirm exit (${(3 - (_exitHoldProgress / 100 * 3)).toStringAsFixed(1)}s)'
                                  : 'Hold the red button for 3 seconds',
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onLongPress: _startExitHold,
                                    child: Stack(
                                      children: [
                                        // Progress background
                                        Container(
                                          height: 56,
                                          decoration: BoxDecoration(
                                            color: Colors.red.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        // Progress fill
                                        AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 100,
                                          ),
                                          height: 56,
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              (_exitHoldProgress / 100),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        // Button text
                                        Container(
                                          height: 56,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: Colors.red.withOpacity(
                                                0.5,
                                              ),
                                              width: 2,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              _isHoldingExitButton
                                                  ? 'HOLDING... ${_exitHoldProgress}%'
                                                  : 'HOLD TO EXIT',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                GestureDetector(
                                  onTap: _cancelExitHold,
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white30),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : GestureDetector(
                          onTap: _showExitConfirmation,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.red.withOpacity(0.5),
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text(
                                'EXIT EARLY',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
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
