import 'package:flutter/material.dart';

import '../../models/profile.dart';
import '../../models/symptoms.dart';
import '../../models/user.dart';
import '../../services/database_service.dart';
import '../../services/misc_methods/date_display.dart';

class FirstTrimester extends StatefulWidget {
  final User user;
  final Profile profile;

  const FirstTrimester({
    Key? key,
    required this.user,
    required this.profile,
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
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('First Trimester'),
        ),
        body: TabBarFirstTrimester(
            trackSymptoms: _symptomsList,
            // educationalResources: _appointmentTodayList,
            // onViewAppointment: _viewAppointment
            ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Navigate to the page where you want to appointment form
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => AppointmentForm(
            //       user: widget.user,
            //       profile: widget.profile,
            //     ),
            //   ),
            // );
          },
          icon: const Icon(Icons.add),
          label: const Text('Add New Symptom'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}

class TabBarFirstTrimester extends StatelessWidget {
  final List<Symptoms> trackSymptoms;
  // final List<Symptoms> educationalResources;
  // final Function(Symptoms) onViewAppointment;

  const TabBarFirstTrimester(
      {Key? key,
      required this.trackSymptoms,
      // required this.educationalResources,
      // required this.onViewAppointment
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        body: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 74, 142, 230),
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
                indicatorColor: Color.fromARGB(255, 37, 101, 184),
                indicatorWeight: 6,
                tabs: <Widget>[
                  Tab(
                    text: 'Track Symptoms',
                  ),
                  // Tab(
                  //   text: 'Educational Resources',
                  // ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  _buildSymptomsList(trackSymptoms),
                  // _buildAppointmentList(educationalResources),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSymptomsList(List<Symptoms> symptomsList) {
    return ListView.builder(
      itemCount: symptomsList.length,
      itemBuilder: (context, index) {
        Symptoms symptoms = symptomsList[index];
        return Column(
          children: [
            const SizedBox(height: 12.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GestureDetector(
                onTap: () {
                  // onViewAppointment(appointment);
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(25.0), // Adjust the radius
                  ),
                  elevation: 8, // Set the elevation for the card
                  color: const Color.fromARGB(255, 238, 238, 238),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListTile(
                      title: Text(
                          '${symptoms.symptom_name} - ${DateDisplay(date: symptoms.symptom_entry_date).getStringDate()}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4.0),
                          Text(symptoms.symptom_category),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.visibility),
                            onPressed: () {
                              // onViewAppointment(appointment);
                            },
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
