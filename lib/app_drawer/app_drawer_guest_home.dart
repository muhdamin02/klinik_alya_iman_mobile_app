// app_drawer.dart
import 'package:flutter/material.dart';
import 'package:klinik_alya_iman_mobile_app/pages/guest_pages/guest_appointment_pages/guest_profile.dart';

import '../models/user.dart';
import '../pages/startup/login.dart';
import '../services/misc_methods/notification_singleton.dart';
import '../services/notification_service.dart';

class AppDrawerGuest extends StatelessWidget {
  final String header;
  final User user;

  const AppDrawerGuest({Key? key, required this.header, required this.user})
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
                    color: Color.fromARGB(255, 37, 101, 184),
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
                ListTile(
                  leading: const Icon(Icons.event),
                  title: const Text('Appointment',
              style: TextStyle(fontFamily: 'ProductSans')),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateTempProfile(
                          user: user,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text('Login',
              style: TextStyle(fontFamily: 'ProductSans')),
            onTap: () async {
              Navigator.pop(context);
              NotificationCounter notificationCounter = NotificationCounter();
              notificationCounter.reset();
              await NotificationService().cancelAllNotifications();
              // ignore: use_build_context_synchronously
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Login(
                      usernamePlaceholder: '', passwordPlaceholder: ''),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
