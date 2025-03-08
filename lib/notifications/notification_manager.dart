import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/notifications/notification_message.dart';

class NotificationManager {
  /// Initializes the Awesome Notifications system
  Future<void> initLocalNotifications() async {
    AwesomeNotifications().initialize(
      'images/logo_icon.png', // Replace with your app icon resource
      [
        NotificationChannel(
          channelKey: 'nightview_channel',
          channelName: 'Nightview Notifications',
          channelDescription: 'Used for Nightview notifications.',
          defaultColor: primaryColor,
          ledColor: secondaryColor,
          importance: NotificationImportance.High,
          channelShowBadge: true,
        ),
      ],
    );
  }

  /// Schedules a single notification
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'nightview_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        year: scheduledDate.year,
        month: scheduledDate.month,
        day: scheduledDate.day,
        hour: scheduledDate.hour,
        minute: scheduledDate.minute,
        second: 0,
        millisecond: 0,
        repeats: false,
      ),
    );
  }

  /// Schedules random notifications for specific days
  void scheduleWeeklyNotifications() {
    // Random generator
    final rng = Random();

    // Define target weekdays (Friday, Saturday)
    final List<int> targetWeekdays = [
      DateTime.friday,
      DateTime.saturday,
    ];

    // Iterate through each target weekday
    for (var weekday in targetWeekdays) {
      // Schedule multiple random notifications for each day
      for (int i = 0; i < 3; i++) {
        final randomMessage =
        //TODO
        NotificationMessage
            .getNotificationMessages()[rng.nextInt(NotificationMessage.getNotificationMessages().length)];

        final DateTime scheduledDate = _getNextWeekdayTime(weekday, hour: 14); // Test

        scheduleNotification(
          id: weekday * 100 + i, // Unique ID for each notification
          title: 'Klar til byen?', // Replace with a custom title if needed
          body: randomMessage,
          scheduledDate: scheduledDate,
        );
      }
    }
  }

  /// Gets the next occurrence of a specific weekday at a given time
  DateTime _getNextWeekdayTime(int weekday, {required int hour}) {
    final DateTime now = DateTime.now();
    final int daysUntilNext = (weekday - now.weekday + 7) % 7;
    final DateTime nextDate = now.add(Duration(days: daysUntilNext));
    return DateTime(nextDate.year, nextDate.month, nextDate.day, hour);
  }

  // W/Android: [Awesome Notifications](32719): Channel model 'nightview_channel' was not found (ChannelManager:88)
  // E/Android: [Awesome Notifications](32719): Notification channel 'nightview_channel' does not exist. (NotificationContentModel:58)
  // W/System.err(32719): me.carda.awesome_notifications.core.exceptions.AwesomeNotificationsException: Notification channel 'nightview_channel' does not exist.
  // W/System.err(32719): 	at me.carda.awesome_notifications.core.exceptions.ExceptionFactory.createNewAwesomeException(ExceptionFactory.java:31)
  // W/System.err(32719): 	at me.carda.awesome_notifications.core.models.NotificationContentModel.validate(NotificationContentModel.java:334)
  // W/System.err(32719): 	at me.carda.awesome_notifications.core.models.NotificationModel.validate(NotificationModel.java:166)
  // W/System.err(32719): 	at me.carda.awesome_notifications.core.threads.NotificationScheduler.schedule(NotificationScheduler.java:100)
  // W/System.err(32719): 	at me.carda.awesome_notifications.core.AwesomeNotifications.createNotification(AwesomeNotifications.java:507)
  // W/System.err(32719): 	at me.carda.awesome_notifications.AwesomeNotificationsPlugin.channelMethodCreateNotification(AwesomeNotificationsPlugin.java:1320)
  // W/System.err(32719): 	at me.carda.awesome_notifications.AwesomeNotificationsPlugin.onMethodCall(AwesomeNotificationsPlugin.java:305)
}