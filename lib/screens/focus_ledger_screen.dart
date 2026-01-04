import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:developer' as developer;
import '../services/focus_storage_service.dart';
import '../models/focus_models.dart';

class LedgerScreen extends StatefulWidget {
  const LedgerScreen({super.key});

  @override
  State<LedgerScreen> createState() => _LedgerScreenState();
}

class _LedgerScreenState extends State<LedgerScreen> {
  final FocusStorageService _storage = FocusStorageService();
  List<PenaltyLedgerModel>? _penalties;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPenalties();
  }

  Future<void> _loadPenalties() async {
    setState(() => _isLoading = true);
    
    try {
      final penalties = await _storage.getAllPenalties();
      setState(() {
        _penalties = penalties;
        _isLoading = false;
      });
    } catch (e) {
      developer.log('Error loading penalties: $e');
      setState(() => _isLoading = false);
    }
  }

  Color _getReasonColor(PenaltyReason reason) {
    switch (reason) {
      case PenaltyReason.earlyExit:
        return const Color(0xFFFF9900); // Orange
      case PenaltyReason.rollover:
        return const Color(0xFFFF5555); // Red
      case PenaltyReason.disciplineTax:
        return const Color(0xFFFF3366); // Deep pink
    }
  }

  IconData _getReasonIcon(PenaltyReason reason) {
    switch (reason) {
      case PenaltyReason.earlyExit:
        return Iconsax.logout;
      case PenaltyReason.rollover:
        return Iconsax.forward_10_seconds;
      case PenaltyReason.disciplineTax:
        return Iconsax.glass;
    }
  }

  void _showPenaltyInfo() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFFFF5555).withOpacity(0.1),
                      border: Border.all(color: const Color(0xFFFF5555).withOpacity(0.2)),
                    ),
                    child: const Center(
                      child: Icon(Iconsax.info_circle, color: Color(0xFFFF5555), size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'PENALTY SYSTEM',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFF0A0A0A),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _PenaltyInfoItem(
                      title: 'EARLY EXIT (2×)',
                      description: 'When you exit a focus chunk before completion, you incur 2× the remaining time as penalty debt.',
                      color: const Color(0xFFFF9900),
                    ),
                    const SizedBox(height: 16),
                    _PenaltyInfoItem(
                      title: 'ROLLOVER (1.5×)',
                      description: 'If penalty debt remains unpaid by midnight, it rolls over to the next day with a 1.5× multiplier.',
                      color: const Color(0xFFFF5555),
                    ),
                    const SizedBox(height: 16),
                    _PenaltyInfoItem(
                      title: 'DISCIPLINE TAX (+10 min)',
                      description: 'If a rolled penalty remains unpaid the following day, a fixed 10-minute discipline tax is added.',
                      color: const Color(0xFFFF3366),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xFFFF5555).withOpacity(0.05),
                        border: Border.all(color: const Color(0xFFFF5555).withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFFF5555).withOpacity(0.1),
                              border: Border.all(color: const Color(0xFFFF5555).withOpacity(0.3)),
                            ),
                            child: const Center(
                              child: Icon(
                                Iconsax.warning_2,
                                color: Color(0xFFFF5555),
                                size: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'No forgiveness. No caps. No resets.',
                              style: TextStyle(
                                color: Color(0xFFFF5555),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5555),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'UNDERSTOOD',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalUnpaid = _penalties?.fold<int>(0, (sum, p) => sum + p.minutes) ?? 0;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0A0A0A),
                border: Border(
                  bottom: BorderSide(color: Colors.white.withOpacity(0.05), width: 1),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0xFF1A1A1A),
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: const Center(
                          child: Icon(
                            Iconsax.arrow_left_2,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PENALTY LEDGER',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Debt & Penalty History',
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
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: const Center(
                          child: Icon(
                            Iconsax.info_circle,
                            color: Color(0xFFFF5555),
                            size: 18,
                          ),
                        ),
                      ),
                      onPressed: _showPenaltyInfo,
                    ),
                  ],
                ),
              ),
            ),

            // Content
            Expanded(
              child: _isLoading
                  ? Center(
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: const CircularProgressIndicator(
                          color: Color(0xFFFF5555),
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          // Total Debt Card
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: totalUnpaid > 0
                                    ? const Color(0xFF1A1A1A)
                                    : const Color(0xFF1A1A1A),
                                border: Border.all(
                                  color: totalUnpaid > 0
                                      ? const Color(0xFFFF5555).withOpacity(0.3)
                                      : const Color(0xFF00FF88).withOpacity(0.3),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: totalUnpaid > 0
                                              ? const Color(0xFFFF5555).withOpacity(0.1)
                                              : const Color(0xFF00FF88).withOpacity(0.1),
                                          border: Border.all(
                                            color: totalUnpaid > 0
                                                ? const Color(0xFFFF5555).withOpacity(0.2)
                                                : const Color(0xFF00FF88).withOpacity(0.2),
                                          ),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            totalUnpaid > 0
                                                ? Iconsax.danger
                                                : Iconsax.tick_circle,
                                            color: totalUnpaid > 0
                                                ? const Color(0xFFFF5555)
                                                : const Color(0xFF00FF88),
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            totalUnpaid > 0 ? 'TOTAL DEBT' : 'ALL CLEAR',
                                            style: TextStyle(
                                              color: totalUnpaid > 0
                                                  ? const Color(0xFFFF5555)
                                                  : const Color(0xFF00FF88),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            totalUnpaid > 0 ? 'Unpaid penalties' : 'No outstanding debt',
                                            style: const TextStyle(
                                              color: Color(0xFF666666),
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    '$totalUnpaid',
                                    style: TextStyle(
                                      color: totalUnpaid > 0
                                          ? const Color(0xFFFF5555)
                                          : const Color(0xFF00FF88),
                                      fontSize: 56,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -2,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'MINUTES',
                                    style: TextStyle(
                                      color: totalUnpaid > 0
                                          ? const Color(0xFFFF5555).withOpacity(0.7)
                                          : const Color(0xFF00FF88).withOpacity(0.7),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                  if (totalUnpaid > 0) ...[
                                    const SizedBox(height: 16),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color(0xFF0A0A0A),
                                        border: Border.all(color: Colors.white.withOpacity(0.05)),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 28,
                                            height: 28,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              color: const Color(0xFFFF9900).withOpacity(0.1),
                                              border: Border.all(color: const Color(0xFFFF9900).withOpacity(0.2)),
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                Iconsax.lamp_charge,
                                                color: Color(0xFFFF9900),
                                                size: 14,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          const Expanded(
                                            child: Text(
                                              'Complete focus chunks to automatically pay debt',
                                              style: TextStyle(
                                                color: Color(0xFF888888),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),

                          // Penalties List Header
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xFF1A1A1A),
                                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Iconsax.document_text,
                                      color: Color(0xFF00CCCC),
                                      size: 18,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'PENALTY HISTORY',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'All recorded penalties',
                                      style: TextStyle(
                                        color: Color(0xFF666666),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Penalties List
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: _penalties == null || _penalties!.isEmpty
                                ? Container(
                                    padding: const EdgeInsets.all(40),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: const Color(0xFF0A0A0A),
                                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 64,
                                          height: 64,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: const Color(0xFF1A1A1A),
                                            border: Border.all(color: Colors.white.withOpacity(0.1)),
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Iconsax.document_text,
                                              color: Color(0xFF666666),
                                              size: 28,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        const Text(
                                          'No penalty records',
                                          style: TextStyle(
                                            color: Color(0xFF666666),
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'All penalties will appear here',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.3),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Column(
                                    children: _penalties!.map((penalty) {
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 12),
                                        child: _PenaltyCard(penalty: penalty),
                                      );
                                    }).toList(),
                                  ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PenaltyCard extends StatelessWidget {
  final PenaltyLedgerModel penalty;

  const _PenaltyCard({required this.penalty});

  Color get _reasonColor {
    switch (penalty.reason) {
      case PenaltyReason.earlyExit:
        return const Color(0xFFFF9900); // Orange
      case PenaltyReason.rollover:
        return const Color(0xFFFF5555); // Red
      case PenaltyReason.disciplineTax:
        return const Color(0xFFFF3366); // Deep pink
    }
  }

  IconData get _reasonIcon {
    switch (penalty.reason) {
      case PenaltyReason.earlyExit:
        return Iconsax.logout;
      case PenaltyReason.rollover:
        return Iconsax.forward_10_seconds;
      case PenaltyReason.disciplineTax:
        return Iconsax.glass;
    }
  }

  String get _multiplierText {
    if (penalty.multiplierApplied == 2.0) {
      return '2× Early Exit';
    } else if (penalty.multiplierApplied == 1.5) {
      return '1.5× Rollover';
    } else {
      return 'Base Rate';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF1A1A1A),
        border: Border.all(
          color: penalty.status == PenaltyStatus.unpaid
              ? _reasonColor.withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: _reasonColor.withOpacity(0.1),
                        border: Border.all(color: _reasonColor.withOpacity(0.2)),
                      ),
                      child: Center(
                        child: Icon(_reasonIcon, color: _reasonColor, size: 16),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            penalty.reason.displayName.toUpperCase(),
                            style: TextStyle(
                              color: _reasonColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            penalty.formattedDate,
                            style: const TextStyle(
                              color: Color(0xFF888888),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${penalty.minutes}m',
                          style: TextStyle(
                            color: _reasonColor,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: penalty.status == PenaltyStatus.unpaid
                                ? const Color(0xFFFF5555).withOpacity(0.1)
                                : const Color(0xFF00FF88).withOpacity(0.1),
                            border: Border.all(
                              color: penalty.status == PenaltyStatus.unpaid
                                  ? const Color(0xFFFF5555).withOpacity(0.2)
                                  : const Color(0xFF00FF88).withOpacity(0.2),
                            ),
                          ),
                          child: Text(
                            penalty.status.displayName.toUpperCase(),
                            style: TextStyle(
                              color: penalty.status == PenaltyStatus.unpaid
                                  ? const Color(0xFFFF5555)
                                  : const Color(0xFF00FF88),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xFF0A0A0A),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Iconsax.calculator, color: _reasonColor, size: 12),
                      const SizedBox(width: 6),
                      Text(
                        _multiplierText,
                        style: TextStyle(
                          color: _reasonColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (penalty.multiplierApplied != 1.0) ...[
                        const SizedBox(width: 6),
                        Text(
                          '(${penalty.multiplierApplied.toString()}× multiplier)',
                          style: const TextStyle(
                            color: Color(0xFF666666),
                            fontSize: 11,
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
      ),
    );
  }
}

class _PenaltyInfoItem extends StatelessWidget {
  final String title;
  final String description;
  final Color color;

  const _PenaltyInfoItem({
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.only(top: 6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.5),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  color: Color(0xFF888888),
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}