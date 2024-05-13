// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../../app_drawer/app_drawer_profiles_logout_only.dart';
import '../../models/appointment.dart';
import '../../models/profile.dart';
import '../../models/user.dart';
import '../../services/database_service.dart';
import '../../services/misc_methods/date_display.dart';
import '../../services/misc_methods/notification_singleton.dart';
import '../../services/notification_service.dart';
import '../medication_management/list_medication.dart';
import '../profile_management/profile_page.dart';
import '../startup/login.dart';
import '../startup/patient_homepage.dart';
import 'appointment_form.dart';
import 'update_appointment.dart';
import 'view_appointment.dart';

class ListAppointment extends StatefulWidget {
  final User user;
  final Profile profile;
  final bool autoImplyLeading;

  const ListAppointment(
      {super.key,
      required this.user,
      required this.profile,
      required this.autoImplyLeading});

  @override
  // ignore: library_private_types_in_public_api
  _ListAppointmentState createState() => _ListAppointmentState();
}

// ----------------------------------------------------------------------

class _ListAppointmentState extends State<ListAppointment> {
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
    List<Appointment> appointmentUpcomingList = await DatabaseService()
        .appointmentUpcoming(widget.user.user_id!, widget.profile.profile_id);

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
        .appointmentToday(widget.user.user_id!, widget.profile.profile_id);

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
        .pastAppointments(widget.user.user_id!, widget.profile.profile_id);

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
        builder: (context) =>
            ViewAppointment(appointment: appointment, user: widget.user),
      ),
    );
  }

  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Update Appointment

  void _updateAppointment(Appointment appointment) {
    // Navigate to the update appointment page with the selected appointment
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateAppointment(
          appointment: appointment,
          rescheduler: widget.user.role,
        ),
      ),
    ).then((result) {
      if (result == true) {
        // If the appointment was updated, refresh the appointment list
        _fetchAppointmentUpcomingList();
      }
    });
  }

  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Cancel Appointment

  void _cancelAppointment(Appointment appointment) {
    TextEditingController cancellationReasonController =
        TextEditingController();
    final int? appointmentId = appointment.appointment_id;
    String status = appointment.status;
    String systemRemarks = appointment.system_remarks;
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Appointment'),
          content: Builder(
            builder: (BuildContext context) {
              return Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Reason for Cancellation:',
                      style: TextStyle(fontSize: 16),
                    ),
                    TextFormField(
                      controller: cancellationReasonController,
                      decoration: const InputDecoration(
                        hintText: 'Enter reason...',
                      ),
                      style: const TextStyle(fontSize: 15),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a reason';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  // Proceed with cancellation
                  status = 'Cancelled';
                  systemRemarks =
                      'The appointment has been cancelled by the patient.';
                  systemRemarks = cancellationReasonController.text;
                  await DatabaseService().updateAppointmentStatus(
                      appointmentId!, status, systemRemarks);
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                  _fetchAppointmentUpcomingList();
                }
              },
              child: const Text('Confirm'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Delete Appointment

  void _deleteAppointment(int? appointmentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Appointment'),
          content: const Text(
              'Are you sure you want to remove this appointment from history?'),
          actions: <Widget>[
            ElevatedButton(
              child:
                  const Text('Remove', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                // Call the deleteAppointment method and pass the appointmentId
                await DatabaseService().deleteAppointment(appointmentId!);
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
                // Refresh the appointment history
                _fetchAppointmentUpcomingList();
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
  // Builder

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return widget.autoImplyLeading;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Appointments'),
          iconTheme: const IconThemeData(
            color: Color(0xFFEDF2FF),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                NotificationCounter notificationCounter = NotificationCounter();
                notificationCounter.reset();
                await NotificationService().cancelAllNotifications();
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
                0xFF0A0F2C), // Set the background color of the BottomAppBar
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
                          builder: (context) => ProfilePage(
                            user: widget.user,
                            profile: widget.profile,
                            autoImplyLeading: false,
                          ),
                        ),
                      );
                    },
                    color: const Color(0xFFEDF2FF), // Set the color of the icon
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.event),
                    iconSize: 27,
                    onPressed: () {},
                    color: const Color(0xFF5464BB), // Set the color of the icon
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.home),
                    iconSize: 25,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PatientHomepage(
                            user: widget.user,
                            profile: widget.profile,
                            hasProfiles: true,
                            hasChosenProfile: true,
                            autoImplyLeading: false,
                          ),
                        ),
                      );
                    },
                    color: const Color(0xFFEDF2FF), // Set the color of the icon
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.medication),
                    iconSize: 25,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListMedication(
                            user: widget.user,
                            profile: widget.profile,
                            autoImplyLeading: false,
                          ),
                        ),
                      );
                    },
                    color: const Color(0xFFEDF2FF), // Set the color of the icon
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
        drawer: AppDrawerProfilesLogout(
          header: 'Appointments',
          user: widget.user,
          profile: widget.profile,
          autoImplyLeading: widget.autoImplyLeading,
        ),
        body: TabBarAppointment(
            appointmentUpcomingList: _appointmentUpcomingList,
            appointmentTodayList: _appointmentTodayList,
            appointmentPastList: _appointmentPastList,
            onViewAppointment: _viewAppointment),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Navigate to the page where you want to appointment form
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AppointmentForm(
                  user: widget.user,
                  profile: widget.profile,
                ),
              ),
            );
          },
          icon: const Icon(Icons.event),
          label: const Text('Book New Appointment'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}

class TabBarAppointment extends StatelessWidget {
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
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  _buildAppointmentList(appointmentUpcomingList),
                  _buildAppointmentList(appointmentTodayList),
                  _buildAppointmentList(appointmentPastList),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentList(List<Appointment> appointmentList) {
    return ListView.builder(
      itemCount: appointmentList.length,
      itemBuilder: (context, index) {
        Appointment appointment = appointmentList[index];
        return Column(
          children: [
            const SizedBox(height: 12.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GestureDetector(
                onTap: () {
                  onViewAppointment(appointment);
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
                              onViewAppointment(appointment);
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
              const SizedBox(height: 77.0), // Add SizedBox after the last item
          ],
        );
      },
    );
  }
}
