import 'package:flutter/material.dart';

import '../../../models/appointment.dart';
import '../../../models/profile.dart';
import '../../../models/user.dart';
import '../../../services/database_service.dart';
import '../../startup/login.dart';
import '../manage_appointment.dart';
import '../practitioner_home.dart';
import '../practitioner_profile_page.dart';
import 'view_patient.dart';

class PatientsList extends StatefulWidget {
  final User user;
  final bool autoImplyLeading;

  const PatientsList(
      {super.key, required this.user, required this.autoImplyLeading});

  @override
  // ignore: library_private_types_in_public_api
  _PatientsListState createState() => _PatientsListState();
}

class _PatientsListState extends State<PatientsList> {
  List<Profile> _patientsUnderCareList = [];
  List<Profile> _guestsUnderCareList = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchPatientsUnderCareList();
  }

  // ----------------------------------------------------------------------
  // Get list of patients under care

  Future<void> _fetchPatientsUnderCareList() async {
    List<Appointment> appointmentsUnderPractitioner =
        await DatabaseService().patientsUnderCare(widget.user.user_id!);

    List<int?> profileIds = appointmentsUnderPractitioner
        .map((appointment) => appointment.profile_id)
        .toList();

    List<Profile> profiles =
        await DatabaseService().profilesByProfileIds(profileIds);

    List<Profile> guestProfiles =
        profiles.where((profile) => profile.user_id == 1).toList();
    List<Profile> patientProfiles =
        profiles.where((profile) => profile.user_id != 1).toList();

    setState(() {
      _guestsUnderCareList = guestProfiles;
      _patientsUnderCareList = patientProfiles;
    });
  }

  // ----------------------------------------------------------------------
  // Builder

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'My Patients',
          ),
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Color(0xFFEDF2FF),
          ),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
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
              0xFF0A0F2C,
            ), // Set the background color of the BottomAppBar
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
                          builder: (context) => PractitionerProfilePage(
                            actualUser: widget.user,
                            practitionerUser: widget.user,
                            autoImplyLeading: false,
                          ),
                        ),
                      );
                    },
                    color: const Color(
                      0xFFEDF2FF,
                    ), // Set the color of the icon
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.event),
                    iconSize: 22,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ManageAppointment(
                              user: widget.user,
                              autoImplyLeading: false,
                              initialTab: 1,
                              profileId: 0),
                        ),
                      );
                    },
                    color: const Color(
                      0xFFEDF2FF,
                    ), // Set the color of the icon
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.home),
                    iconSize: 25,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PractitionerHome(
                            user: widget.user,
                          ),
                        ),
                      );
                    },
                    color: const Color(
                      0xFFEDF2FF,
                    ), // Set the color of the icon
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.groups_3),
                    iconSize: 30,
                    onPressed: () {},
                    color: const Color(
                      0xFF5464BB,
                    ), // Set the color of the icon
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
        body: TabBarPatient(
          patientList: _patientsUnderCareList,
          guestList: _guestsUnderCareList,
          onSearchQueryChanged: (value) {
            setState(() {
              _searchQuery = value.toLowerCase();
            });
          },
          searchQuery: _searchQuery,
          user: widget.user,
        ),
      ),
    );
  }
}

class TabBarPatient extends StatelessWidget {
  final List<Profile> patientList;
  final List<Profile> guestList;
  final Function(String) onSearchQueryChanged;
  final String searchQuery;
  final User user;

  const TabBarPatient(
      {Key? key,
      required this.patientList,
      required this.guestList,
      required this.onSearchQueryChanged,
      required this.searchQuery,
      required this.user})
      : super(key: key);

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
                    text: 'Patients',
                  ),
                  Tab(
                    text: 'Guests',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 16.0, left: 19.0, right: 19.0, bottom: 0.0),
              child: TextField(
                onChanged: onSearchQueryChanged,
                decoration: const InputDecoration(
                  hintText: 'Search by name or IC/passport',
                  hintStyle: TextStyle(
                    color: Color(0xFFB6CBFF), // Set the hint text color here
                  ),
                  filled: true,
                  fillColor: Color(0xFF4D5FC0),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                  ),
                  prefixIcon: Padding(
                    padding:
                        EdgeInsets.only(left: 10.0), // Adjust the left padding
                    child: Icon(Icons.search, color: Color(0xFFB6CBFF)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  _buildPatientList(patientList, searchQuery, user),
                  _buildPatientList(guestList, searchQuery, user),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientList(List<Profile> patientList, searchQuery, User user) {
    if (patientList.isEmpty) {
      return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Spacer(),
              Center(
                child: Text(
                  'You have no patients.',
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
      itemCount: patientList.length,
      itemBuilder: (context, index) {
        Profile patient = patientList[index];
        if (searchQuery.isEmpty ||
            patient.name.toLowerCase().contains(searchQuery) ||
            patient.identification.toLowerCase().contains(searchQuery)) {
          return Column(
            children: [
              if (index == 0) // Add SizedBox only for the first item
                const SizedBox(height: 8.0),
              const SizedBox(height: 4.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewPatient(
                          user: user,
                          autoImplyLeading: true,
                          profile: patient,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(25.0), // Adjust the radius
                    ),
                    elevation: 0,
                    color: const Color(0xFF303E8F),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListTile(
                        title: Text(
                          _getFirstTwoWords(patient.name),
                          style: const TextStyle(
                              color: Color(0xFFEDF2FF), fontSize: 18),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4.0),
                            Text(
                              patient.identification,
                              style: const TextStyle(
                                  color: Color(0xFFB6CBFF), fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (index == patientList.length - 1) const SizedBox(height: 77.0),
            ],
          );
        } else {
          return Container();
        }
      },
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
