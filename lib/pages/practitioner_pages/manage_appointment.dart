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

// ----------------------------------------------------------------------

class _ManageAppointmentState extends State<ManageAppointment> {
  List<Appointment> _bookingHistory = [];

  @override
  void initState() {
    super.initState();
    _fetchBookingHistory();
  }

  // ----------------------------------------------------------------------
  // View list of appointments

  Future<void> _fetchBookingHistory() async {
    List<Appointment> bookingHistory = await DatabaseService().appointmentAll();
    setState(() {
      _bookingHistory = bookingHistory;
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
        builder: (context) => ViewAppointment(appointment: appointment, user: widget.user,),
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
        builder: (context) => UpdateAppointment(appointment: appointment, reschedulerIsPatient: false,),
      ),
    ).then((result) {
      if (result == true) {
        // If the appointment was updated, refresh the appointment history
        _fetchBookingHistory();
      }
    });
  }

  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Confirm Appointment

  void _confirmAppointment(Appointment appointment) {
    String status = appointment.status;
    String remarks = appointment.system_remarks;
    String practitionerName = '${widget.user.f_name} ${widget.user.l_name}';

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
                _fetchBookingHistory();
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
    // Sort the _bookingHistory list by appointment date
    _bookingHistory
        .sort((a, b) => a.appointment_date.compareTo(b.appointment_date));

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
        body: Stack(
          children: [
            ListView.builder(
              itemCount: _bookingHistory.length,
              itemBuilder: (context, index) {
                Appointment appointment = _bookingHistory[index];
                return Column(
                  children: [
                    const SizedBox(height: 16.0),
                    ListTile(
                      title: DateDisplay(date: appointment.appointment_date),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4.0),
                          Text('Status: ${appointment.status}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.visibility),
                            onPressed: () {
                              // Call a method to handle the update functionality
                              _viewAppointment(appointment);
                            },
                          ),
                          Visibility(
                            visible: appointment.status != 'Cancelled',
                            child: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                // Call a method to handle the update functionality
                                _updateAppointment(appointment);
                              },
                            ),
                          ),
                          Visibility(
                            visible: appointment.status != 'Cancelled' && appointment.status != 'Confirmed',
                            child: IconButton(
                              icon: const Icon(Icons.thumb_up),
                              onPressed: () {
                                // Call a method to handle the update functionality
                                _confirmAppointment(appointment);
                              },
                            ),
                          ),
                          Visibility(
                            visible: appointment.status != 'Cancelled',
                            child: IconButton(
                              icon: const Icon(Icons.not_interested_rounded),
                              onPressed: () {
                                // Call a method to handle the cancel functionality
                                // _cancelAppointment(appointment);
                              },
                            ),
                          ),
                          Visibility(
                            visible: appointment.status == 'Cancelled',
                            child: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                // Call a method to handle the delete functionality
                                // _deleteAppointment(appointment.appointment_id);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            // Positioned(
            //   bottom: 32.0,
            //   right: 32.0,
            //   child: FloatingActionButton(
            //     onPressed: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => AppointmentForm(
            //             user: widget.user,
            //             profile: widget.profile,
            //           ),
            //         ),
            //       );
            //     },
            //     child: const Icon(Icons.add),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
