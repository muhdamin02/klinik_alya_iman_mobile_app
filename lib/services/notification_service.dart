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

  DateTime getNextDayOfWeek(DateTime now, int day) {
    int currentDay = now.weekday;
    int daysUntilNextDay = (day - currentDay + 7) % 7;

    return now.add(Duration(days: daysUntilNextDay));
  }

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

  Future<void> showDailyNotification(
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
      _dailyInstanceOfScheduledTime(scheduledTime),
      platformChannelSpecifics,
      // Type of time interpretation
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle:
          true, // To show notification even when the app is closed
    );
  }

  Future<void> showBiDailyNotification(int id, String title, String body,
      Time scheduledTime, DateTime? initialDate) async {
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
      _biDailyInstanceOfScheduledTime(scheduledTime, initialDate),
      platformChannelSpecifics,
      // Type of time interpretation
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle:
          true, // To show notification even when the app is closed
    );
  }

  Future<void> showEverySpecificDayNotification(
    int id,
    String title,
    String body,
    Time scheduledTime,
    int repeatInterval,
    int dayOfWeek,
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
      _calculateSpecificDayNotificationTime(scheduledTime, repeatInterval, dayOfWeek),
      platformChannelSpecifics,
      // Type of time interpretation
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle:
          true, // To show notification even when the app is closed
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  Future<void> showXDaysNotification(int id, String title, String body,
      Time scheduledTime, DateTime? initialDate, int frequencyInterval) async {
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
      _xDaysInstanceOfScheduledTime(scheduledTime, initialDate, frequencyInterval),
      platformChannelSpecifics,
      // Type of time interpretation
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle:
          true, // To show notification even when the app is closed
    );
  }

  Future<void> showXWeeksNotification(int id, String title, String body,
      Time scheduledTime, DateTime? initialDate, int frequencyInterval) async {
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
      _xWeeksInstanceOfScheduledTime(scheduledTime, initialDate, frequencyInterval),
      platformChannelSpecifics,
      // Type of time interpretation
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle:
          true, // To show notification even when the app is closed
    );
  }

  Future<void> showXMonthsNotification(int id, String title, String body,
      Time scheduledTime, DateTime? initialDate, int frequencyInterval) async {
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
      _xMonthsInstanceOfScheduledTime(scheduledTime, initialDate, frequencyInterval),
      platformChannelSpecifics,
      // Type of time interpretation
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle:
          true, // To show notification even when the app is closed
    );
  }

  tz.TZDateTime _dailyInstanceOfScheduledTime(Time scheduledTime) {
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

  tz.TZDateTime _biDailyInstanceOfScheduledTime(
    Time scheduledTime,
    DateTime? initialDate,
  ) {
    print(scheduledTime);
    final now = tz.TZDateTime.now(tz.getLocation('Asia/Kuala_Lumpur'));
    print(now);

    DateTime firstNotificationDate = initialDate ?? now;

    var scheduledDateTime = tz.TZDateTime(
      tz.getLocation('Asia/Kuala_Lumpur'),
      firstNotificationDate.year,
      firstNotificationDate.month,
      firstNotificationDate.day,
      scheduledTime.hour,
      scheduledTime.minute,
    );

    print('scheduled date time: $scheduledDateTime');

    if (scheduledDateTime.isBefore(now)) {
      scheduledDateTime = scheduledDateTime.add(const Duration(days: 2));
      print('the notification will arrive in 2 days');
      print('scheduled date time after add: $scheduledDateTime');
    }

    return scheduledDateTime;
  }

  tz.TZDateTime _calculateSpecificDayNotificationTime(
    Time scheduledTime,
    int repeatInterval,
    int dayOfWeek,
  ) {
    final now = tz.TZDateTime.now(tz.getLocation('Asia/Kuala_Lumpur'));

    DateTime initialDate = getNextDayOfWeek(now, dayOfWeek);

    var scheduledDateTime = tz.TZDateTime(
      tz.getLocation('Asia/Kuala_Lumpur'),
      initialDate.year,
      initialDate.month,
      initialDate.day,
      scheduledTime.hour,
      scheduledTime.minute,
    );

    print('scheduled date time: $scheduledDateTime');

    if (scheduledDateTime.isBefore(now)) {
      scheduledDateTime = scheduledDateTime.add(Duration(days: repeatInterval));
      print('the notification will arrive in $repeatInterval days');
      print('scheduled date time after add: $scheduledDateTime');
    }

    return scheduledDateTime;
  }

  tz.TZDateTime _xDaysInstanceOfScheduledTime(
    Time scheduledTime,
    DateTime? initialDate,
    int frequencyInterval,
  ) {
    print(scheduledTime);
    final now = tz.TZDateTime.now(tz.getLocation('Asia/Kuala_Lumpur'));
    print(now);

    DateTime firstNotificationDate = initialDate ?? now;

    var scheduledDateTime = tz.TZDateTime(
      tz.getLocation('Asia/Kuala_Lumpur'),
      firstNotificationDate.year,
      firstNotificationDate.month,
      firstNotificationDate.day,
      scheduledTime.hour,
      scheduledTime.minute,
    );

    print('scheduled date time: $scheduledDateTime');

    if (scheduledDateTime.isBefore(now)) {
      scheduledDateTime = scheduledDateTime.add(Duration(days: frequencyInterval));
      print('the notification will arrive in $frequencyInterval days');
      print('scheduled date time after add: $scheduledDateTime');
    }

    return scheduledDateTime;
  }

  tz.TZDateTime _xWeeksInstanceOfScheduledTime(
    Time scheduledTime,
    DateTime? initialDate,
    int frequencyInterval,
  ) {
    frequencyInterval = frequencyInterval * 7;

    print(scheduledTime);
    final now = tz.TZDateTime.now(tz.getLocation('Asia/Kuala_Lumpur'));
    print(now);

    DateTime firstNotificationDate = initialDate ?? now;

    var scheduledDateTime = tz.TZDateTime(
      tz.getLocation('Asia/Kuala_Lumpur'),
      firstNotificationDate.year,
      firstNotificationDate.month,
      firstNotificationDate.day,
      scheduledTime.hour,
      scheduledTime.minute,
    );

    print('scheduled date time: $scheduledDateTime');

    if (scheduledDateTime.isBefore(now)) {
      scheduledDateTime = scheduledDateTime.add(Duration(days: frequencyInterval));
      print('the notification will arrive in $frequencyInterval weeks');
      print('scheduled date time after add: $scheduledDateTime');
    }

    return scheduledDateTime;
  }

  tz.TZDateTime _xMonthsInstanceOfScheduledTime(
    Time scheduledTime,
    DateTime? initialDate,
    int frequencyInterval,
  ) {
    frequencyInterval = frequencyInterval * 28;

    print(scheduledTime);
    final now = tz.TZDateTime.now(tz.getLocation('Asia/Kuala_Lumpur'));
    print(now);

    DateTime firstNotificationDate = initialDate ?? now;

    var scheduledDateTime = tz.TZDateTime(
      tz.getLocation('Asia/Kuala_Lumpur'),
      firstNotificationDate.year,
      firstNotificationDate.month,
      firstNotificationDate.day,
      scheduledTime.hour,
      scheduledTime.minute,
    );

    print('scheduled date time: $scheduledDateTime');

    if (scheduledDateTime.isBefore(now)) {
      scheduledDateTime = scheduledDateTime.add(Duration(days: frequencyInterval));
      print('the notification will arrive in $frequencyInterval months');
      print('scheduled date time after add: $scheduledDateTime');
    }

    return scheduledDateTime;
  }

  // cancel all notifications
  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
