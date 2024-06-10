// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:klinik_alya_iman_mobile_app/pages/medical_history/create_new_med_history_entry.dart';

import '../../models/medical_history.dart';
import '../../models/profile.dart';
import '../../models/user.dart';
import '../../services/database_service.dart';
import '../../services/misc_methods/datetime_display.dart';
import '../../services/misc_methods/notification_singleton.dart';
import '../../services/notification_service.dart';
import '../appointment_management/list_appointment.dart';
import '../health_profile/health_profile_page.dart';
import '../medication_management/list_medication.dart';
import '../profile_management/profile_page.dart';
import '../startup/login.dart';
import '../startup/patient_homepage.dart';

class ListMedicalHistory extends StatefulWidget {
  final User user;
  final Profile profile;
  final bool autoImplyLeading;

  const ListMedicalHistory(
      {Key? key,
      required this.user,
      required this.profile,
      required this.autoImplyLeading})
      : super(key: key);

  @override
  _ListMedicalHistoryState createState() => _ListMedicalHistoryState();
}

class _ListMedicalHistoryState extends State<ListMedicalHistory> {
  List<MedicalHistory> _medicalHistory = [];

  @override
  void initState() {
    super.initState();
    _fetchMedicalHistory();
  }

  // ----------------------------------------------------------------------
  // View medicalHistory

  Future<void> _fetchMedicalHistory() async {
    List<MedicalHistory> medicalHistory = await DatabaseService()
        .retrieveMedHistory(widget.user.user_id!, widget.profile.profile_id);
    setState(() {
      _medicalHistory = medicalHistory;
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
          title: const Text('Health Diary'),
          iconTheme: const IconThemeData(
            color: Color(0xFFEDF2FF),
          ),
          automaticallyImplyLeading: false,
          actions: <Widget>[
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
                        usernamePlaceholder: widget.user.username,
                        passwordPlaceholder: widget.user.password),
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
                    iconSize: 23,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HealthProfilePage(
                            user: widget.user,
                            profile: widget.profile,
                            autoImplyLeading: false,
                            initialTabOthers: true,
                          ),
                        ),
                      );
                    },
                    color: const Color(0xFFEDF2FF), // Set the color of the icon
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
        // drawer: AppDrawerAllPages(
        //   header: 'Medical History',
        //   user: widget.user,
        //   profile: widget.profile,
        //   autoImplyLeading: true,
        // ),
        body: Stack(
          children: [
            if (_medicalHistory.isEmpty)
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Spacer(),
                      Center(
                        child: Text(
                          'You have no diary entries.',
                          style: TextStyle(
                              fontSize: 18.0, color: Color(0xFFB6CBFF)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 56.0),
                      Spacer(),
                    ],
                  )),
            ListView.builder(
              itemCount: _medicalHistory.length,
              itemBuilder: (context, index) {
                MedicalHistory medicalHistory = _medicalHistory[index];
                return Column(
                  children: [
                    if (index == 0) const SizedBox(height: 8),
                    const SizedBox(height: 4.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GestureDetector(
                        onTap: () {
                          // function
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          elevation: 0,
                          color: const Color(0xFF303E8F),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ListTile(
                              title: Text(
                                medicalHistory.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFFD271),
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8.0),
                                  Text(
                                    medicalHistory.body,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(height: 1.4),
                                  ),
                                  const SizedBox(height: 20.0),
                                  Row(
                                    children: [
                                      Text(
                                        DateTimeDisplay(
                                                datetime: medicalHistory
                                                    .datetime_posted)
                                            .getStringTime(),
                                        style: const TextStyle(
                                            color: Color(0xFFB6CBFF)),
                                      ),
                                      const Spacer(),
                                      Text(
                                        DateTimeDisplay(
                                                datetime: medicalHistory
                                                    .datetime_posted)
                                            .getStringDate(),
                                        style: const TextStyle(
                                            color: Color(0xFFB6CBFF)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (index == _medicalHistory.length - 1)
                      const SizedBox(height: 76.0),
                  ],
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Navigate to the page where you want to appointment form
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateNewMedHistoryEntry(
                  user: widget.user,
                  profile: widget.profile,
                ),
              ),
            );
          },
          backgroundColor: const Color(0xFFC1D3FF), // Set background color here
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25), // Adjust the border radius
            side: const BorderSide(
                width: 2.5,
                color: Color(0xFF6086f6)), // Set the outline color here
          ),
          foregroundColor: const Color(0xFF1F3299),
          elevation: 0,
          icon: const Padding(
            padding: EdgeInsets.only(left: 16.0, right: 8.0),
            child: Icon(Icons.edit_document),
          ),
          label: const Padding(
            padding: EdgeInsets.only(right: 16.0), // Adjust the padding here
            child: Text('Create New Entry'),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
