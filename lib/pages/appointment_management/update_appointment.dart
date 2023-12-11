import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/appointment.dart';
import '../../services/database_service.dart';

class UpdateAppointment extends StatefulWidget {
  final Appointment appointment;

  const UpdateAppointment({Key? key, required this.appointment})
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

  // List<bool> _selectedFlowerTypes = List.filled(5, false);
  // String? _selectedArrangement;

  @override
  void initState() {
    super.initState();
    // Initialize the text controllers with the existing values
    _appointmentDateController.text = widget.appointment.appointment_date;
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
      });
    }
  }

  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Update booking

  void _updateBooking() async {
    if (_formKey.currentState!.validate()) {
      final appointmentDate = _appointmentDateController.text;
      final oldAppointmentDate = widget.appointment.appointment_date;
      String timeNow = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

      // Create a new Appointment instance with the updated data
      final updatedAppointment = Appointment(
        appointment_id: widget.appointment.appointment_id,
        appointment_date: appointmentDate,
        user_id: widget.appointment.user_id,
        profile_id: widget.appointment.profile_id,
        status: widget.appointment.status,
        remarks:
            'Updated appointment date from $oldAppointmentDate to $appointmentDate on $timeNow',
        practitioner_id: widget.appointment.practitioner_id,
      );

      try {
        // Update the FlowerBook in the database
        await DatabaseService().updateAppointment(updatedAppointment);

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

  // ----------------------------------------------------------------------
}
