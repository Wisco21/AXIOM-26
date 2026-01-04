// lib/screens/perspective_change_screen.dart
import 'package:axiom/screens/perspective_change_management.dart';
import 'package:axiom/widgets/mind_change_card.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../providers/perspective_change_provider.dart';

class PerspectiveChangeScreen extends StatefulWidget {
  const PerspectiveChangeScreen({super.key});

  @override
  State<PerspectiveChangeScreen> createState() =>
      _PerspectiveChangeScreenState();
}

class _PerspectiveChangeScreenState extends State<PerspectiveChangeScreen> {
  Offset _position = Offset.zero;
  bool _isDragging = false;
  double _rotation = 0.0;

  final List<Color> _cardColors = [
    const Color(0xFF1A1A1A),
    const Color(0xFF1C1C1C),
    const Color(0xFF181818),
    const Color(0xFF1B1B1B),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Consumer<PerspectiveChangeProvider>(
          builder: (context, provider, _) {
            return Column(
              children: [
                // Header
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0A0A),
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white.withOpacity(0.05),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PERSPECTIVE SHIFT',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Change your mindset',
                              style: TextStyle(
                                color: Color(0xFF666666),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          icon: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFF1A1A1A),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1),
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Iconsax.edit_2,
                                color: Color(0xFF00CCCC),
                                size: 18,
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const PerspectiveChangeManagementScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Main Content
                Expanded(
                  child: Stack(
                    children: [
                      // Background cards
                      if (provider.cards.isNotEmpty) ...[
                        // Bottom-most card
                        Positioned.fill(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 60,
                              left: 32,
                              right: 16,
                              bottom: 40,
                            ),
                            child: Transform.translate(
                              offset: const Offset(8, 12),
                              child: Transform.rotate(
                                angle: 0.06,
                                child: _buildBackgroundCard(
                                  provider: provider,
                                  depth: 3,
                                  color: _cardColors[2],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Middle card
                        Positioned.fill(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 40,
                              left: 24,
                              right: 24,
                              bottom: 20,
                            ),
                            child: Transform.translate(
                              offset: const Offset(-4, 8),
                              child: Transform.rotate(
                                angle: -0.03,
                                child: _buildBackgroundCard(
                                  provider: provider,
                                  depth: 2,
                                  color: _cardColors[1],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Top background card
                        Positioned.fill(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 20,
                              left: 16,
                              right: 32,
                              bottom: 10,
                            ),
                            child: Transform.translate(
                              offset: const Offset(4, 4),
                              child: Transform.rotate(
                                angle: 0.02,
                                child: _buildBackgroundCard(
                                  provider: provider,
                                  depth: 1,
                                  color: _cardColors[3],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],

                      // Current card (swipeable)
                      Positioned.fill(
                        child: GestureDetector(
                          onPanStart: (_) {
                            if (provider.cards.length > 1) {
                              setState(() {
                                _isDragging = true;
                              });
                            }
                          },
                          onPanUpdate: (details) {
                            if (provider.cards.length > 1) {
                              setState(() {
                                _position += details.delta;
                                _rotation = _position.dx / 1000;
                              });
                            }
                          },
                          onPanEnd: (details) {
                            if (provider.cards.length > 1) {
                              final threshold = 100.0;
                              final velocity =
                                  details.velocity.pixelsPerSecond.dx;

                              if (_position.dx.abs() > threshold ||
                                  velocity.abs() > 500) {
                                _handleSwipe(provider);
                              } else {
                                setState(() {
                                  _position = Offset.zero;
                                  _rotation = 0.0;
                                  _isDragging = false;
                                });
                              }
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            child: Transform.translate(
                              offset: _position,
                              child: Transform.rotate(
                                angle: _rotation,
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: PerspectiveChangeCardWidget(
                                    card: provider.currentCard,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Swipe instruction
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xFF1A1A1A),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (provider.cards.length > 1) ...[
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: const Color(0xFF00CCCC).withOpacity(0.1),
                              border: Border.all(
                                color: const Color(0xFF00CCCC).withOpacity(0.2),
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Iconsax.arrow_left_2,
                                color: Color(0xFF00CCCC),
                                size: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'SWIPE TO CHANGE',
                            style: TextStyle(
                              color: Color(0xFF888888),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: const Color(0xFF00CCCC).withOpacity(0.1),
                              border: Border.all(
                                color: const Color(0xFF00CCCC).withOpacity(0.2),
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Iconsax.arrow_right_3,
                                color: Color(0xFF00CCCC),
                                size: 12,
                              ),
                            ),
                          ),
                        ] else ...[
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: const Color(0xFF00CCCC).withOpacity(0.1),
                              border: Border.all(
                                color: const Color(0xFF00CCCC).withOpacity(0.2),
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Iconsax.add,
                                color: Color(0xFF00CCCC),
                                size: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'ADD CARDS TO GET STARTED',
                            style: TextStyle(
                              color: Color(0xFF888888),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ],
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

  Widget _buildBackgroundCard({
    required PerspectiveChangeProvider provider,
    required int depth,
    required Color color,
  }) {
    if (provider.cards.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: color,
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: const Center(
          child: Text(
            'Add perspective cards\nin management screen',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF666666), fontSize: 14),
          ),
        ),
      );
    }

    final nextIndex = (provider.currentIndex + depth) % provider.cards.length;
    final nextCard = provider.cards[nextIndex];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color,
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Opacity(
        opacity: 0.6,
        child: PerspectiveChangeCardWidget(
          card: nextCard,
          backgroundColor: color,
        ),
      ),
    );
  }

  void _handleSwipe(PerspectiveChangeProvider provider) {
    if (provider.cards.isEmpty) {
      setState(() {
        _position = Offset.zero;
        _rotation = 0.0;
        _isDragging = false;
      });
      return;
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final direction = _position.dx > 0 ? 1 : -1;

    setState(() {
      _position = Offset(screenWidth * 1.5 * direction, _position.dy);
      _rotation = direction * 0.3;
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      provider.nextCard();
      setState(() {
        _position = Offset.zero;
        _rotation = 0.0;
        _isDragging = false;
      });
    });
  }
}
