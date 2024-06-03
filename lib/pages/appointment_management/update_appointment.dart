// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';

import '../../models/appointment.dart';
import '../../services/database_service.dart';
import '../../services/misc_methods/date_display.dart';

class UpdateAppointment extends StatefulWidget {
  final Appointment appointment;
  final String rescheduler;
  final int appointmentBranch;

  const UpdateAppointment(
      {Key? key,
      required this.appointment,
      required this.rescheduler,
      required this.appointmentBranch})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UpdateAppointmentState createState() => _UpdateAppointmentState();
}

class _UpdateAppointmentState extends State<UpdateAppointment> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _appointmentDateController =
      TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isDateSelected = false;
  String _selectedTime = '';
  int _selectedBranch = -1;
  String _selectedBranchString = '';

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

  // List<bool> _selectedFlowerTypes = List.filled(5, false);
  // String? _selectedArrangement;

  @override
  void initState() {
    super.initState();
    // Initialize the text controllers with the existing values
    _isDateSelected = true;
    _appointmentDateController.text = widget.appointment.appointment_date;
    _selectedTime = widget.appointment.appointment_time;
    _selectedBranch = widget.appointmentBranch;
    switch (_selectedBranch) {
      case 0:
        _selectedBranchString = 'Karang Darat';
        break;
      case 1:
        _selectedBranchString = 'Inderapura';
        break;
      case 2:
        _selectedBranchString = 'Kemaman';
        break;
      default:
        _selectedBranchString = 'Unknown';
        break;
    }
  }

  // ----------------------------------------------------------------------
  // Dispose

  @override
  void dispose() {
    _appointmentDateController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _onBranchPressed(int index) {
    setState(() {
      _selectedBranch = index;
      switch (index) {
        case 0:
          _selectedBranchString = 'Karang Darat';
          break;
        case 1:
          _selectedBranchString = 'Inderapura';
          break;
        case 2:
          _selectedBranchString = 'Kemaman';
          break;
        default:
          _selectedBranchString = 'Unknown';
          break;
      }
    });
  }

  Future<void> launchMap(double lat, double long, String branch) async {
    try {
      final coords = Coords(lat, long); // Coordinates of the marker
      final title = branch; // Title of the marker
      const description = 'Clinic'; // Description of the marker

      final isGoogleMapsAvailable =
          await MapLauncher.isMapAvailable(MapType.google);

      if (isGoogleMapsAvailable ?? false) {
        await MapLauncher.showMarker(
          mapType: MapType.google,
          coords: coords,
          title: title,
          description: description,
        );
      } else {
        print('Google Maps is not available.');
      }
    } catch (e) {
      print('Error launching map: $e');
    }
  }

  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Select new date

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime.now(),
  //     lastDate: DateTime(DateTime.now().year + 1),
  //   );

  //   if (picked != null) {
  //     setState(() {
  //       _appointmentDateController.text =
  //           picked.toIso8601String().split('T')[0];
  //       _selectedTime = ''; // Reset selected time when date changes
  //       _isDateSelected = true; // Set the flag to true when date is selected
  //     });
  //   }
  // }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime oneDayForward = currentDate.add(const Duration(days: 1));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: oneDayForward,
      firstDate: currentDate,
      lastDate: DateTime(currentDate.year + 1),
    );

    if (picked != null) {
      setState(() {
        _appointmentDateController.text =
            picked.toIso8601String().split('T')[0];
        _selectedTime = ''; // Reset selected time when date changes
        _isDateSelected = true; // Set the flag to true when date is selected
      });
    }
  }

  //

  // ----------------------------------------------------------------------
  // Time Picker

  // Widget _buildTimeButton(String selectedTime) {
  //   return Expanded(
  //     child: Padding(
  //       padding: const EdgeInsets.all(4.0),
  //       child: FutureBuilder<bool>(
  //         future:
  //             isTimeAvailable(_appointmentDateController.text, selectedTime),
  //         builder: (context, snapshot) {
  //           final isAvailable = snapshot.data ?? false;

  //           return ElevatedButton(
  //             onPressed: _isDateSelected && isAvailable
  //                 ? () {
  //                     setState(() {
  //                       _selectedTime = selectedTime;
  //                     });
  //                   }
  //                 : null,
  //             style: ElevatedButton.styleFrom(
  //               foregroundColor: const Color(0xFF32a3cb),
  //               backgroundColor: _selectedTime == selectedTime
  //                   ? Colors.white // White fill when selected
  //                   : const Color(0xFF32a3cb), // Text color
  //               side: BorderSide(
  //                 color: _selectedTime == selectedTime
  //                     ? const Color(0xFF32a3cb) // Blue outline when selected
  //                     : const Color.fromARGB(
  //                         0, 255, 255, 255), // No outline by default
  //                 width: 3.0,
  //               ),
  //             ),
  //             child: Text(
  //               selectedTime,
  //               style: TextStyle(
  //                 color: _selectedTime == selectedTime
  //                     ? const Color(0xFF32a3cb) // Blue text when selected
  //                     : Colors.white, // White text by default
  //               ),
  //             ),
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }

  Widget _buildTimeButton(String selectedTime) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 5.0),
        child: FutureBuilder<bool>(
          future: isTimeAvailable(_appointmentDateController.text, selectedTime,
              _selectedBranchString),
          builder: (context, snapshot) {
            final isAvailable = snapshot.data ?? false;
            return ElevatedButton(
              onPressed: _isDateSelected && isAvailable
                  ? () {
                      setState(() {
                        _selectedTime = selectedTime;
                      });
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                fixedSize: const Size.fromHeight(50.0),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10.0), // Adjust the value as needed
                ),
                foregroundColor: const Color(0xFFFFB938),
                backgroundColor: _selectedTime == selectedTime
                    ? const Color(0xFFFFE2A2) // Button color when selected
                    : const Color(0xFFC1D3FF), // Buttons available
                side: BorderSide(
                  color: _selectedTime == selectedTime
                      ? const Color(0xFF5F4712) // Button outline when selected
                      : const Color.fromARGB(
                          0, 255, 255, 255), // No outline by default
                  width: 2.0,
                ),
              ),
              child: Text(
                selectedTime,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: _selectedTime == selectedTime
                      ? const Color(0xFF5F4712) // Text when selected
                      : const Color(0xFF1F3299), // Text by default
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

  Future<bool> isTimeAvailable(
      String selectedDate, String selectedTime, String branch) async {
    if (await DatabaseService()
        .isAppointmentDateConfirmedBranch(selectedDate, selectedTime, branch)) {
      return false; // Time slot is booked
    }
    return true; // Time slot is available
  }

  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Update booking

  void _updateBooking() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedBranch == -1) {
        // Show an error message and return if no time is selected
        // You can customize the error handling based on your requirements
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFF303E8F),
            title: const Text('Error'),
            content: const Text('Please choose a branch.',
                style: TextStyle(color: Color(0xFFEDF2FF))),
            actions: <Widget>[
              TextButton(
                child: const Text('OK',
                    style: TextStyle(color: Color(0xFFEDF2FF))),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
        return;
      }
      if (_appointmentDateController.text.isEmpty) {
        // Show an error message and return if no time is selected
        // You can customize the error handling based on your requirements
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFF303E8F),
            title: const Text('Error'),
            content: const Text('Please suggest a date.',
                style: TextStyle(color: Color(0xFFEDF2FF))),
            actions: <Widget>[
              TextButton(
                child: const Text('OK',
                    style: TextStyle(color: Color(0xFFEDF2FF))),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
        return;
      }

      final appointmentDate = _appointmentDateController.text;
      final appointmentTime = _selectedTime;
      String branchName = _selectedBranchString;
      // Check availability one more time before submitting (just in case)
      bool isAvailable =
          await isTimeAvailable(appointmentDate, appointmentTime, branchName);
      if (!isAvailable) {
        // Handle the case where the selected time became unavailable
        // (Maybe show an error message to the user)
        return;
      }
      final oldAppointmentDate = widget.appointment.appointment_date;

      // Check if a time has been selected
      if (_selectedTime.isEmpty) {
        // Show an error message and return if no time is selected
        // You can customize the error handling based on your requirements
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFF303E8F),
            title: const Text('Error'),
            content: const Text('Please pick a timeslot.',
                style: TextStyle(color: Color(0xFFEDF2FF))),
            actions: <Widget>[
              TextButton(
                child: const Text('OK',
                    style: TextStyle(color: Color(0xFFEDF2FF))),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
        return;
      }

      switch (_selectedBranch) {
        case 0:
          branchName = 'Karang Darat';
          break;
        case 1:
          branchName = 'Inderapura';
          break;
        case 2:
          branchName = 'Kemaman';
          break;
        default:
          branchName = 'Placeholder';
          break;
      }

      DateDisplay dateDisplayNew = DateDisplay(date: appointmentDate);
      String appointmentDateString = dateDisplayNew.getStringDate();
      DateDisplay dateDisplayOld = DateDisplay(date: oldAppointmentDate);
      String oldAppointmentDateString = dateDisplayOld.getStringDate();

      String timeNow =
          DateFormat('MMMM dd, yyyy \'at\' hh:mm a').format(DateTime.now());

      String rescheduler;

      if (widget.rescheduler == 'patient') {
        rescheduler = 'patient';
      } else if (widget.rescheduler == 'practitioner') {
        rescheduler = 'practitioner';
      } else {
        rescheduler = 'admin';
      }

      // Create a new Appointment instance with the updated data
      final updatedAppointment = Appointment(
        appointment_id: widget.appointment.appointment_id,
        appointment_date: appointmentDate,
        appointment_time: appointmentTime,
        user_id: widget.appointment.user_id,
        profile_id: widget.appointment.profile_id,
        status: 'Updated',
        branch: branchName,
        system_remarks:
            'Rescheduled appointment date from $oldAppointmentDateString at ${widget.appointment.appointment_time} to $appointmentDateString at $appointmentTime on $timeNow by the $rescheduler.',
        patient_remarks: widget.appointment.patient_remarks,
        practitioner_remarks: widget.appointment.practitioner_remarks,
        random_id: widget.appointment.random_id,
        practitioner_id: widget.appointment.practitioner_id,
      );

      try {
        // Update the FlowerBook in the database
        await DatabaseService().rescheduleAppointment(updatedAppointment);

        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFF303E8F),
            title: const Text('Success'),
            content: const Text('Appointment updated successfully!'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK',
                    style: TextStyle(color: Color(0xFFEDF2FF))),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pop(context, true);
                },
              ),
            ],
          ),
        );
      } catch (error) {
        // Handle the error
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFF303E8F),
            title: const Text('Error'),
            content:
                const Text('An error occurred while updating the appointment.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK',
                    style: TextStyle(color: Color(0xFFEDF2FF))),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    }
  }

  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Required validator

  String? _requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Builder

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Appointment'),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4.0),
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
                                    'Choose a Branch',
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
                          const SizedBox(height: 24.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ElevatedButton(
                                  onPressed: (widget.rescheduler == 'patient' &&
                                          widget.appointment.practitioner_id ==
                                              0)
                                      ? () {
                                          _onBranchPressed(0);
                                          _selectedTime = '';
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _selectedBranch == 0
                                        ? const Color(0xFFFFE2A2)
                                        : const Color(0xFFC1D3FF),
                                    fixedSize: const Size.fromHeight(60.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    foregroundColor: const Color(0xFFFFB938),
                                    side: BorderSide(
                                      color: _selectedBranch == 0
                                          ? const Color(0xFF5F4712)
                                          : const Color.fromARGB(
                                              0, 255, 255, 255),
                                      width: 2.0,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
                                        child: Text(
                                          'Karang Darat, Kuantan',
                                          style: TextStyle(
                                            color: _selectedBranch == 0
                                                ? const Color(0xFF5F4712)
                                                : const Color(0xFF1F3299),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.fmd_good),
                                        iconSize: 20,
                                        color: _selectedBranch == 0
                                            ? const Color(0xFF5F4712)
                                            : const Color(0xFF1F3299),
                                        onPressed: () {
                                          launchMap(
                                              3.9112965679321294,
                                              103.34899018744197,
                                              'Klinik Alya Iman - Karang Darat');
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: (widget.rescheduler == 'patient' &&
                                          widget.appointment.practitioner_id ==
                                              0)
                                      ? () {
                                          _onBranchPressed(1);
                                          _selectedTime = '';
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _selectedBranch == 1
                                        ? const Color(0xFFFFE2A2)
                                        : const Color(0xFFC1D3FF),
                                    fixedSize: const Size.fromHeight(60.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    foregroundColor: const Color(0xFFFFB938),
                                    side: BorderSide(
                                      color: _selectedBranch == 1
                                          ? const Color(0xFF5F4712)
                                          : const Color.fromARGB(
                                              0, 255, 255, 255),
                                      width: 2.0,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
                                        child: Text(
                                          'Inderapura, Kuantan',
                                          style: TextStyle(
                                            color: _selectedBranch == 1
                                                ? const Color(0xFF5F4712)
                                                : const Color(0xFF1F3299),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.fmd_good),
                                        iconSize: 20,
                                        color: _selectedBranch == 1
                                            ? const Color(0xFF5F4712)
                                            : const Color(0xFF1F3299),
                                        onPressed: () {
                                          launchMap(
                                              3.7511729280328034,
                                              103.26166483677974,
                                              'Klinik Alya Iman - Inderapura');
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: (widget.rescheduler == 'patient' &&
                                          widget.appointment.practitioner_id ==
                                              0)
                                      ? () {
                                          _onBranchPressed(2);
                                          _selectedTime = '';
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _selectedBranch == 2
                                        ? const Color(0xFFFFE2A2)
                                        : const Color(0xFFC1D3FF),
                                    fixedSize: const Size.fromHeight(60.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    foregroundColor: const Color(0xFFFFB938),
                                    side: BorderSide(
                                      color: _selectedBranch == 2
                                          ? const Color(0xFF5F4712)
                                          : const Color.fromARGB(
                                              0, 255, 255, 255),
                                      width: 2.0,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
                                        child: Text(
                                          'Kemaman, Terengganu',
                                          style: TextStyle(
                                            color: _selectedBranch == 2
                                                ? const Color(0xFF5F4712)
                                                : const Color(0xFF1F3299),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.fmd_good),
                                        iconSize: 20,
                                        color: _selectedBranch == 2
                                            ? const Color(0xFF5F4712)
                                            : const Color(0xFF1F3299),
                                        onPressed: () {
                                          launchMap(
                                              4.257055848607369,
                                              103.40434944427868,
                                              'Klinik Alya Iman - Kemaman');
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 42.0),
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
                                    'Suggest a Date',
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
                          const SizedBox(height: 24.0),
                          TextFormField(
                            controller: _appointmentDateController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: _selectedBranch != -1
                                  ? const Color(0xFF4D5FC0)
                                  : const Color(0xFF09124B),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              labelText: 'Enter Date',
                              labelStyle:
                                  const TextStyle(color: Color(0xFFB6CBFF)),
                              counterText: '',
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 20.0),
                            ),
                            readOnly: true,
                            onTap: () {
                              if (_selectedBranch != -1) {
                                _selectDate(context);
                              }
                            },
                            style: const TextStyle(color: Color(0xFFEDF2FF)),
                            enabled: _selectedBranch != -1,
                          ),
                          const SizedBox(height: 42.0),
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
                                    'Pick a Timeslot',
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
                          _buildTimeRow(['09:00 AM', '10:00 AM', '11:00 AM']),
                          _buildTimeRow(['12:00 PM', '01:00 PM', '02:00 PM']),
                          _buildTimeRow(['03:00 PM', '04:00 PM', '05:00 PM']),
                          const SizedBox(height: 80.0),
                        ],
                      ),
                    ),
                  ),
                ),
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
                  onPressed: _updateBooking,
                  label: const Text('Update',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1F3299))),
                  elevation: 0,
                  backgroundColor:
                      const Color(0xFFC1D3FF), // Set the fill color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        50.0), // Adjust the value as needed
                    side: const BorderSide(
                      color: Color(0xFF6086f6), // Set the outline color
                      width: 2.5, // Set the outline width
                    ),
                  ),
                  foregroundColor: const Color(0xFF1F3299),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
