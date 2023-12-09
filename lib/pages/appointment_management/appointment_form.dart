import 'package:klinik_alya_iman_mobile_app/models/appointment.dart';
import 'package:klinik_alya_iman_mobile_app/models/profile.dart';
import 'package:klinik_alya_iman_mobile_app/pages/appointment_management/list_appointment.dart';
import 'package:klinik_alya_iman_mobile_app/pages/profile_management/list_profile.dart';
import 'package:klinik_alya_iman_mobile_app/pages/startup/login.dart';
import 'package:flutter/material.dart';
import 'package:klinik_alya_iman_mobile_app/services/database_service.dart';

class AppointmentForm extends StatefulWidget {
  final int userId;
  final Profile profile;

  const AppointmentForm(
      {Key? key,
      required this.userId,
      required this.profile})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AppointmentFormState createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _appointmentDateController =
      TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // ----------------------------------------------------------------------
  // Date Picker

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
  // Submit form

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final appointmentDate = _appointmentDateController.text;

      // Create a new appointment instance with the form data
      final appointment = Appointment(
        appointment_date: appointmentDate,
        user_id: widget.userId,
        profile_id: widget.profile.profile_id,
      );

      // ----------------------------------------------------------------------
      // Create new booking

      try {
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
                      builder: (context) => ListAppointment(
                        userId: widget.userId,
                        profile: widget.profile,
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

      // ----------------------------------------------------------------------
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
        title: const Text('Appointment Form',
            style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'profile',
                  child: ListTile(
                    leading: Icon(Icons.list),
                    title: Text('Profiles'),
                  ),
                ),
                const PopupMenuItem(
                  value: 'history',
                  child: ListTile(
                    leading: Icon(Icons.list),
                    title: Text('Appointment History'),
                  ),
                ),
                const PopupMenuItem(
                  value: 'logout',
                  child: ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Logout'),
                  ),
                ),
              ];
            },
            onSelected: (value) {
              if (value == 'profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListProfile(
                      userId: widget.userId,
                    ),
                  ),
                );
              } else if (value == 'history') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListAppointment(
                      userId: widget.userId,
                      profile: widget.profile,
                    ),
                  ),
                );
              } else if (value == 'logout') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Login(),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                const SizedBox(height: 32.0),
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: widget.profile.f_name,
                  ),
                  enabled: false,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: widget.profile.l_name,
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
      ),
    );
  }

  // ----------------------------------------------------------------------
}
