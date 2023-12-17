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

  void scheduleNotificationDaily() {
    const scheduledTime = Time(14, 15);

    NotificationService().showRepeatingNotification(1, 'Repeating noti',
        'This notification repeats every day', scheduledTime);
  }

  // Other methods or functionality as needed
  // ...
}
