import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../models/appointment.dart';
import '../../../models/profile.dart';
import '../../../models/user.dart';
import '../../../services/database_service.dart';
import 'guest_complete_book.dart';
// import '../../appointment_management/list_appointment.dart';

class GuestAppointmentForm extends StatefulWidget {
  final User user;
  final Profile profile;

  const GuestAppointmentForm(
      {Key? key, required this.user, required this.profile})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _GuestAppointmentFormState createState() => _GuestAppointmentFormState();
}

class _GuestAppointmentFormState extends State<GuestAppointmentForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _appointmentDateController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _identificationController =
      TextEditingController();
  bool _isDateSelected = false;
  String _selectedTime = '';
  var uuid = const Uuid();
  String formattedUUID = '';

  String formatUUID(Uuid uuid) {
    String rawUUID = uuid.v4();
    return rawUUID.substring(0, 8).toUpperCase();
  }

  @override
  void initState() {
    super.initState();

    var uuid = const Uuid();
    formattedUUID = formatUUID(uuid);
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

  // ----------------------------------------------------------------------
  // Date Picker

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
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

  // ...

  Widget _buildTimeButton(String selectedTime) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
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
                foregroundColor: const Color(0xFF32a3cb),
                backgroundColor: _selectedTime == selectedTime
                    ? Colors.white // White fill when selected
                    : const Color(0xFF32a3cb), // Text color
                side: BorderSide(
                  color: _selectedTime == selectedTime
                      ? const Color(0xFF32a3cb) // Blue outline when selected
                      : const Color.fromARGB(
                          0, 255, 255, 255), // No outline by default
                  width: 3.0,
                ),
              ),
              child: Text(
                selectedTime,
                style: TextStyle(
                  color: _selectedTime == selectedTime
                      ? const Color(0xFF32a3cb) // Blue text when selected
                      : Colors.white, // White text by default
                ),
              ),
            );
          },
        ),
      ),
    );
  }

// ...

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
      // Check if a time has been selected
      if (_selectedTime.isEmpty) {
        // Show an error message and return if no time is selected
        // You can customize the error handling based on your requirements
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Please select an appointment time.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
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

      // Check availability one more time before submitting (just in case)
      bool isAvailable =
          await isTimeAvailable(appointmentDate, appointmentTime);
      if (!isAvailable) {
        // Handle the case where the selected time became unavailable
        // (Maybe show an error message to the user)
        return;
      }

      // setState(() {
      //   bookedAppointments.add(appointment);
      // });

      // ----------------------------------------------------------------------
      // Create new booking

      try {
        await DatabaseService().insertProfile(widget.profile);

        int profileId =
            await DatabaseService().getLatestProfileId(widget.user.user_id!);

        // Create a new appointment instance with the form data
        final appointment = Appointment(
          appointment_date: _appointmentDateController.text,
          appointment_time: appointmentTime,
          user_id: widget.user.user_id!,
          profile_id: profileId,
          status: 'Pending',
          system_remarks: 'The appointment is pending.',
          patient_remarks: 'No remarks by patient.',
          practitioner_remarks: 'No remarks by practitioner.',
          random_id: formattedUUID,
        );
        // Insert the appointment into the database
        await DatabaseService().insertAppointment(appointment);

        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Success'),
            content: const Text('Form submitted successfully!'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  // Clear the text fields after submitting the form
                  _formKey.currentState!.reset();
                  _appointmentDateController.clear();
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GuestCompleteBook(
                        user: widget.user,
                        appointment: appointment,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
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
                child: const Text('OK'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _appointmentDateController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Appointment Date',
                ),
                readOnly: true,
                onTap: () {
                  _selectDate(context);
                },
                validator: _requiredValidator,
              ),
              const SizedBox(height: 16.0),
              const Text('Choose Appointment Time'),
              _buildTimeRow(['09:00 AM', '10:00 AM', '11:00 AM']),
              _buildTimeRow(['12:00 PM', '01:00 PM', '02:00 PM']),
              _buildTimeRow(['03:00 PM', '04:00 PM', '05:00 PM']),
              const SizedBox(height: 32.0),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: widget.profile.name,
                ),
                enabled: false,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _identificationController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: widget.profile.identification,
                ),
                enabled: false,
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                height: 45.0,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Submit',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
