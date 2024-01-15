// app_drawer.dart
import 'package:flutter/material.dart';

import '../models/user.dart';
import '../pages/startup/login.dart';
import '../services/misc_methods/notification_singleton.dart';
import '../services/notification_service.dart';

class AppDrawerLogout extends StatelessWidget {
  final String header;
  final User user;

  const AppDrawerLogout({Key? key, required this.header, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: const [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 37, 101, 184),
                  ),
                  child: Text(
                    'Menu Header',
                    style: TextStyle(
                        color: Colors.white, fontSize: 24, fontFamily: 'Rubik'),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text(
              'Logout',
              style: TextStyle(fontFamily: 'Rubik'),
            ),
            onTap: () async {
              Navigator.pop(context);
              NotificationCounter notificationCounter = NotificationCounter();
              notificationCounter.reset();
              await NotificationService().cancelAllNotifications();
              // ignore: use_build_context_synchronously
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Login(
                      identificationPlaceholder: user.identification,
                      passwordPlaceholder: user.password),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
