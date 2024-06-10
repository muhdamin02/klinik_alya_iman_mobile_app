// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';

import '../../models/profile.dart';
import '../../models/user.dart';
import '../../services/database_service.dart';
import '../../services/misc_methods/datetime_display.dart';
import '../../services/misc_methods/get_first_two_words.dart';
import '../../services/misc_methods/notification_singleton.dart';
import '../../services/notification_service.dart';
import '../appointment_management/list_appointment.dart';
import '../health_profile/health_profile_page.dart';
import '../health_reporting/health_reporting.dart';
import '../maternity_pages/maternity_overview.dart';
import '../medication_management/list_medication.dart';
import '../startup/login.dart';
import '../startup/patient_homepage.dart';
import 'list_profile.dart';

class ProfilePage extends StatefulWidget {
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
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Profile> _patientInfo = [];

  bool viewMore = false;
  bool viewLess = true;

  @override
  void initState() {
    super.initState();
    _fetchPatientInfo();
  }

  Future<void> _fetchPatientInfo() async {
    List<Profile> patientInfo =
        await DatabaseService().profileInfo(widget.profile.profile_id);
    setState(() {
      _patientInfo = patientInfo;
    });
  }

  void _editOccupation(Profile profile) async {
    if (widget.user.role.toLowerCase() == 'patient') {
      TextEditingController occupationController = TextEditingController();
      final int? profileId = profile.profile_id;
      String newOccupation;
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color(0xFF303E8F),
            title: const Text('Update Occupation'),
            content: Builder(
              builder: (BuildContext context) {
                return Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: occupationController,
                        decoration: const InputDecoration(
                          hintText: 'Enter occupation...',
                          hintStyle: TextStyle(color: Color(0xFFB6CBFF)),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(
                                    0xFFB6CBFF)), // Set the color of the underline
                          ),
                        ),
                        style: const TextStyle(fontSize: 15),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter occupation.';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    newOccupation = occupationController.text;
                    await DatabaseService()
                        .editOccupation(profileId!, newOccupation);
                    Navigator.pop(context); // Close the dialog
                    setState(() {
                      _fetchPatientInfo();
                    });
                  }
                },
                child: const Text('Confirm',
                    style: TextStyle(color: Color(0xFFEDF2FF))),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Cancel',
                    style: TextStyle(color: Color(0xFFEDF2FF))),
              ),
            ],
          );
        },
        barrierDismissible: false,
      );
    }
  }

  void _editMaritalStatus(Profile profile) async {
    if (widget.user.role.toLowerCase() == 'patient') {
      TextEditingController statusController = TextEditingController();
      final int? profileId = profile.profile_id;
      String newStatus;
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color(0xFF303E8F),
            title: const Text('Update Marital Status'),
            content: Builder(
              builder: (BuildContext context) {
                return Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: statusController,
                        decoration: const InputDecoration(
                          hintText: 'Enter marital status...',
                          hintStyle: TextStyle(color: Color(0xFFB6CBFF)),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(
                                    0xFFB6CBFF)), // Set the color of the underline
                          ),
                        ),
                        style: const TextStyle(fontSize: 15),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter marital status.';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    newStatus = statusController.text;
                    await DatabaseService()
                        .editMaritalStatus(profileId!, newStatus);
                    Navigator.pop(context); // Close the dialog
                    setState(() {
                      _fetchPatientInfo();
                    });
                  }
                },
                child: const Text('Confirm',
                    style: TextStyle(color: Color(0xFFEDF2FF))),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Cancel',
                    style: TextStyle(color: Color(0xFFEDF2FF))),
              ),
            ],
          );
        },
        barrierDismissible: false,
      );
    }
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
          title: Text(getFirstTwoWords(widget.profile.name)),
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Color(0xFFEDF2FF),
          ),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.group),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListProfile(
                      user: widget.user,
                    ),
                  ),
                );
              },
            ),
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
                            user: widget.user,
                            profile: widget.profile,
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
                            user: widget.user,
                            profile: widget.profile,
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
                            user: widget.user,
                            profile: widget.profile,
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
        body: ListView.builder(
          shrinkWrap: true,
          itemCount: _patientInfo.length,
          itemBuilder: (context, index) {
            Profile patient = _patientInfo[index];
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
                                  color: Color(0xFFEDF2FF), letterSpacing: 2
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
                      SizedBox(
                        width: double.infinity, // Adjust padding as needed
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
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
                                  const Row(
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
                                  const SizedBox(height: 8),
                                  Text(
                                    patient.name,
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
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity, // Adjust padding as needed
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
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
                                  const Row(
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
                                  const SizedBox(height: 8),
                                  Text(
                                    patient.identification,
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
                      Visibility(
                        visible: viewLess,
                        child: const SizedBox(height: 8.0),
                      ),
                      AnimatedOpacity(
                        opacity: viewLess ? 1.0 : 0.0,
                        duration: const Duration(
                            milliseconds: 300), // Adjust the duration as needed
                        curve: Curves.easeInOut, // Adjust the curve as needed
                        child: Visibility(
                          visible: viewLess,
                          child: SizedBox(
                            width: double.infinity, // Adjust padding as needed
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    viewLess = !viewLess;
                                    viewMore = true;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  backgroundColor: const Color(0xFF222E75),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 16.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: Color(
                                            0xFFB6CBFF), // Set the color of the icon
                                        size:
                                            20, // Adjust the size of the icon as needed
                                      ),
                                      Spacer(),
                                      Text(
                                        "view more",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Color(0xFFB6CBFF),
                                        ),
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: Color(
                                            0xFFB6CBFF), // Set the color of the icon
                                        size:
                                            20, // Adjust the size of the icon as needed
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: AnimatedOpacity(
                              opacity: viewMore ? 1.0 : 0.0,
                              duration: const Duration(
                                  milliseconds:
                                      200), // Adjust the duration as needed
                              curve: Curves
                                  .easeInOut, // Adjust the curve as needed
                              child: Visibility(
                                visible: viewMore,
                                child: SizedBox(
                                  width: double
                                      .infinity, // Adjust padding as needed
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 4.0, left: 5.0),
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        backgroundColor:
                                            const Color(0xFF303E8F),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 28.0, horizontal: 12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Row(
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
                                            const SizedBox(height: 8),
                                            Text(
                                              DateTimeDisplay(
                                                      datetime: patient.dob)
                                                  .getStringDate(),
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
                            ),
                          ),
                          Expanded(
                            child: AnimatedOpacity(
                              opacity: viewMore ? 1.0 : 0.0,
                              duration: const Duration(
                                  milliseconds:
                                      400), // Adjust the duration as needed
                              curve: Curves
                                  .easeInOut, // Adjust the curve as needed
                              child: Visibility(
                                visible: viewMore,
                                child: SizedBox(
                                  width: double
                                      .infinity, // Adjust padding as needed
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 5.0, left: 4.0),
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        backgroundColor:
                                            const Color(0xFF303E8F),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 28.0, horizontal: 12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Row(
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
                                            const SizedBox(height: 8),
                                            Text(
                                              '${patient.gender}',
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
                            ),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: viewMore,
                        child: const SizedBox(height: 8),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: AnimatedOpacity(
                              opacity: viewMore ? 1.0 : 0.0,
                              duration: const Duration(
                                  milliseconds:
                                      500), // Adjust the duration as needed
                              curve: Curves
                                  .easeInOut, // Adjust the curve as needed
                              child: Visibility(
                                visible: viewMore,
                                child: SizedBox(
                                  width: double
                                      .infinity, // Adjust padding as needed
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 4.0, left: 5.0),
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        backgroundColor:
                                            const Color(0xFF303E8F),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 28.0, horizontal: 12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Row(
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
                                            const SizedBox(height: 8),
                                            Text(
                                              '${patient.ethnicity}',
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
                            ),
                          ),
                          Expanded(
                            child: AnimatedOpacity(
                              opacity: viewMore ? 1.0 : 0.0,
                              duration: const Duration(
                                  milliseconds:
                                      600), // Adjust the duration as needed
                              curve: Curves
                                  .easeInOut, // Adjust the curve as needed
                              child: Visibility(
                                visible: viewMore,
                                child: SizedBox(
                                  width: double
                                      .infinity, // Adjust padding as needed
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 5.0, left: 4.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _editMaritalStatus(patient);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        backgroundColor:
                                            const Color(0xFF303E8F),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 28.0, horizontal: 12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Row(
                                              children: [
                                                Text(
                                                  "STATUS",
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
                                            const SizedBox(height: 8),
                                            Text(
                                              '${patient.marital_status}',
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
                            ),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: viewMore,
                        child: const SizedBox(height: 8),
                      ),
                      AnimatedOpacity(
                        opacity: viewMore ? 1.0 : 0.0,
                        duration: const Duration(
                            milliseconds: 700), // Adjust the duration as needed
                        curve: Curves.easeInOut, // Adjust the curve as needed
                        child: Visibility(
                          visible: viewMore,
                          child: SizedBox(
                            width: double.infinity, // Adjust padding as needed
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  _editOccupation(patient);
                                },
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Row(
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
                                                  4), // Add some spacing between text and icon
                                          Icon(
                                            Icons.edit,
                                            color: Color(
                                                0xFFFFD271), // Set the color of the icon
                                            size:
                                                16, // Adjust the size of the icon as needed
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        patient.occupation,
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
                      ),
                      Visibility(
                        visible: viewMore,
                        child: const SizedBox(height: 16),
                      ),
                      AnimatedOpacity(
                        opacity: viewMore ? 1.0 : 0.0,
                        duration: const Duration(
                            milliseconds: 800), // Adjust the duration as needed
                        curve: Curves.easeInOut, // Adjust the curve as needed
                        child: Visibility(
                          visible: viewMore,
                          child: SizedBox(
                            width: double.infinity, // Adjust padding as needed
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    viewMore = !viewMore;
                                    viewLess = true;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  backgroundColor: const Color(0xFF222E75),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 16.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.keyboard_arrow_up_rounded,
                                        color: Color(
                                            0xFFB6CBFF), // Set the color of the icon
                                        size:
                                            20, // Adjust the size of the icon as needed
                                      ),
                                      Spacer(),
                                      Text(
                                        "view less",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Color(0xFFB6CBFF),
                                        ),
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.keyboard_arrow_up_rounded,
                                        color: Color(
                                            0xFFB6CBFF), // Set the color of the icon
                                        size:
                                            20, // Adjust the size of the icon as needed
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // =============== FEATURES ============== //
                      const SizedBox(height: 36.0),
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
                                'Features',
                                style: TextStyle(
                                  color: Color(0xFFEDF2FF), letterSpacing: 2
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
                                  builder: (context) => HealthProfilePage(
                                    user: widget.user,
                                    profile: widget.profile,
                                    autoImplyLeading: true,
                                    initialTabOthers: false,
                                  ),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFFDBE5FF), // Set the fill color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    50.0), // Adjust the value as needed
                              ),
                              side: const BorderSide(
                                color:
                                    Color(0xFF6086f6), // Set the outline color
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
                                    Icons
                                        .health_and_safety_outlined, // Use any icon you want
                                    color: Color(0xFF1F3299),
                                    size: 28,
                                  ),
                                ),
                                Spacer(), // Adjust the spacing between icon and text
                                Text(
                                  'Health',
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
                                    Icons
                                        .health_and_safety_outlined, // Use any icon you want
                                    color: Color(0xFF1F3299),
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (widget.profile.maternity != 'No')
                        const SizedBox(height: 10),
                      Visibility(
                        visible: widget.profile.maternity != 'No',
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: SizedBox(
                            height: 80.0,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MaternityOverview(
                                      user: widget.user,
                                      profile: widget.profile,
                                      autoImplyLeading: true,
                                    ),
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: const Color(
                                    0xFFCBD9FF), // Set the fill color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      50.0), // Adjust the value as needed
                                ),
                                side: const BorderSide(
                                  color: Color(
                                      0xFF5479E6), // Set the outline color
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
                                      Icons
                                          .pregnant_woman, // Use any icon you want
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
                                      Icons
                                          .pregnant_woman, // Use any icon you want
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HealthReportingPage(
                                    user: widget.user,
                                    profile: widget.profile,
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
                                color: Color.fromARGB(
                                    255, 76, 112, 219), // Set the outline color
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
                                    Icons.timeline, // Use any icon you want
                                    color: Color(0xFF182985),
                                    size: 28,
                                  ),
                                ),
                                Spacer(), // Adjust the spacing between icon and text
                                Text(
                                  'Reporting',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF182985),
                                  ),
                                ),
                                Spacer(),
                                Padding(
                                  padding: EdgeInsets.all(
                                      12.0), // Adjust padding as needed
                                  child: Icon(
                                    Icons.timeline, // Use any icon you want
                                    color: Color(0xFF182985),
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ]),
              ),
            );
          },
        ),
      ),
    );
  }
}