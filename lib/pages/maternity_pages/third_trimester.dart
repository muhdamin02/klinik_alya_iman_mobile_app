import 'package:flutter/material.dart';

import '../../models/profile.dart';
import '../../models/user.dart';
import 'third_trimester/contractions_list.dart';
import 'third_trimester/newborn_care_dashboard.dart';

class ThirdTrimester extends StatefulWidget {
  final User user;
  final Profile profile;

  const ThirdTrimester({
    Key? key,
    required this.user,
    required this.profile,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ThirdTrimesterState createState() => _ThirdTrimesterState();
}

class _ThirdTrimesterState extends State<ThirdTrimester> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return false to prevent the user from navigating back
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Third Trimester'),
          automaticallyImplyLeading: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Third Trimester Page Placeholder',
                style: TextStyle(fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
              Expanded(
                child: SizedBox(
                  height: 90.0,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to the page where you want to appointment form
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewbornCareDashboard(
                            user: widget.user,
                            profile: widget.profile,
                            autoImplyLeading: true,
                          ),
                        ),
                      );
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
                          Icons.assignment, // Use any icon you want
                          color: Color.fromARGB(255, 37, 101, 184),
                          size: 32,
                        ),
                        SizedBox(
                            height:
                                8), // Adjust the spacing between icon and text
                        Text(
                          'Newborn Care Resources',
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
              Expanded(
                child: SizedBox(
                  height: 90.0,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to the page where you want to appointment form
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContractionsList(
                            user: widget.user,
                            profile: widget.profile,
                            autoImplyLeading: true,
                          ),
                        ),
                      );
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
                          Icons.pregnant_woman, // Use any icon you want
                          color: Color.fromARGB(255, 37, 101, 184),
                          size: 32,
                        ),
                        SizedBox(
                            height:
                                8), // Adjust the spacing between icon and text
                        Text(
                          'Track Contractions',
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
        ),
      ),
    );
  }
}
