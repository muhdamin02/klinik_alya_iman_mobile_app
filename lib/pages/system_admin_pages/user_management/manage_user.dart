import 'package:flutter/material.dart';

import '../../../models/user.dart';
import '../../../services/database_service.dart';
import '../../../services/misc_methods/get_first_two_words.dart';
import '../../startup/login.dart';
import '../admin_appt_management/admin_appt_management.dart';
import '../system_admin_home.dart';
import 'register_user.dart';
import 'view_user.dart';

class ManageUser extends StatefulWidget {
  final User user;
  final bool autoImplyLeading;
  final int initialTab;

  const ManageUser(
      {super.key,
      required this.user,
      required this.autoImplyLeading,
      required this.initialTab});

  @override
  // ignore: library_private_types_in_public_api
  _ManageUserState createState() => _ManageUserState();
}

// ----------------------------------------------------------------------

class _ManageUserState extends State<ManageUser> {
  List<User> _patientList = [];
  List<User> _practitionerList = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchPatientList();
    _fetchPractitionerList();
  }

  // ----------------------------------------------------------------------
  // View list of users
  Future<void> _fetchPatientList() async {
    List<User> patientList = await DatabaseService().userPatient();
    setState(() {
      _patientList = patientList;
    });
  }
  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // View list of users
  Future<void> _fetchPractitionerList() async {
    List<User> practitionerList = await DatabaseService().userPractitioner();
    setState(() {
      _practitionerList = practitionerList;
    });
  }
  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // View user

  void _viewUser(User viewedUser) {
    // Navigate to the view user details page with the selected user
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewUser(
          viewedUser: viewedUser,
          actualUser: widget.user,
          autoImplyLeading: true,
        ),
      ),
    );
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
          title: const Text('Users'),
          iconTheme: const IconThemeData(
            color: Color(0xFFEDF2FF),
          ),
          elevation: 0,
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
                    icon: const Icon(Icons.event),
                    iconSize: 22,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ManageAppointmentAdmin(
                            user: widget.user,
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
                    icon: const Icon(Icons.home),
                    iconSize: 25,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SystemAdminHome(
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
                    icon: const Icon(Icons.group),
                    iconSize: 30,
                    onPressed: () {},
                    color: const Color(
                      0xFF5464BB,
                    ), // Set the color of the icon
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            TabBarUser(
              patientList: _patientList,
              practitionerList: _practitionerList,
              onViewUser: _viewUser,
              onSearchQueryChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              searchQuery: _searchQuery,
              initialTab: widget.initialTab,
            ),
            Positioned(
              bottom: 24.0,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width:
                      MediaQuery.of(context).size.width - 34, // Adjust padding
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterUser(
                            user: widget.user,
                            willPopScopeBool: true,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.person_add_alt),
                    label: const Text('Register New User'),
                    elevation: 0,
                    backgroundColor:
                        const Color(0xFFC1D3FF), // Set background color here
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(25), // Adjust the border radius
                      side: const BorderSide(
                          width: 2.5,
                          color:
                              Color(0xFF6086f6)), // Set the outline color here
                    ),
                    foregroundColor:
                        const Color(0xFF1F3299), // Set text and icon color here
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TabBarUser extends StatelessWidget {
  final List<User> patientList;
  final List<User> practitionerList;
  final Function(User) onViewUser;
  final Function(String) onSearchQueryChanged;
  final String searchQuery;
  final int initialTab;

  const TabBarUser(
      {Key? key,
      required this.patientList,
      required this.practitionerList,
      required this.onViewUser,
      required this.onSearchQueryChanged,
      required this.searchQuery,
      required this.initialTab})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: initialTab,
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
                    text: 'Practitioners',
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
                  hintText: 'Search by full name or username',
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
            const SizedBox(height: 8.0),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  _buildUserList(patientList, searchQuery),
                  _buildUserList(practitionerList, searchQuery),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserList(List<User> userList, searchQuery) {
    return ListView.builder(
      itemCount: userList.length,
      itemBuilder: (context, index) {
        User user = userList[index];
        if (searchQuery.isEmpty ||
            user.name.toLowerCase().contains(searchQuery) ||
            user.username.toLowerCase().contains(searchQuery)) {
          return Column(
            children: [
              const SizedBox(height: 4.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GestureDetector(
                  onTap: () {
                    onViewUser(user);
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
                          getFirstTwoWords(user.name),
                          style: const TextStyle(
                              color: Color(0xFFEDF2FF), fontSize: 18),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4.0),
                            Text(
                              user.username,
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
              if (index == userList.length - 1) const SizedBox(height: 77.0),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}
