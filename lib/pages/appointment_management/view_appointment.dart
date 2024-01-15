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
  List<String> _practitionerList = [];
  String? _patientName, _practitionerName;
  String? _selectedPractitioner;

  @override
  void initState() {
    super.initState();
    _fetchAppointmentInfo();
    _loadPatientName();
    _getPractitionerName();
    _getPractitionerList();
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

  // ----------------------------------------------------------------------
  // Fetch details

  Future<void> _getPractitionerList() async {
    List<String> practitionerList =
        await DatabaseService().getPractitionerDDL();
    setState(() {
      _practitionerList = practitionerList;
    });
  }
  //

  // ----------------------------------------------------------------------
  // load patient name
  Future<void> _loadPatientName() async {
    _patientName =
        await DatabaseService().getPatientName(widget.appointment.profile_id);
    setState(() {}); // Update the UI to display the patient name
  }
  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // load patient name
  Future<void> _getPractitionerName() async {
    _practitionerName =
        await DatabaseService().getUserName(widget.appointment.practitioner_id);
    setState(() {});
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
        title: const Text('Appointment Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                        const Text('PATIENT NAME',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 121, 121, 121))),
                        const SizedBox(height: 4),
                        Text('$_patientName'),
                        const SizedBox(height: 24),
                        const Text('APPOINTMENT DATE',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 121, 121, 121))),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            DateDisplay(date: appointment.appointment_date),
                            Text(' ($dayOfWeek)'),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Text('APPOINTMENT TIME',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 121, 121, 121))),
                        const SizedBox(height: 4),
                        Text(appointment.appointment_time),
                        const SizedBox(height: 24),
                        const Text('STATUS',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 121, 121, 121))),
                        const SizedBox(height: 4),
                        Text(appointment.status),
                        const SizedBox(height: 24),
                        const Text('REFERENCE NUMBER',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 121, 121, 121))),
                        const SizedBox(height: 4),
                        Text(appointment.random_id),
                        const SizedBox(height: 24),
                        const Text('PRACTITIONER',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 121, 121, 121))),
                        const SizedBox(height: 4),
                        Text('$_practitionerName'),
                        const SizedBox(height: 24),
                        const Text('SYSTEM-GENERATED REMARKS',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 121, 121, 121))),
                        const SizedBox(height: 4),
                        Text(appointment.system_remarks),
                        const SizedBox(height: 24),
                        const Text('PATIENT REMARKS',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 121, 121, 121))),
                        const SizedBox(height: 4),
                        Text(appointment.patient_remarks),
                        const SizedBox(height: 24),
                        const Text('PRACTITIONER REMARKS',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 121, 121, 121))),
                        const SizedBox(height: 4),
                        Text(appointment.practitioner_remarks),
                        const SizedBox(height: 24),
                        const Text('Practitioner in Charge:'),
                        DropdownButton<String>(
                          value: _selectedPractitioner,
                          items: _practitionerList.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedPractitioner = newValue;
                            });
                          },
                        ),
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
