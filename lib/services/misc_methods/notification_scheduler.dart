import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../notification_service.dart';

class NotificationScheduler {
  // Fields or properties can be added here
  // ...

  // Constructor if needed
  NotificationScheduler(/* constructor parameters */) {
    // Initialization logic if needed
    // ...
  }

  // Methods for your notification scheduling logic
  void scheduleNotificationSpecificDateTime() {
    NotificationService().showNotification(1, 'delayed noti',
        'tolonglah berhasil aku merayu', DateTime(2023, 12, 17, 00, 09));
  }

  void scheduleNotificationInFiveSeconds() {
    NotificationService().showNotification(
        1,
        'delayed noti',
        'tolonglah berhasil aku merayu',
        DateTime.now().add(const Duration(seconds: 5)));
  }

  void scheduleNotificationDaily(
      int id, String title, String subtitle, Time scheduledTime) {
    NotificationService()
        .showDailyNotification(id, title, subtitle, scheduledTime);
  }

  void scheduleNotificationBiDaily(int id, String title, String subtitle,
      Time scheduledTime, DateTime initialDate) {
    NotificationService().showBiDailyNotification(
        id, title, subtitle, scheduledTime, initialDate);
  }

  void scheduleNotificationEverySpecificDays(int id, String title,
      String subtitle, Time scheduledTime, int repeatInterval, int dayOfWeek) {
    NotificationService().showEverySpecificDayNotification(
        id, title, subtitle, scheduledTime, repeatInterval, dayOfWeek);
  }

  void scheduleNotificationEveryXDays(int id, String title, String subtitle,
      Time scheduledTime, DateTime initialDate, int frequencyInterval) {
    NotificationService().showXDaysNotification(
        id, title, subtitle, scheduledTime, initialDate, frequencyInterval);
  }

  void scheduleNotificationEveryXWeeks(int id, String title, String subtitle,
      Time scheduledTime, DateTime initialDate, int frequencyInterval) {
    NotificationService().showXWeeksNotification(
        id, title, subtitle, scheduledTime, initialDate, frequencyInterval);
  }

  void scheduleNotificationEveryXMonths(int id, String title, String subtitle,
      Time scheduledTime, DateTime initialDate, int frequencyInterval) {
    NotificationService().showXMonthsNotification(
        id, title, subtitle, scheduledTime, initialDate, frequencyInterval);
  }

  // Other methods or functionality as needed
  // ...
}
