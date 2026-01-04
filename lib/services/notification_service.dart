import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:developer' as developer;


class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  Future<void> init() async {
    try {
      developer.log('Initializing notifications...');

      tz.initializeTimeZones();

      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );
      final iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      final initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (details) {
          developer.log('Notification tapped: ${details.payload}');
        },
      );

      // Request permissions for iOS
      await _notifications
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);

      // Request permissions for Android 13+
      await _notifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();

      developer.log('Notifications initialized successfully');
    } catch (e) {
      developer.log('Error initializing notifications: $e', error: e);
    }
  }

  Future<void> scheduleDailyNotifications(
    String ruleTitle,
    String mantra,
  ) async {
    try {
      developer.log('Scheduling daily notifications for: $ruleTitle');

      // Cancel any existing notifications
      await cancelAll();

      // Create notification channel for Android
      await _createNotificationChannel();

      // Get current time
      final now = tz.TZDateTime.now(tz.local);
      developer.log('Current time: $now');

      // Schedule three notifications at different times
      final times = [
        {'hour': 6, 'minute': 0, 'title': '🌅 Morning Reminder'},
        {'hour': 12, 'minute': 0, 'title': '☀️ Midday Check-in'},
        {'hour': 18, 'minute': 0, 'title': '🌇 Evening Reflection'},
      ];

      for (int i = 0; i < times.length; i++) {
        final time = times[i];
        final scheduledTime = _nextInstanceOfTime(
          time['hour'] as int,
          time['minute'] as int,
        );

        String body;
        switch (i) {
          case 0:
            body = '$ruleTitle\n\n"$mantra"\n\nStart your day with this law.';
            break;
          case 1:
            body =
                '$ruleTitle\n\n"$mantra"\n\nHow are you applying this today?';
            break;
          case 2:
            body = '$ruleTitle\n\n"$mantra"\n\nReflect on your progress today.';
            break;
          default:
            body = ruleTitle;
        }

        await _scheduleNotification(
          id: i,
          title: time['title'] as String,
          body: body,
          scheduledTime: scheduledTime,
        );

        developer.log('Scheduled notification $i for: $scheduledTime');
      }

      // Log all pending notifications
      await _logPendingNotifications();
    } catch (e) {
      developer.log('Error scheduling notifications: $e', error: e);
    }
  }

  Future<void> _createNotificationChannel() async {
    const androidChannel = AndroidNotificationChannel(
      'daily_rule_channel',
      'Daily Rule Reminders',
      description: 'Reminders for your daily operating system rules',
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound('notification'),
      playSound: true,
    );

    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.createNotificationChannel(androidChannel);
  }

  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledTime,
  }) async {
    try {
      const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'daily_rule_channel',
        'Daily Rule Reminders',
        channelDescription: 'Reminders for your daily operating system rules',
        importance: Importance.max,
        priority: Priority.high,
        enableVibration: true,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('notification'),
        ledColor: Colors.blue,
        ledOnMs: 1000,
        ledOffMs: 500,
        showWhen: true,
        visibility: NotificationVisibility.public,
        ticker: 'AXIOM-26 Daily Rule',
      );

      const iOSPlatformChannelSpecifics = DarwinNotificationDetails(
        sound: 'default',
        badgeNumber: 1,
        threadIdentifier: 'axiom26_daily_rule',
        subtitle: 'AXIOM-26 Daily Rule',
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );

      await _notifications.zonedSchedule(
        id,
        title,
        body,
        scheduledTime,
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'rule_reminder_$id',
      );
    } catch (e) {
      developer.log('Error scheduling notification $id: $e', error: e);
      // Try without custom sound as fallback
      await _scheduleSimpleNotification(id, title, body, scheduledTime);
    }
  }

  // Fallback method without custom sound
  Future<void> _scheduleSimpleNotification(
    int id,
    String title,
    String body,
    tz.TZDateTime scheduledTime,
  ) async {
    try {
      const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'daily_rule_channel',
        'Daily Rule Reminders',
        channelDescription: 'Reminders for your daily operating system rules',
        importance: Importance.max,
        priority: Priority.high,
        enableVibration: true,
      );

      const iOSPlatformChannelSpecifics = DarwinNotificationDetails(
        badgeNumber: 1,
        threadIdentifier: 'axiom26_daily_rule',
        subtitle: 'AXIOM-26 Daily Rule',
      );

      final platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );

      await _notifications.zonedSchedule(
        id,
        title,
        body,
        scheduledTime,
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'rule_reminder_simple_$id',
      );
      
      print('Successfully scheduled simple notification $id');
    } catch (e) {
      print('Error scheduling simple notification $id: $e');
    }
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
      0,
    );

    // If the time has already passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    developer.log('Next instance of $hour:$minute will be at: $scheduledDate');
    return scheduledDate;
  }

  Future<void> _logPendingNotifications() async {
    final pending = await _notifications.pendingNotificationRequests();
    developer.log('Pending notifications: ${pending.length}');
    for (var notification in pending) {
      developer.log(
        '  - ID: ${notification.id}, Title: ${notification.title}, Body: ${notification.body}, Payload: ${notification.payload}',
      );
    }
  }

  // Test notification - schedule for 10 seconds from now
  Future<void> scheduleTestNotification() async {
    try {
      final scheduledTime = tz.TZDateTime.now(
        tz.local,
      ).add(const Duration(seconds: 10));

      await _scheduleNotification(
        id: 999,
        title: '🔔 Test Notification',
        body:
            'This is a test notification from AXIOM-26. If you see this, notifications are working!',
        scheduledTime: scheduledTime,
      );

      developer.log('Test notification scheduled for: $scheduledTime');
    } catch (e) {
      developer.log('Error scheduling test notification: $e', error: e);
    }
  }

  // Immediate notification (for testing)
  Future<void> showImmediateNotification() async {
    try {
      await _notifications.show(
        1000,
        '🔔 Immediate Notification',
        'This shows notifications are working!',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_rule_channel',
            'Daily Rule Reminders',
            channelDescription:
                'Reminders for your daily operating system rules',
            importance: Importance.max,
            priority: Priority.high,
            enableVibration: true,
            playSound: true,
            sound: RawResourceAndroidNotificationSound('notification'),
          ),
          iOS: DarwinNotificationDetails(
            sound: 'default',
            badgeNumber: 1,
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
      );
      developer.log('Immediate notification shown');
    } catch (e) {
      developer.log('Error showing immediate notification: $e', error: e);
    }
  }

  List<DateTime> getTodayScheduledTimes() {
    final now = DateTime.now();
    return [
      DateTime(now.year, now.month, now.day, 6, 0),
      DateTime(now.year, now.month, now.day, 12, 0),
      DateTime(now.year, now.month, now.day, 18, 0),
    ];
  }

  bool isNotificationTime() {
    final now = DateTime.now();
    final hour = now.hour;
    final minute = now.minute;

    return (hour == 6 && minute < 15) ||
        (hour == 12 && minute < 15) ||
        (hour == 18 && minute < 15);
  }

  // Schedule notification at specific time (for debugging)
  Future<void> scheduleAtSpecificTime(DateTime dateTime) async {
    try {
      final tzTime = tz.TZDateTime.from(dateTime, tz.local);
      final now = tz.TZDateTime.now(tz.local);

      // Don't schedule if time is in the past
      if (tzTime.isBefore(now)) {
        print('Cannot schedule notification in the past');
        return;
      }

      const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'daily_rule_channel',
        'Daily Rule Reminders',
        channelDescription: 'Reminders for your daily operating system rules',
        importance: Importance.max,
        priority: Priority.high,
        enableVibration: true,
      );

      const iOSPlatformChannelSpecifics = DarwinNotificationDetails(
        badgeNumber: 1,
      );

      final platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );

      await _notifications.zonedSchedule(
        1001,
        '⏰ Scheduled Test',
        'Test notification scheduled at specific time: ${dateTime.hour}:${dateTime.minute}',
        tzTime,
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );

      print('Notification scheduled at specific time: $tzTime');
    } catch (e) {
      print('Error scheduling at specific time: $e');
    }
  }

  
  
  Future<void> cancelAll() async {
    await _notifications.cancelAll();
    developer.log('All notifications cancelled');
  }
}


