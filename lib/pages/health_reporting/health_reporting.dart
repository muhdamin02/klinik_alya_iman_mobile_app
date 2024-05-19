// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import '../../models/profile.dart';
import '../../models/user.dart';
import '../../services/database_service.dart';
import '../../services/misc_methods/save_pdf.dart';

class HealthReportingPage extends StatefulWidget {
  final User user;
  final Profile profile;

  const HealthReportingPage(
      {Key? key, required this.user, required this.profile})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HealthReportingPageState createState() => _HealthReportingPageState();
}

class _HealthReportingPageState extends State<HealthReportingPage> {
  int _appointmentsAttend = 0;
  int _appointmentsAbsent = 0;
  int _totalAppointments = 0;
  double _appointmentAttendancePercentage = 0.0;

  @override
  void initState() {
    super.initState();
    _calculateAppointmentAttendance();
  }

  // ----------------------------------------------------------------------
  // Fetch details

  Future<void> _calculateAppointmentAttendance() async {
    int appointmentsAttend = await DatabaseService()
        .getAppointmentCountStatus(widget.profile.profile_id, 'Attended');
    int appointmentsAbsent = await DatabaseService()
        .getAppointmentCountStatus(widget.profile.profile_id, 'Absent');

    int totalAppointments = appointmentsAttend + appointmentsAbsent;
    double appointmentAttendancePercentage = 0.0;

    if (totalAppointments > 0) {
      appointmentAttendancePercentage = double.parse(
          ((appointmentsAttend / totalAppointments) * 100).toStringAsFixed(2));
    } else {
      appointmentAttendancePercentage = 0.0;
    }
    setState(() {
      _appointmentsAttend = appointmentsAttend;
      _appointmentsAbsent = appointmentsAbsent;
      _totalAppointments = totalAppointments;
      _appointmentAttendancePercentage = appointmentAttendancePercentage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Appointment'),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.download_rounded),
            onPressed: () async {
              generateAndSavePDF(context);
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        shrinkWrap: true,
        itemCount: 1,
        itemBuilder: (context, index) {
          return SizedBox(
            width:
                MediaQuery.of(context).size.width, // Set width to screen width
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Color(0xFFB6CBFF),
                          height: 1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'Appointment',
                          style: TextStyle(
                            color: Color(0xFFEDF2FF),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Color(0xFFB6CBFF),
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: double.infinity, // Adjust padding as needed
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                            0xFF303E8F), // Background color of the ElevatedButton
                        elevation: 0, // Set the elevation for the button
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20.0), // Adjust the radius
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Handle onTap action here
                              },
                              child: const Text(
                                'APPOINTMENT ATTENDANCE',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Color(0xFFB6CBFF),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$_appointmentAttendancePercentage%',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 42,
                                color: Color(0xFFEDF2FF),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: double.infinity, // Adjust padding as needed
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20.0), // Adjust the radius
                          ),
                          elevation: 0, // Set the elevation for the card
                          color: const Color(0xFF3848A1),
                          child: Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Handle onTap action here
                                  },
                                  child: const Text(
                                    'ATTENDED',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Color(0xFFB6CBFF),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '$_appointmentsAttend',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 24,
                                    color: Color(0xFFEDF2FF),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity, // Adjust padding as needed
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20.0), // Adjust the radius
                          ),
                          elevation: 0, // Set the elevation for the card
                          color: const Color(0xFF3848A1),
                          child: Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Handle onTap action here
                                  },
                                  child: const Text(
                                    'ABSENT',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Color(0xFFB6CBFF),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '$_appointmentsAbsent',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 24,
                                    color: Color(0xFFEDF2FF),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 36),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Color(0xFFB6CBFF),
                          height: 1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'Medication',
                          style: TextStyle(
                            color: Color(0xFFEDF2FF),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Color(0xFFB6CBFF),
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: double.infinity, // Adjust padding as needed
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                            0xFF303E8F), // Background color of the ElevatedButton
                        elevation: 0, // Set the elevation for the button
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20.0), // Adjust the radius
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Handle onTap action here
                              },
                              child: const Text(
                                'MEDICATION ADHERENCE',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Color(0xFFB6CBFF),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '???%',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 42,
                                color: Color(0xFFEDF2FF),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: double.infinity, // Adjust padding as needed
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20.0), // Adjust the radius
                          ),
                          elevation: 0, // Set the elevation for the card
                          color: const Color(0xFF3848A1),
                          child: Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Handle onTap action here
                                  },
                                  child: const Text(
                                    'ADHERED',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Color(0xFFB6CBFF),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '???',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 24,
                                    color: Color(0xFFEDF2FF),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity, // Adjust padding as needed
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20.0), // Adjust the radius
                          ),
                          elevation: 0, // Set the elevation for the card
                          color: const Color(0xFF3848A1),
                          child: Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Handle onTap action here
                                  },
                                  child: const Text(
                                    'NON-ADHERED',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Color(0xFFB6CBFF),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '???',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 24,
                                    color: Color(0xFFEDF2FF),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
