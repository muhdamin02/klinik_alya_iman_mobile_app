import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../models/user.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';
import 'profile_management/first_profile.dart';
import 'profile_management/list_profile.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class Home extends StatelessWidget {
  final User user;

  const Home({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    NotificationService().initNotification();
    NotificationService()
        .showNotification(1, 'delayed noti', 'tolonglah berhasil aku merayu', DateTime(2023, 12, 16, 17, 27));

    return FutureBuilder<int>(
      future: DatabaseService().getProfileCount(user.user_id!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Data is still loading
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Error while fetching data
          return Text('Error: ${snapshot.error}');
        } else {
          // Data has been successfully loaded
          int profileCount = snapshot.data!;

          // Decide which page to navigate based on the profile count
          if (profileCount > 0) {
            return ListProfile(user: user);
          } else {
            return FirstProfile(
              user: user,
            );
          }
        }
      },
    );
  }
}
