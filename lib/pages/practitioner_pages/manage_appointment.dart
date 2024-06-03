import 'package:flutter/material.dart';

import '../../models/appointment.dart';
import '../../models/user.dart';
import '../../services/database_service.dart';
import '../../services/misc_methods/date_display.dart';
import '../../services/misc_methods/get_icon_status.dart';
import '../../services/misc_methods/get_icon_status_color.dart';
import '../appointment_management/update_appointment.dart';
import '../appointment_management/view_appointment.dart';
import '../startup/login.dart';
import 'patient_pages/view_patients_list.dart';
import 'practitioner_home.dart';

class ManageAppointment extends StatefulWidget {
  final User user;
  final bool autoImplyLeading;
  final int initialTab;

  const ManageAppointment(
      {super.key,
      required this.user,
      required this.autoImplyLeading,
      required this.initialTab});

  @override
  // ignore: library_private_types_in_public_api
  _ManageAppointmentState createState() => _ManageAppointmentState();
}

class _ManageAppointmentState extends State<ManageAppointment> {
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
        .appointmentUpcomingPractitioner(widget.user.user_id!);

    // Sort the list by appointment date in ascending order
    appointmentUpcomingList
        .sort((a, b) => a.appointment_date.compareTo(b.appointment_date));

    setState(() {
      _appointmentUpcomingList = appointmentUpcomingList;
    });
  }

  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Get list of today appointments

  Future<void> _fetchAppointmentTodayList() async {
    List<Appointment> appointmentTodayList = await DatabaseService()
        .appointmentTodayPractitioner(widget.user.user_id!);

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
        .pastAppointmentsPractitioner(widget.user.user_id!);

    // Sort the list by appointment date in descending order
    appointmentPastList
        .sort((a, b) => b.appointment_date.compareTo(a.appointment_date));

    setState(() {
      _appointmentPastList = appointmentPastList;
    });
  }

  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // View Appointment

  void _viewAppointment(Appointment appointment) {
    // Navigate to the view appointment details page with the selected appointment
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewAppointment(
          appointment: appointment,
          user: widget.user,
          autoImplyLeading: false,
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Update Appointment

  void _updateAppointment(Appointment appointment) {
    int branch;

    switch (appointment.branch) {
      case 'Karang Darat':
        branch = 0;
        break;
      case 'Inderapura':
        branch = 1;
        break;
      case 'Kemaman':
        branch = 2;
        break;
      default:
        branch = 0;
    }

    // Navigate to the update appointment page with the selected appointment
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateAppointment(
          appointment: appointment,
          rescheduler: widget.user.role,
          appointmentBranch: branch,
        ),
      ),
    ).then((result) {
      if (result == true) {
        // If the appointment was updated, refresh the appointment history
        _fetchAppointmentUpcomingList();
        _fetchAppointmentPastList();
      }
    });
  }

  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Confirm Appointment

  void _confirmAppointment(Appointment appointment) {
    String status = appointment.status;
    String remarks = appointment.system_remarks;
    String practitionerName = widget.user.name;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Appointment'),
          content:
              const Text('Are you sure you want to confirm this appointment?'),
          actions: <Widget>[
            ElevatedButton(
              child:
                  const Text('Confirm', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                status = 'Confirmed';
                remarks =
                    'The appointment has been confirmed by $practitionerName.';
                // Call the deleteAppointment method and pass the appointmentId
                await DatabaseService().updateAppointmentStatus(
                    appointment.appointment_id!, status, remarks);
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
                // Refresh the appointment history
                _fetchAppointmentUpcomingList();
                _fetchAppointmentPastList();
              },
            ),
            ElevatedButton(
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // ----------------------------------------------------------------------
  // Cancel Appointment

  // void _cancelAppointment(Appointment appointment) {
  //   TextEditingController cancellationReasonController =
  //       TextEditingController();
  //   final int? appointmentId = appointment.appointment_id;
  //   String status = appointment.status;
  //   String remarks = appointment.remarks;
  //   final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Cancel Appointment'),
  //         content: Builder(
  //           builder: (BuildContext context) {
  //             return Form(
  //               key: formKey,
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   const Text(
  //                     'Reason for Cancellation:',
  //                     style: TextStyle(fontSize: 16),
  //                   ),
  //                   TextFormField(
  //                     controller: cancellationReasonController,
  //                     decoration: const InputDecoration(
  //                       hintText: 'Enter reason...',
  //                     ),
  //                     style: const TextStyle(fontSize: 15),
  //                     validator: (value) {
  //                       if (value == null || value.isEmpty) {
  //                         return 'Please enter a reason';
  //                       }
  //                       return null;
  //                     },
  //                   ),
  //                 ],
  //               ),
  //             );
  //           },
  //         ),
  //         actions: [
  //           ElevatedButton(
  //             onPressed: () async {
  //               if (formKey.currentState!.validate()) {
  //                 // Proceed with cancellation
  //                 status = 'Cancelled';
  //                 remarks = cancellationReasonController.text;
  //                 await DatabaseService()
  //                     .cancelAppointment(appointmentId!, status, remarks);
  //                 // ignore: use_build_context_synchronously
  //                 Navigator.of(context).pop();
  //                 _fetchBookingHistory();
  //               }
  //             },
  //             child: const Text('Confirm'),
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text('Cancel'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Delete Appointment

  // void _deleteAppointment(int? appointmentId) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Remove Appointment'),
  //         content: const Text(
  //             'Are you sure you want to remove this appointment from history?'),
  //         actions: <Widget>[
  //           ElevatedButton(
  //             child:
  //                 const Text('Remove', style: TextStyle(color: Colors.white)),
  //             onPressed: () async {
  //               // Call the deleteAppointment method and pass the appointmentId
  //               await DatabaseService().deleteAppointment(appointmentId!);
  //               // ignore: use_build_context_synchronously
  //               Navigator.of(context).pop();
  //               // Refresh the appointment history
  //               _fetchBookingHistory();
  //             },
  //           ),
  //           ElevatedButton(
  //             child:
  //                 const Text('Cancel', style: TextStyle(color: Colors.white)),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

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
          title: const Text('My Appointments'),
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
                    icon: const Icon(Icons.person),
                    iconSize: 25,
                    onPressed: () {
                      // PROFILE PAGE FOR PRACTITIONER
                    },
                    color: const Color(
                      0xFFEDF2FF,
                    ), // Set the color of the icon
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.event),
                    iconSize: 27,
                    onPressed: () {
                      //
                    },
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
                    icon: const Icon(Icons.group),
                    iconSize: 25,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PatientsList(
                            user: widget.user,
                            autoImplyLeading: true,
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
        body: Stack(
          children: [
            TabBarAppointment(
              appointmentUpcomingList: _appointmentUpcomingList,
              appointmentTodayList: _appointmentTodayList,
              appointmentPastList: _appointmentPastList,
              onViewAppointment: _viewAppointment,
              initialTab: widget.initialTab,
              onSearchQueryChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              searchQuery: _searchQuery,
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
                    icon: const Icon(Icons.event),
                    label: const Text('Schedule Appointment'),
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

class TabBarAppointment extends StatefulWidget {
  final List<Appointment> appointmentUpcomingList;
  final List<Appointment> appointmentTodayList;
  final List<Appointment> appointmentPastList;
  final Function(Appointment) onViewAppointment;
  final int initialTab;
  final Function(String) onSearchQueryChanged;
  final String searchQuery;

  const TabBarAppointment(
      {Key? key,
      required this.appointmentUpcomingList,
      required this.appointmentTodayList,
      required this.appointmentPastList,
      required this.onViewAppointment,
      required this.initialTab,
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
      initialIndex: widget.initialTab,
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
                        hintText: 'Search by Reference Number',
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
                  'You have no $noAppointment',
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
              if (index == 0) // Add SizedBox only for the first item
                const SizedBox(height: 8.0),
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
                    elevation: 0, // Set the elevation for the card
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
                            const SizedBox(height: 4.0),
                            Text(
                              '${appointment.appointment_time} - ${DateDisplay(date: appointment.appointment_date).getStringDate()}',
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
