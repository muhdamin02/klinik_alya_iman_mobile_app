import 'package:flutter/material.dart';

import '../../../models/profile.dart';
import '../../../models/user.dart';
import '../../appointment_management/list_appointment.dart';
import '../../medication_management/list_medication.dart';
import '../../profile_management/profile_page.dart';
import '../../startup/patient_homepage.dart';
import '../first_trimester.dart';

class EducationalResources extends StatefulWidget {
  final User user;
  final Profile profile;
  final bool autoImplyLeading;

  const EducationalResources({
    Key? key,
    required this.user,
    required this.profile,
    required this.autoImplyLeading,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EducationalResourcesState createState() => _EducationalResourcesState();
}

class _EducationalResourcesState extends State<EducationalResources> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return false to prevent the user from navigating back
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Educational Resources'),
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
                    icon: const Icon(Icons.looks_one),
                    iconSize: 25,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FirstTrimester(
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
            padding: const EdgeInsets.all(16.0), // Add your desired padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Newborn Care Resources',
                  style: TextStyle(fontSize: 18.0),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 120.0,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
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
                                Icons.info, // Use any icon you want
                                color: Color.fromARGB(255, 37, 101, 184),
                                size: 32,
                              ),
                              SizedBox(
                                  height:
                                      8), // Adjust the spacing between icon and text
                              Text(
                                'Basic Care Information',
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
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 120.0,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
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
                                Icons.medical_services, // Use any icon you want
                                color: Color.fromARGB(255, 37, 101, 184),
                                size: 32,
                              ),
                              SizedBox(
                                  height:
                                      8), // Adjust the spacing between icon and text
                              Text(
                                'Health and Safety',
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
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 120.0,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
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
                                Icons.timeline, // Use any icon you want
                                color: Color.fromARGB(255, 37, 101, 184),
                                size: 32,
                              ),
                              SizedBox(
                                  height:
                                      8), // Adjust the spacing between icon and text
                              Text(
                                'Developmental Milestones',
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
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 120.0,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
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
                                Icons
                                    .lightbulb_outline, // Use any icon you want
                                color: Color.fromARGB(255, 37, 101, 184),
                                size: 32,
                              ),
                              SizedBox(
                                  height:
                                      8), // Adjust the spacing between icon and text
                              Text(
                                'Practical Tips and Advice',
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
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 120.0,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
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
                                Icons.warning, // Use any icon you want
                                color: Color.fromARGB(255, 37, 101, 184),
                                size: 32,
                              ),
                              SizedBox(
                                  height:
                                      8), // Adjust the spacing between icon and text
                              Text(
                                'Emergency Preparedness',
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
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 120.0,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
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
                                Icons.build, // Use any icon you want
                                color: Color.fromARGB(255, 37, 101, 184),
                                size: 32,
                              ),
                              SizedBox(
                                  height:
                                      8), // Adjust the spacing between icon and text
                              Text(
                                'Miscellaneous Resources',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
