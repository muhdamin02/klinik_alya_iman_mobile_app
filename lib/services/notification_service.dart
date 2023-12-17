import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future<void> initNotification() async {
    // Android initialization
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    // the initialization settings are initialized after they are setted
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(
    int id,
    String title,
    String body,
    DateTime scheduledTime,
  ) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        // Android details
        android: AndroidNotificationDetails('main_channel', 'Main Channel',
            channelDescription: "ashwin",
            importance: Importance.max,
            priority: Priority.max),
      ),

      // Type of time interpretation
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle:
          true, // To show notification even when the app is closed
    );
  }

  Future<void> showRepeatingNotification(
    int id,
    String title,
    String body,
    Time scheduledTime,
  ) async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'repeating_channel_id',
      'Repeating Channel Name',
      channelDescription: 'Repeating Channel Description',
      importance: Importance.max,
      priority: Priority.max,
    );

    final platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      _nextInstanceOfScheduledTime(scheduledTime),
      platformChannelSpecifics,
      // Type of time interpretation
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle:
          true, // To show notification even when the app is closed
    );
  }

  tz.TZDateTime _nextInstanceOfScheduledTime(Time scheduledTime) {
    print(scheduledTime);
    final now = tz.TZDateTime.now(tz.getLocation('Asia/Kuala_Lumpur'));
    print(now);
    var scheduledDateTime = tz.TZDateTime(tz.getLocation('Asia/Kuala_Lumpur'),
        now.year, now.month, now.day, scheduledTime.hour, scheduledTime.minute);

    print('scheduled date time: $scheduledDateTime');

    if (scheduledDateTime.isBefore(now)) {
      scheduledDateTime = scheduledDateTime.add(const Duration(days: 1));
      print('the notification will arrive tomorrow');
      print('scheduled date time after add: $scheduledDateTime');
    }

    return scheduledDateTime;
  }
}
