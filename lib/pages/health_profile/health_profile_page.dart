// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:klinik_alya_iman_mobile_app/pages/medical_history/list_medical_history.dart';

import '../../models/health_profile.dart';
import '../../models/profile.dart';
import '../../models/user.dart';
import '../../services/database_service.dart';
import '../../services/misc_methods/notification_singleton.dart';
import '../../services/notification_service.dart';
import '../appointment_management/list_appointment.dart';
import '../health_reporting/health_reporting.dart';
import '../maternity_pages/maternity_overview.dart';
import '../medication_management/list_medication.dart';
import '../profile_management/profile_page.dart';
import '../startup/login.dart';
import '../startup/patient_homepage.dart';

class HealthProfilePage extends StatefulWidget {
  final User user;
  final Profile profile;
  final bool autoImplyLeading;
  final bool initialTabOthers;

  const HealthProfilePage(
      {Key? key,
      required this.user,
      required this.profile,
      required this.autoImplyLeading,
      required this.initialTabOthers})
      : super(key: key);

  @override
  _HealthProfilePageState createState() => _HealthProfilePageState();
}

class _HealthProfilePageState extends State<HealthProfilePage> {
  List<HealthProfile> _healthInfo = [];
  bool viewMore = false;
  bool viewLess = true;
  int initialTab = 0;

  @override
  void initState() {
    super.initState();
    _fetchHealthInfo();
    if (widget.initialTabOthers) {
      initialTab = 2;
    }
  }

  // ----------------------------------------------------------------------
  // Fetch details

  Future<void> _fetchHealthInfo() async {
    List<HealthProfile> healthInfo =
        await DatabaseService().healthInfo(widget.profile.profile_id);
    setState(() {
      _healthInfo = healthInfo;
      if (_healthInfo.isNotEmpty) {}
    });
  }

  void _onHealthDiary(User user, Profile profile) {
    // Navigate to the view appointment details page with the selected appointment
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListMedicalHistory(
            user: user, profile: profile, autoImplyLeading: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String cleanedDate = widget.profile.dob.replaceAll(" at", "");
    DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(cleanedDate);
    String formattedDate = DateFormat('dd MMM yyyy').format(parsedDate);

    return WillPopScope(
      onWillPop: () async {
        // Return false to prevent the user from navigating back
        return widget.autoImplyLeading;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_getFirstTwoWords(widget.profile.name)),
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
                    icon: const Icon(Icons.health_and_safety_outlined),
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
        body: Stack(
          children: [
            TabBarHealthProfile(
              user: widget.user,
              profile: widget.profile,
              healthInfo: _healthInfo,
              onHealthDiary: _onHealthDiary,
              initialTabIndex: initialTab,
            ),
          ],
        ),
      ),
    );
  }
}

class TabBarHealthProfile extends StatelessWidget {
  final User user;
  final Profile profile;
  final List<HealthProfile> healthInfo;
  final Function(User, Profile) onHealthDiary;
  final int initialTabIndex;

  const TabBarHealthProfile({
    Key? key,
    required this.user,
    required this.profile,
    required this.healthInfo,
    required this.onHealthDiary,
    required this.initialTabIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: initialTabIndex,
      length: 3,
      child: Scaffold(
        body: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF0A0F2C),
              ),
              child: const TabBar(
                labelStyle: TextStyle(
                  // Set your desired text style for the selected (active) tab here
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  fontFamily: 'ProductSans',
                  // You can set other text style properties as needed
                ),
                unselectedLabelStyle: TextStyle(
                  // Set your desired text style for the unselected tabs here
                  fontSize: 16,
                  fontFamily: 'ProductSans',
                  // You can set other text style properties as needed
                ),
                indicatorColor: Color(0xFFB6CBFF),
                indicatorWeight: 6,
                tabs: <Widget>[
                  Tab(
                    text: 'General',
                  ),
                  Tab(
                    text: 'Medical',
                  ),
                  Tab(
                    text: 'Others',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  _buildGeneral(profile),
                  _buildMedical(profile, healthInfo),
                  _buildOthers(user, profile),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneral(Profile profile) {
    double bmi = 0;
    String activity_level = 'Not specified';

    if (profile.weight > 0 && profile.height > 0) {
      bmi = profile.weight / (profile.height / 100);
    }

    if (profile.activity_level != '') {
      activity_level = profile.activity_level;
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  width: double.infinity, // Adjust padding as needed
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                            0xFF303E8F), // Background color of the ElevatedButton
                        elevation: 0, // Set the elevation for the button
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20.0), // Adjust the radius
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Handle onTap action here
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "HEIGHT",
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
                                    Icons.expand,
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
                              '${profile.height}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xFFEDF2FF),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: SizedBox(
                  width: double.infinity, // Adjust padding as needed
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                            0xFF303E8F), // Background color of the ElevatedButton
                        elevation: 0, // Set the elevation for the button
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20.0), // Adjust the radius
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Handle onTap action here
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "WEIGHT",
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
                                    Icons.scale,
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
                              '${profile.weight}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xFFEDF2FF),
                              ),
                              textAlign: TextAlign.center,
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
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  width: double.infinity, // Adjust padding as needed
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                            0xFF303E8F), // Background color of the ElevatedButton
                        elevation: 0, // Set the elevation for the button
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20.0), // Adjust the radius
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Handle onTap action here
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "BFP",
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
                                    Icons.accessibility_new,
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
                              '${profile.body_fat_percentage}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xFFEDF2FF),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: SizedBox(
                  width: double.infinity, // Adjust padding as needed
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                            0xFF303E8F), // Background color of the ElevatedButton
                        elevation: 0, // Set the elevation for the button
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20.0), // Adjust the radius
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Handle onTap action here
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "BMI",
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
                                    Icons.monitor_weight,
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
                              '$bmi',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xFFEDF2FF),
                              ),
                              textAlign: TextAlign.center,
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
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity, // Adjust padding as needed
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                      0xFF303E8F), // Background color of the ElevatedButton
                  elevation: 0, // Set the elevation for the button
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20.0), // Adjust the radius
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Handle onTap action here
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "ACTIVITY LEVEL",
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
                              Icons.fitness_center,
                              color: Color(
                                  0xFFB6CBFF), // Set the color of the icon
                              size: 16, // Adjust the size of the icon as needed
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        activity_level,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Color(0xFFEDF2FF),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 36),
          const SizedBox(height: 10),
        ]),
      ),
    );
  }

  Widget _buildMedical(Profile profile, List<HealthProfile> healthInfo) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      shrinkWrap: true,
      itemCount: healthInfo.length,
      itemBuilder: (context, index) {
        HealthProfile health = healthInfo[index];
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: double.infinity, // Adjust padding as needed
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                                0xFF303E8F), // Background color of the ElevatedButton
                            elevation: 0, // Set the elevation for the button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20.0), // Adjust the radius
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Handle onTap action here
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "BSL",
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
                                        Icons.bloodtype,
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
                                  '${health.blood_sugar_level}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Color(0xFFEDF2FF),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: SizedBox(
                      width: double.infinity, // Adjust padding as needed
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                                0xFF303E8F), // Background color of the ElevatedButton
                            elevation: 0, // Set the elevation for the button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20.0), // Adjust the radius
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Handle onTap action here
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "BP",
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
                                        Icons.favorite,
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
                                  health.blood_pressure,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Color(0xFFEDF2FF),
                                  ),
                                  textAlign: TextAlign.center,
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
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity, // Adjust padding as needed
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                          0xFF303E8F), // Background color of the ElevatedButton
                      elevation: 0, // Set the elevation for the button
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20.0), // Adjust the radius
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Handle onTap action here
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "ALLERGIES",
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
                                  Icons.warning_rounded,
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
                            health.allergies,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color(0xFFEDF2FF),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity, // Adjust padding as needed
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                          0xFF303E8F), // Background color of the ElevatedButton
                      elevation: 0, // Set the elevation for the button
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20.0), // Adjust the radius
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Handle onTap action here
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "MEDICAL CONDITION",
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
                                  Icons.health_and_safety,
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
                            health.current_condition,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color(0xFFEDF2FF),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 36),
              const SizedBox(height: 10),
            ]),
          ),
        );
      },
    );
  }

  Widget _buildOthers(User user, Profile profile) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 8.0),
          SizedBox(
            width: double.infinity, // Adjust padding as needed
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ElevatedButton(
                onPressed: () {
                  onHealthDiary(user, profile);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                      0xFF303E8F), // Background color of the ElevatedButton
                  elevation: 0, // Set the elevation for the button
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20.0), // Adjust the radius
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(28.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Health Diary',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Color(0xFFEDF2FF),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity, // Adjust padding as needed
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                      0xFF303E8F), // Background color of the ElevatedButton
                  elevation: 0, // Set the elevation for the button
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20.0), // Adjust the radius
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(28.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Surgeries and Procedures',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Color(0xFFEDF2FF),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity, // Adjust padding as needed
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                      0xFF303E8F), // Background color of the ElevatedButton
                  elevation: 0, // Set the elevation for the button
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20.0), // Adjust the radius
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(28.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Family Medical History',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Color(0xFFEDF2FF),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity, // Adjust padding as needed
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                      0xFF303E8F), // Background color of the ElevatedButton
                  elevation: 0, // Set the elevation for the button
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20.0), // Adjust the radius
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(28.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Immunization Records',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Color(0xFFEDF2FF),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity, // Adjust padding as needed
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                      0xFF303E8F), // Background color of the ElevatedButton
                  elevation: 0, // Set the elevation for the button
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20.0), // Adjust the radius
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(28.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Dietary Restrictions',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Color(0xFFEDF2FF),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 36),
          const SizedBox(height: 10),
        ]),
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

// body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child:
//                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               const SizedBox(height: 8.0),
//               Row(
//                 children: [
//                   Expanded(
//                     child: SizedBox(
//                       width: double.infinity, // Adjust padding as needed
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                         child: ElevatedButton(
//                           onPressed: () {},
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(
//                                 0xFF303E8F), // Background color of the ElevatedButton
//                             elevation: 0, // Set the elevation for the button
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(
//                                   20.0), // Adjust the radius
//                             ),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(28.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 GestureDetector(
//                                   onTap: () {
//                                     // Handle onTap action here
//                                   },
//                                   child: const Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         "HEIGHT",
//                                         style: TextStyle(
//                                           fontWeight: FontWeight.w500,
//                                           fontSize: 16,
//                                           color: Color(0xFFB6CBFF),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                           width:
//                                               8), // Add some spacing between text and icon
//                                       Icon(
//                                         Icons.expand,
//                                         color: Color(
//                                             0xFFB6CBFF), // Set the color of the icon
//                                         size:
//                                             16, // Adjust the size of the icon as needed
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   '200 cm',
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: 16,
//                                     color: Color(0xFFEDF2FF),
//                                   ),
//                                   textAlign: TextAlign.center,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 4),
//                   Expanded(
//                     child: SizedBox(
//                       width: double.infinity, // Adjust padding as needed
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                         child: ElevatedButton(
//                           onPressed: () {},
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(
//                                 0xFF303E8F), // Background color of the ElevatedButton
//                             elevation: 0, // Set the elevation for the button
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(
//                                   20.0), // Adjust the radius
//                             ),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(28.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 GestureDetector(
//                                   onTap: () {
//                                     // Handle onTap action here
//                                   },
//                                   child: const Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         "WEIGHT",
//                                         style: TextStyle(
//                                           fontWeight: FontWeight.w500,
//                                           fontSize: 16,
//                                           color: Color(0xFFB6CBFF),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                           width:
//                                               8), // Add some spacing between text and icon
//                                       Icon(
//                                         Icons.scale,
//                                         color: Color(
//                                             0xFFB6CBFF), // Set the color of the icon
//                                         size:
//                                             16, // Adjust the size of the icon as needed
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   '100 kg',
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: 16,
//                                     color: Color(0xFFEDF2FF),
//                                   ),
//                                   textAlign: TextAlign.center,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   Expanded(
//                     child: SizedBox(
//                       width: double.infinity, // Adjust padding as needed
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                         child: ElevatedButton(
//                           onPressed: () {},
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(
//                                 0xFF303E8F), // Background color of the ElevatedButton
//                             elevation: 0, // Set the elevation for the button
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(
//                                   20.0), // Adjust the radius
//                             ),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(28.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 GestureDetector(
//                                   onTap: () {
//                                     // Handle onTap action here
//                                   },
//                                   child: const Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         "BFP",
//                                         style: TextStyle(
//                                           fontWeight: FontWeight.w500,
//                                           fontSize: 16,
//                                           color: Color(0xFFB6CBFF),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                           width:
//                                               8), // Add some spacing between text and icon
//                                       Icon(
//                                         Icons.accessibility_new,
//                                         color: Color(
//                                             0xFFB6CBFF), // Set the color of the icon
//                                         size:
//                                             16, // Adjust the size of the icon as needed
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   '200 cm',
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: 16,
//                                     color: Color(0xFFEDF2FF),
//                                   ),
//                                   textAlign: TextAlign.center,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 4),
//                   Expanded(
//                     child: SizedBox(
//                       width: double.infinity, // Adjust padding as needed
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                         child: ElevatedButton(
//                           onPressed: () {},
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(
//                                 0xFF303E8F), // Background color of the ElevatedButton
//                             elevation: 0, // Set the elevation for the button
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(
//                                   20.0), // Adjust the radius
//                             ),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(28.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 GestureDetector(
//                                   onTap: () {
//                                     // Handle onTap action here
//                                   },
//                                   child: const Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         "BMI",
//                                         style: TextStyle(
//                                           fontWeight: FontWeight.w500,
//                                           fontSize: 16,
//                                           color: Color(0xFFB6CBFF),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                           width:
//                                               8), // Add some spacing between text and icon
//                                       Icon(
//                                         Icons.monitor_weight,
//                                         color: Color(
//                                             0xFFB6CBFF), // Set the color of the icon
//                                         size:
//                                             16, // Adjust the size of the icon as needed
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   '100 kg',
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: 16,
//                                     color: Color(0xFFEDF2FF),
//                                   ),
//                                   textAlign: TextAlign.center,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               SizedBox(
//                 width: double.infinity, // Adjust padding as needed
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                   child: ElevatedButton(
//                     onPressed: () {},
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(
//                           0xFF303E8F), // Background color of the ElevatedButton
//                       elevation: 0, // Set the elevation for the button
//                       shape: RoundedRectangleBorder(
//                         borderRadius:
//                             BorderRadius.circular(20.0), // Adjust the radius
//                       ),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(28.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           GestureDetector(
//                             onTap: () {
//                               // Handle onTap action here
//                             },
//                             child: const Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   "ACTIVITY LEVEL",
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: 16,
//                                     color: Color(0xFFB6CBFF),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                     width:
//                                         8), // Add some spacing between text and icon
//                                 Icon(
//                                   Icons.fitness_center,
//                                   color: Color(
//                                       0xFFB6CBFF), // Set the color of the icon
//                                   size:
//                                       16, // Adjust the size of the icon as needed
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             'a',
//                             style: const TextStyle(
//                               fontWeight: FontWeight.w500,
//                               fontSize: 16,
//                               color: Color(0xFFEDF2FF),
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 36),
//               const SizedBox(height: 10),
//             ]),
//           ),
//         ),