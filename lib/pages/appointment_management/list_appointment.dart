import 'package:flutter/material.dart';

import '../../appbar/appbar_appointment.dart';
import '../../models/appointment.dart';
import '../../models/profile.dart';
import '../../services/database_service.dart';
import 'update_appointment.dart';


class ListAppointment extends StatefulWidget {
  final int userId;
  final Profile profile;
  final bool autoImplyLeading;

  const ListAppointment(
      {super.key,
      required this.userId,
      required this.profile,
      required this.autoImplyLeading});

  @override
  // ignore: library_private_types_in_public_api
  _ListAppointmentState createState() => _ListAppointmentState();
}

class _ListAppointmentState extends State<ListAppointment> {
  List<Appointment> _bookingHistory = [];

  @override
  void initState() {
    super.initState();
    _fetchBookingHistory();
  }

  // ----------------------------------------------------------------------
  // View list of booking

  Future<void> _fetchBookingHistory() async {
    List<Appointment> bookingHistory = await DatabaseService()
        .appointment(widget.userId, widget.profile.profile_id);
    setState(() {
      _bookingHistory = bookingHistory;
    });
  }
  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Update Booking

  void _updateAppointment(Appointment appointment) {
    // Navigate to the update booking page with the selected booking
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateBookingPage(appointment: appointment),
      ),
    ).then((result) {
      if (result == true) {
        // If the booking was updated, refresh the booking history
        _fetchBookingHistory();
      }
    });
  }

  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Cancel Booking

  void _cancelAppointment(Appointment appointment) {
    TextEditingController cancellationReasonController =
        TextEditingController();
    final int? appointmentId = appointment.appointment_id;
    String status = appointment.status;
    String remarks = appointment.remarks;
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
                  remarks = cancellationReasonController.text;
                  await DatabaseService()
                      .cancelAppointment(appointmentId!, status, remarks);
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                  _fetchBookingHistory();
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
  // Delete Booking

  void _deleteAppointment(int? appointmentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Appointment (ID: $appointmentId)'),
          content:
              const Text('Are you sure you want to delete this appointment?'),
          actions: <Widget>[
            ElevatedButton(
              child:
                  const Text('Delete', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                // Call the deleteAppointment method and pass the appointmentId
                await DatabaseService().deleteAppointment(appointmentId!);
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

  // ----------------------------------------------------------------------
  // Builder

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return widget.autoImplyLeading;
      },
      child: Scaffold(
        appBar: AlyaImanAppBarAppointment(
          title: 'Appointment History',
          profile: widget.profile,
          autoImplyLeading: widget.autoImplyLeading,
        ),
        body: ListView.builder(
          itemCount: _bookingHistory.length,
          itemBuilder: (context, index) {
            Appointment appointment = _bookingHistory[index];
            return Column(
              children: [
                const SizedBox(height: 16.0),
                ListTile(
                  title: Text('Appointment ID: ${appointment.appointment_id}',
                      style: const TextStyle(fontSize: 20)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4.0),
                      Text('Appointment Date: ${appointment.appointment_date}'),
                      Text('Appointment Status: ${appointment.status}'),
                      Text('Appointment Remarks: ${appointment.remarks}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // Call a method to handle the update functionality
                          _updateAppointment(appointment);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          // Call a method to handle the cancel functionality
                          _cancelAppointment(appointment);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          // Call a method to handle the delete functionality
                          _deleteAppointment(appointment.appointment_id);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------
}
