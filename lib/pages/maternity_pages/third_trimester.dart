import 'package:flutter/material.dart';

import '../../models/profile.dart';
import '../../models/user.dart';
import '../appointment_management/list_appointment.dart';
import '../medication_management/list_medication.dart';
import '../profile_management/profile_page.dart';
import '../startup/patient_homepage.dart';
import 'maternity_overview.dart';
import 'third_trimester/contractions_list.dart';
import 'third_trimester/newborn_care_dashboard.dart';

class ThirdTrimester extends StatefulWidget {
  final User user;
  final Profile profile;
  final bool autoImplyLeading;

  const ThirdTrimester({
    Key? key,
    required this.user,
    required this.profile,
    required this.autoImplyLeading,
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
          automaticallyImplyLeading: false,
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
                    icon: const Icon(Icons.pregnant_woman),
                    iconSize: 23,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MaternityOverview(
                            user: widget.user,
                            profile: widget.profile,
                            autoImplyLeading: false,
                          ),
                        ),
                      );
                    },
                    color: const Color(0xFFFFD271), // Set the color of the icon
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 24.0, vertical: 16.0), // Add your desired padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(
                  color: Color(0xFFB6CBFF),
                ),
                const SizedBox(height: 8.0),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trimester 3',
                      style: TextStyle(
                          fontSize: 28.0,
                          color: Color(0xFFFFD271),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.3),
                    ),
                    Spacer(),
                    Text(
                      'Week 27-?',
                      style:
                          TextStyle(fontSize: 28.0, color: Color(0xFFB6CBFF)),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                const Divider(
                  color: Color(0xFFB6CBFF),
                ),
                const SizedBox(height: 24),
                const Text(
                  'What to expect?',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5),
                ),
                const SizedBox(height: 16),
                const Text(
                  'The third trimester is the final stretch before your baby arrives. It\'s a time of significant growth and preparation, both physically and emotionally. As you approach your due date, you\'ll focus more on birth plans and postpartum readiness.',
                  style: TextStyle(
                      fontSize: 18.0, height: 2, color: Color(0xFFC5D6FF)),
                ),
                const SizedBox(height: 48),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 0),
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
                          'Explore',
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
                const SizedBox(height: 24),
                SizedBox(
                  height: 70.0,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
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
                    style: OutlinedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFDBE5FF), // Set the fill color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            25.0), // Adjust the value as needed
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
                          padding: EdgeInsets.all(12.0),
                          child: Icon(
                            Icons.assignment_outlined,
                            color: Color(0xFF1F3299),
                            size: 28,
                          ),
                        ),
                        Spacer(), // Adjust the spacing between icon and text
                        Text(
                          'Newborn Care',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F3299),
                            letterSpacing: 1.2,
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Icon(
                            Icons.assignment_outlined,
                            color: Color(0xFF1F3299),
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 70.0,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
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
                    style: OutlinedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFC4D6FF), // Set the fill color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            25.0), // Adjust the value as needed
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
                          padding: EdgeInsets.all(12.0),
                          child: Icon(
                            Icons.track_changes,
                            color: Color(0xFF1F3299),
                            size: 28,
                          ),
                        ),
                        Spacer(), // Adjust the spacing between icon and text
                        Text(
                          'Track Contractions',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F3299),
                            letterSpacing: 1.2,
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Icon(
                            Icons.track_changes,
                            color: Color(0xFF1F3299),
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
