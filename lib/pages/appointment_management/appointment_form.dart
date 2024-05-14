// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:map_launcher/map_launcher.dart';

import '../../models/appointment.dart';
import '../../models/profile.dart';
import '../../models/user.dart';
import '../../services/database_service.dart';
import 'list_appointment.dart';

class AppointmentForm extends StatefulWidget {
  final User user;
  final Profile profile;

  const AppointmentForm({Key? key, required this.user, required this.profile})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AppointmentFormState createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _appointmentDateController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _identificationController =
      TextEditingController();
  bool _isDateSelected = false;
  String _selectedTime = '';
  int _selectedBranch = -1;

  @override
  void initState() {
    super.initState();

    var uuid = const Uuid();
    formattedUUID = formatUUID(uuid);
  }

  var uuid = const Uuid();
  String formattedUUID = '';

  String formatUUID(Uuid uuid) {
    String rawUUID = uuid.v4();
    return rawUUID.substring(0, 8).toUpperCase();
  }

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

  void _onBranchPressed(int index) {
    setState(() {
      _selectedBranch = index;
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
  // Date Picker

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

  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Time Picker

  Widget _buildTimeButton(String selectedTime) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 5.0),
        child: FutureBuilder<bool>(
          future:
              isTimeAvailable(_appointmentDateController.text, selectedTime),
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

  Future<bool> isTimeAvailable(String selectedDate, String selectedTime) async {
    if (await DatabaseService()
        .isAppointmentDateConfirmed(selectedDate, selectedTime)) {
      return false; // Time slot is booked
    }
    return true; // Time slot is available
  }

  // ----------------------------------------------------------------------
  // Submit form

  // Submit form
  void _submitForm() async {
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

      final appointmentDate = _appointmentDateController.text;
      final appointmentTime = _selectedTime;
      String branchName = '';
      // Check availability one more time before submitting (just in case)
      bool isAvailable =
          await isTimeAvailable(appointmentDate, appointmentTime);
      if (!isAvailable) {
        // Handle the case where the selected time became unavailable
        // (Maybe show an error message to the user)
        return;
      }

      switch (_selectedBranch){
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

      // Create a new appointment instance with the form data
      final appointment = Appointment(
        appointment_date: _appointmentDateController.text,
        appointment_time: appointmentTime,
        user_id: widget.user.user_id!,
        profile_id: widget.profile.profile_id,
        status: 'Pending',
        branch: branchName,
        system_remarks: 'The appointment is pending.',
        patient_remarks: 'No remarks by patient.',
        practitioner_remarks: 'No remarks by practitioner.',
        random_id: formattedUUID,
        practitioner_id: 0,
      );

      // setState(() {
      //   bookedAppointments.add(appointment);
      // });

      // ----------------------------------------------------------------------
      // Create new booking

      try {
        // Insert the appointment into the database
        await DatabaseService().insertAppointment(appointment);

        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFF303E8F),
            title: const Text('Success'),
            content: const Text('Appointment booked successfully!',
                style: TextStyle(color: Color(0xFFEDF2FF))),
            actions: <Widget>[
              TextButton(
                child: const Text('OK',
                    style: TextStyle(color: Color(0xFFEDF2FF))),
                onPressed: () {
                  // Clear the text fields after submitting the form
                  _formKey.currentState!.reset();
                  _appointmentDateController.clear();
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListAppointment(
                        user: widget.user,
                        profile: widget.profile,
                        autoImplyLeading: false,
                        initialTab: 0,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          barrierDismissible: false,
        );
      } catch (error) {
        // Handle any errors that occur during the database operation
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('An error occurred: $error'),
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
        title: const Text('Book Appointment'),
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
                                  onPressed: () {
                                    _onBranchPressed(0);
                                  },
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
                                  onPressed: () {
                                    _onBranchPressed(1);
                                  },
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
                                  onPressed: () {
                                    _onBranchPressed(2);
                                  },
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

              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: Container(
              //     margin: const EdgeInsets.only(
              //         bottom: 16.0,
              //         left: 16.0,
              //         right: 16.0), // Set your desired margin
              //     child: SizedBox(
              //       height: 60.0,
              //       width: double.infinity,
              //       child: ElevatedButton(
              //         onPressed: _submitForm,
              //         style: OutlinedButton.styleFrom(
              //           backgroundColor:
              //               const Color(0xFFC1D3FF), // Set the fill color
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(
              //                 50.0), // Adjust the value as needed
              //           ),
              //           side: const BorderSide(
              //             color: Color(0xFF6086f6), // Set the outline color
              //             width: 2.5, // Set the outline width
              //           ),
              //         ),
              //         child: const Text('Continue',
              //             style: TextStyle(
              //                 fontSize: 18.0,
              //                 fontWeight: FontWeight.w500,
              //                 color: Color(0xFF1F3299))),
              //       ),
              //     ),
              //   ),
              // ),
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
                  onPressed: _submitForm,
                  label: const Text('Continue',
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
