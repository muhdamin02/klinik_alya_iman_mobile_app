// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../models/appointment.dart';
import '../../models/user.dart';
import '../../services/database_service.dart';
import '../../services/misc_methods/date_display.dart';
import '../../services/misc_methods/show_hovering_message.dart';
import 'update_appointment.dart';

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
  List<User> _practitionerList = [];
  String? _patientName, _practitionerName;
  User? _selectedPractitioner;

  @override
  void initState() {
    super.initState();
    _fetchAppointmentInfo();
    _loadPatientName();
    _getPractitionerList();
  }

  // ----------------------------------------------------------------------
  // Fetch details

  Future<void> _fetchAppointmentInfo() async {
    List<Appointment> appointmentInfo = await DatabaseService()
        .appointmentInfo(widget.appointment.appointment_id);
    setState(() {
      _appointmentInfo = appointmentInfo;
      if (_appointmentInfo.isNotEmpty) {
        // Call _getPractitionerName with the practitioner_id from the first appointment in the list
        _getPractitionerName(_appointmentInfo[0].practitioner_id);
      }
    });
  }
  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Fetch details

  Future<void> _getPractitionerList() async {
    List<User> practitionerList = await DatabaseService().getPractitionerDDL();
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
  // load practitioner name
  Future<void> _getPractitionerName(practitionerId) async {
    if (practitionerId != 0) {
      String? practitionerName =
          await DatabaseService().getUserName(practitionerId);
      setState(() {
        _practitionerName = practitionerName;
      });
    } else {
      setState(() {
        _practitionerName = 'Not yet assigned';
      });
    }
    setState(() {});
  }
  // ----------------------------------------------------------------------

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
                remarks = 'The appointment has been confirmed.';
                // Call the deleteAppointment method and pass the appointmentId
                await DatabaseService().updateAppointmentStatus(
                    appointment.appointment_id!, status, remarks);
                Navigator.of(context).pop();
                // Refresh the appointment
                _fetchAppointmentInfo();
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
      barrierDismissible: false,
    );
  }

  void _leaveRemarks(Appointment appointment) async {
    TextEditingController remarksController = TextEditingController();
    final int? appointmentId = appointment.appointment_id;
    String userRemarks;
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF303E8F),
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
                        hintStyle: TextStyle(color: Color(0xFFB6CBFF)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color(
                                  0xFFB6CBFF)), // Set the color of the underline
                        ),
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
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  if (widget.user.role.toLowerCase() == 'patient') {
                    userRemarks = remarksController.text;
                    await DatabaseService()
                        .leaveRemarksAsPatient(appointmentId!, userRemarks);
                  } else if (widget.user.role.toLowerCase() == 'practitioner') {
                    userRemarks = remarksController.text;
                    await DatabaseService().leaveRemarksAsPractitioner(
                        appointmentId!, userRemarks);
                  } else {
                    return;
                  }
                  Navigator.pop(context); // Close the dialog
                  _fetchAppointmentInfo();
                }
              },
              child: const Text('Confirm',
                  style: TextStyle(color: Color(0xFFEDF2FF))),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel',
                  style: TextStyle(color: Color(0xFFEDF2FF))),
            ),
          ],
        );
      },
      barrierDismissible: false,
    );
  }

  void _handlePractitionerSelection(practitionerId) async {
    print(
        'Selected Practitioner: ${_selectedPractitioner?.user_id} ${_selectedPractitioner?.name}');

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF303E8F),
          title: const Text('Assign Practitioner',
              style: TextStyle(color: Color(0xFFFFD271))),
          content: Builder(
            builder: (BuildContext context) {
              return Text(
                  'Are you sure you want to assign ${_selectedPractitioner?.name} to this appointment?',
                  style: const TextStyle(height: 1.5));
            },
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () async {
                  await DatabaseService().assignAppointmentPractitioner(
                      widget.appointment.appointment_id!, practitionerId);
                  Navigator.pop(context);
                  _fetchAppointmentInfo();
                },
                child: const Text('Confirm',
                    style: TextStyle(color: Color(0xFFEDF2FF)))),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Cancel',
                    style: TextStyle(color: Color(0xFFEDF2FF)))),
          ],
        );
      },
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Appointment'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        shrinkWrap: true,
        itemCount: _appointmentInfo.length,
        itemBuilder: (context, index) {
          Appointment appointment = _appointmentInfo[index];
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
                          'Reference Number',
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
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: appointment.random_id));
                        showHoveringMessage(
                            context, 'Copied to clipboard', 0.19, 0.25, 0.5);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                            0xFF2B3885), // Background color of the ElevatedButton
                        elevation: 0, // Set the elevation for the button
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20.0), // Adjust the radius
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              appointment.random_id,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 24,
                                letterSpacing: 8,
                                color: Color(0xFFFFD271),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32.0),
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
                          'Appointment Details',
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
                const SizedBox(height: 16.0),
                SizedBox(
                  width: double.infinity, // Adjust padding as needed
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20.0), // Adjust the radius
                    ),
                    elevation: 0, // Set the elevation for the card
                    color: const Color(0xFF303E8F),
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
                              "PATIENT",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xFFB6CBFF),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$_patientName',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color(0xFFEDF2FF),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
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
                                    "DATE",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Color(0xFFB6CBFF),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  DateDisplay(
                                          date: appointment.appointment_date)
                                      .getStringDate(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
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
                                    "TIME",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Color(0xFFB6CBFF),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  appointment.appointment_time,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
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
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (widget.user.role.toLowerCase() == 'systemadmin') {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: const Color(0xFF303E8F),
                                title: const Text('Choose Practitioner'),
                                content: SizedBox(
                                  height: 60,
                                  child: DropdownButton<User>(
                                    dropdownColor: const Color(0xFF303E8F),
                                    value: _selectedPractitioner,
                                    items: _practitionerList.map((User user) {
                                      return DropdownMenuItem<User>(
                                        value: user,
                                        child: Container(
                                          constraints: const BoxConstraints(
                                            maxWidth:
                                                200, // Adjust the maxWidth as needed
                                          ),
                                          child: Text(
                                            user.name,
                                            style: const TextStyle(
                                              color: Color(0xFFEDF2FF),
                                            ),
                                            softWrap:
                                                true, // Allows text to wrap to the next line
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (User? newValue) {
                                      setState(() {
                                        Navigator.of(context).pop();
                                        _selectedPractitioner = newValue;
                                        _handlePractitionerSelection(
                                            _selectedPractitioner!.user_id);
                                      });
                                    },
                                  ),
                                ),
                                // actions: <Widget>[
                                //   TextButton(
                                //     onPressed: () async {
                                //       Navigator.of(context).pop();
                                //       _handlePractitionerSelection(
                                //           _selectedPractitioner!.user_id);
                                //     },
                                //     child: const Text('Yes',
                                //         style: TextStyle(
                                //             color: Color(0xFFEDF2FF))),
                                //   ),
                                //   TextButton(
                                //     onPressed: () {
                                //       Navigator.of(context).pop();
                                //     },
                                //     child: const Text('No',
                                //         style: TextStyle(
                                //             color: Color(0xFFEDF2FF))),
                                //   ),
                                // ],
                              );
                            },
                          );
                        } else {
                          if (_practitionerName == 'Not yet assigned') {
                            showHoveringMessage(
                                context,
                                'The practitioner has not been assigned yet',
                                0.82,
                                0.15,
                                0.7);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                            0xFF4151B1), // Background color of the ElevatedButton
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
                            Row(
                              mainAxisSize:
                                  MainAxisSize.min, // Center the Row content
                              children: [
                                const Text(
                                  'PRACTITIONER',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Color(0xFFB6CBFF),
                                  ),
                                ),
                                Visibility(
                                  visible: widget.user.role.toLowerCase() ==
                                      'systemadmin',
                                  child: const SizedBox(width: 8.0),
                                ),
                                Visibility(
                                  visible: widget.user.role.toLowerCase() ==
                                      'systemadmin',
                                  child: const Icon(
                                    Icons.edit,
                                    color: Color(0xFFFFD271),
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$_practitionerName',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
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
                                  child: Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          "STATUS",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: Color(0xFFB6CBFF),
                                          ),
                                        ),
                                        Visibility(
                                          visible:
                                              widget.user.role.toLowerCase() ==
                                                  'systemadmin',
                                          child: const SizedBox(width: 8.0),
                                        ),
                                        Visibility(
                                          visible:
                                              widget.user.role.toLowerCase() ==
                                                  'systemadmin',
                                          child: const Icon(
                                            Icons.edit,
                                            color: Color(0xFFFFD271),
                                            size: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  appointment.status,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
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
                                    "BRANCH",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Color(0xFFB6CBFF),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  appointment.branch,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
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
                const SizedBox(height: 4),
                SizedBox(
                  width: double.infinity, // Adjust padding as needed
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20.0), // Adjust the radius
                    ),
                    elevation: 0, // Set the elevation for the card
                    color: const Color(0xFF303E8F),
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
                              'REMARKS BY SYSTEM',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xFFB6CBFF),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            appointment.system_remarks,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color(0xFFEDF2FF),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: double.infinity, // Adjust padding as needed
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20.0), // Adjust the radius
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
                              'REMARKS BY PATIENT',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xFFB6CBFF),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            appointment.patient_remarks,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color(0xFFEDF2FF),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: double.infinity, // Adjust padding as needed
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20.0), // Adjust the radius
                    ),
                    elevation: 0, // Set the elevation for the card
                    color: const Color(0xFF4151B1),
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
                              'REMARKS BY PRACTITIONER',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xFFB6CBFF),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            appointment.practitioner_remarks,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color(0xFFEDF2FF),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32.0),
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
                          'Actions',
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
                if (widget.user.role.toLowerCase() != 'systemadmin')
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: SizedBox(
                      height: 80.0,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _leaveRemarks(widget.appointment);
                        },
                        style: OutlinedButton.styleFrom(
                          elevation: 0,
                          backgroundColor:
                              const Color(0xFFDBE5FF), // Set the fill color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                50.0), // Adjust the value as needed
                          ),
                          side: const BorderSide(
                            color: Color(0xFF6086f6), // Set the outline color
                            width: 2.5, // Set the outline width
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(
                                  12.0), // Adjust padding as needed
                              child: Icon(
                                Icons.rate_review, // Use any icon you want
                                color: Color(0xFF1F3299),
                                size: 28,
                              ),
                            ),
                            Spacer(), // Adjust the spacing between icon and text
                            Text(
                              'Leave Remarks',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF1F3299),
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: EdgeInsets.all(
                                  12.0), // Adjust padding as needed
                              child: Icon(
                                Icons.rate_review, // Use any icon you want
                                color: Color(0xFF1F3299),
                                size: 28,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: SizedBox(
                    height: 80.0,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _leaveRemarks(widget.appointment);
                      },
                      style: OutlinedButton.styleFrom(
                        elevation: 0,
                        backgroundColor:
                            const Color(0xFF0B1655), // Set the fill color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              50.0), // Adjust the value as needed
                        ),
                        side: const BorderSide(
                          color: Color(0xFFC1D3FF), // Set the outline color
                          width: 3, // Set the outline width
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(
                                12.0), // Adjust padding as needed
                            child: Icon(
                              Icons.highlight_off, // Use any icon you want
                              color: Color(0xFFC1D3FF),
                              size: 28,
                            ),
                          ),
                          Spacer(), // Adjust the spacing between icon and text
                          Text(
                            'Cancel Appointment',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFC1D3FF),
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.all(
                                12.0), // Adjust padding as needed
                            child: Icon(
                              Icons.highlight_off, // Use any icon you want
                              color: Color(0xFFC1D3FF),
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
      // floatingActionButton: Column(
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   children: [
      //     Visibility(
      //       visible: widget.user.role.toLowerCase() != 'patient' &&
      //           widget.appointment.status != 'Confirmed',
      //       child: FloatingActionButton.extended(
      //         onPressed: () {
      //           _confirmAppointment(widget.appointment);
      //         },
      //         icon: const Icon(Icons.check),
      //         label: const Text('Confirm'),
      //       ),
      //     ),
      //     const SizedBox(height: 8),
      //     Visibility(
      //       visible: widget.user.role.toLowerCase() != 'patient',
      //       child: FloatingActionButton.extended(
      //         onPressed: () {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) => UpdateAppointment(
      //                 appointment: widget.appointment,
      //                 rescheduler: widget.user.role,
      //               ),
      //             ),
      //           ).then((result) {
      //             if (result == true) {
      //               // If the appointment was updated, refresh the appointment list
      //               _fetchAppointmentInfo();
      //               _loadPatientName();
      //               _getPractitionerList();
      //             }
      //           });
      //         },
      //         icon: const Icon(Icons.edit),
      //         label: const Text('Reschedule'),
      //       ),
      //     ),
      //     const SizedBox(height: 8),
      //     Visibility(
      //       visible: widget.user.role.toLowerCase() != 'systemadmin',
      //       child: FloatingActionButton.extended(
      //         onPressed: () {
      //           _leaveRemarks(widget.appointment);
      //         },
      //         icon: const Icon(Icons.rate_review),
      //         label: const Text('Leave Remarks'),
      //       ),
      //     ),
      //   ],
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
