import 'package:klinik_alya_iman_mobile_app/models/profile.dart';
import 'package:klinik_alya_iman_mobile_app/pages/appointment_management/update_appointment.dart';
import 'package:flutter/material.dart';
import 'package:klinik_alya_iman_mobile_app/models/appointment.dart';
import 'package:klinik_alya_iman_mobile_app/services/database_service.dart';

class ListAppointment extends StatefulWidget {
  final int userId;
  final Profile profile;

  const ListAppointment({super.key, required this.userId, required this.profile});

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
    List<Appointment> bookingHistory =
        await DatabaseService().appointment(widget.userId, widget.profile.profile_id);
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
  // Delete Booking

  void _deleteAppointment(int? appointmentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Appointment (ID: $appointmentId)'),
          content: const Text('Are you sure you want to delete this appointment?'),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment History',
            style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: ListView.builder(
        itemCount: _bookingHistory.length,
        itemBuilder: (context, index) {
          Appointment appointment = _bookingHistory[index];
          return Column(
            children: [
              const SizedBox(height: 16.0), // Add SizedBox widget here
              ListTile(
                title: Text('Appointment ID: ${appointment.appointment_id}', style: const TextStyle(fontSize: 20)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4.0),
                    Text('Appointment Date: ${appointment.appointment_date}'),
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
    );
  }

  // ----------------------------------------------------------------------
}