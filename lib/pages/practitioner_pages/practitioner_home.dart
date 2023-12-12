import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../startup/login.dart';
import 'manage_appointment.dart';

class PractitionerHome extends StatelessWidget {
  final User user;

  const PractitionerHome({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return false to prevent the user from navigating back
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Practitioner placeholder',
            style: TextStyle(color: Colors.white),
          ),
          automaticallyImplyLeading: false,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          actions: [
            PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return [
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
                if (value == 'logout') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(usernamePlaceholder: user.username, passwordPlaceholder: user.password),
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
              Text('Welcome, ${user.f_name} ${user.l_name}!',
                  style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 16.0),
              Text('User ID: ${user.user_id}',
                  style: const TextStyle(fontSize: 16)),
              Text('Email: ${user.email}',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ManageAppointment(
                        user: user,
                        autoImplyLeading: true,
                      ),
                    ),
                  );
                },
                child: const Text('Manage Appointments'),
              ),
              // Add more details specific to practitioners
            ],
          ),
        ),
      ),
    );
  }
}
