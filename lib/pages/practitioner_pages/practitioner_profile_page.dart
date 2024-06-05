// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';

import '../../models/practitioner_profile.dart';
import '../../models/user.dart';
import '../../services/database_service.dart';
import '../../services/misc_methods/notification_singleton.dart';
import '../../services/notification_service.dart';
import '../startup/login.dart';
import 'manage_appointment.dart';
import 'patient_pages/view_patients_list.dart';
import 'practitioner_home.dart';

class PractitionerProfilePage extends StatefulWidget {
  final User user;
  final bool autoImplyLeading;

  const PractitionerProfilePage(
      {Key? key, required this.user, required this.autoImplyLeading})
      : super(key: key);

  @override
  _PractitionerProfilePageState createState() =>
      _PractitionerProfilePageState();
}

class _PractitionerProfilePageState extends State<PractitionerProfilePage> {
  List<PractitionerProfile> _practitionerInfo = [];

  @override
  void initState() {
    super.initState();
    _fetchPractitionerInfo();
  }

  Future<void> _fetchPractitionerInfo() async {
    List<PractitionerProfile> practitionerInfo =
        await DatabaseService().practitionerInfo(widget.user.user_id);
    setState(() {
      _practitionerInfo = practitionerInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return false to prevent the user from navigating back
        return widget.autoImplyLeading;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_getFirstTwoWords(widget.user.name)),
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Color(0xFFEDF2FF),
          ),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                // Show a dialog to confirm logout
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: const Color(0xFF303E8F),
                      title: const Text('Confirm Logout'),
                      content: const Text('Are you sure you want to log out?',
                          style: TextStyle(color: Color(0xFFEDF2FF))),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () async {
                            // Perform logout actions
                            NotificationCounter notificationCounter =
                                NotificationCounter();
                            notificationCounter.reset();
                            await NotificationService()
                                .cancelAllNotifications();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Login(
                                  usernamePlaceholder: widget.user.username,
                                  passwordPlaceholder: widget.user.password,
                                ),
                              ),
                            );
                          },
                          child: const Text('Yes',
                              style: TextStyle(color: Color(0xFFEDF2FF))),
                        ),
                        TextButton(
                          onPressed: () {
                            // Close the dialog
                            Navigator.of(context).pop();
                          },
                          child: const Text('No',
                              style: TextStyle(color: Color(0xFFEDF2FF))),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: SizedBox(
          height: 56.0, // Adjust the height as needed
          child: BottomAppBar(
            color: const Color(
              0xFF0A0F2C,
            ), // Set the background color of the BottomAppBar
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.person),
                    iconSize: 30,
                    onPressed: () {
                      // PROFILE PAGE FOR PRACTITIONER
                    },
                    color: const Color(
                      0xFF5464BB,
                    ), // Set the color of the icon
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.event),
                    iconSize: 22,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ManageAppointment(
                              user: widget.user,
                              autoImplyLeading: false,
                              initialTab: 1),
                        ),
                      );
                    },
                    color: const Color(
                      0xFFEDF2FF,
                    ), // Set the color of the icon
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.home),
                    iconSize: 30,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PractitionerHome(
                            user: widget.user,
                          ),
                        ),
                      );
                    },
                    color: const Color(
                      0xFFEDF2FF,
                    ), // Set the color of the icon
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.group),
                    iconSize: 25,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PatientsList(
                            user: widget.user,
                            autoImplyLeading: false,
                          ),
                        ),
                      );
                    },
                    color: const Color(
                      0xFFEDF2FF,
                    ), // Set the color of the icon
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
        body: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          shrinkWrap: true,
          itemCount: _practitionerInfo.length,
          itemBuilder: (context, index) {
            PractitionerProfile practitioner = _practitionerInfo[index];
            return SizedBox(
              width: MediaQuery.of(context)
                  .size
                  .width, // Set width to screen width
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8.0),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Color(0xFFB6CBFF),
                            height: 1,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            'Profile',
                            style: TextStyle(
                              color: Color(0xFFEDF2FF),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Color(0xFFB6CBFF),
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: double.infinity, // Adjust padding as needed
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30.0), // Adjust the radius
                      ),
                      elevation: 0, // Set the elevation for the card
                      color: const Color(0xFF303E8F),
                      child: Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Handle onTap action here
                              },
                              child: const Row(
                                children: [
                                  Text(
                                    "FULL NAME",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Color(0xFFB6CBFF),
                                    ),
                                  ),
                                  SizedBox(
                                      width:
                                          8), // Add some spacing between text and icon
                                  Icon(
                                    Icons.lock,
                                    color: Color(
                                        0xFFB6CBFF), // Set the color of the icon
                                    size:
                                        16, // Adjust the size of the icon as needed
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              practitioner.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xFFEDF2FF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: double.infinity, // Adjust padding as needed
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  30.0), // Adjust the radius
                            ),
                            elevation: 0, // Set the elevation for the card
                            color: const Color(0xFF303E8F),
                            child: Padding(
                              padding: const EdgeInsets.all(28.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // Handle onTap action here
                                    },
                                    child: const Row(
                                      children: [
                                        Text(
                                          "BIRTH DATE",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: Color(0xFFB6CBFF),
                                          ),
                                        ),
                                        SizedBox(
                                            width:
                                                8), // Add some spacing between text and icon
                                        Icon(
                                          Icons.lock,
                                          color: Color(
                                              0xFFB6CBFF), // Set the color of the icon
                                          size:
                                              16, // Adjust the size of the icon as needed
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    practitioner.dob,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Color(0xFFEDF2FF),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: SizedBox(
                          width: double.infinity, // Adjust padding as needed
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  30.0), // Adjust the radius
                            ),
                            elevation: 0, // Set the elevation for the card
                            color: const Color(0xFF303E8F),
                            child: Padding(
                              padding: const EdgeInsets.all(28.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // Handle onTap action here
                                    },
                                    child: const Row(
                                      children: [
                                        Text(
                                          "GENDER",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: Color(0xFFB6CBFF),
                                          ),
                                        ),
                                        SizedBox(
                                            width:
                                                8), // Add some spacing between text and icon
                                        Icon(
                                          Icons.lock,
                                          color: Color(
                                              0xFFB6CBFF), // Set the color of the icon
                                          size:
                                              16, // Adjust the size of the icon as needed
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    practitioner.gender!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Color(0xFFEDF2FF),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity, // Adjust padding as needed
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30.0), // Adjust the radius
                      ),
                      elevation: 0, // Set the elevation for the card
                      color: const Color(0xFF303E8F),
                      child: Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Handle onTap action here
                              },
                              child: const Row(
                                children: [
                                  Text(
                                    "EMAIL",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Color(0xFFB6CBFF),
                                    ),
                                  ),
                                  SizedBox(
                                      width:
                                          8), // Add some spacing between text and icon
                                  Icon(
                                    Icons.edit,
                                    color: Color(
                                        0xFFFFD271), // Set the color of the icon
                                    size:
                                        16, // Adjust the size of the icon as needed
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              practitioner.email,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xFFEDF2FF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: double.infinity, // Adjust padding as needed
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  30.0), // Adjust the radius
                            ),
                            elevation: 0, // Set the elevation for the card
                            color: const Color(0xFF303E8F),
                            child: Padding(
                              padding: const EdgeInsets.all(28.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // Handle onTap action here
                                    },
                                    child: const Row(
                                      children: [
                                        Text(
                                          "PHONE",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: Color(0xFFB6CBFF),
                                          ),
                                        ),
                                        SizedBox(
                                            width:
                                                8), // Add some spacing between text and icon
                                        Icon(
                                          Icons.edit,
                                          color: Color(
                                              0xFFFFD271), // Set the color of the icon
                                          size:
                                              16, // Adjust the size of the icon as needed
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    practitioner.phone,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Color(0xFFEDF2FF),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: SizedBox(
                          width: double.infinity, // Adjust padding as needed
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  30.0), // Adjust the radius
                            ),
                            elevation: 0, // Set the elevation for the card
                            color: const Color(0xFF303E8F),
                            child: Padding(
                              padding: const EdgeInsets.all(28.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // Handle onTap action here
                                    },
                                    child: const Row(
                                      children: [
                                        Text(
                                          "BRANCH",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: Color(0xFFB6CBFF),
                                          ),
                                        ),
                                        SizedBox(
                                            width:
                                                8), // Add some spacing between text and icon
                                        Icon(
                                          Icons.lock,
                                          color: Color(
                                              0xFFB6CBFF), // Set the color of the icon
                                          size:
                                              16, // Adjust the size of the icon as needed
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    practitioner.branch,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Color(0xFFEDF2FF),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity, // Adjust padding as needed
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30.0), // Adjust the radius
                      ),
                      elevation: 0, // Set the elevation for the card
                      color: const Color(0xFF303E8F),
                      child: Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Handle onTap action here
                              },
                              child: const Row(
                                children: [
                                  Text(
                                    "SPECIALIZATION",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Color(0xFFB6CBFF),
                                    ),
                                  ),
                                  SizedBox(
                                      width:
                                          8), // Add some spacing between text and icon
                                  Icon(
                                    Icons.edit,
                                    color: Color(
                                        0xFFFFD271), // Set the color of the icon
                                    size:
                                        16, // Adjust the size of the icon as needed
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              practitioner.specialization,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xFFEDF2FF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity, // Adjust padding as needed
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30.0), // Adjust the radius
                      ),
                      elevation: 0, // Set the elevation for the card
                      color: const Color(0xFF303E8F),
                      child: Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Handle onTap action here
                              },
                              child: const Row(
                                children: [
                                  Text(
                                    "QUALIFICATIONS",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Color(0xFFB6CBFF),
                                    ),
                                  ),
                                  SizedBox(
                                      width:
                                          8), // Add some spacing between text and icon
                                  Icon(
                                    Icons.edit,
                                    color: Color(
                                        0xFFFFD271), // Set the color of the icon
                                    size:
                                        16, // Adjust the size of the icon as needed
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              practitioner.qualifications,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xFFEDF2FF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// Function to get the first two words from a string
String _getFirstTwoWords(String fullName) {
  // Split the string into words
  List<String> words = fullName.split(' ');

  // Take the first two words and join them back into a string
  return words.take(2).join(' ');
}
