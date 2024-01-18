import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:klinik_alya_iman_mobile_app/pages/medical_history/list_medical_history.dart';

import '../../app_drawer/app_drawer_all_pages.dart';
import '../../models/profile.dart';
import '../../models/user.dart';
import '../appointment_management/list_appointment.dart';
import '../medication_management/list_medication.dart';

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
          ),
          drawer: AppDrawerAllPages(
            header: 'Profile Page',
            user: user,
            profile: profile,
            autoImplyLeading: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0), // Add your desired padding
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.all(16.0), // Add your desired padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('NAME',
                        style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 121, 121, 121))),
                    const SizedBox(height: 4),
                    Text(profile.name, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 24),
                    const Text('IC/PASSPORT',
                        style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 121, 121, 121))),
                    const SizedBox(height: 4),
                    Text(profile.identification,
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 24),
                    const Text('DATE OF BIRTH',
                        style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 121, 121, 121))),
                    const SizedBox(height: 4),
                    Text(
                      formattedDate,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    const Text('GENDER',
                        style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 121, 121, 121))),
                    const SizedBox(height: 4),
                    Text('${profile.gender}',
                        style: const TextStyle(fontSize: 16)),
                    // Add more details as needed
                  ],
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
                                fontWeight: FontWeight.bold,
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
                                fontWeight: FontWeight.bold,
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
                                fontWeight: FontWeight.bold,
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
                      // Handle button press
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
                            fontWeight: FontWeight.bold,
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
        ));
  }
}
