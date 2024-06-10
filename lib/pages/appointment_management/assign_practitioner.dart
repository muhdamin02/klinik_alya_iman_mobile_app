// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/appointment.dart';
import '../../models/profile.dart';
import '../../models/user.dart';
import '../../services/database_service.dart';
import '../../services/misc_methods/datetime_display.dart';
import 'view_appointment.dart';

class AssignPractitioner extends StatefulWidget {
  final Appointment appointment;
  final User user;
  final int practitionerId;

  const AssignPractitioner(
      {Key? key,
      required this.appointment,
      required this.user,
      required this.practitionerId})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AssignPractitionerState createState() => _AssignPractitionerState();
}

class _AssignPractitionerState extends State<AssignPractitioner> {
  List<Appointment> _appointmentInfo = [];
  List<User> _practitionerList = [];
  String? _practitionerName;
  User? _selectedPractitioner;
  User? _selectedPractitionerAvailability;
  String? _isTimeAvailableForThisPractitionerString;

  final List<String> availableTimeSlots = [
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '01:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
    '05:00 PM',
  ];

  @override
  void initState() {
    super.initState();
    _fetchPractitioner();
    _fetchAppointmentInfo();
    _isTimeAvailableForThisPractitioner();
  }

  // ----------------------------------------------------------------------
  // Fetch details

  Future<void> _fetchPractitioner() async {
    List<User> selectedPractitionerAvailability =
        await DatabaseService().userInfo(widget.practitionerId);
    setState(() {
      if (selectedPractitionerAvailability.isNotEmpty) {
        _selectedPractitionerAvailability = selectedPractitionerAvailability[0];
      }
    });
  }

  Future<void> _fetchAppointmentInfo() async {
    List<Appointment> appointmentInfo = await DatabaseService()
        .appointmentInfo(widget.appointment.appointment_id);
    setState(() {
      _appointmentInfo = appointmentInfo;
      if (_appointmentInfo.isNotEmpty) {
        _getPractitionerName(_appointmentInfo[0].practitioner_id);
        _getPractitionerList(_appointmentInfo[0].branch);
      }
    });
  }

  // ----------------------------------------------------------------------
  // Fetch details

  Future<void> _getPractitionerList(String appointmentBranch) async {
    List<User> practitionerList =
        await DatabaseService().getPractitionersByBranch(appointmentBranch);
    setState(() {
      _practitionerList = practitionerList;
    });
  }
  //

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
  }

  // ----------------

  void _handlePractitionerSelection(
      practitionerId, Appointment appointment) async {
    String status = appointment.status;
    String remarks = appointment.system_remarks;
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
                  status = 'Assigned';
                  remarks =
                      'The appointment has been assigned to practitioner ${_selectedPractitioner?.name} at ${DateFormat('yyyy-MM-dd, h:mm a').format(DateTime.now())}.';
                  // Call the deleteAppointment method and pass the appointmentId
                  await DatabaseService().updateAppointmentStatus(
                      appointment.appointment_id!, status, remarks);
                  Navigator.pop(context);
                  // Refresh the appointment
                  setState(() {
                    _fetchAppointmentInfo();
                  });
                  final tempProfile = Profile(
                    name: 'unknown',
                    identification: 'unknown',
                    dob: 'unknown',
                    gender: 'unknown',
                    height: 0,
                    weight: 0,
                    body_fat_percentage: 0,
                    activity_level: 'unknown',
                    belly_size: 0,
                    maternity: 'No',
                    maternity_due: 'unknown',
                    ethnicity: 'unknown',
                    marital_status: 'unknown',
                    occupation: 'unknown',
                    medical_alert: 'unknown',
                    profile_pic: 'unknown',
                    creation_date: 'unknown',
                    user_id: widget.user.user_id!,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewAppointment(
                        actualUser: widget.user,
                        viewedUser: widget.user,
                        appointment: widget.appointment,
                        profile: tempProfile,
                        autoImplyLeading: false,
                        sharedAppointments: false,
                        appointmentByPractitioner: false,
                      ),
                    ),
                  );
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

  Widget _buildTimeButton(String selectedTime) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 5.0),
        child: FutureBuilder<bool>(
          future: _isPractitionerFree(widget.appointment.appointment_date,
              selectedTime, _selectedPractitionerAvailability?.user_id),
          builder: (context, snapshot) {
            final isAvailable = snapshot.data ?? false;
            return ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                fixedSize: const Size.fromHeight(50.0),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10.0), // Adjust the value as needed
                ),
                foregroundColor: const Color(0xFFC1D3FF),
                backgroundColor: isAvailable
                    ? const Color(
                        0xFFC1D3FF) // Button color when practitioner is free
                    : const Color(
                        0xFF0B1655), // Buttons when practitioner is not free
                side: BorderSide(
                  color: isAvailable
                      ? const Color(
                          0xFF1F3299) // Button outline when practitioner is free
                      : const Color(
                          0xFF303E8F), // Buttons outline when practitioner is not free
                  width: 2.0,
                ),
              ),
              child: Text(
                selectedTime,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isAvailable
                      ? const Color(
                          0xFF1F3299) // Text when practitioner is free
                      : const Color(
                          0xFF303E8F), // Text when practitioner is free not free
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Function to generate a row of time buttons
  Widget _buildTimeRow(List<String> timeSlots) {
    return Row(
      children:
          timeSlots.map((timeSlot) => _buildTimeButton(timeSlot)).toList(),
    );
  }

  // ----------------------------------------------------------------------
  // Check if TimeAvailable

  Future<bool> _isPractitionerFree(
      String selectedDate, String selectedTime, int? practitionerId) async {
    if (await DatabaseService()
        .isPractitionerFree(selectedDate, selectedTime, practitionerId)) {
      return true; // Time slot is free for practitioner
    }
    return false; // Time slot is not free for practitioner
  }

  // ----------------------------------------------------------------------
  // Check if TimeAvailable

  Future<void> _isTimeAvailableForThisPractitioner() async {
    if (await DatabaseService().isPractitionerFree(
        widget.appointment.appointment_date,
        widget.appointment.appointment_time,
        _selectedPractitionerAvailability?.user_id)) {
      _isTimeAvailableForThisPractitionerString = 'Available';
    } else {
      _isTimeAvailableForThisPractitionerString = 'Unavailable';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assign Practitioner'),
        automaticallyImplyLeading: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              ListView.builder(
                padding: const EdgeInsets.all(16.0),
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
                                  'Choose Practitioner',
                                  style: TextStyle(
                                      color: Color(0xFFEDF2FF),
                                      letterSpacing: 2),
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
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: const Color(0xFF303E8F),
                                      title: const Text('Choose Practitioner'),
                                      content: SizedBox(
                                        height: 60,
                                        child: DropdownButton<User>(
                                          dropdownColor:
                                              const Color(0xFF303E8F),
                                          value: _selectedPractitioner,
                                          items: _practitionerList
                                              .map((User user) {
                                            return DropdownMenuItem<User>(
                                              value: user,
                                              child: Container(
                                                constraints:
                                                    const BoxConstraints(
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
                                              _selectedPractitionerAvailability =
                                                  newValue;
                                              _getPractitionerName(
                                                  newValue!.user_id);
                                              // _handlePractitionerSelection(
                                              //     _selectedPractitioner!.user_id,
                                              //     appointment);
                                            });
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                    0xFF4151B1), // Background color of the ElevatedButton
                                elevation:
                                    0, // Set the elevation for the button
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20.0), // Adjust the radius
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(28.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'PRACTITIONER',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Color(0xFFB6CBFF),
                                      ),
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
                        const SizedBox(height: 32.0),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Divider(
                                  color: Color(0xFFB6CBFF),
                                  height: 1,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  'Availability for ${DateTimeDisplay(datetime: appointment.appointment_date).getStringDate()}',
                                  style: const TextStyle(
                                      color: Color(0xFFEDF2FF),
                                      letterSpacing: 2),
                                ),
                              ),
                              const Expanded(
                                child: Divider(
                                  color: Color(0xFFB6CBFF),
                                  height: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        _buildTimeRow(['09:00 AM', '10:00 AM', '11:00 AM']),
                        _buildTimeRow(['12:00 PM', '01:00 PM', '02:00 PM']),
                        _buildTimeRow(['03:00 PM', '04:00 PM', '05:00 PM']),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                    0xFF4151B1), // Background color of the ElevatedButton
                                elevation:
                                    0, // Set the elevation for the button
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20.0), // Adjust the radius
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(28.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'AVAILABILITY FOR ${appointment.appointment_time}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Color(0xFFB6CBFF),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '$_isTimeAvailableForThisPractitionerString',
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
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          Positioned(
            bottom: 24.0,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 34, // Adjust padding
                child: FloatingActionButton.extended(
                  onPressed: () {
                    if (_selectedPractitioner == null) {
                      final tempProfile = Profile(
                        name: 'unknown',
                        identification: 'unknown',
                        dob: 'unknown',
                        gender: 'unknown',
                        height: 0,
                        weight: 0,
                        body_fat_percentage: 0,
                        activity_level: 'unknown',
                        belly_size: 0,
                        maternity: 'No',
                        maternity_due: 'unknown',
                        ethnicity: 'unknown',
                        marital_status: 'unknown',
                        occupation: 'unknown',
                        medical_alert: 'unknown',
                        profile_pic: 'unknown',
                        creation_date: 'unknown',
                        user_id: widget.user.user_id!,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewAppointment(
                            actualUser: widget.user,
                            viewedUser: widget.user,
                            appointment: widget.appointment,
                            profile: tempProfile,
                            autoImplyLeading: false,
                            sharedAppointments: false,
                            appointmentByPractitioner: false,
                          ),
                        ),
                      );

                      // Navigate to the page where you want to appointment form
                    } else {
                      _handlePractitionerSelection(
                          _selectedPractitioner!.user_id, widget.appointment);
                    }
                  },
                  icon: const Icon(Icons.person_add_rounded),
                  label: const Text('Assign'),
                  elevation: 0,
                  backgroundColor:
                      const Color(0xFFC1D3FF), // Set background color here
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(25), // Adjust the border radius
                    side: const BorderSide(
                        width: 2.5,
                        color: Color(0xFF6086f6)), // Set the outline color here
                  ),
                  foregroundColor:
                      const Color(0xFF1F3299), // Set text and icon color here
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
