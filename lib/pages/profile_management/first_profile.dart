import 'package:flutter/material.dart';
import 'package:klinik_alya_iman_mobile_app/pages/profile_management/create_profile.dart';

class FirstProfile extends StatelessWidget {
  final int userId;
  final String userFName, userLName, userEmail;

  const FirstProfile(
      {Key? key,
      required this.userId,
      required this.userFName,
      required this.userLName,
      required this.userEmail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quick Start'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Add your button click logic here
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateProfile(
                      userId: userId,
                      userFName: userFName,
                      userLName: userLName,
                      userEmail: userEmail,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(20.0),
              ),
              child: const Icon(
                Icons.add,
                size: 120.0,
              ),
            ),
            const SizedBox(height: 56.0),
            const Text(
              'Create a Profile',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
