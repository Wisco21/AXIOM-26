
// lib/screens/notification_debug_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import '../services/notification_service.dart';
import '../providers/rule_provider.dart';

class NotificationDebugScreen extends StatefulWidget {
  const NotificationDebugScreen({super.key});

  @override
  State<NotificationDebugScreen> createState() => _NotificationDebugScreenState();
}

class _NotificationDebugScreenState extends State<NotificationDebugScreen> {
  DateTime? _selectedTime;
  final NotificationService _notificationService = NotificationService();

  @override
  Widget build(BuildContext context) {
    final ruleProvider = Provider.of<RuleProvider>(context);
    
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
                        child: const Icon(
                          Iconsax.arrow_left_2,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NOTIFICATIONS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Test & Schedule',
                          style: TextStyle(
                            color: Color(0xFF888888),
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
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Current Rule Info
                    Container(
                      width: double.infinity,
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
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color(0xFF00FF88).withOpacity(0.1),
                                  border: Border.all(color: const Color(0xFF00FF88).withOpacity(0.2)),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Iconsax.notification_status,
                                    color: Color(0xFF00FF88),
                                    size: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'CURRENT RULE',
                                style: TextStyle(
                                  color: Color(0xFF666666),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            ruleProvider.currentRule?.title ?? 'No rule selected',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (ruleProvider.currentRule?.mantra != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              ruleProvider.currentRule!.mantra,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Quick Tests
                    const Text(
                      'QUICK TESTS',
                      style: TextStyle(
                        color: Color(0xFF666666),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 12),

                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.5,
                      children: [
                        _buildTestCard(
                          icon: Iconsax.notification,
                          label: 'Immediate',
                          color: const Color(0xFF00FF88),
                          onTap: () async {
                            await _notificationService.showImmediateNotification();
                            _showSnackBar('Immediate notification sent!');
                          },
                        ),
                        _buildTestCard(
                          icon: Iconsax.timer_1,
                          label: '10 Seconds',
                          color: const Color(0xFF00CCCC),
                          onTap: () async {
                            await _notificationService.scheduleTestNotification();
                            _showSnackBar('Test notification scheduled!');
                          },
                        ),
                        _buildTestCard(
                          icon: Iconsax.timer,
                          label: '1 Minute',
                          color: const Color(0xFF0088FF),
                          onTap: () async {
                            final now = DateTime.now();
                            final testTime = DateTime(
                              now.year,
                              now.month,
                              now.day,
                              now.hour,
                              now.minute + 1,
                            );
                            await _notificationService.scheduleAtSpecificTime(testTime);
                            _showSnackBar('Notification scheduled for 1 minute!');
                          },
                        ),
                        _buildTestCard(
                          icon: Iconsax.calendar,
                          label: 'Custom Time',
                          color: const Color(0xFFAA00FF),
                          onTap: () => _showTimePicker(context),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Daily Schedule
                    const Text(
                      'DAILY SCHEDULE',
                      style: TextStyle(
                        color: Color(0xFF666666),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Container(
                      width: double.infinity,
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
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  color: const Color(0xFF00CCCC).withOpacity(0.1),
                                  border: Border.all(color: const Color(0xFF00CCCC).withOpacity(0.2)),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Iconsax.calendar_tick,
                                    color: Color(0xFF00CCCC),
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
                                      'Auto Schedule',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Schedule daily notifications at 6AM, 12PM, 6PM',
                                      style: TextStyle(
                                        color: Color(0xFF888888),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  if (ruleProvider.currentRule != null) {
                                    await _notificationService.scheduleDailyNotifications(
                                      ruleProvider.currentRule!.title,
                                      ruleProvider.currentRule!.mantra,
                                    );
                                    _showSnackBar('Daily notifications scheduled!');
                                  } else {
                                    _showSnackBar('No current rule to schedule notifications for', isError: true);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF00FF88), Color(0xFF00CCCC)],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                  ),
                                  child: const Text(
                                    'SCHEDULE',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildTimeScheduleList(),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Management
                    const Text(
                      'MANAGEMENT',
                      style: TextStyle(
                        color: Color(0xFF666666),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              await _notificationService.cancelAll();
                              _showSnackBar('All notifications cancelled');
                            },
                            child: Container(
                              height: 52,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: const Color(0xFF1A1A1A),
                                border: Border.all(color: Colors.white.withOpacity(0.1)),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Iconsax.close_circle,
                                    color: Color(0xFFFF5555),
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'CANCEL ALL',
                                    style: TextStyle(
                                      color: Color(0xFFFF5555),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Custom Time Section
                    if (_selectedTime != null) ...[
                      const Text(
                        'CUSTOM SCHEDULE',
                        style: TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: const Color(0xFF1A1A1A),
                          border: Border.all(color: const Color(0xFFAA00FF).withOpacity(0.3)),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFFAA00FF).withOpacity(0.1),
                                    border: Border.all(color: const Color(0xFFAA00FF).withOpacity(0.3)),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Iconsax.clock,
                                      color: Color(0xFFAA00FF),
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
                                        DateFormat('EEEE, MMMM d').format(_selectedTime!),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'at ${DateFormat('hh:mm a').format(_selectedTime!)}',
                                        style: const TextStyle(
                                          color: Color(0xFFAA00FF),
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            GestureDetector(
                              onTap: () async {
                                await _notificationService.scheduleAtSpecificTime(_selectedTime!);
                                _showSnackBar('Notification scheduled for ${DateFormat('hh:mm a').format(_selectedTime!)}');
                              },
                              child: Container(
                                width: double.infinity,
                                height: 44,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: const Color(0xFFAA00FF)),
                                ),
                                child: const Center(
                                  child: Text(
                                    'SCHEDULE AT THIS TIME',
                                    style: TextStyle(
                                      color: Color(0xFFAA00FF),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFF1A1A1A),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.1),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Center(
                child: Icon(icon, color: color, size: 24),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeScheduleList() {
    final times = _notificationService.getTodayScheduledTimes();
    
    return Column(
      children: times.map((time) {
        final isPassed = _isTimePassed(time);
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFF0A0A0A),
            border: Border.all(
              color: isPassed 
                ? const Color(0xFF444444) 
                : const Color(0xFF00CCCC).withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                _getTimeIcon(time.hour),
                color: isPassed ? const Color(0xFF666666) : const Color(0xFF00CCCC),
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getTimeLabel(time.hour),
                      style: TextStyle(
                        color: isPassed ? const Color(0xFF666666) : Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        color: isPassed ? const Color(0xFF444444) : const Color(0xFF00CCCC),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: isPassed 
                    ? const Color(0xFF444444).withOpacity(0.2)
                    : const Color(0xFF00CCCC).withOpacity(0.1),
                  border: Border.all(
                    color: isPassed 
                      ? const Color(0xFF444444)
                      : const Color(0xFF00CCCC).withOpacity(0.2),
                  ),
                ),
                child: Text(
                  isPassed ? 'PASSED' : 'UPCOMING',
                  style: TextStyle(
                    color: isPassed ? const Color(0xFF666666) : const Color(0xFF00CCCC),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final initialTime = TimeOfDay.now();
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF00FF88),
              onPrimary: Colors.black,
              surface: Color(0xFF1A1A1A),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF0A0A0A),
            dialogTheme: DialogThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.white.withOpacity(0.1)),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedTime != null) {
      final now = DateTime.now();
      setState(() {
        _selectedTime = DateTime(
          now.year,
          now.month,
          now.day,
          selectedTime.hour,
          selectedTime.minute,
        );
      });
      _showSnackBar('Time selected: ${selectedTime.format(context)}');
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Iconsax.close_circle : Iconsax.tick_circle,
              color: isError ? const Color(0xFFFF5555) : const Color(0xFF00FF88),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isError ? const Color(0xFFFF5555) : const Color(0xFF00FF88),
            width: 1,
          ),
        ),
      ),
    );
  }

  IconData _getTimeIcon(int hour) {
    switch (hour) {
      case 6: return Iconsax.sun_1;
      case 12: return Iconsax.sun_fog;
      case 18: return Iconsax.moon;
      default: return Iconsax.clock;
    }
  }

  String _getTimeLabel(int hour) {
    switch (hour) {
      case 6: return 'Morning Reminder';
      case 12: return 'Midday Check-in';
      case 18: return 'Evening Reflection';
      default: return '';
    }
  }

  bool _isTimePassed(DateTime time) {
    final now = DateTime.now();
    final currentTime = DateTime(now.year, now.month, now.day, now.hour, now.minute);
    final scheduledTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return currentTime.isAfter(scheduledTime);
  }
}