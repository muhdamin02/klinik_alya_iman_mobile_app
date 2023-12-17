import 'package:flutter/material.dart';

import '../models/profile.dart';
import '../models/user.dart';
import '../pages/profile_management/profile_page.dart';
import '../pages/startup/login.dart';
import '../services/misc_methods/notification_singleton.dart';
import '../services/notification_service.dart';

class AlyaImanAppBarOnlySeeProfilesAndLogout extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final User user;
  final Profile profile;
  final bool autoImplyLeading;

  const AlyaImanAppBarOnlySeeProfilesAndLogout({
    Key? key,
    required this.title,
    required this.user,
    required this.profile,
    required this.autoImplyLeading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(title),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        automaticallyImplyLeading: autoImplyLeading,
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'profile_page',
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Profile Page'),
                  ),
                ),
                const PopupMenuItem(
                  value: 'logout',
                  child: ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Logout'),
                  ),
                ),
              ];
            },
            onSelected: (value) async {
              if (value == 'profile_page') {
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
              } else if (value == 'logout') {
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
              }
            },
          ),
        ]);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
