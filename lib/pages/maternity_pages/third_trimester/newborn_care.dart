import 'package:flutter/material.dart';

import '../../../models/profile.dart';
import '../../../models/user.dart';

// ignore: must_be_immutable
class NewbornCare extends StatefulWidget {
  User user;
  Profile profile;
  bool autoImplyLeading;

  NewbornCare({
    Key? key,
    required this.user,
    required this.profile,
    required this.autoImplyLeading,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NewbornCareState createState() => _NewbornCareState();
}

class _NewbornCareState extends State<NewbornCare> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return false to prevent the user from navigating back
        return widget.autoImplyLeading;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Newborn Care Resources'),
          automaticallyImplyLeading: widget.autoImplyLeading,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0), // Add your desired padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Newborn Care Resources',
                style: TextStyle(fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 90.0,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          //
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                              255, 233, 243, 255), // Set the text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                32.0), // Adjust the value as needed
                          ),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.info, // Use any icon you want
                              color: Color.fromARGB(255, 37, 101, 184),
                              size: 32,
                            ),
                            SizedBox(
                                height:
                                    8), // Adjust the spacing between icon and text
                            Text(
                              'Basic Care Information',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 37, 101, 184),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 90.0,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          //
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                              255, 233, 243, 255), // Set the text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                32.0), // Adjust the value as needed
                          ),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.medical_services, // Use any icon you want
                              color: Color.fromARGB(255, 37, 101, 184),
                              size: 32,
                            ),
                            SizedBox(
                                height:
                                    8), // Adjust the spacing between icon and text
                            Text(
                              'Health and Safety',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 37, 101, 184),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}