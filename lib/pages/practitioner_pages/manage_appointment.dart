import 'package:flutter/material.dart';

class ManageAppointment extends StatelessWidget {
  const ManageAppointment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Appointments'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Manage Appointment Page Placeholder',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            Icon(
              Icons.date_range,
              size: 50,
            ),
          ],
        ),
      ),
    );
  }
}
