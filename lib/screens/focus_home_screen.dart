import 'package:axiom/widgets/chunk_completion_dialog.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../providers/focus_provider.dart';
import '../models/focus_models.dart';
import 'focus_timer_screen.dart';
import 'focus_week_screen.dart';

class FocusHomeScreen extends StatefulWidget {
  const FocusHomeScreen({super.key});

  @override
  State<FocusHomeScreen> createState() => _FocusHomeScreenState();
}

class _FocusHomeScreenState extends State<FocusHomeScreen> {
  final _taskController = TextEditingController();
  final _durationController = TextEditingController();

  @override
  void dispose() {
    _taskController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _showPlanningInfo() {
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
                      color: const Color(0xFF00FF88).withOpacity(0.1),
                      border: Border.all(color: const Color(0xFF00FF88).withOpacity(0.2)),
                    ),
                    child: const Center(
                      child: Icon(Iconsax.info_circle, color: Color(0xFF00FF88), size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'PLANNING RULE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFF0A0A0A),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: const Text(
                  'Only plan what you will sit down and finish today. Everything else becomes debt.',
                  style: TextStyle(
                    color: Color(0xFF888888),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00FF88),
                    foregroundColor: Colors.black,
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
                      child: Icon(Iconsax.warning_2, color: Color(0xFFFF5555), size: 20),
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
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFF0A0A0A),
                  border: Border.all(color: const Color(0xFFFF5555).withOpacity(0.2)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Penalties exist to remove negotiation. Without cost, discipline collapses.',
                      style: TextStyle(
                        color: Color(0xFF888888),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 16),
                    _PenaltyItem(
                      title: 'Early exit',
                      description: '2× remaining time',
                    ),
                    SizedBox(height: 8),
                    _PenaltyItem(
                      title: 'Unpaid by midnight',
                      description: '1.5× rollover',
                    ),
                    SizedBox(height: 8),
                    _PenaltyItem(
                      title: 'Still unpaid next day',
                      description: '+10 min tax',
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No forgiveness. No caps. No resets.',
                      style: TextStyle(
                        color: Color(0xFFFF5555),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
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

  void _showCreateChunk() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFF00CCCC).withOpacity(0.1),
                      border: Border.all(color: const Color(0xFF00CCCC).withOpacity(0.2)),
                    ),
                    child: const Center(
                      child: Icon(Iconsax.add, color: Color(0xFF00CCCC), size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'NEW FOCUS CHUNK',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Plan what you will finish today',
                        style: TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _taskController,
                style: const TextStyle(color: Colors.white, fontSize: 15),
                decoration: InputDecoration(
                  labelText: 'Task Description',
                  labelStyle: const TextStyle(color: Color(0xFF666666)),
                  floatingLabelStyle: const TextStyle(color: Color(0xFF00CCCC)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF00CCCC)),
                  ),
                  fillColor: const Color(0xFF0A0A0A),
                  filled: true,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white, fontSize: 15),
                decoration: InputDecoration(
                  labelText: 'Duration (minutes)',
                  labelStyle: const TextStyle(color: Color(0xFF666666)),
                  floatingLabelStyle: const TextStyle(color: Color(0xFF00CCCC)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF00CCCC)),
                  ),
                  fillColor: const Color(0xFF0A0A0A),
                  filled: true,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_taskController.text.isEmpty || _durationController.text.isEmpty) {
                      return;
                    }
                    
                    final duration = int.tryParse(_durationController.text);
                    if (duration == null || duration <= 0) {
                      return;
                    }

                    context.read<FocusProvider>().createChunk(
                      taskDescription: _taskController.text,
                      plannedDurationMinutes: duration,
                    );

                    _taskController.clear();
                    _durationController.clear();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00CCCC),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'CREATE CHUNK',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FocusProvider>(
      builder: (context, provider, _) {
        if (provider.showCompletionSheet) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showCompletionSheet(context);
          });
        }

        if (provider.isLoading) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
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
            ),
          );
        }

        final today = provider.todayRecord;
        if (today == null) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: const Color(0xFF1A1A1A),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: const Icon(
                      Iconsax.close_circle,
                      color: Color(0xFFFF5555),
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Failed to load data',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

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
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: const Color(0xFF1A1A1A),
                            border: Border.all(color: Colors.white.withOpacity(0.1)),
                          ),
                          child: const Center(
                            child: Icon(
                              Iconsax.timer,
                              color: Color(0xFF00CCCC),
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'FOCUS',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Today\'s Focus',
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
                                color: Color(0xFF00FF88),
                                size: 18,
                              ),
                            ),
                          ),
                          onPressed: _showPlanningInfo,
                        ),
                        const SizedBox(width: 8),
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
                                Iconsax.warning_2,
                                color: Color(0xFFFF5555),
                                size: 18,
                              ),
                            ),
                          ),
                          onPressed: _showPenaltyInfo,
                        ),
                        const SizedBox(width: 8),
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
                                Iconsax.calendar_2,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const FocusWeekScreen()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Main Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        // Penalty Warning
                        if (today.hasUnpaidPenalty)
                          Container(
                            margin: const EdgeInsets.all(20),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: const Color(0xFFFF5555).withOpacity(0.05),
                              border: Border.all(color: const Color(0xFFFF5555).withOpacity(0.2)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFFFF5555).withOpacity(0.1),
                                    border: Border.all(color: const Color(0xFFFF5555).withOpacity(0.3)),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Iconsax.danger,
                                      color: Color(0xFFFF5555),
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
                                        'UNPAID PENALTY DEBT',
                                        style: TextStyle(
                                          color: const Color(0xFFFF5555),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${today.penaltyDebtMinutes} minutes must be paid today',
                                        style: const TextStyle(
                                          color: Color(0xFF888888),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Stats Grid
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _StatCard(
                                      label: 'PLANNED',
                                      value: '${today.totalPlannedMinutes}m',
                                      subtitle: '${today.chunks.length}/${today.chunks.length} chunks',
                                      color: const Color(0xFF00CCCC),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _StatCard(
                                      label: 'NET WORK',
                                      value: '${today.netProductiveMinutes}m',
                                      subtitle: 'After debt payment',
                                      color: today.netProductiveMinutes >= today.totalPlannedMinutes 
                                          ? const Color(0xFF00FF88)
                                          : const Color(0xFFFFCC00),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _StatCard(
                                      label: 'DEBT OWED',
                                      value: '${today.penaltyDebtMinutes}m',
                                      subtitle: today.penaltyDebtMinutes > 0 ? 'Unpaid' : 'Clear',
                                      color: today.penaltyDebtMinutes > 0 
                                          ? const Color(0xFFFF5555)
                                          : const Color(0xFF00FF88),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _StatCard(
                                      label: 'DEBT PAID',
                                      value: '${today.totalDebtPaidMinutes}m',
                                      subtitle: 'Today\'s payments',
                                      color: const Color(0xFF00CCCC),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Chunks Header
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
                                    Iconsax.task_square,
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
                                    'FOCUS CHUNKS',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Today\'s planned work',
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

                        // Chunks List
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: today.chunks.isEmpty
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
                                            Iconsax.task_square,
                                            color: Color(0xFF666666),
                                            size: 28,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        'No focus chunks planned',
                                        style: TextStyle(
                                          color: Color(0xFF666666),
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Add your first focus chunk',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.3),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Column(
                                  children: today.chunks.map((chunk) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 12),
                                      child: _ChunkCard(chunk: chunk),
                                    );
                                  }).toList(),
                                ),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: today.isLocked || provider.isChunkActive
              ? null
              : Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: FloatingActionButton(
                    onPressed: _showCreateChunk,
                    backgroundColor: const Color(0xFF00CCCC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Iconsax.add, color: Colors.black, size: 28),
                  ),
                ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF1A1A1A),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color.withOpacity(0.7),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF666666),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChunkCard extends StatelessWidget {
  final FocusChunkModel chunk;

  const _ChunkCard({required this.chunk});

  Color get _statusColor {
    switch (chunk.status) {
      case ChunkStatus.pending:
        return const Color(0xFF00CCCC);
      case ChunkStatus.active:
        return const Color(0xFFFFCC00);
      case ChunkStatus.completed:
        return const Color(0xFF00FF88);
      case ChunkStatus.abandoned:
        return const Color(0xFFFF5555);
    }
  }

  IconData get _statusIcon {
    switch (chunk.status) {
      case ChunkStatus.pending:
        return Iconsax.clock;
      case ChunkStatus.active:
        return Iconsax.play_circle;
      case ChunkStatus.completed:
        return Iconsax.tick_circle;
      case ChunkStatus.abandoned:
        return Iconsax.close_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF1A1A1A),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
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
                        color: _statusColor.withOpacity(0.1),
                        border: Border.all(color: _statusColor.withOpacity(0.2)),
                      ),
                      child: Center(
                        child: Icon(_statusIcon, color: _statusColor, size: 16),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        chunk.taskDescription,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (chunk.status == ChunkStatus.pending)
                      GestureDetector(
                        onTap: () {
                          context.read<FocusProvider>().deleteChunk(chunk.id);
                        },
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: const Color(0xFF0A0A0A),
                            border: Border.all(color: Colors.white.withOpacity(0.1)),
                          ),
                          child: const Center(
                            child: Icon(
                              Iconsax.trash,
                              color: Color(0xFFFF5555),
                              size: 14,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _InfoChip(
                      label: chunk.durationDisplay,
                      icon: Iconsax.timer,
                      color: const Color(0xFF00CCCC),
                    ),
                    if (chunk.status == ChunkStatus.completed && chunk.debtPaidMinutes > 0)
                      _InfoChip(
                        label: 'Paid ${chunk.debtPaidMinutes}m debt',
                        icon: Iconsax.card,
                        color: const Color(0xFF00FF88),
                      ),
                    if (chunk.penaltyMinutes > 0)
                      _InfoChip(
                        label: '+${chunk.penaltyMinutes}m penalty',
                        icon: Iconsax.danger,
                        color: const Color(0xFFFF5555),
                      ),
                  ],
                ),
              ],
            ),
          ),
          if (chunk.status == ChunkStatus.pending) ...[
            Container(
              height: 1,
              color: Colors.white.withOpacity(0.05),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await context.read<FocusProvider>().startChunk(chunk.id);
                      if (context.mounted) {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FocusTimerScreen(chunk: chunk),
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(Iconsax.close_circle, color: Color(0xFFFF5555), size: 20),
                                const SizedBox(width: 8),
                                Text('Failed to start: $e'),
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
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00CCCC),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'START FOCUS',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _InfoChip({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PenaltyItem extends StatelessWidget {
  final String title;
  final String description;

  const _PenaltyItem({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFFF5555).withOpacity(0.5),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '$title: $description',
            style: const TextStyle(
              color: Color(0xFF888888),
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}



