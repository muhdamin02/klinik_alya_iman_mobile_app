import 'package:flutter/material.dart';
import 'package:klinik_alya_iman_mobile_app/models/profile.dart';
import 'package:klinik_alya_iman_mobile_app/pages/appointment_management/list_appointment.dart';
import 'package:klinik_alya_iman_mobile_app/pages/profile_management/list_profile.dart';
import 'package:klinik_alya_iman_mobile_app/pages/startup/login.dart';

class ProfilePage extends StatelessWidget {
  final Profile profile;

  const ProfilePage({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page',
            style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'profile',
                  child: ListTile(
                    leading: Icon(Icons.list),
                    title: Text('Profiles'),
                  ),
                ),
                const PopupMenuItem(
                  value: 'history',
                  child: ListTile(
                    leading: Icon(Icons.list),
                    title: Text('Appointment History'),
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
                      userId: profile.user_id,
                    ),
                  ),
                );
              } else if (value == 'history') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListAppointment(
                      userId: profile.user_id,
                      profile: profile,
                    ),
                  ),
                );
              } else if (value == 'logout') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Login(),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${profile.f_name} ${profile.l_name}',
                style: const TextStyle(fontSize: 20)),
            Text('Date of Birth: ${profile.dob}',
                style: const TextStyle(fontSize: 16)),
            Text('Gender: ${profile.gender}',
                style: const TextStyle(fontSize: 16))
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}
