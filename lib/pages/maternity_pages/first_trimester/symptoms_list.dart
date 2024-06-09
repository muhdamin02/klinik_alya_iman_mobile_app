import 'package:flutter/material.dart';

import '../../../models/profile.dart';
import '../../../models/symptoms.dart';
import '../../../models/user.dart';
import '../../../services/database_service.dart';
import '../../../services/misc_methods/date_display.dart';
import '../../appointment_management/list_appointment.dart';
import '../../medication_management/list_medication.dart';
import '../../profile_management/profile_page.dart';
import '../../startup/patient_homepage.dart';
import '../first_trimester.dart';
import 'track_new_symptom.dart';

class SymptomsList extends StatefulWidget {
  final User user;
  final Profile profile;
  final bool autoImplyLeading;

  const SymptomsList({
    Key? key,
    required this.user,
    required this.profile,
    required this.autoImplyLeading,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SymptomsListState createState() => _SymptomsListState();
}

class _SymptomsListState extends State<SymptomsList> {
  List<Symptoms> _symptomsList = [];

  @override
  void initState() {
    super.initState();
    _fetchSymptomsList();
  }

  Future<void> _fetchSymptomsList() async {
    List<Symptoms> symptomsList = await DatabaseService()
        .retrieveSymptoms(widget.user.user_id!, widget.profile.profile_id);

    setState(() {
      _symptomsList = symptomsList;
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
          title: const Text('Symptoms List'),
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
        body: Stack(
          children: [
            if (_symptomsList.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Spacer(),
                    Center(
                      child: Text(
                        'You have not tracked any symptoms.',
                        style:
                            TextStyle(fontSize: 18.0, color: Color(0xFFB6CBFF)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 56.0),
                    Spacer(),
                  ],
                ),
              ),
            ListView.builder(
              itemCount: _symptomsList.length,
              itemBuilder: (context, index) {
                Symptoms symptoms = _symptomsList[index];
                return Column(
                  children: [
                    if (index == 0) const SizedBox(height: 8),
                    const SizedBox(height: 4.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GestureDetector(
                        onTap: () {
                          // onViewAppointment(appointment);
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
                                symptoms.symptom_name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFFD271),
                                ),
                              ),
                              // '${symptoms.symptom_name} - ${DateDisplay(date: symptoms.symptom_entry_date).getStringDate()}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8.0),
                                  Text(
                                    symptoms.symptom_description,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(height: 1.4),
                                  ),
                                  const SizedBox(height: 20.0),
                                  Row(
                                    children: [
                                      Text(
                                        symptoms.symptom_category,
                                        style: const TextStyle(
                                            color: Color(0xFFB6CBFF)),
                                      ),
                                      const Spacer(),
                                      Text(
                                        DateDisplay(
                                                date:
                                                    symptoms.symptom_entry_date)
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
                    if (index == _symptomsList.length - 1)
                      const SizedBox(
                          height: 77.0), // Add SizedBox after the last item
                  ],
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: const Color(0xFFC1D3FF), // Set background color here
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25), // Adjust the border radius
            side: const BorderSide(
                width: 2.5,
                color: Color(0xFF6086f6)), // Set the outline color here
          ),
          foregroundColor: const Color(0xFF1F3299),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TrackNewSymptom(
                  user: widget.user,
                  profile: widget.profile,
                ),
              ),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text('Track New Symptom'),
        ),
      ),
    );
  }
}
