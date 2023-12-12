// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/appointment.dart';
import '../../models/user.dart';
import '../../services/database_service.dart';
import '../../services/misc_methods/date_display.dart';

class ViewAppointment extends StatefulWidget {
  final Appointment appointment;
  final User user;

  const ViewAppointment(
      {Key? key, required this.appointment, required this.user})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ViewAppointmentState createState() => _ViewAppointmentState();
}

class _ViewAppointmentState extends State<ViewAppointment> {
  List<Appointment> _appointmentInfo = [];

  @override
  void initState() {
    super.initState();
    _fetchAppointmentInfo();
  }

  // ----------------------------------------------------------------------
  // Fetch details

  Future<void> _fetchAppointmentInfo() async {
    List<Appointment> appointmentInfo = await DatabaseService()
        .appointmentInfo(widget.appointment.appointment_id);
    setState(() {
      _appointmentInfo = appointmentInfo;
    });
  }
  // ----------------------------------------------------------------------

  void _leaveRemarks(Appointment appointment) async {
    TextEditingController remarksController = TextEditingController();
    final int? appointmentId = appointment.appointment_id;
    String userRemarks;
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Leave Remarks'),
          content: Builder(
            builder: (BuildContext context) {
              return Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: remarksController,
                      decoration: const InputDecoration(
                        hintText: 'Enter remarks...',
                      ),
                      style: const TextStyle(fontSize: 15),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter remarks.';
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
                  if (widget.user.role.toLowerCase() == 'patient') {
                    userRemarks = remarksController.text;
                    await DatabaseService()
                        .leaveRemarksAsPatient(appointmentId!, userRemarks);
                  } else {
                    userRemarks = remarksController.text;
                    await DatabaseService().leaveRemarksAsPractitioner(
                        appointmentId!, userRemarks);
                  }
                  Navigator.pop(context); // Close the dialog
                  _fetchAppointmentInfo();
                }
              },
              child: const Text('Confirm'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime appointmentDate =
        DateTime.parse(widget.appointment.appointment_date);
    String dayOfWeek = DateFormat('EEEE').format(appointmentDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('View Appointment'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Appointment Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              // Display appointment details using ListView.builder
              ListView.builder(
                shrinkWrap: true,
                itemCount: _appointmentInfo.length,
                itemBuilder: (context, index) {
                  Appointment appointment = _appointmentInfo[index];
                  return SizedBox(
                    width: MediaQuery.of(context)
                        .size
                        .width, // Set width to screen width
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('Date: '),
                            DateDisplay(
                                date: appointment.appointment_date),
                            Text(' ($dayOfWeek)'),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Text('Status: ${appointment.status}'),
                        const SizedBox(height: 12.0),
                        Text(
                            'System-generated Remarks: \n${appointment.system_remarks}'),
                        const SizedBox(height: 12.0),
                        Text(
                            'Patient Remarks: \n${appointment.patient_remarks}'),
                        const SizedBox(height: 12.0),
                        Text(
                            'Practitioner Remarks: \n${appointment.practitioner_remarks}'),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _leaveRemarks(widget.appointment);
        },
        icon: const Icon(Icons.rate_review),
        label: const Text('Leave Remarks'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
