// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import '../../../models/user.dart';
import '../../../services/database_service.dart';
import '../../../services/misc_methods/capitalize_first_letter.dart';
import '../../../services/misc_methods/get_first_two_words.dart';
import '../admin_appt_management/admin_appt_management.dart';
import '../admin_appt_management/appointment_by_practitioner.dart';
import '../system_admin_home.dart';
import 'manage_user.dart';

class ViewUser extends StatefulWidget {
  final User viewedUser;
  final User actualUser;
  final bool autoImplyLeading;

  const ViewUser(
      {Key? key,
      required this.viewedUser,
      required this.autoImplyLeading,
      required this.actualUser})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ViewUserState createState() => _ViewUserState();
}

class _ViewUserState extends State<ViewUser> {
  List<User> _userInfo = [];
  String? _userName;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
    _loadUserName();
  }

  // ----------------------------------------------------------------------
  // Fetch details

  Future<void> _fetchUserInfo() async {
    List<User> userInfo =
        await DatabaseService().userInfo(widget.viewedUser.user_id);
    setState(() {
      _userInfo = userInfo;
    });
  }
  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // load user name
  Future<void> _loadUserName() async {
    _userName = await DatabaseService().getUserName(widget.viewedUser.user_id);
    setState(() {}); // Update the UI to display the patient name
  }
  // ----------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // DateTime appointmentDate =
    //     DateTime.parse(widget.appointment.appointment_date);
    // String dayOfWeek = DateFormat('EEEE').format(appointmentDate);

    return WillPopScope(
      onWillPop: () async {
        return widget.autoImplyLeading;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(getFirstTwoWords(widget.viewedUser.name)),
          elevation: 0,
          automaticallyImplyLeading: false,
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
                            user: widget.actualUser,
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
                            user: widget.viewedUser,
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
                    iconSize: 25,
                    onPressed: () {
                      int initialTab = 0;
                      if (widget.viewedUser.role == 'patient') {
                        initialTab = 0;
                      } else {
                        initialTab = 1;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ManageUser(
                            user: widget.actualUser,
                            autoImplyLeading: false,
                            initialTab: initialTab,
                          ),
                        ),
                      );
                    },
                    color: const Color(
                      0xFFFFD271,
                    ), // Set the color of the icon
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12.0),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Color(0xFFB6CBFF),
                          height: 1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'User Information',
                          style: TextStyle(
                              color: Color(0xFFEDF2FF), letterSpacing: 2),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Color(0xFFB6CBFF),
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: double.infinity, // Adjust padding as needed
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                            0xFF303E8F), // Background color of the ElevatedButton
                        elevation: 0, // Set the elevation for the button
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(30.0), // Adjust the radius
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 28.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Handle onTap action here
                              },
                              child: const Row(
                                children: [
                                  Text(
                                    "FULL NAME",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Color(0xFFB6CBFF),
                                    ),
                                  ),
                                  SizedBox(
                                      width:
                                          8), // Add some spacing between text and icon
                                  Icon(
                                    Icons.edit,
                                    color: Color(
                                        0xFFFFD271), // Set the color of the icon
                                    size:
                                        16, // Adjust the size of the icon as needed
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.viewedUser.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xFFEDF2FF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity, // Adjust padding as needed
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                            0xFF303E8F), // Background color of the ElevatedButton
                        elevation: 0, // Set the elevation for the button
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(30.0), // Adjust the radius
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 28.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Handle onTap action here
                              },
                              child: const Row(
                                children: [
                                  Text(
                                    "USERNAME",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Color(0xFFB6CBFF),
                                    ),
                                  ),
                                  SizedBox(
                                      width:
                                          8), // Add some spacing between text and icon
                                  Icon(
                                    Icons.lock,
                                    color: Color(
                                        0xFFB6CBFF), // Set the color of the icon
                                    size:
                                        16, // Adjust the size of the icon as needed
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.viewedUser.username,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xFFEDF2FF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity, // Adjust padding as needed
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                            0xFF303E8F), // Background color of the ElevatedButton
                        elevation: 0, // Set the elevation for the button
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(30.0), // Adjust the radius
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 28.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Handle onTap action here
                              },
                              child: const Row(
                                children: [
                                  Text(
                                    "PHONE",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Color(0xFFB6CBFF),
                                    ),
                                  ),
                                  SizedBox(
                                      width:
                                          8), // Add some spacing between text and icon
                                  Icon(
                                    Icons.edit,
                                    color: Color(
                                        0xFFFFD271), // Set the color of the icon
                                    size:
                                        16, // Adjust the size of the icon as needed
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.viewedUser.phone,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xFFEDF2FF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity, // Adjust padding as needed
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                            0xFF303E8F), // Background color of the ElevatedButton
                        elevation: 0, // Set the elevation for the button
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(30.0), // Adjust the radius
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 28.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Handle onTap action here
                              },
                              child: const Row(
                                children: [
                                  Text(
                                    "ROLE",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Color(0xFFB6CBFF),
                                    ),
                                  ),
                                  SizedBox(
                                      width:
                                          8), // Add some spacing between text and icon
                                  Icon(
                                    Icons.lock,
                                    color: Color(
                                        0xFFB6CBFF), // Set the color of the icon
                                    size:
                                        16, // Adjust the size of the icon as needed
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _capitalizeFirstLetterOfEachWord(
                                  widget.viewedUser.role),
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xFFEDF2FF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (widget.viewedUser.role == 'practitioner')
                  const SizedBox(height: 12),
                if (widget.viewedUser.role == 'practitioner')
                  SizedBox(
                    width: double.infinity, // Adjust padding as needed
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                              0xFF303E8F), // Background color of the ElevatedButton
                          elevation: 0, // Set the elevation for the button
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                30.0), // Adjust the radius
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 28.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Handle onTap action here
                                },
                                child: const Row(
                                  children: [
                                    Text(
                                      "BRANCH",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Color(0xFFB6CBFF),
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            8), // Add some spacing between text and icon
                                    Icon(
                                      Icons.lock,
                                      color: Color(
                                          0xFFB6CBFF), // Set the color of the icon
                                      size:
                                          16, // Adjust the size of the icon as needed
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Placeholder',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Color(0xFFEDF2FF),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 36.0),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Color(0xFFB6CBFF),
                          height: 1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'Actions',
                          style: TextStyle(
                              color: Color(0xFFEDF2FF), letterSpacing: 2),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Color(0xFFB6CBFF),
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                if (widget.viewedUser.role == 'patient')
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: SizedBox(
                      height: 60.0,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFFDBE5FF), // Set the fill color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                50.0), // Adjust the value as needed
                          ),
                          side: const BorderSide(
                            color: Color(0xFF6086f6), // Set the outline color
                            width: 2.5, // Set the outline width
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(
                                  12.0), // Adjust padding as needed
                              child: Icon(
                                Icons.group, // Use any icon you want
                                color: Color(0xFF1F3299),
                                size: 24,
                              ),
                            ),
                            Spacer(), // Adjust the spacing between icon and text
                            Text(
                              'View Profiles',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF1F3299),
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: EdgeInsets.all(
                                  12.0), // Adjust padding as needed
                              child: Icon(
                                Icons.group, // Use any icon you want
                                color: Color(0xFF1F3299),
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (widget.viewedUser.role == 'practitioner')
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: SizedBox(
                      height: 60.0,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFFDBE5FF), // Set the fill color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                50.0), // Adjust the value as needed
                          ),
                          side: const BorderSide(
                            color: Color(0xFF6086f6), // Set the outline color
                            width: 2.5, // Set the outline width
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(
                                  12.0), // Adjust padding as needed
                              child: Icon(
                                Icons.group, // Use any icon you want
                                color: Color(0xFF1F3299),
                                size: 24,
                              ),
                            ),
                            Spacer(), // Adjust the spacing between icon and text
                            Text(
                              'Patients Cared',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF1F3299),
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: EdgeInsets.all(
                                  12.0), // Adjust padding as needed
                              child: Icon(
                                Icons.group, // Use any icon you want
                                color: Color(0xFF1F3299),
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (widget.viewedUser.role == 'practitioner')
                  const SizedBox(height: 10.0),
                if (widget.viewedUser.role == 'practitioner')
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: SizedBox(
                      height: 60.0,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AppointmentByPractitioner(
                                viewedUser: widget.viewedUser,
                                actualUser: widget.actualUser,
                                autoImplyLeading: true,
                              ),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFFCBD9FF), // Set the fill color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                50.0), // Adjust the value as needed
                          ),
                          side: const BorderSide(
                            color: Color(0xFF6086f6), // Set the outline color
                            width: 2.5, // Set the outline width
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(
                                  12.0), // Adjust padding as needed
                              child: Icon(
                                Icons.event, // Use any icon you want
                                color: Color(0xFF1F3299),
                                size: 24,
                              ),
                            ),
                            Spacer(), // Adjust the spacing between icon and text
                            Text(
                              'Appointments',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF1F3299),
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: EdgeInsets.all(
                                  12.0), // Adjust padding as needed
                              child: Icon(
                                Icons.event, // Use any icon you want
                                color: Color(0xFF1F3299),
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: SizedBox(
                    height: 60.0,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF0B1655), // Set the fill color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              50.0), // Adjust the value as needed
                        ),
                        side: const BorderSide(
                          color: Color(0xFFC1D3FF), // Set the outline color
                          width: 3, // Set the outline width
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(
                                12.0), // Adjust padding as needed
                            child: Icon(
                              Icons.refresh_rounded, // Use any icon you want
                              color: Color(0xFFC1D3FF),
                              size: 24,
                            ),
                          ),
                          Spacer(), // Adjust the spacing between icon and text
                          Text(
                            'Reset Password',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFC1D3FF),
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.all(
                                12.0), // Adjust padding as needed
                            child: Icon(
                              Icons.refresh_rounded, // Use any icon you want
                              color: Color(0xFFC1D3FF),
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _capitalizeFirstLetterOfEachWord(String input) {
  if (input.isEmpty) return input;
  return input.split(' ').map((word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join(' ');
}
