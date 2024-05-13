// app_drawer.dart
import 'package:flutter/material.dart';

import '../models/user.dart';
import '../pages/profile_management/list_profile.dart';
import '../pages/startup/login.dart';
import '../services/misc_methods/notification_singleton.dart';
import '../services/notification_service.dart';

class AppDrawerUser extends StatelessWidget {
  final String header;
  final User user;
  final bool autoImplyLeading;

  const AppDrawerUser(
      {Key? key,
      required this.header,
      required this.user,
      required this.autoImplyLeading})
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
                    color: Color(0xFF6086f6),
                  ),
                  child: Text(
                    'Menu Header',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily: 'ProductSans'
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.group),
            title: const Text('Switch Profile',
                style: TextStyle(fontFamily: 'ProductSans')),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListProfile(
                    user: user,
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout', style: TextStyle(fontFamily: 'ProductSans')),
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
                      usernamePlaceholder: user.username,
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
