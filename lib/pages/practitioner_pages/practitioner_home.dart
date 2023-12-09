import 'package:flutter/material.dart';
import 'package:klinik_alya_iman_mobile_app/models/user.dart';

class PractitionerHome extends StatelessWidget {
  final User user;

  const PractitionerHome({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Practitioner Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome, ${user.f_name} ${user.l_name}!',
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 16.0),
            Text('User ID: ${user.user_id}', style: const TextStyle(fontSize: 16)),
            Text('Email: ${user.email}', style: const TextStyle(fontSize: 16)),
            // Add more details specific to practitioners
          ],
        ),
      ),
    );
  }
}
