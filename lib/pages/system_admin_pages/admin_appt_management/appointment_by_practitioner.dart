import 'package:flutter/material.dart';

import '../../../models/appointment.dart';
import '../../../models/profile.dart';
import '../../../models/user.dart';
import '../../../services/database_service.dart';
import '../../../services/misc_methods/date_display.dart';
import '../../../services/misc_methods/get_first_two_words.dart';
import '../../../services/misc_methods/get_icon_status.dart';
import '../../../services/misc_methods/get_icon_status_color.dart';
import '../../appointment_management/view_appointment.dart';
import '../../startup/login.dart';
import '../system_admin_home.dart';
import '../user_management/manage_user.dart';
import '../user_management/view_user.dart';
import 'admin_appt_management.dart';

class AppointmentByPractitioner extends StatefulWidget {
  final User viewedUser;
  final User actualUser;
  final bool autoImplyLeading;

  const AppointmentByPractitioner(
      {super.key,
      required this.viewedUser,
      required this.autoImplyLeading,
      required this.actualUser});

  @override
  // ignore: library_private_types_in_public_api
  _AppointmentByPractitionerState createState() =>
      _AppointmentByPractitionerState();
}

// ----------------------------------------------------------------------

class _AppointmentByPractitionerState extends State<AppointmentByPractitioner> {
  List<Appointment> _appointmentUpcomingList = [];
  List<Appointment> _appointmentTodayList = [];
  List<Appointment> _appointmentPastList = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchAppointmentUpcomingList();
    _fetchAppointmentTodayList();
    _fetchAppointmentPastList();
  }

  // ----------------------------------------------------------------------
  // Get list of upcoming appointments

  Future<void> _fetchAppointmentUpcomingList() async {
    List<Appointment> appointmentUpcomingList = await DatabaseService()
        .appointmentUpcomingPractitioner(widget.viewedUser.user_id);

    // Sort the list by appointment date in ascending order
    appointmentUpcomingList
        .sort((a, b) => a.appointment_date.compareTo(b.appointment_date));

    setState(() {
      _appointmentUpcomingList = appointmentUpcomingList;
    });
  }

  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Get list of Today appointments

  Future<void> _fetchAppointmentTodayList() async {
    List<Appointment> appointmentTodayList = await DatabaseService()
        .appointmentTodayPractitioner(widget.viewedUser.user_id);

    // Sort the list by appointment date in ascending order
    appointmentTodayList
        .sort((a, b) => a.appointment_date.compareTo(b.appointment_date));

    setState(() {
      _appointmentTodayList = appointmentTodayList;
    });
  }

  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Get list of past appointments

  Future<void> _fetchAppointmentPastList() async {
    List<Appointment> appointmentPastList = await DatabaseService()
        .pastAppointmentsPractitioner(widget.viewedUser.user_id);

    // Sort the list by appointment date in descending order
    appointmentPastList
        .sort((a, b) => b.appointment_date.compareTo(a.appointment_date));

    setState(() {
      _appointmentPastList = appointmentPastList;
    });
  }

  // ----------------------------------------------------------------------

  void _viewAppointment(Appointment appointment) {
    final tempProfile = Profile(
      name: 'unknown',
      identification: 'unknown',
      dob: 'unknown',
      gender: 'unknown',
      height: 0,
      weight: 0,
      body_fat_percentage: 0,
      activity_level: 'unknown',
      belly_size: 0,
      maternity: 'No',
      maternity_due: 'unknown',
      ethnicity: 'unknown',
      marital_status: 'unknown',
      occupation: 'unknown',
      medical_alert: 'unknown',
      profile_pic: 'unknown',
      creation_date: 'unknown',
      user_id: widget.actualUser.user_id!,
    );
    // Navigate to the view appointment details page with the selected appointment
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewAppointment(
          appointment: appointment,
          actualUser: widget.actualUser,
          viewedUser: widget.viewedUser,
          profile: tempProfile,
          autoImplyLeading: false,
          sharedAppointments: false,
          appointmentByPractitioner: true,
        ),
      ),
    );
  }

  // -----

  void onSearchQueryChanged(String value) {
    setState(() {
      _searchQuery = value.toLowerCase();
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
          title: Text(getFirstTwoWords(widget.viewedUser.name)),
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
                        usernamePlaceholder: widget.actualUser.username,
                        passwordPlaceholder: widget.actualUser.password),
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
                    icon: const Icon(Icons.person_rounded),
                    iconSize: 25,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewUser(
                            viewedUser: widget.viewedUser,
                            autoImplyLeading: false,
                            actualUser: widget.actualUser,
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
        body: TabBarAppointment(
          appointmentUpcomingList: _appointmentUpcomingList,
          appointmentTodayList: _appointmentTodayList,
          appointmentPastList: _appointmentPastList,
          onViewAppointment: _viewAppointment,
          onSearchQueryChanged: (value) {
            setState(() {
              _searchQuery = value.toLowerCase();
            });
          },
          searchQuery: _searchQuery,
        ),
      ),
    );
  }
}

class TabBarAppointment extends StatefulWidget {
  final List<Appointment> appointmentUpcomingList;
  final List<Appointment> appointmentTodayList;
  final List<Appointment> appointmentPastList;
  final Function(Appointment) onViewAppointment;
  final Function(String) onSearchQueryChanged;
  final String searchQuery;

  const TabBarAppointment(
      {Key? key,
      required this.appointmentUpcomingList,
      required this.appointmentTodayList,
      required this.appointmentPastList,
      required this.onViewAppointment,
      required this.onSearchQueryChanged,
      required this.searchQuery})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TabBarAppointmentState createState() => _TabBarAppointmentState();
}

class _TabBarAppointmentState extends State<TabBarAppointment> {
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
                    text: 'Upcoming',
                  ),
                  Tab(
                    text: 'Today',
                  ),
                  Tab(
                    text: 'Past',
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 16.0, left: 19.0, right: 19.0, bottom: 0.0),
                    child: TextField(
                      onChanged: widget.onSearchQueryChanged,
                      decoration: const InputDecoration(
                        hintText: 'Reference Number',
                        hintStyle: TextStyle(
                          color:
                              Color(0xFFB6CBFF), // Set the hint text color here
                        ),
                        filled: true,
                        fillColor: Color(0xFF4D5FC0),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(25.0),
                          ),
                        ),
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(
                              left: 10.0), // Adjust the left padding
                          child: Icon(Icons.search, color: Color(0xFFB6CBFF)),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  _buildAppointmentList(widget.appointmentUpcomingList, 1),
                  _buildAppointmentList(widget.appointmentTodayList, 2),
                  _buildAppointmentList(widget.appointmentPastList, 3),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentList(List<Appointment> appointmentList, int tab) {
    List<Appointment> filteredList;

    if (appointmentList.isEmpty) {
      String noAppointment = 'appointments.';
      switch (tab) {
        case 1:
          noAppointment = 'upcoming appointments.';
          break;
        case 2:
          noAppointment = 'appointments today.';
          break;
        case 3:
          noAppointment = 'past appointments.';
          break;
        default:
          noAppointment = 'appointments.';
          break;
      }
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const Spacer(),
              Center(
                child: Text(
                  'There are no $noAppointment',
                  style:
                      const TextStyle(fontSize: 18.0, color: Color(0xFFB6CBFF)),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 56.0),
              const Spacer(),
            ],
          ));
    }

    return ListView.builder(
      itemCount: appointmentList.length,
      itemBuilder: (context, index) {
        Appointment appointment = appointmentList[index];
        if (widget.searchQuery.isEmpty ||
            appointment.random_id.toLowerCase().contains(widget.searchQuery) ||
            appointment.random_id.toLowerCase().contains(widget.searchQuery)) {
          return Column(
            children: [
              const SizedBox(height: 4.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GestureDetector(
                  onTap: () {
                    widget.onViewAppointment(appointment);
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
                          appointment.random_id,
                          style: const TextStyle(
                              color: Color(0xFFEDF2FF),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8.0),
                            Text(
                              '${DateDisplay(date: appointment.appointment_date).getStringDate()} - ${appointment.appointment_time}',
                              style: const TextStyle(
                                  color: Color(0xFFB6CBFF), fontSize: 16),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                getIconForStatus(appointment.status),
                                color:
                                    getIconColorForStatus(appointment.status),
                              ),
                              onPressed: () {
                                widget.onViewAppointment(appointment);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (index == appointmentList.length - 1)
                const SizedBox(
                    height: 77.0), // Add SizedBox after the last item
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}
