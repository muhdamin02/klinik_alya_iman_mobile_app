// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:klinik_alya_iman_mobile_app/pages/medical_history/list_medical_history.dart';

import '../../app_drawer/app_drawer_all_pages.dart';
import '../../models/profile.dart';
import '../../models/user.dart';
import '../../services/misc_methods/notification_singleton.dart';
import '../../services/notification_service.dart';
import '../appointment_management/list_appointment.dart';
import '../maternity_pages/first_trimester.dart';
import '../maternity_pages/second_trimester.dart';
import '../maternity_pages/third_trimester.dart';
import '../medication_management/list_medication.dart';
import '../profile_management/profile_page.dart';
import '../startup/login.dart';
import '../startup/patient_homepage.dart';

class MaternityOverview extends StatelessWidget {
  final User user;
  final Profile profile;
  final bool autoImplyLeading;

  const MaternityOverview(
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
          title: const Text("Maternity Hub"),
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
                                  usernamePlaceholder: user.username,
                                  passwordPlaceholder: user.password,
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
                0xFF0A0F2C), // Set the background color of the BottomAppBar
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.person),
                    iconSize: 25,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(
                            user: user,
                            profile: profile,
                            autoImplyLeading: false,
                          ),
                        ),
                      );
                    },
                    color: const Color(0xFFEDF2FF), // Set the color of the icon
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.event),
                    iconSize: 22,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListAppointment(
                            user: user,
                            profile: profile,
                            autoImplyLeading: false,
                            initialTab: 1,
                          ),
                        ),
                      );
                    },
                    color: const Color(0xFFEDF2FF), // Set the color of the icon
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.home),
                    iconSize: 25,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PatientHomepage(
                            user: user,
                            profile: profile,
                            hasProfiles: true,
                            hasChosenProfile: true,
                            autoImplyLeading: false,
                          ),
                        ),
                      );
                    },
                    color: const Color(0xFFEDF2FF), // Set the color of the icon
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.medication),
                    iconSize: 25,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListMedication(
                            user: user,
                            profile: profile,
                            autoImplyLeading: false,
                          ),
                        ),
                      );
                    },
                    color: const Color(0xFFEDF2FF), // Set the color of the icon
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.pregnant_woman),
                    iconSize: 28,
                    onPressed: () {},
                    color: const Color(0xFF5464BB), // Set the color of the icon
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 12.0),
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
                        'Overview',
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
              Row(
                children: [
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      elevation: 0,
                      color: const Color(0xFF303E8F),
                      child: Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Handle onTap action here
                              },
                              child: const Text(
                                "TRIMESTER",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Color(0xFFB6CBFF),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              profile.maternity == 'First Trimester'
                                  ? '1'
                                  : profile.maternity == 'Second Trimester'
                                      ? '2'
                                      : profile.maternity == 'Third Trimester'
                                          ? '3'
                                          : '', // Default text if none of the conditions are met
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 24,
                                color: Color(0xFFEDF2FF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4), // Add spacing between the cards
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      elevation: 0,
                      color: const Color(0xFF303E8F),
                      child: Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Handle onTap action here
                              },
                              child: const Text(
                                "WEEK",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Color(0xFFB6CBFF),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${profile.maternity_week}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 24,
                                color: Color(0xFFEDF2FF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4.0),
              SizedBox(
                width: double.infinity, // Adjust padding as needed
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20.0), // Adjust the radius
                  ),
                  elevation: 0, // Set the elevation for the card
                  color: const Color(0xFF303E8F),
                  child: Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Handle onTap action here
                          },
                          child: const Text(
                            "EST. DUE DATE",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color(0xFFB6CBFF),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          formattedDate,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: Color(0xFFEDF2FF),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 42.0),
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
                        'Resources',
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
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: SizedBox(
                  height: 80.0,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FirstTrimester(
                            user: user,
                            profile: profile,
                            autoImplyLeading: true,
                          ),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFC1D3FF), // Set the fill color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            50.0), // Adjust the value as needed
                      ),
                      side: const BorderSide(
                        color: Color(0xFF6086f6), // Set the outline color
                        width: 2.5, // Set the outline width
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.all(12.0), // Adjust padding as needed
                          child: Icon(
                            Icons.looks_one, // Use any icon you want
                            color: Color(0xFF1F3299),
                            size: 28,
                          ),
                        ),
                        Spacer(), // Adjust the spacing between icon and text
                        Text(
                          'First Trimester',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1F3299),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding:
                              EdgeInsets.all(12.0), // Adjust padding as needed
                          child: Icon(
                            Icons.looks_one, // Use any icon you want
                            color: Color(0xFF1F3299),
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: SizedBox(
                  height: 80.0,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SecondTrimester(
                            user: user,
                            profile: profile,
                            autoImplyLeading: true,
                          ),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFC1D3FF), // Set the fill color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            50.0), // Adjust the value as needed
                      ),
                      side: const BorderSide(
                        color: Color(0xFF6086f6), // Set the outline color
                        width: 2.5, // Set the outline width
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.all(12.0), // Adjust padding as needed
                          child: Icon(
                            Icons.looks_two, // Use any icon you want
                            color: Color(0xFF1F3299),
                            size: 28,
                          ),
                        ),
                        Spacer(), // Adjust the spacing between icon and text
                        Text(
                          'Second Trimester',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1F3299),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding:
                              EdgeInsets.all(12.0), // Adjust padding as needed
                          child: Icon(
                            Icons.looks_two, // Use any icon you want
                            color: Color(0xFF1F3299),
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: SizedBox(
                  height: 80.0,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ThirdTrimester(
                            user: user,
                            profile: profile,
                            autoImplyLeading: true,
                          ),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFC1D3FF), // Set the fill color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            50.0), // Adjust the value as needed
                      ),
                      side: const BorderSide(
                        color: Color(0xFF6086f6), // Set the outline color
                        width: 2.5, // Set the outline width
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.all(12.0), // Adjust padding as needed
                          child: Icon(
                            Icons.looks_3, // Use any icon you want
                            color: Color(0xFF1F3299),
                            size: 28,
                          ),
                        ),
                        Spacer(), // Adjust the spacing between icon and text
                        Text(
                          'Third Trimester',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1F3299),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding:
                              EdgeInsets.all(12.0), // Adjust padding as needed
                          child: Icon(
                            Icons.looks_3, // Use any icon you want
                            color: Color(0xFF1F3299),
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
