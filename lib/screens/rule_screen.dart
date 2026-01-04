
// Updated RulesScreen with modern design
import 'package:axiom/providers/rule_provider.dart';
import 'package:axiom/screens/rule_management_screen.dart';
import 'package:axiom/widgets/rule_card.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class RulesScreen extends StatefulWidget {
  const RulesScreen({super.key}); 

  @override
  State<RulesScreen> createState() => _RulesScreenState();
}

class _RulesScreenState extends State<RulesScreen>
    with TickerProviderStateMixin {
  double _dragOffset = 0.0;
  bool _isDragging = false;
  late AnimationController _swipeController;
  late Animation<double> _swipeAnimation;

  @override
  void initState() {
    super.initState();
    _swipeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _swipeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _swipeController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _swipeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Consumer<RuleProvider>(
          builder: (context, provider, _) {
            if (!provider.isInitialized || provider.currentRule == null) {
              return Center(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: const CircularProgressIndicator(
                    color: Color(0xFF00CCCC),
                    strokeWidth: 2,
                  ),
                ),
              );
            }

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
                        
                        const SizedBox(width: 16),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'RULES',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Daily Operating System',
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
                                Iconsax.setting_4,
                                color: Color(0xFF00CCCC),
                                size: 18,
                              ),
                            ),
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RuleManagementScreen(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Yesterday's rule button
                if (provider.yesterdayRule != null)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.black,
                          isScrollControlled: true,
                          builder: (context) => DraggableScrollableSheet(
                            initialChildSize: 0.9,
                            builder: (context, scrollController) => Container(
                              decoration: const BoxDecoration(
                                color: Color(0xFF1A1A1A),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: SingleChildScrollView(
                                controller: scrollController,
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 4,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.3),
                                          borderRadius: BorderRadius.circular(
                                            2,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      RuleCard(
                                        rule: provider.yesterdayRule!,
                                        onAudioTap: () {},
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
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
                                color: const Color(0xFFFF9900).withOpacity(0.1),
                                border: Border.all(
                                  color: const Color(
                                    0xFFFF9900,
                                  ).withOpacity(0.2),
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.history,
                                  color: Color(0xFFFF9900),
                                  size: 18,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'YESTERDAY\'S RULE',
                                    style: TextStyle(
                                      color: Color(0xFFFF9900),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Tap to review previous rule',
                                    style: TextStyle(
                                      color: Color(0xFF888888),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white.withOpacity(0.05),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.1),
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  Iconsax.arrow_up_2,
                                  color: Color(0xFF666666),
                                  size: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // Main content
                Expanded(
                  child: GestureDetector(
                    onHorizontalDragStart: (_) {
                      setState(() {
                        _isDragging = true;
                      });
                    },
                    onHorizontalDragUpdate: (details) {
                      setState(() {
                        _dragOffset += details.delta.dx;
                        _dragOffset = _dragOffset.clamp(-300.0, 300.0);
                      });
                    },
                    onHorizontalDragEnd: (details) async {
                      final screenWidth = MediaQuery.of(context).size.width;
                      final threshold = screenWidth * 0.25;

                      if (_dragOffset > threshold) {
                        await _swipeRight(provider);
                      } else if (_dragOffset < -threshold) {
                        await _swipeLeft(provider);
                      } else {
                        await _resetPosition();
                      }
                    },
                    child: AnimatedBuilder(
                      animation: _swipeAnimation,
                      builder: (context, child) {
                        double offset = _dragOffset;

                        if (_swipeController.isAnimating) {
                          offset = _dragOffset * (1 - _swipeAnimation.value);
                        }

                        return Transform.translate(
                          offset: Offset(offset, 0),
                          child: _buildCurrentCard(provider),
                        );
                      },
                    ),
                  ),
                ),

                // Bottom controls
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Column(
                    children: [
                      // Progress dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, (index) {
                          final isActive = index == provider.currentCardIndex;
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            width: isActive ? 12 : 8,
                            height: isActive ? 12 : 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isActive
                                  ? const Color(0xFF00CCCC)
                                  : const Color(0xFF333333),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 16),

                      // Swipe instructions
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0xFF1A1A1A),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (provider.currentCardIndex > 0) ...[
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: const Color(
                                    0xFF00CCCC,
                                  ).withOpacity(0.1),
                                  border: Border.all(
                                    color: const Color(
                                      0xFF00CCCC,
                                    ).withOpacity(0.2),
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
                              const SizedBox(width: 8),
                              const Text(
                                'BACK',
                                style: TextStyle(
                                  color: Color(0xFF888888),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                            if (provider.currentCardIndex > 0 &&
                                provider.currentCardIndex < 3) ...[
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                width: 1,
                                height: 12,
                                color: Colors.white.withOpacity(0.1),
                              ),
                            ],
                            if (provider.currentCardIndex < 3) ...[
                              const Text(
                                'NEXT',
                                style: TextStyle(
                                  color: Color(0xFF888888),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: const Color(
                                    0xFF00CCCC,
                                  ).withOpacity(0.1),
                                  border: Border.all(
                                    color: const Color(
                                      0xFF00CCCC,
                                    ).withOpacity(0.2),
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
                            ],
                          ],
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

  Widget _buildCurrentCard(RuleProvider provider) {
    final rule = provider.currentRule!;
    final cardIndex = provider.currentCardIndex;

    switch (cardIndex) {
      case 0:
        return RuleCard1(rule: rule);
      case 1:
        return RuleCard2(rule: rule);
      case 2:
        return RuleCard3(rule: rule);
      case 3:
        return RuleCard4(
          rule: rule,
          onAudioTap: () => provider.playMantra(),
        );
      default:
        return RuleCard1(rule: rule);
    }
  }

  Future<void> _swipeRight(RuleProvider provider) async {
    await provider.nextCard();
    await _animateToReset();
  }

  Future<void> _swipeLeft(RuleProvider provider) async {
    await provider.previousCard();
    await _animateToReset();
  }

  Future<void> _resetPosition() async {
    await _animateToReset();
  }

  Future<void> _animateToReset() async {
    await _swipeController.forward();
    setState(() {
      _dragOffset = 0.0;
      _isDragging = false;
    });
    _swipeController.reset();
  }
}
