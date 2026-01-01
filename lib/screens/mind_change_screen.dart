import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/rule_provider.dart';
import '../widgets/mind_change_card.dart';

class MindChangeScreen extends StatefulWidget {
  const MindChangeScreen({super.key});

  @override
  State<MindChangeScreen> createState() => _MindChangeScreenState();
}

class _MindChangeScreenState extends State<MindChangeScreen> {
  Offset _position = Offset.zero;
  bool _isDragging = false;
  double _opacity = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: Consumer<MindChangeProvider>(
          builder: (context, provider, _) {
            return Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF0A0A0A),
                    border: Border(
                      bottom: BorderSide(color: Color(0xFF1A1A1A), width: 1),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'MIND CHANGE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Stack(
                    children: [
                      // Swipe instruction
                      Positioned(
                        bottom: 100,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1A1A),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'SWIPE TO CONTINUE',
                              style: TextStyle(
                                color: Color(0xFF666666),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Card
                      Positioned.fill(
                        child: GestureDetector(
                          onPanStart: (_) {
                            setState(() {
                              _isDragging = true;
                            });
                          },
                          onPanUpdate: (details) {
                            setState(() {
                              _position += details.delta;
                              _opacity = 1.0 - (_position.dx.abs() / 200).clamp(0.0, 0.7);
                            });
                          },
                          onPanEnd: (details) {
                            final threshold = MediaQuery.of(context).size.width * 0.25;

                            if (_position.dx.abs() > threshold) {
                              _handleSwipe(provider);
                            } else {
                              setState(() {
                                _position = Offset.zero;
                                _opacity = 1.0;
                                _isDragging = false;
                              });
                            }
                          },
                          child: Transform.translate(
                            offset: _position,
                            child: Transform.rotate(
                              angle: _position.dx * 0.0005,
                              child: Opacity(
                                opacity: _opacity,
                                child: MindChangeCardWidget(
                                  card: provider.currentCard,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _handleSwipe(MindChangeProvider provider) {
    provider.nextCard();
    setState(() {
      _position = Offset.zero;
      _opacity = 1.0;
      _isDragging = false;
    });
  }
}