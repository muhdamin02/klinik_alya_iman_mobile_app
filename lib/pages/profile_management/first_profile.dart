import 'package:flutter/material.dart';
import 'package:klinik_alya_iman_mobile_app/pages/startup/login.dart';

import '../../models/user.dart';
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
          title: const Text('Quick Start'),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'You do not have any profiles.\nCreate your first?',
                style: TextStyle(fontSize: 18.0),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        255, 233, 243, 255), // Set the text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          32.0), // Adjust the value as needed
                    ),
                    padding: const EdgeInsets.all(32.0),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person, // Use any icon you want
                        color: Color.fromARGB(255, 37, 101, 184),
                        size: 64,
                      ),
                      SizedBox(
                          height:
                              16), // Adjust the spacing between icon and text
                      Text(
                        'Create Profile',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 37, 101, 184),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Login(
                          identificationPlaceholder: widget.user.identification,
                          passwordPlaceholder: widget.user.password,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        255, 255, 233, 233), // Set the text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          32.0), // Adjust the value as needed
                    ),
                    padding: const EdgeInsets.all(32.0),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout, // Use any icon you want
                        color: Color.fromARGB(255, 184, 37, 37),
                        size: 64,
                      ),
                      SizedBox(
                          height:
                              16), // Adjust the spacing between icon and text
                      Text(
                        'Nevermind',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 184, 37, 37),
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
