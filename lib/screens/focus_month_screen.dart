import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/focus_provider.dart';
import '../models/focus_models.dart';

class FocusMonthScreen extends StatefulWidget {
  const FocusMonthScreen({super.key});

  @override
  State<FocusMonthScreen> createState() => _FocusMonthScreenState();
}

class _FocusMonthScreenState extends State<FocusMonthScreen> {
  DateTime _selectedMonth = DateTime.now();
  List<DayRecordModel>? _monthData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMonthData();
  }

  Future<void> _loadMonthData() async {
    setState(() => _isLoading = true);

    final provider = context.read<FocusProvider>();
    final data = await provider.getMonthData(
      _selectedMonth.year,
      _selectedMonth.month,
    );

    setState(() {
      _monthData = data;
      _isLoading = false;
    });
  }

  void _previousMonth() {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month - 1,
      );
    });
    _loadMonthData();
  }

  void _nextMonth() {
    final next = DateTime(
      _selectedMonth.year,
      _selectedMonth.month + 1,
    );
    if (next.isBefore(DateTime.now().add(const Duration(days: 1)))) {
      setState(() {
        _selectedMonth = next;
      });
      _loadMonthData();
    }
  }

  DayRecordModel? _getDayData(int day) {
    if (_monthData == null) return null;
    
    final dateStr = DateFormat('yyyy-MM-dd').format(
      DateTime(_selectedMonth.year, _selectedMonth.month, day),
    );
    
    return _monthData!.firstWhere(
      (d) => d.date == dateStr,
      orElse: () => DayRecordModel(
        date: dateStr,
        chunks: [],
        penaltyDebtMinutes: 0,
        isLocked: false,
      ),
    );
  }

  Color _getDayColor(DayRecordModel? day) {
    if (day == null || day.chunks.isEmpty) {
      return Colors.white.withOpacity(0.05);
    }

    if (day.hasUnpaidPenalty) {
      return const Color(0xFFFF5555).withOpacity(0.3);
    }

    final rate = day.totalPlannedMinutes > 0
        ? day.totalCompletedMinutes / day.totalPlannedMinutes
        : 0.0;

    if (rate >= 1.0) {
      return const Color(0xFF00FF88).withOpacity(0.8);
    } else if (rate >= 0.75) {
      return const Color(0xFF00FF88).withOpacity(0.5);
    } else if (rate >= 0.5) {
      return const Color(0xFFFFCC00).withOpacity(0.5);
    } else if (rate > 0) {
      return const Color(0xFFFF9900).withOpacity(0.4);
    } else {
      return const Color(0xFFFF5555).withOpacity(0.3);
    }
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0).day;
    final firstWeekday = DateTime(_selectedMonth.year, _selectedMonth.month, 1).weekday;

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
                          'MONTH VIEW',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '30-Day Overview',
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
                          // Month Navigation
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: _previousMonth,
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
                                    DateFormat('MMMM yyyy').format(_selectedMonth),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: _nextMonth,
                                  child: Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: DateTime(_selectedMonth.year, _selectedMonth.month + 1)
                                              .isBefore(DateTime.now().add(const Duration(days: 1)))
                                          ? const Color(0xFF1A1A1A)
                                          : const Color(0xFF0A0A0A),
                                      border: Border.all(
                                        color: DateTime(_selectedMonth.year, _selectedMonth.month + 1)
                                                .isBefore(DateTime.now().add(const Duration(days: 1)))
                                            ? Colors.white.withOpacity(0.1)
                                            : Colors.white.withOpacity(0.05),
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Iconsax.arrow_right_3,
                                        color: DateTime(_selectedMonth.year, _selectedMonth.month + 1)
                                                .isBefore(DateTime.now().add(const Duration(days: 1)))
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

                          // Month Summary
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: const Color(0xFF1A1A1A),
                                border: Border.all(color: Colors.white.withOpacity(0.1)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _MonthStat(
                                      label: 'TOTAL PLANNED',
                                      value: '${_monthData!.fold<int>(0, (sum, d) => sum + d.totalPlannedMinutes)}m',
                                      color: const Color(0xFF00CCCC),
                                    ),
                                  ),
                                  Expanded(
                                    child: _MonthStat(
                                      label: 'COMPLETED',
                                      value: '${_monthData!.fold<int>(0, (sum, d) => sum + d.totalCompletedMinutes)}m',
                                      color: const Color(0xFF00FF88),
                                    ),
                                  ),
                                  Expanded(
                                    child: _MonthStat(
                                      label: 'TOTAL DEBT',
                                      value: '${_monthData!.fold<int>(0, (sum, d) => sum + d.penaltyDebtMinutes)}m',
                                      color: const Color(0xFFFF5555),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Calendar Heatmap
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
                                  // Weekday labels
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                                        .map((d) => SizedBox(
                                              width: 36,
                                              child: Center(
                                                child: Text(
                                                  d,
                                                  style: TextStyle(
                                                    color: Colors.white.withOpacity(0.5),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                  const SizedBox(height: 12),
                                  
                                  // Calendar grid
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 7,
                                      mainAxisSpacing: 6,
                                      crossAxisSpacing: 6,
                                    ),
                                    itemCount: firstWeekday % 7 + daysInMonth,
                                    itemBuilder: (context, index) {
                                      if (index < firstWeekday % 7) {
                                        return const SizedBox();
                                      }

                                      final day = index - (firstWeekday % 7) + 1;
                                      final dayData = _getDayData(day);
                                      final color = _getDayColor(dayData);

                                      return GestureDetector(
                                        onTap: () {
                                          if (dayData != null && dayData.chunks.isNotEmpty) {
                                            _showDayDetails(dayData);
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: color,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(
                                              color: dayData?.hasUnpaidPenalty == true
                                                  ? const Color(0xFFFF5555)
                                                  : Colors.transparent,
                                              width: 2,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '$day',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Legend
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
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
                                            Iconsax.info_circle,
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
                                            'LEGEND',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: -0.5,
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            'What the colors mean',
                                            style: TextStyle(
                                              color: Color(0xFF666666),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  _LegendItem(color: const Color(0xFF00FF88).withOpacity(0.8), label: '100% completion'),
                                  const SizedBox(height: 8),
                                  _LegendItem(color: const Color(0xFF00FF88).withOpacity(0.5), label: '75-99% completion'),
                                  const SizedBox(height: 8),
                                  _LegendItem(color: const Color(0xFFFFCC00).withOpacity(0.5), label: '50-74% completion'),
                                  const SizedBox(height: 8),
                                  _LegendItem(color: const Color(0xFFFF9900).withOpacity(0.4), label: '1-49% completion'),
                                  const SizedBox(height: 8),
                                  _LegendItem(color: const Color(0xFFFF5555).withOpacity(0.3), label: 'Planned but not completed'),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(color: const Color(0xFFFF5555), width: 2),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Unpaid penalty debt',
                                        style: TextStyle(color: Color(0xFF888888), fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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

  void _showDayDetails(DayRecordModel day) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      child: Icon(
                        Iconsax.calendar_1,
                        color: Color(0xFF00CCCC),
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        day.formattedDate.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Day Details',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Planned',
                          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${day.totalPlannedMinutes}m',
                          style: const TextStyle(color: Color(0xFF00CCCC), fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Completed',
                          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${day.totalCompletedMinutes}m',
                          style: const TextStyle(color: Color(0xFF00FF88), fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  if (day.hasUnpaidPenalty)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Debt',
                            style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${day.penaltyDebtMinutes}m',
                            style: const TextStyle(color: Color(0xFFFF5555), fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'CHUNKS',
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
              ...day.chunks.map((chunk) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFF0A0A0A),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: chunk.status == ChunkStatus.completed
                            ? const Color(0xFF00FF88).withOpacity(0.1)
                            : chunk.status == ChunkStatus.abandoned
                                ? const Color(0xFFFF5555).withOpacity(0.1)
                                : const Color(0xFF00CCCC).withOpacity(0.1),
                        border: Border.all(
                          color: chunk.status == ChunkStatus.completed
                              ? const Color(0xFF00FF88).withOpacity(0.2)
                              : chunk.status == ChunkStatus.abandoned
                                  ? const Color(0xFFFF5555).withOpacity(0.2)
                                  : const Color(0xFF00CCCC).withOpacity(0.2),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          chunk.status == ChunkStatus.completed
                              ? Iconsax.tick_circle
                              : chunk.status == ChunkStatus.abandoned
                                  ? Iconsax.close_circle
                                  : Iconsax.clock,
                          size: 16,
                          color: chunk.status == ChunkStatus.completed
                              ? const Color(0xFF00FF88)
                              : chunk.status == ChunkStatus.abandoned
                                  ? const Color(0xFFFF5555)
                                  : const Color(0xFF00CCCC),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            chunk.taskDescription,
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${chunk.durationDisplay} • ${chunk.status.displayName.toUpperCase()}',
                            style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _MonthStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MonthStat({
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
          textAlign: TextAlign.center,
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
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(color: Color(0xFF888888), fontSize: 13),
        ),
      ],
    );
  }
}
