import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

/// Notification service using awesome_notifications
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  /// Initialize notifications
  Future<void> initialize() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'aero_channel',
          channelName: 'Aero Notifications',
          channelDescription: 'Deadline and reminder notifications',
          defaultColor: const Color(0xFF00D9FF),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          channelShowBadge: true,
        ),
      ],
      debug: false,
    );

    // Request permissions
    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  /// Schedule a deadline notification
  Future<void> scheduleDeadlineNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'aero_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
        category: NotificationCategory.Reminder,
      ),
      schedule: NotificationCalendar.fromDate(date: scheduledDate),
    );
  }

  /// Cancel a notification
  Future<void> cancelNotification(int id) async {
    await AwesomeNotifications().cancel(id);
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await AwesomeNotifications().cancelAll();
  }

  /// Show immediate notification (for testing or instant reminders)
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'aero_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }

  /// Schedule workout reminder (for fitness)
  Future<void> scheduleWorkoutReminder({
    required int id,
    required String workoutName,
    required String day,
    required DateTime reminderTime,
  }) async {
    await scheduleDeadlineNotification(
      id: id,
      title: 'Antrenman Hatırlatıcısı',
      body: '$day günü için $workoutName antremanını unutma!',
      scheduledDate: reminderTime,
    );
  }

  /// Schedule task deadline reminder (for work)
  Future<void> scheduleTaskReminder({
    required int id,
    required String taskName,
    required DateTime deadline,
  }) async {
    // 1 saat önceden hatırlat
    final reminderTime = deadline.subtract(const Duration(hours: 1));
    
    if (reminderTime.isAfter(DateTime.now())) {
      await scheduleDeadlineNotification(
        id: id,
        title: 'Görev Hatırlatıcısı',
        body: '$taskName görevi 1 saat içinde sona eriyor!',
        scheduledDate: reminderTime,
      );
    }
  }
}
