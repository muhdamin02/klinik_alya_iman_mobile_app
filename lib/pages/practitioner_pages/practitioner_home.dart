import 'package:flutter/material.dart';

class PractitionerHome extends StatelessWidget {
  final int userId;
  final String userFName;
  final String userLName;
  final String userEmail;

  const PractitionerHome({
    Key? key,
    required this.userId,
    required this.userFName,
    required this.userLName,
    required this.userEmail,
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
            Text('Welcome, $userFName $userLName!',
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 16.0),
            Text('User ID: $userId', style: const TextStyle(fontSize: 16)),
            Text('Email: $userEmail', style: const TextStyle(fontSize: 16)),
            // Add more details specific to practitioners
          ],
        ),
      ),
    );
  }
}
