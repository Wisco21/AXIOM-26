import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/focus_provider.dart';
import '../models/focus_models.dart';
import 'focus_month_screen.dart';

class FocusWeekScreen extends StatefulWidget {
  const FocusWeekScreen({super.key});

  @override
  State<FocusWeekScreen> createState() => _FocusWeekScreenState();
}

class _FocusWeekScreenState extends State<FocusWeekScreen> {
  DateTime _selectedWeekStart = _getWeekStart(DateTime.now());
  WeekSummary? _weekData;
  bool _isLoading = true;

  static DateTime _getWeekStart(DateTime date) {
    return date.subtract(Duration(days: date.weekday % 7));
  }

  @override
  void initState() {
    super.initState();
    _loadWeekData();
  }

  Future<void> _loadWeekData() async {
    setState(() => _isLoading = true);
    
    final provider = context.read<FocusProvider>();
    final data = await provider.getWeekSummary(_selectedWeekStart);
    
    setState(() {
      _weekData = data;
      _isLoading = false;
    });
  }

  void _previousWeek() {
    setState(() {
      _selectedWeekStart = _selectedWeekStart.subtract(const Duration(days: 7));
    });
    _loadWeekData();
  }

  void _nextWeek() {
    final nextWeek = _selectedWeekStart.add(const Duration(days: 7));
    if (nextWeek.isBefore(DateTime.now().add(const Duration(days: 1)))) {
      setState(() {
        _selectedWeekStart = nextWeek;
      });
      _loadWeekData();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          'WEEK VIEW',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '7-Day Overview',
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
                            Iconsax.calendar_1,
                            color: Color(0xFF00CCCC),
                            size: 18,
                          ),
                        ),
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FocusMonthScreen()),
                      ),
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
                          color: Color(0xFF00CCCC),
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          // Week Navigation
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: _previousWeek,
                                  child: Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: const Color(0xFF1A1A1A),
                                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Iconsax.arrow_left_3,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: const Color(0xFF1A1A1A),
                                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                                  ),
                                  child: Text(
                                    '${DateFormat('MMM d').format(_selectedWeekStart)} - ${DateFormat('MMM d').format(_selectedWeekStart.add(const Duration(days: 6)))}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: _nextWeek,
                                  child: Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: _selectedWeekStart.add(const Duration(days: 7)).isBefore(
                                              DateTime.now().add(const Duration(days: 1)))
                                          ? const Color(0xFF1A1A1A)
                                          : const Color(0xFF0A0A0A),
                                      border: Border.all(
                                        color: _selectedWeekStart.add(const Duration(days: 7)).isBefore(
                                                DateTime.now().add(const Duration(days: 1)))
                                            ? Colors.white.withOpacity(0.1)
                                            : Colors.white.withOpacity(0.05),
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Iconsax.arrow_right_3,
                                        color: _selectedWeekStart.add(const Duration(days: 7)).isBefore(
                                                DateTime.now().add(const Duration(days: 1)))
                                            ? Colors.white
                                            : const Color(0xFF444444),
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Week Stats
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: const Color(0xFF1A1A1A),
                                border: Border.all(color: Colors.white.withOpacity(0.1)),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _WeekStatItem(
                                          label: 'PLANNED',
                                          value: '${_weekData!.totalPlannedMinutes}m',
                                          color: const Color(0xFF00CCCC),
                                        ),
                                      ),
                                      Expanded(
                                        child: _WeekStatItem(
                                          label: 'COMPLETED',
                                          value: '${_weekData!.totalCompletedMinutes}m',
                                          color: const Color(0xFF00FF88),
                                        ),
                                      ),
                                      Expanded(
                                        child: _WeekStatItem(
                                          label: 'DEBT',
                                          value: '${_weekData!.totalPenaltyDebt}m',
                                          color: const Color(0xFFFF5555),
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
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 36,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: const Color(0xFF00FF88).withOpacity(0.1),
                                            border: Border.all(color: const Color(0xFF00FF88).withOpacity(0.2)),
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Iconsax.chart_2,
                                              color: Color(0xFF00FF88),
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
                                                'COMPLETION RATE',
                                                style: TextStyle(
                                                  color: Colors.white.withOpacity(0.6),
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '${_weekData!.completionRate.toStringAsFixed(0)}%',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Days List
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: _weekData!.days.map((day) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _DayCard(day: day),
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

class _WeekStatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _WeekStatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _DayCard extends StatelessWidget {
  final DayRecordModel day;

  const _DayCard({required this.day});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF1A1A1A),
        border: Border.all(
          color: day.hasUnpaidPenalty
              ? const Color(0xFFFF5555).withOpacity(0.2)
              : Colors.white.withOpacity(0.1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        day.formattedDate.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '${day.totalCompletedMinutes}/${day.totalPlannedMinutes}m',
                            style: const TextStyle(
                              color: Color(0xFF888888),
                              fontSize: 12,
                            ),
                          ),
                          if (day.hasUnpaidPenalty) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: const Color(0xFFFF5555).withOpacity(0.1),
                                border: Border.all(color: const Color(0xFFFF5555).withOpacity(0.2)),
                              ),
                              child: Text(
                                '${day.penaltyDebtMinutes}m DEBT',
                                style: const TextStyle(
                                  color: Color(0xFFFF5555),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                if (day.isLocked)
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xFF0A0A0A),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: const Center(
                      child: Icon(
                        Iconsax.lock,
                        color: Color(0xFF666666),
                        size: 14,
                      ),
                    ),
                  ),
              ],
            ),
            if (day.chunks.isNotEmpty) ...[
              const SizedBox(height: 12),
              ...day.chunks.map((chunk) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: chunk.status == ChunkStatus.completed
                            ? const Color(0xFF00FF88)
                            : chunk.status == ChunkStatus.abandoned
                                ? const Color(0xFFFF5555)
                                : const Color(0xFF00CCCC),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        chunk.taskDescription,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      chunk.durationDisplay,
                      style: const TextStyle(
                        color: Color(0xFF666666),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ],
        ),
      ),
    );
  }
}
