import 'package:flutter/material.dart';

import '../../models/appointment.dart';
import '../../models/user.dart';
import '../../services/database_service.dart';
import '../../services/misc_methods/date_display.dart';
import '../appointment_management/update_appointment.dart';
import '../appointment_management/view_appointment.dart';

class ManageAppointment extends StatefulWidget {
  final User user;
  final bool autoImplyLeading;

  const ManageAppointment(
      {super.key, required this.user, required this.autoImplyLeading});

  @override
  // ignore: library_private_types_in_public_api
  _ManageAppointmentState createState() => _ManageAppointmentState();
}

class _ManageAppointmentState extends State<ManageAppointment> {
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
        ),
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
        return widget.autoImplyLeading;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Appointment List',
            style: TextStyle(color: Colors.white),
          ),
          automaticallyImplyLeading: widget.autoImplyLeading,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
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
