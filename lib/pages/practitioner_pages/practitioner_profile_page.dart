// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final User actualUser;
  final User practitionerUser;
  final bool autoImplyLeading;

  const PractitionerProfilePage(
      {Key? key,
      required this.actualUser,
      required this.practitionerUser,
      required this.autoImplyLeading})
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
    List<PractitionerProfile> practitionerInfo = await DatabaseService()
        .practitionerInfo(widget.practitionerUser.user_id);
    setState(() {
      _practitionerInfo = practitionerInfo;
    });
  }

  Future<void> _launchPhoneNumber(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneUri';
    }
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: _encodeQueryParameters(<String, String>{
        'subject': 'Query about Klinik Alya Iman',
        'body': 'Hello, I want to ask about...'
      }),
    );
    if (!await launchUrl(emailUri)) {
      throw 'Could not launch $emailUri';
    }
  }

  String _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
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
          title: Text(_getFirstTwoWords(widget.practitionerUser.name)),
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Color(0xFFEDF2FF),
          ),
          automaticallyImplyLeading: widget.autoImplyLeading,
          actions: <Widget>[
            if (widget.actualUser.role == 'practitioner')
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
                                    usernamePlaceholder:
                                        widget.actualUser.username,
                                    passwordPlaceholder:
                                        widget.actualUser.password,
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
        bottomNavigationBar: widget.actualUser.role == 'practitioner'
            ? SizedBox(
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
                                    user: widget.actualUser,
                                    autoImplyLeading: false,
                                    initialTab: 1,
                                    profileId: 0),
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
                          iconSize: 25,
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PractitionerHome(
                                  user: widget.actualUser,
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
                          icon: const Icon(Icons.groups_3),
                          iconSize: 25,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PatientsList(
                                  user: widget.actualUser,
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
                          color: const Color(
                              0xFFEDF2FF), // Set the color of the icon
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              )
            : null,
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
                                color: Color(0xFFEDF2FF), letterSpacing: 2),
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          backgroundColor: const Color(0xFF303E8F),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 28.0, horizontal: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Handle onTap action here
                                },
                                child: Row(
                                  children: [
                                    const Text(
                                      "FULL NAME",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Color(0xFFB6CBFF),
                                      ),
                                    ),
                                    if (widget.actualUser.role ==
                                        'practitioner')
                                      const SizedBox(
                                          width:
                                              8), // Add some spacing between text and icon
                                    if (widget.actualUser.role ==
                                        'practitioner')
                                      const Icon(
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
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: double.infinity, // Adjust padding as needed
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                backgroundColor: const Color(0xFF303E8F),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 28.0, horizontal: 12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        // Handle onTap action here
                                      },
                                      child: Row(
                                        children: [
                                          const Text(
                                            "BIRTH DATE",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: Color(0xFFB6CBFF),
                                            ),
                                          ),
                                          if (widget.actualUser.role ==
                                              'practitioner')
                                            const SizedBox(
                                                width:
                                                    8), // Add some spacing between text and icon
                                          if (widget.actualUser.role ==
                                              'practitioner')
                                            const Icon(
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
                      ),
                      Expanded(
                        child: SizedBox(
                          width: double.infinity, // Adjust padding as needed
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                backgroundColor: const Color(0xFF303E8F),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 28.0, horizontal: 12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        // Handle onTap action here
                                      },
                                      child: Row(
                                        children: [
                                          const Text(
                                            "GENDER",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: Color(0xFFB6CBFF),
                                            ),
                                          ),
                                          if (widget.actualUser.role ==
                                              'practitioner')
                                            const SizedBox(
                                                width:
                                                    8), // Add some spacing between text and icon
                                          if (widget.actualUser.role ==
                                              'practitioner')
                                            const Icon(
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
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity, // Adjust padding as needed
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (widget.actualUser.role != 'practitioner') {
                            _launchEmail(practitioner.email);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          backgroundColor: const Color(0xFF303E8F),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 28.0, horizontal: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "EMAIL",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Color(0xFFB6CBFF),
                                    ),
                                  ),
                                  const SizedBox(
                                      width:
                                          8), // Add some spacing between text and icon
                                  if (widget.actualUser.role == 'practitioner')
                                    const Icon(
                                      Icons.edit,
                                      color: Color(
                                          0xFFFFD271), // Set the color of the icon
                                      size:
                                          16, // Adjust the size of the icon as needed
                                    ),
                                  if (widget.actualUser.role != 'practitioner')
                                    const Icon(
                                      Icons.mail_rounded,
                                      color: Color(
                                          0xFFB6CBFF), // Set the color of the icon
                                      size:
                                          16, // Adjust the size of the icon as needed
                                    ),
                                ],
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
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: double.infinity, // Adjust padding as needed
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: ElevatedButton(
                              onPressed: () {
                                if (widget.actualUser.role != 'practitioner') {
                                  _launchPhoneNumber(practitioner.phone);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                backgroundColor: const Color(0xFF303E8F),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 28.0, horizontal: 12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          "PHONE",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: Color(0xFFB6CBFF),
                                          ),
                                        ),
                                        const SizedBox(
                                            width:
                                                8), // Add some spacing between text and icon
                                        if (widget.actualUser.role ==
                                            'practitioner')
                                          const Icon(
                                            Icons.edit,
                                            color: Color(
                                                0xFFFFD271), // Set the color of the icon
                                            size:
                                                16, // Adjust the size of the icon as needed
                                          ),
                                        if (widget.actualUser.role !=
                                            'practitioner')
                                          const Icon(
                                            Icons.phone,
                                            color: Color(
                                                0xFFB6CBFF), // Set the color of the icon
                                            size:
                                                16, // Adjust the size of the icon as needed
                                          ),
                                      ],
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
                      ),
                      Expanded(
                        child: SizedBox(
                          width: double.infinity, // Adjust padding as needed
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                backgroundColor: const Color(0xFF303E8F),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 28.0, horizontal: 12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        // Handle onTap action here
                                      },
                                      child: Row(
                                        children: [
                                          const Text(
                                            "BRANCH",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: Color(0xFFB6CBFF),
                                            ),
                                          ),
                                          if (widget.actualUser.role ==
                                              'practitioner')
                                            const SizedBox(
                                                width:
                                                    8), // Add some spacing between text and icon
                                          if (widget.actualUser.role ==
                                              'practitioner')
                                            const Icon(
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
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity, // Adjust padding as needed
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          backgroundColor: const Color(0xFF303E8F),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 28.0, horizontal: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Handle onTap action here
                                },
                                child: Row(
                                  children: [
                                    const Text(
                                      "SPECIALIZATION",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Color(0xFFB6CBFF),
                                      ),
                                    ),
                                    if (widget.actualUser.role ==
                                        'practitioner')
                                      const SizedBox(
                                          width:
                                              8), // Add some spacing between text and icon
                                    if (widget.actualUser.role ==
                                        'practitioner')
                                      const Icon(
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
