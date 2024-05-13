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
import '../startup/login.dart';
import '../startup/patient_homepage.dart';
import 'list_profile.dart';

class ProfilePage extends StatelessWidget {
  final User user;
  final Profile profile;
  final bool autoImplyLeading;

  const ProfilePage(
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
          title: const Text('Profile Page'),
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Color(0xFFEDF2FF),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.group),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListProfile(
                      user: user,
                    ),
                  ),
                );
              },
            ),
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
                        usernamePlaceholder: user.username,
                        passwordPlaceholder: user.password),
                  ),
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
                    iconSize: 30,
                    onPressed: () {},
                    color: const Color(0xFF5464BB), // Set the color of the icon
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
        drawer: AppDrawerAllPages(
          header: 'Profile Page',
          user: user,
          profile: profile,
          autoImplyLeading: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                          profile.name,
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
                                "IC/PASSPORT",
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
                          profile.identification,
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
              const SizedBox(height: 8),
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
                          builder: (context) => ListMedicalHistory(
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
                            Icons.assignment, // Use any icon you want
                            color: Color(0xFF1F3299),
                            size: 28,
                          ),
                        ),
                        Spacer(), // Adjust the spacing between icon and text
                        Text(
                          'Health Profile',
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
                            Icons.assignment, // Use any icon you want
                            color: Color(0xFF1F3299),
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (profile.maternity != 'No') const SizedBox(height: 10),
              Visibility(
                visible: profile.maternity != 'No',
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: SizedBox(
                    height: 80.0,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (profile.maternity == 'First Trimester') {
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
                        }
                        if (profile.maternity == 'Second Trimester') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SecondTrimester(
                                user: user,
                                profile: profile,
                              ),
                            ),
                          );
                        }
                        if (profile.maternity == 'Third Trimester') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ThirdTrimester(
                                user: user,
                                profile: profile,
                              ),
                            ),
                          );
                        }
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
                            padding: EdgeInsets.all(
                                12.0), // Adjust padding as needed
                            child: Icon(
                              Icons.pregnant_woman, // Use any icon you want
                              color: Color(0xFF1F3299),
                              size: 28,
                            ),
                          ),
                          Spacer(), // Adjust the spacing between icon and text
                          Text(
                            'Maternity',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1F3299),
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.all(
                                12.0), // Adjust padding as needed
                            child: Icon(
                              Icons.pregnant_woman, // Use any icon you want
                              color: Color(0xFF1F3299),
                              size: 28,
                            ),
                          ),
                        ],
                      ),
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
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => ListMedicalHistory(
                      //       user: user,
                      //       profile: profile,
                      //       autoImplyLeading: true,
                      //     ),
                      //   ),
                      // );
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
                            Icons.timeline, // Use any icon you want
                            color: Color(0xFF1F3299),
                            size: 28,
                          ),
                        ),
                        Spacer(), // Adjust the spacing between icon and text
                        Text(
                          'Reporting',
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
                            Icons.timeline, // Use any icon you want
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
                                "DATE OF BIRTH",
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
                          formattedDate,
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
                          '${profile.gender}',
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
                                "ETHNICITY",
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
                          '${profile.ethnicity}',
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
                                "MARITAL STATUS",
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
                          '${profile.marital_status}',
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
                                "OCCUPATION",
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
                          profile.occupation,
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
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 90.0,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListAppointment(
                                user: user,
                                profile: profile,
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
                              Icons.event, // Use any icon you want
                              color: Color.fromARGB(255, 37, 101, 184),
                              size: 32,
                            ),
                            SizedBox(
                                height:
                                    8), // Adjust the spacing between icon and text
                            Text(
                              'Appointment',
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
                  const SizedBox(width: 8),
                  Expanded(
                    child: SizedBox(
                      height: 90.0,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to the page where you want to medication form
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListMedication(
                                user: user,
                                profile: profile,
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
                              Icons.medication, // Use any icon you want
                              color: Color.fromARGB(255, 37, 101, 184),
                              size: 32,
                            ),
                            SizedBox(
                                height:
                                    8), // Adjust the spacing between icon and text
                            Text(
                              'Medication',
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
                  const SizedBox(width: 8),
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
                              builder: (context) => ListMedicalHistory(
                                user: user,
                                profile: profile,
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
                              'Personal Info',
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
              const SizedBox(height: 8),
              Visibility(
                visible: profile.maternity != 'No',
                child: SizedBox(
                  height: 90.0,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (profile.maternity == 'First Trimester') {
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
                      }
                      if (profile.maternity == 'Second Trimester') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SecondTrimester(
                              user: user,
                              profile: profile,
                            ),
                          ),
                        );
                      }
                      if (profile.maternity == 'Third Trimester') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ThirdTrimester(
                              user: user,
                              profile: profile,
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 233, 243, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.pregnant_woman,
                          color: Color.fromARGB(255, 37, 101, 184),
                          size: 32,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Maternity',
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
            ]),
          ),
        ),
      ),
    );
  }
}
