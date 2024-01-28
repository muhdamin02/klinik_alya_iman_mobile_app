import 'package:flutter/material.dart';
import 'package:klinik_alya_iman_mobile_app/app_drawer/app_drawer_system_admin.dart';

import '../../../models/appointment.dart';
import '../../../models/user.dart';
import '../../../services/database_service.dart';
import '../../../services/misc_methods/date_display.dart';
import '../../appointment_management/view_appointment.dart';

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
            'Appointment List',
            style: TextStyle(color: Colors.white),
          ),
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        drawer: AppDrawerSystemAdmin(
          header: 'Manage Appointment',
          user: widget.user,
        ),
        body: TabBarAppointment(
            appointmentUpcomingList: _appointmentUpcomingList,
            appointmentTodayList: _appointmentTodayList,
            appointmentPastList: _appointmentPastList,
            onViewAppointment: _viewAppointment),
      ),
    );
  }
}

class TabBarAppointment extends StatefulWidget {
  final List<Appointment> appointmentUpcomingList;
  final List<Appointment> appointmentTodayList;
  final List<Appointment> appointmentPastList;
  final Function(Appointment) onViewAppointment;

  const TabBarAppointment(
      {Key? key,
      required this.appointmentUpcomingList,
      required this.appointmentTodayList,
      required this.appointmentPastList,
      required this.onViewAppointment})
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
                color: Color.fromARGB(255, 74, 142, 230),
              ),
              child: const Column(
                children: [
                  SizedBox(height: 8),
                  TabBar(
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
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Filter:',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  DropdownButton<String>(
                    value: _selectedFilter,
                    onChanged: (value) {
                      setState(() {
                        _selectedFilter = value!;
                      });
                    },
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
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  _buildAppointmentList(widget.appointmentUpcomingList),
                  _buildAppointmentList(widget.appointmentTodayList),
                  _buildAppointmentList(widget.appointmentPastList),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentList(List<Appointment> appointmentList) {
    List<Appointment> filteredList;

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
        return Column(
          children: [
            const SizedBox(height: 12.0),
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
                  elevation: 8, // Set the elevation for the card
                  color: const Color.fromARGB(255, 238, 238, 238),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListTile(
                      title: Text(
                          '${appointment.appointment_time} - ${DateDisplay(date: appointment.appointment_date).getStringDate()}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4.0),
                          Text(appointment.status),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.visibility),
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
              const SizedBox(height: 77.0), // Add SizedBox after the last item
          ],
        );
      },
    );
  }
}
