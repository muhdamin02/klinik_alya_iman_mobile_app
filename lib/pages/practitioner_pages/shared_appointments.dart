import 'package:flutter/material.dart';

import '../../models/appointment.dart';
import '../../models/profile.dart';
import '../../models/user.dart';
import '../../services/database_service.dart';
import '../../services/misc_methods/date_display.dart';
import '../../services/misc_methods/get_icon_status.dart';
import '../../services/misc_methods/get_icon_status_color.dart';
import '../appointment_management/update_appointment.dart';
import '../appointment_management/view_appointment.dart';
import '../startup/login.dart';
import 'manage_appointment.dart';
import 'patient_pages/view_patient.dart';
import 'patient_pages/view_patients_list.dart';
import 'practitioner_home.dart';
import 'practitioner_profile_page.dart';

class SharedAppointments extends StatefulWidget {
  final User user;
  final bool autoImplyLeading;
  final int initialTab;
  final Profile profile;
  final String patientName;

  const SharedAppointments(
      {super.key,
      required this.user,
      required this.autoImplyLeading,
      required this.initialTab,
      required this.profile,
      required this.patientName});

  @override
  // ignore: library_private_types_in_public_api
  _SharedAppointmentsState createState() => _SharedAppointmentsState();
}

class _SharedAppointmentsState extends State<SharedAppointments> {
  List<Appointment> _appointmentList = [];
  List<Profile> _patientInfo = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchAppointmentList();
  }

  // ----------------------------------------------------------------------
  // Get list of all shared appointments

  Future<void> _fetchAppointmentList() async {
    List<Appointment> appointmentList = await DatabaseService()
        .sharedAppointmentAllPractitioner(
            widget.user.user_id!, widget.profile.profile_id!);

    // Sort the list by appointment date in ascending order
    appointmentList
        .sort((a, b) => a.appointment_date.compareTo(b.appointment_date));

    setState(() {
      _appointmentList = appointmentList;
    });
  }
  // ----------------------------------------------------------------------

  Future<Profile> _getPatientInfo(int profileId) async {
    List<Profile> patientInfo = await DatabaseService().profileInfo(profileId);
    return patientInfo[0];
  }

  // ----------------------------------------------------------------------
  // View Appointment

  void _viewAppointment(Appointment appointment, int profileId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FutureBuilder<Profile>(
          future: _getPatientInfo(profileId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While the future is still executing, show a loading indicator
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // If the future completed with an error, show an error message
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              // Once the future completes successfully, pass the Profile object
              return ViewAppointment(
                appointment: appointment,
                actualUser: widget.user,
                viewedUser: widget.user,
                profile: snapshot.data!,
                autoImplyLeading: false,
                sharedAppointments: true,
                appointmentByPractitioner: false,
              );
            } else {
              // If for some reason the future completes but with no data, show a message
              return const Center(child: Text('No data found'));
            }
          },
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------

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
          title: const Text('Shared Appointments'),
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
                    icon: const Icon(Icons.group),
                    iconSize: 25,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewPatient(
                            user: widget.user,
                            autoImplyLeading: true,
                            profile: widget.profile,
                          ),
                        ),
                      );
                    },
                    color: const Color(
                      0xFFFFD271,
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
              appointmentList: _appointmentList,
              onViewAppointment: _viewAppointment,
              initialTab: widget.initialTab,
              onSearchQueryChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              searchQuery: _searchQuery,
              patientName: widget.patientName,
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
  final List<Appointment> appointmentList;
  final Function(Appointment, int) onViewAppointment;
  final int initialTab;
  final Function(String) onSearchQueryChanged;
  final String searchQuery;
  final String patientName;

  const TabBarAppointment(
      {Key? key,
      required this.onViewAppointment,
      required this.initialTab,
      required this.onSearchQueryChanged,
      required this.searchQuery,
      required this.appointmentList,
      required this.patientName})
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
      length: 1,
      child: Scaffold(
        body: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF0A0F2C),
              ),
              child: TabBar(
                labelStyle: const TextStyle(
                  // Set your desired text style for the selected (active) tab here
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  fontFamily: 'ProductSans',
                  // You can set other text style properties as needed
                ),
                unselectedLabelStyle: const TextStyle(
                  // Set your desired text style for the unselected tabs here
                  fontSize: 16,
                  fontFamily: 'ProductSans',
                  // You can set other text style properties as needed
                ),
                indicatorColor: const Color(0xFFB6CBFF),
                indicatorWeight: 6,
                tabs: <Widget>[
                  Tab(
                    text: 'Appointments with ${widget.patientName}',
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
                  _buildAppointmentList(widget.appointmentList, 1),
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
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const Spacer(),
              Center(
                child: Text(
                  'You have no appointments with ${widget.patientName}.',
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
                    widget.onViewAppointment(
                        appointment, appointment.profile_id!);
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
                                widget.onViewAppointment(
                                    appointment, appointment.profile_id!);
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
