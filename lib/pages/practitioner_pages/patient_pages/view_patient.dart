import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/profile.dart';
import '../../../models/user.dart';

class ViewPatient extends StatelessWidget {
  final User user;
  final Profile profile;
  final bool autoImplyLeading;

  const ViewPatient(
      {Key? key,
      required this.user,
      required this.profile,
      required this.autoImplyLeading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String cleanedDate = profile.dob.replaceAll(" at", "");
    DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(cleanedDate);
    String formattedDate = DateFormat('dd MMMM yyyy').format(parsedDate);

    return WillPopScope(
      onWillPop: () async {
        // Return false to prevent the user from navigating back
        return autoImplyLeading;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Patient Info'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0), // Add your desired padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('NAME',
                  style: TextStyle(
                      fontSize: 14, color: Color.fromARGB(255, 121, 121, 121))),
              const SizedBox(height: 4),
              Text(profile.name, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 24),
              const Text('IC/PASSPORT',
                  style: TextStyle(
                      fontSize: 14, color: Color.fromARGB(255, 121, 121, 121))),
              const SizedBox(height: 4),
              Text(profile.identification,
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 24),
              const Text('DATE OF BIRTH',
                  style: TextStyle(
                      fontSize: 14, color: Color.fromARGB(255, 121, 121, 121))),
              const SizedBox(height: 4),
              Text(
                formattedDate,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              const Text('GENDER',
                  style: TextStyle(
                      fontSize: 14, color: Color.fromARGB(255, 121, 121, 121))),
              const SizedBox(height: 4),
              Text('${profile.gender}', style: const TextStyle(fontSize: 16)),
              // Add more details as needed
            ],
          ),
        ),
      ),
    );
  }
}
