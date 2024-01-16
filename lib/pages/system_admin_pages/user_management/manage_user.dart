import 'package:flutter/material.dart';
import 'package:klinik_alya_iman_mobile_app/app_drawer/app_drawer_system_admin.dart';

import '../../../models/user.dart';
import '../../../services/database_service.dart';
import 'register_user.dart';
import 'view_user.dart';

class ManageUser extends StatefulWidget {
  final User user;
  final bool autoImplyLeading;

  const ManageUser(
      {super.key, required this.user, required this.autoImplyLeading});

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

  void _viewUser(User user) {
    // Navigate to the view user details page with the selected user
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewUser(
          user: user,
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
          title: const Text(
            'User List',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        drawer: AppDrawerSystemAdmin(
          header: 'Manage User',
          user: widget.user,
        ),
        body: TabBarUser(
          patientList: _patientList,
          practitionerList: _practitionerList,
          onViewUser: _viewUser,
          onSearchQueryChanged: (value) {
            setState(() {
              _searchQuery = value.toLowerCase();
            });
          },
          searchQuery: _searchQuery,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Navigate to the page where you want to appointment form
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
          icon: const Icon(Icons.person_2_outlined),
          label: const Text('Register New User'),
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

  const TabBarUser(
      {Key? key,
      required this.patientList,
      required this.practitionerList,
      required this.onViewUser,
      required this.onSearchQueryChanged,
      required this.searchQuery})
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
            user.identification.toLowerCase().contains(searchQuery)) {
          return Column(
            children: [
              const SizedBox(height: 12.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GestureDetector(
                  onTap: () {
                    onViewUser(user);
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
                        title: Text(user.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4.0),
                            Text(user.identification),
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
