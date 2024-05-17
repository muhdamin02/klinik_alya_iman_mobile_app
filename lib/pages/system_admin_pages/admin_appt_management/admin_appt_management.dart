import 'package:flutter/material.dart';
import 'package:klinik_alya_iman_mobile_app/app_drawer/app_drawer_system_admin.dart';

import '../../../models/appointment.dart';
import '../../../models/user.dart';
import '../../../services/database_service.dart';
import '../../../services/misc_methods/date_display.dart';
import '../../appointment_management/view_appointment.dart';
import '../../startup/login.dart';
import '../system_admin_home.dart';
import '../user_management/manage_user.dart';

class ManageAppointmentAdmin extends StatefulWidget {
  final User user;
  final bool autoImplyLeading;

  const ManageAppointmentAdmin(
      {super.key, required this.user, required this.autoImplyLeading});

  @override
  // ignore: library_private_types_in_public_api
  _ManageAppointmentAdminState createState() => _ManageAppointmentAdminState();
}

// ----------------------------------------------------------------------

class _ManageAppointmentAdminState extends State<ManageAppointmentAdmin> {
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
    List<Appointment> appointmentUpcomingList =
        await DatabaseService().appointmentAllUpcoming();

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
    List<Appointment> appointmentTodayList =
        await DatabaseService().appointmentAllToday();

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
    List<Appointment> appointmentPastList =
        await DatabaseService().appointmentAllPast();

    // Sort the list by appointment date in descending order
    appointmentPastList
        .sort((a, b) => b.appointment_date.compareTo(a.appointment_date));

    setState(() {
      _appointmentPastList = appointmentPastList;
    });
  }

  // ----------------------------------------------------------------------

  void _viewAppointment(Appointment appointment) {
    // Navigate to the view appointment details page with the selected appointment
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ViewAppointment(appointment: appointment, user: widget.user),
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
          title: const Text('Appointments'),
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
                    iconSize: 27,
                    onPressed: () {},
                    color: const Color(
                      0xFF5464BB,
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
                    iconSize: 25,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ManageUser(
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
  String _selectedFilter = 'All'; // default

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
                        top: 16.0, left: 19.0, right: 0.0, bottom: 0.0),
                    child: TextField(
                      onChanged: widget.onSearchQueryChanged,
                      decoration: const InputDecoration(
                        hintText: 'Ref Number',
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 25, top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(Icons.filter_list_rounded,
                            color: Color(0xFFB6CBFF)),
                        // const Text(
                        //   'Filter by ',
                        //   style: TextStyle(
                        //     color: Color(0xFFB6CBFF),
                        //     fontSize: 16, // Set your desired font size
                        //   ),
                        // ),
                        const SizedBox(width: 10),
                        DropdownButton<String>(
                          value: _selectedFilter,
                          onChanged: (value) {
                            setState(() {
                              _selectedFilter = value!;
                            });
                          },
                          dropdownColor: const Color(0xFF303E8F),
                          items: ['All', 'Assigned', 'Unassigned']
                              .map<DropdownMenuItem<String>>(
                            (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            },
                          ).toList(),
                        ),
                      ],
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

    if (_selectedFilter == 'Assigned') {
      filteredList = appointmentList
          .where((appointment) => appointment.practitioner_id != 0)
          .toList();
    } else if (_selectedFilter == 'Unassigned') {
      filteredList = appointmentList
          .where((appointment) => appointment.practitioner_id == 0)
          .toList();
    } else {
      filteredList = appointmentList;
    }

    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        Appointment appointment = filteredList[index];
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
                              color: Color(0xFFEDF2FF), fontSize: 18),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8.0),
                            Text(
                              '${DateDisplay(date: appointment.appointment_date).getStringDate()} - ${appointment.appointment_time}',
                              style: const TextStyle(
                                  color: Color(0xFFB6CBFF), fontSize: 18),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                _getIconForStatus(appointment.status),
                                color: const Color(0xFFFFD271),
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
              if (index == filteredList.length - 1)
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

IconData _getIconForStatus(String status) {
  if (status == 'Pending') {
    return Icons.hourglass_empty;
  } else if (status == 'Confirmed') {
    return Icons.check_circle_outline_rounded;
  } else if (status == 'Cancelled') {
    return Icons.cancel;
  } else if (status == 'In Progress') {
    return Icons.timelapse;
  } else {
    return Icons.help; // Default icon for unknown statuses
  }
}
