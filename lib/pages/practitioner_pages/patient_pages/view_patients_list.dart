import 'package:flutter/material.dart';

import '../../../models/appointment.dart';
import '../../../models/profile.dart';
import '../../../models/user.dart';
import '../../../services/database_service.dart';
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
        return widget.autoImplyLeading;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Patient List',
            style: TextStyle(color: Colors.white),
          ),
          automaticallyImplyLeading: widget.autoImplyLeading,
          iconTheme: const IconThemeData(
            color: Colors.white,
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
                color: Color.fromARGB(255, 74, 142, 230),
              ),
              child: const TabBar(
                labelStyle: TextStyle(
                  // Set your desired text style for the selected (active) tab here
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Rubik',
                  // You can set other text style properties as needed
                ),
                unselectedLabelStyle: TextStyle(
                  // Set your desired text style for the unselected tabs here
                  fontSize: 16,
                  fontFamily: 'Rubik',
                  // You can set other text style properties as needed
                ),
                indicatorColor: Color.fromARGB(255, 37, 101, 184),
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
                  top: 16.0, left: 16.0, right: 16.0, bottom: 0.0),
              child: TextField(
                onChanged: onSearchQueryChanged,
                decoration: const InputDecoration(
                  hintText: 'Search by name or IC/passport',
                  filled: true,
                  fillColor: Colors.white,
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
                    child: Icon(Icons.search),
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
    return ListView.builder(
      itemCount: patientList.length,
      itemBuilder: (context, index) {
        Profile patient = patientList[index];
        if (searchQuery.isEmpty ||
            patient.name.toLowerCase().contains(searchQuery) ||
            patient.identification.toLowerCase().contains(searchQuery)) {
          return Column(
            children: [
              const SizedBox(height: 12.0),
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
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    elevation: 3,
                    color: const Color.fromARGB(255, 238, 238, 238),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListTile(
                        title: Text(patient.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4.0),
                            Text(patient.identification),
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
