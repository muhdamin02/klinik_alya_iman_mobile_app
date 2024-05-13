// app_drawer.dart
import 'package:flutter/material.dart';

import '../models/profile.dart';
import '../models/user.dart';
import '../pages/profile_management/profile_page.dart';
import '../pages/startup/login.dart';
import '../services/misc_methods/notification_singleton.dart';
import '../services/notification_service.dart';

class AppDrawerProfilesLogout extends StatelessWidget {
  final String header;
  final User user;
  final Profile profile;
  final bool autoImplyLeading;

  const AppDrawerProfilesLogout(
      {Key? key,
      required this.header,
      required this.user,
      required this.profile,
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
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color(0xFF6086f6),
                  ),
                  child: Text(
                    'Menu Header',
                    style: TextStyle(
                        color: Colors.white, fontSize: 24, fontFamily: 'ProductSans'),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('My Profile',
                      style: TextStyle(fontFamily: 'ProductSans')),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(
                          user: user,
                          profile: profile,
                          autoImplyLeading: false,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
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
