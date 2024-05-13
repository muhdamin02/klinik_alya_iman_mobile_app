import 'package:flutter/material.dart';

import '../../../app_drawer/app_drawer_guest_appointment.dart';
import '../../../models/profile.dart';
import '../../../models/user.dart';
import 'guest_appointment.dart';

class CreateTempProfile extends StatefulWidget {
  final User user;

  const CreateTempProfile({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CreateTempProfileState createState() => _CreateTempProfileState();
}

class _CreateTempProfileState extends State<CreateTempProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _identificationController =
      TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();

  String? _selectedGender;
  final List<String> _genderOptions = ['Male', 'Female'];
  bool _genderError = false;

  // Date of Birth picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _dateOfBirthController.text = picked.toIso8601String().split('T')[0];
      });
    }
  }

  // ----------------------------------------------------------------------
  // Submit form

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final String name = _nameController.text;
      final String identification = _identificationController.text;
      final String dateOfBirth = _dateOfBirthController.text;
      final String? selectedGender = _selectedGender;

      var profile = Profile(
        name: name,
        identification: identification,
        dob: dateOfBirth,
        gender: selectedGender,
        height: 0,
        weight: 0,
        body_fat_percentage: 0,
        activity_level: '',
        belly_size: 0,
        maternity: 'No',
        maternity_week: 0,
        ethnicity: 'Placeholder',
        marital_status: 'Placeholder',
        occupation: 'Placeholder',
        medical_alert: 'Placeholder',
        profile_pic: 'Placeholder',
        creation_date: 'Placeholder',
        user_id: widget.user.user_id!,
      );

      if (_selectedGender == null) {
        setState(() {
          _genderError = true;
        });
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GuestAppointmentForm(
            user: widget.user,
            profile: profile,
          ),
        ),
      );
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
    return WillPopScope(
      onWillPop: () async {
        // Return false to prevent the user from navigating back
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Enter Patient Details'),
        ),
        drawer: AppDrawerGuestAppt(
          header: 'Guest Appointment',
          user: widget.user,
        ),
        body: Column(
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
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 20.0),
                            labelText: 'Full Name',
                          ),
                          validator: _requiredValidator,
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _identificationController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 20.0),
                            labelText: 'IC or Passport',
                          ),
                          validator: _requiredValidator,
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _dateOfBirthController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 20.0),
                            labelText: 'Date of Birth',
                          ),
                          readOnly: true,
                          onTap: () {
                            _selectDate(context);
                          },
                          validator: _requiredValidator,
                        ),
                        const SizedBox(height: 16.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Select Gender:',
                                style: TextStyle(fontSize: 20)),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                for (String gender in _genderOptions)
                                  Expanded(
                                    child: RadioListTile<String>(
                                      title: Text(gender),
                                      value: gender,
                                      groupValue: _selectedGender,
                                      onChanged: (String? value) {
                                        setState(() {
                                          _selectedGender = value;
                                          _genderError = false;
                                        });
                                      },
                                    ),
                                  ),
                              ],
                            ),
                            if (_genderError)
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Please select a gender',
                                  style: TextStyle(
                                    color: Color.fromRGBO(197, 44, 44, 1),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(
                    bottom: 16.0,
                    left: 16.0,
                    right: 16.0), // Set your desired margin
                child: SizedBox(
                  height: 60.0,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 115, 176, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            25.0), // Adjust the value as needed
                      ),
                    ),
                    child: const Text('Continue',
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontWeight: FontWeight.w500)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
