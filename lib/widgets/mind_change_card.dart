// Updated PerspectiveChangeCardWidget with modern design
import 'package:axiom/models/perspective_change.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class PerspectiveChangeCardWidget extends StatelessWidget {
  final PerspectiveChangeModel card;
  final Color? backgroundColor;

  const PerspectiveChangeCardWidget({
    super.key,
    required this.card,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: backgroundColor ?? const Color(0xFF1A1A1A),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with type indicator
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xFF00CCCC).withOpacity(0.1),
                    border: Border.all(
                      color: const Color(0xFF00CCCC).withOpacity(0.2),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      card.isCustom ? Iconsax.user : Iconsax.lamp_on,
                      color: const Color(0xFF00CCCC),
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  card.isCustom ? 'CUSTOM PERSPECTIVE' : 'PERSPECTIVE SHIFT',
                  style: const TextStyle(
                    color: Color(0xFF00CCCC),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Don't section
            _buildSection(
              label: 'DON\'T THINK',
              content: card.dont,
              icon: Iconsax.close_circle,
              color: const Color(0xFFFF5555),
            ),
            const SizedBox(height: 24),

            // Divider
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.white.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Say section
            _buildSection(
              label: 'THINK INSTEAD',
              content: card.say,
              icon: Iconsax.tick_circle,
              color: const Color(0xFF00FF88),
            ),
            const SizedBox(height: 32),

            // Aim section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color(0xFF0A0A0A),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xFFFF9900).withOpacity(0.1),
                          border: Border.all(
                            color: const Color(0xFFFF9900).withOpacity(0.2),
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Iconsax.flag_2,
                            color: Color(0xFFFF9900),
                            size: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'AIM',
                        style: TextStyle(
                          color: Color(0xFFFF9900),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    card.aim,
                    style: const TextStyle(
                      color: Color(0xFFCCCCCC),
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String label,
    required String content,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: color.withOpacity(0.1),
                border: Border.all(color: color.withOpacity(0.2)),
              ),
              child: Center(child: Icon(icon, color: color, size: 14)),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            content,
            style: TextStyle(
              color: color == const Color(0xFFFF5555)
                  ? const Color(0xFF888888)
                  : Colors.white,
              fontSize: 22,
              height: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

