import 'package:flutter/material.dart';
import '../models/os_card.dart';

class MindChangeCardWidget extends StatelessWidget {
  final MindChangeCard card;

  const MindChangeCardWidget({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'MIND CHANGE',
            style: TextStyle(
              color: Color(0xFF666666),
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 40),
          
          // DON'T
          _buildSection(
            label: 'DON\'T',
            content: card.dont,
            color: const Color(0xFF666666),
          ),
          
          const SizedBox(height: 32),
          
          // SAY
          _buildSection(
            label: 'SAY',
            content: card.say,
            color: Colors.white,
          ),
          
          const SizedBox(height: 32),
          
          // AIM
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF0A0A0A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AIM',
                  style: TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  card.aim,
                  style: const TextStyle(
                    color: Color(0xFFCCCCCC),
                    fontSize: 16,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String label,
    required String content,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF666666),
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: TextStyle(
            color: color,
            fontSize: 24,
            height: 1.4,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}