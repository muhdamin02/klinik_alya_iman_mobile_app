import 'package:flutter/material.dart';

import '../../models/profile.dart';
import '../../models/user.dart';
import 'second_trimester/baby_kicks_list.dart';
import 'second_trimester/track_body_changes.dart';

class SecondTrimester extends StatefulWidget {
  final User user;
  final Profile profile;

  const SecondTrimester({
    Key? key,
    required this.user,
    required this.profile,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SecondTrimesterState createState() => _SecondTrimesterState();
}

class _SecondTrimesterState extends State<SecondTrimester> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return false to prevent the user from navigating back
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Second Trimester'),
          automaticallyImplyLeading: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0), // Add your desired padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Second Trimester Page Placeholder',
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
                          builder: (context) => BabyKicksList(
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
                          'Baby Kicks Counter',
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
              const SizedBox(height: 16),
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
                          builder: (context) => TrackBodyChanges(
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
                          'Track Body Changes',
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
