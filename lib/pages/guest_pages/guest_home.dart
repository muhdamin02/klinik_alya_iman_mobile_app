import 'package:flutter/material.dart';

import '../../app_drawer/app_drawer_login.dart';
import '../../models/user.dart';
import 'guest_appointment_pages/guest_profile.dart';

class GuestHome extends StatelessWidget {
  final User user;

  const GuestHome({
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
            'Guest placeholder',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        drawer: AppDrawerLogin(
          header: 'Guest Home',
          user: user,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome, ${user.name}!',
                  style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 16.0),
              Text('User ID: ${user.user_id}',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16.0),
              Text('IC or Passport: ${user.identification}',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16.0),
              Text('Phone: ${user.phone}',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateTempProfile(
                        user: user
                      ),
                    ),
                  );
                },
                child: const Text('Book Appointment'),
              ),
              // Add more details specific to practitioners
            ],
          ),
        ),
      ),
    );
  }
}
