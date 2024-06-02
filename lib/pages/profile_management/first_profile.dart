// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:klinik_alya_iman_mobile_app/pages/startup/login.dart';

import '../../models/profile.dart';
import '../../models/user.dart';
import '../../services/misc_methods/notification_singleton.dart';
import '../../services/notification_service.dart';
import '../startup/patient_homepage.dart';
import 'create_profile.dart';

class FirstProfile extends StatefulWidget {
  final User user;
  final bool showTips;

  const FirstProfile({
    Key? key,
    required this.user,
    required this.showTips,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FirstProfileState createState() => _FirstProfileState();
}

class _FirstProfileState extends State<FirstProfile> {
  @override
  void initState() {
    super.initState();

    if (widget.showTips) {
      Future.delayed(Duration.zero, () {
        _showTipsDialog1();
      });
    }
  }

  void _showTipsDialog1() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          title: const Text(
            'TIPS (1/2)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'Profiles are a representation of a patient\'s account, where they can store personal information, book for appointments, register medication for reminders, and engage in various other functionalities.',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Center(
              child: SizedBox(
                height: 60.0,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showTipsDialog2();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        255, 115, 176, 255), // Set the button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          20.0), // Adjust the value as needed
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
      barrierDismissible: false,
    );
  }

  void _showTipsDialog2() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          title: const Text(
            'TIPS (2/2)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'You can have more than one profile. Each profile can book their own appointments, register their own medication, and more.',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Center(
              child: SizedBox(
                height: 60.0,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        255, 115, 176, 255), // Set the button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          20.0), // Adjust the value as needed
                    ),
                  ),
                  child: const Text(
                    'Okay',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return false to prevent the user from navigating back
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Profiles'),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                NotificationCounter notificationCounter = NotificationCounter();
                notificationCounter.reset();
                await NotificationService().cancelAllNotifications();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login(
                        usernamePlaceholder: widget.user.username,
                        passwordPlaceholder: widget.user.password),
                  ),
                );
              },
            ),
          ],
          elevation: 0,
        ),
        bottomNavigationBar: SizedBox(
          height: 56.0, // Adjust the height as needed
          child: BottomAppBar(
            color: const Color(
                0xFF0A0F2C), // Set the background color of the BottomAppBar
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.group),
                    iconSize: 30,
                    onPressed: () {},
                    color: const Color(0xFF5464BB), // Set the color of the icon
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.home),
                    iconSize: 25,
                    onPressed: () {
                      final tempProfile = Profile(
                        name: 'unknown',
                        identification: 'unknown',
                        dob: 'unknown',
                        gender: 'unknown',
                        height: 0,
                        weight: 0,
                        body_fat_percentage: 0,
                        activity_level: 'unknown',
                        belly_size: 0,
                        maternity: 'No',
                        maternity_due: 'Not set',
                        ethnicity: 'unknown',
                        marital_status: 'unknown',
                        occupation: 'unknown',
                        medical_alert: 'unknown',
                        profile_pic: 'unknown',
                        creation_date: 'unknown',
                        user_id: widget.user.user_id!,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PatientHomepage(
                            user: widget.user,
                            profile: tempProfile,
                            hasProfiles: false,
                            hasChosenProfile: false,
                            autoImplyLeading: false,
                          ),
                        ),
                      );
                    },
                    color: const Color(0xFFEDF2FF), // Set the color of the icon
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    iconSize: 23,
                    onPressed: () {},
                    color: const Color(0xFFEDF2FF), // Set the color of the icon
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'You do not have any profiles.\nCreate your first?',
                style: TextStyle(fontSize: 18.0, color: Color(0xFFEDF2FF)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateProfile(
                          user: widget.user,
                        ),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFC1D3FF), // Set the fill color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            60.0), // Adjust the value as needed
                      ),
                      side: const BorderSide(
                        color: Color(0xFF6086f6), // Set the outline color
                        width: 2.5, // Set the outline width
                      ),
                      padding: const EdgeInsets.all(32.0)),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person, // Use any icon you want
                        color: Color(0xFF1F3299),
                        size: 32,
                      ),
                      SizedBox(
                          height:
                              16), // Adjust the spacing between icon and text
                      Text(
                        'New Profile',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1F3299),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
