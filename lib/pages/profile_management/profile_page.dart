import 'package:flutter/material.dart';

import '../../appbar/appbar_profile.dart';
import '../../models/profile.dart';
import '../../models/user.dart';
import '../appointment_management/appointment_form.dart';

class ProfilePage extends StatelessWidget {
  final User user;
  final Profile profile;

  const ProfilePage({Key? key, required this.user, required this.profile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AlyaImanAppBarProfile(
        title: 'Profile Page',
        user: user,
        profile: profile,
        autoImplyLeading: true,
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
                style: const TextStyle(fontSize: 16)),
            // Add more details as needed
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to the page where you want to appointment form
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AppointmentForm(
                user: user,
                profile: profile,
              ),
            ),
          );
        },
        icon: const Icon(Icons.event), // Customize the icon as needed
        label: const Text('Book Appointment'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
