import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/appointment.dart';
import '../../services/database_service.dart';
import '../../services/misc_methods/date_display.dart';

class UpdateAppointment extends StatefulWidget {
  final Appointment appointment;
  final String rescheduler;

  const UpdateAppointment(
      {Key? key, required this.appointment, required this.rescheduler})
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

  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Select new date

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
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

  // ----------------------------------------------------------------------
  // Update booking

  void _updateBooking() async {
    if (_formKey.currentState!.validate()) {
      final appointmentDate = _appointmentDateController.text;
      final oldAppointmentDate = widget.appointment.appointment_date;
      final appointmentTime = _selectedTime;

      if (_selectedTime.isEmpty) {
        // Show an error message and return if no time is selected
        // You can customize the error handling based on your requirements
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

      // Check availability one more time before submitting (just in case)
      bool isAvailable =
          await isTimeAvailable(appointmentDate, appointmentTime);
      if (!isAvailable) {
        // Handle the case where the selected time became unavailable
        // (Maybe show an error message to the user)
        return;
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
        status: 'Pending',
        branch: widget.appointment.branch,
        system_remarks:
            'Rescheduled appointment date from $oldAppointmentDateString at ${widget.appointment.appointment_time} to $appointmentDateString at $appointmentTime on $timeNow by the $rescheduler.',
        patient_remarks: widget.appointment.patient_remarks,
        practitioner_remarks: widget.appointment.practitioner_remarks,
        random_id: widget.appointment.random_id,
        practitioner_id: 0,
      );

      try {
        // Update the FlowerBook in the database
        await DatabaseService().rescheduleAppointment(updatedAppointment);

        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Success'),
            content: const Text('Booking updated successfully!'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
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
            title: const Text('Error'),
            content:
                const Text('An error occurred while updating the booking.'),
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
        title: const Text('Reschedule Appointment',
            style: TextStyle(color: Colors.white)),
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 32.0),
              TextFormField(
                controller: _appointmentDateController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Delivery Date',
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
              SizedBox(
                height: 45.0,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updateBooking,
                  child: const Text('Update',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                height: 45.0,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    side: const BorderSide(
                        width: 3, color: Color.fromARGB(255, 224, 99, 99)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel',
                      style:
                          TextStyle(color: Color.fromARGB(255, 224, 99, 99))),
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
