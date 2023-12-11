import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import '../../models/appointment.dart';
import '../../services/misc_methods/date_display.dart';

class ViewAppointment extends StatelessWidget {
  final Appointment appointment;

  const ViewAppointment({Key? key, required this.appointment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Parse the appointment date string to DateTime
    DateTime appointmentDate = DateTime.parse(appointment.appointment_date);

    // Format the date to the desired format

    // Get the day of the week
    String dayOfWeek = DateFormat('EEEE').format(appointmentDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('View Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Appointment Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                const Text('Date: '),
                DateDisplay(date: appointment.appointment_date),
                Text(' ($dayOfWeek)'),
              ],
            ),
            Text('Status: ${appointment.status}'),
            Text('Remarks: ${appointment.remarks}'),
            // Add more details specific to the appointment
          ],
        ),
      ),
    );
  }
}
