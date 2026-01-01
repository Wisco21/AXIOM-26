// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/rule_provider.dart';
// import '../widgets/rule_card.dart';

// class RulesScreen extends StatefulWidget {
//   const RulesScreen({super.key});

//   @override
//   State<RulesScreen> createState() => _RulesScreenState();
// }

// class _RulesScreenState extends State<RulesScreen> {
//   Offset _position = Offset.zero;
//   bool _isDragging = false;
//   double _opacity = 1.0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF000000),
//       body: SafeArea(
//         child: Consumer<RuleProvider>(
//           builder: (context, provider, _) {
//             if (!provider.isInitialized || provider.currentRule == null) {
//               return const Center(
//                 child: CircularProgressIndicator(color: Colors.white),
//               );
//             }

//             return Column(
//               children: [
//                 // Header with streak
//                 _buildHeader(provider),
                
//                 // Yesterday's rule button
//                 if (provider.yesterdayRule != null)
//                   _buildYesterdayButton(provider),

//                 Expanded(
//                   child: Stack(
//                     children: [
//                       // Swipe instruction
//                       if (!provider.isDailyCompleted)
//                         Positioned(
//                           bottom: 100,
//                           left: 0,
//                           right: 0,
//                           child: Center(
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 20,
//                                 vertical: 10,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: const Color(0xFF1A1A1A),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: const Text(
//                                 'SWIPE RIGHT TO CONTINUE →',
//                                 style: TextStyle(
//                                   color: Color(0xFF666666),
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w600,
//                                   letterSpacing: 1.5,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),

//                       // Current card
//                       Positioned.fill(
//                         child: GestureDetector(
//                           onPanStart: (_) {
//                             if (!provider.isDailyCompleted) {
//                               setState(() {
//                                 _isDragging = true;
//                               });
//                             }
//                           },
//                           onPanUpdate: (details) {
//                             if (!provider.isDailyCompleted) {
//                               setState(() {
//                                 _position += details.delta;
//                                 _opacity = 1.0 - (_position.dx.abs() / 200).clamp(0.0, 0.7);
//                               });
//                             }
//                           },
//                           onPanEnd: (details) {
//                             if (!provider.isDailyCompleted) {
//                               final threshold = MediaQuery.of(context).size.width * 0.3;

//                               if (_position.dx > threshold) {
//                                 _handleSwipeRight(provider);
//                               } else {
//                                 setState(() {
//                                   _position = Offset.zero;
//                                   _opacity = 1.0;
//                                   _isDragging = false;
//                                 });
//                               }
//                             }
//                           },
//                           child: Transform.translate(
//                             offset: _position,
//                             child: Transform.rotate(
//                               angle: _position.dx * 0.0005,
//                               child: Opacity(
//                                 opacity: _opacity,
//                                 child: _buildCurrentCard(provider),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),

//                       // Completed overlay
//                       if (provider.isDailyCompleted)
//                         Positioned(
//                           top: MediaQuery.of(context).size.height * 0.3,
//                           left: 0,
//                           right: 0,
//                           child: Center(
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 32,
//                                 vertical: 16,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: const Color(0xFF2A2A2A),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: const Text(
//                                 'COMPLETED',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.w700,
//                                   letterSpacing: 2,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader(RuleProvider provider) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//       decoration: const BoxDecoration(
//         color: Color(0xFF0A0A0A),
//         border: Border(
//           bottom: BorderSide(color: Color(0xFF1A1A1A), width: 1),
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'TODAY\'S RULE',
//                 style: TextStyle(
//                   color: Color(0xFF666666),
//                   fontSize: 10,
//                   fontWeight: FontWeight.w600,
//                   letterSpacing: 1,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 provider.currentRule!.title.toUpperCase(),
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ],
//           ),
//           Column(
//             children: [
//               const Text(
//                 'STREAK',
//                 style: TextStyle(
//                   color: Color(0xFF666666),
//                   fontSize: 10,
//                   fontWeight: FontWeight.w600,
//                   letterSpacing: 1,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 provider.totalDaysOpened.toString(),
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 20,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildYesterdayButton(RuleProvider provider) {
//     return GestureDetector(
//       onTap: () {
//         showModalBottomSheet(
//           context: context,
//           backgroundColor: const Color(0xFF000000),
//           isScrollControlled: true,
//           builder: (context) => DraggableScrollableSheet(
//             initialChildSize: 0.9,
//             builder: (context, scrollController) => SingleChildScrollView(
//               controller: scrollController,
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: RuleCard(
//                   rule: provider.yesterdayRule!,
//                   onAudioTap: () {},
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//         decoration: BoxDecoration(
//           color: const Color(0xFF1A1A1A),
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
//         ),
//         child: const Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.history, color: Color(0xFF666666), size: 16),
//             SizedBox(width: 8),
//             Text(
//               'YESTERDAY\'S RULE',
//               style: TextStyle(
//                 color: Color(0xFF666666),
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 letterSpacing: 1,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCurrentCard(RuleProvider provider) {
//     final rule = provider.currentRule!;
//     final cardIndex = provider.currentCardIndex;

//     switch (cardIndex) {
//       case 0:
//         return RuleCard1(rule: rule);
//       case 1:
//         return RuleCard2(rule: rule);
//       case 2:
//         return RuleCard3(rule: rule);
//       case 3:
//         return RuleCard4(
//           rule: rule,
//           onAudioTap: () => provider.playMantra(),
//         );
//       default:
//         return RuleCard1(rule: rule);
//     }
//   }

//   void _handleSwipeRight(RuleProvider provider) async {
//     await provider.nextCard();
//     setState(() {
//       _position = Offset.zero;
//       _opacity = 1.0;
//       _isDragging = false;
//     });
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/rule_provider.dart';
import '../widgets/rule_card.dart';

class RulesScreen extends StatefulWidget {
  const RulesScreen({super.key});

  @override
  State<RulesScreen> createState() => _RulesScreenState();
}

class _RulesScreenState extends State<RulesScreen> {
  Offset _position = Offset.zero;
  bool _isDragging = false;
  double _opacity = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: Consumer<RuleProvider>(
          builder: (context, provider, _) {
            if (!provider.isInitialized || provider.currentRule == null) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            return Column(
              children: [
                // Header with streak
                _buildHeader(provider),
                
                // Yesterday's rule button
                if (provider.yesterdayRule != null)
                  _buildYesterdayButton(provider),

                Expanded(
                  child: Stack(
                    children: [
                      // Current card
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
                            final threshold = MediaQuery.of(context).size.width * 0.3;

                            if (_position.dx > threshold) {
                              _handleSwipeRight(provider);
                            } else if (_position.dx < -threshold) {
                              _handleSwipeLeft(provider);
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
                                child: _buildCurrentCard(provider),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom controls (progress dots + swipe instructions)
                _buildBottomControls(provider),
                const SizedBox(height: 24),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(RuleProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF0A0A0A),
        border: Border(
          bottom: BorderSide(color: Color(0xFF1A1A1A), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'TODAY\'S RULE',
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                provider.currentRule!.title.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Column(
            children: [
              const Text(
                'STREAK',
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                provider.totalDaysOpened.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildYesterdayButton(RuleProvider provider) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: const Color(0xFF000000),
          isScrollControlled: true,
          builder: (context) => DraggableScrollableSheet(
            initialChildSize: 0.9,
            builder: (context, scrollController) => SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: RuleCard(
                  rule: provider.yesterdayRule!,
                  onAudioTap: () {},
                ),
              ),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, color: Color(0xFF666666), size: 16),
            SizedBox(width: 8),
            Text(
              'YESTERDAY\'S RULE',
              style: TextStyle(
                color: Color(0xFF666666),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomControls(RuleProvider provider) {
    final cardIndex = provider.currentCardIndex;
    final isFirstCard = cardIndex == 0;
    final isLastCard = cardIndex == 3;

    return Column(
      children: [
        // Progress dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: index == cardIndex ? 12 : 8,
              height: index == cardIndex ? 12 : 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index == cardIndex 
                    ? Colors.white 
                    : const Color(0xFF333333),
              ),
            );
          }),
        ),
        const SizedBox(height: 16),

        // Swipe instructions
        if (isFirstCard)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'SWIPE RIGHT TO CONTINUE →',
              style: TextStyle(
                color: Color(0xFF666666),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
            ),
          )
        else if (isLastCard)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '← BACK',
              style: TextStyle(
                color: Color(0xFF666666),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
            ),
          )
        else
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '← BACK',
                  style: TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                  ),
                ),
                SizedBox(width: 24),
                Text(
                  'FORWARD →',
                  style: TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
      ],
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

  void _handleSwipeRight(RuleProvider provider) async {
    await provider.nextCard();
    setState(() {
      _position = Offset.zero;
      _opacity = 1.0;
      _isDragging = false;
    });
  }

  void _handleSwipeLeft(RuleProvider provider) async {
    await provider.previousCard();
    setState(() {
      _position = Offset.zero;
      _opacity = 1.0;
      _isDragging = false;
    });
  }
}