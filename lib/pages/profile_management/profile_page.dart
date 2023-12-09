import 'package:flutter/material.dart';
import 'package:klinik_alya_iman_mobile_app/models/profile.dart';

class ProfilePage extends StatelessWidget {
  final Profile profile;

  const ProfilePage({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${profile.f_name} ${profile.l_name}', style: const TextStyle(fontSize: 20)),
            Text('Date of Birth: ${profile.dob}', style: const TextStyle(fontSize: 16)),
            Text('Gender: ${profile.gender}', style: const TextStyle(fontSize: 16))
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}
