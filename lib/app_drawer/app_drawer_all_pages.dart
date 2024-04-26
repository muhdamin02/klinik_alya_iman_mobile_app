// app_drawer.dart
import 'package:flutter/material.dart';
import 'package:klinik_alya_iman_mobile_app/pages/medical_history/list_medical_history.dart';
import 'package:klinik_alya_iman_mobile_app/pages/profile_management/profile_page.dart';

import '../models/profile.dart';
import '../models/user.dart';
import '../pages/appointment_management/list_appointment.dart';
import '../pages/medication_management/list_medication.dart';
import '../pages/profile_management/list_profile.dart';
import '../pages/startup/login.dart';
import '../pages/startup/patient_homepage.dart';
import '../services/misc_methods/notification_singleton.dart';
import '../services/notification_service.dart';

class AppDrawerAllPages extends StatelessWidget {
  final String header;
  final User user;
  final Profile profile;
  final bool autoImplyLeading;

  const AppDrawerAllPages(
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
                    color: Color.fromARGB(255, 37, 101, 184),
                  ),
                  child: Text(
                    'Menu Header',
                    style: TextStyle(
                        color: Colors.white, fontSize: 24, fontFamily: 'ProductSans'),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title:
                      const Text('Home', style: TextStyle(fontFamily: 'ProductSans')),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PatientHomepage(
                          user: user,
                          profile: profile,
                          autoImplyLeading: false,
                        ),
                      ),
                    );
                  },
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
                ListTile(
                  leading: const Icon(Icons.event),
                  title: const Text('Appointments',
                      style: TextStyle(fontFamily: 'ProductSans')),
                  onTap: () {
                    Navigator.pop(context);
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
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.medication),
                  title: const Text('Medications',
                      style: TextStyle(fontFamily: 'ProductSans')),
                  onTap: () {
                    Navigator.pop(context);
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
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.assignment),
                  title: const Text('Medical History',
                      style: TextStyle(fontFamily: 'ProductSans')),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListMedicalHistory(
                          user: user,
                          profile: profile,
                          autoImplyLeading: true,
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.timeline),
                  title: const Text('Reporting',
                      style: TextStyle(fontFamily: 'ProductSans')),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListMedicalHistory(
                          user: user,
                          profile: profile,
                          autoImplyLeading: true,
                        ),
                      ),
                    );
                  },
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
