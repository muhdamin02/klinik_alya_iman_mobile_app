import 'package:flutter/material.dart';

import '../../models/profile.dart';
import '../../models/symptoms.dart';
import '../../models/user.dart';
import '../../services/database_service.dart';
import '../../services/misc_methods/date_display.dart';
import '../appointment_management/list_appointment.dart';
import '../medication_management/list_medication.dart';
import '../profile_management/profile_page.dart';
import '../startup/patient_homepage.dart';
import 'first_trimester/track_new_symptom.dart';
import 'maternity_overview.dart';

class FirstTrimester extends StatefulWidget {
  final User user;
  final Profile profile;
  final bool autoImplyLeading;

  const FirstTrimester({
    Key? key,
    required this.user,
    required this.profile,
    required this.autoImplyLeading,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FirstTrimesterState createState() => _FirstTrimesterState();
}

class _FirstTrimesterState extends State<FirstTrimester> {
  List<Symptoms> _symptomsList = [];
  // List<EducationalResources> _educationResourcesList = [];

  @override
  void initState() {
    super.initState();
    _fetchSymptomsList();
    // _fetchEducationResourcesList();
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
          title: const Text('First Trimester'),
          automaticallyImplyLeading: false,
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
                    color: const Color(0xFFEDF2FF), // Set the color of the icon
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
        body: TabBarFirstTrimester(
          trackSymptoms: _symptomsList,
          educationalResources: _symptomsList,
          // onViewAppointment: _viewAppointment
        ),
        floatingActionButton: FloatingActionButton.extended(
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
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}

class TabBarFirstTrimester extends StatelessWidget {
  final List<Symptoms> trackSymptoms;
  final List<Symptoms> educationalResources;
  // final Function(Symptoms) onViewAppointment;

  const TabBarFirstTrimester({
    Key? key,
    required this.trackSymptoms,
    required this.educationalResources,
    // required this.onViewAppointment
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
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
                    text: 'Track Symptoms',
                  ),
                  Tab(
                    text: 'Educational Resources',
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  _buildSymptomsList(trackSymptoms),
                  _buildSymptomsList(educationalResources),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSymptomsList(List<Symptoms> symptomsList) {
    if (symptomsList.isEmpty) {
      return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Spacer(),
              Center(
                child: Text(
                  'You have no tracked symptoms.',
                  style: TextStyle(fontSize: 18.0, color: Color(0xFFB6CBFF)),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 56.0),
              Spacer(),
            ],
          ));
    }

    return ListView.builder(
      itemCount: symptomsList.length,
      itemBuilder: (context, index) {
        Symptoms symptoms = symptomsList[index];
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
                                style:
                                    const TextStyle(color: Color(0xFFB6CBFF)),
                              ),
                              const Spacer(),
                              Text(
                                DateDisplay(date: symptoms.symptom_entry_date).getStringDate(),
                                style:
                                    const TextStyle(color: Color(0xFFB6CBFF)),
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
            if (index == symptomsList.length - 1)
              const SizedBox(height: 77.0), // Add SizedBox after the last item
          ],
        );
      },
    );
  }
}
