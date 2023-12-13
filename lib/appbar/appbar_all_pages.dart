import 'package:flutter/material.dart';

import '../models/profile.dart';
import '../models/user.dart';
import '../pages/appointment_management/list_appointment.dart';
import '../pages/medication_management/list_medication.dart';
import '../pages/profile_management/list_profile.dart';
import '../pages/startup/login.dart';


class AlyaImanAppBarSeeAllPages extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final User user;
  final Profile profile;
  final bool autoImplyLeading;

  const AlyaImanAppBarSeeAllPages({
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
                  value: 'profile',
                  child: ListTile(
                    leading: Icon(Icons.group),
                    title: Text('Profiles'),
                  ),
                ),
                const PopupMenuItem(
                  value: 'appointment',
                  child: ListTile(
                    leading: Icon(Icons.event),
                    title: Text('Appointments'),
                  ),
                ),
                const PopupMenuItem(
                  value: 'medication',
                  child: ListTile(
                    leading: Icon(Icons.medication),
                    title: Text('Medications'),
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
            onSelected: (value) {
              if (value == 'profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListProfile(
                      user: user,
                    ),
                  ),
                );
              } else if (value == 'appointment') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListAppointment(
                      user: user,
                      profile: profile,
                      autoImplyLeading: true,
                    ),
                  ),
                );
              } else if (value == 'medication') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListMedication(
                      user: user,
                      profile: profile,
                      autoImplyLeading: true,
                    ),
                  ),
                );
              } else if (value == 'logout') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login(usernamePlaceholder: user.username, passwordPlaceholder: user.password),
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
