import 'package:flutter/material.dart';

import '../../models/profile.dart';
import '../../services/database_service.dart';


class UpdateProfile extends StatefulWidget {
  final Profile profile;

  const UpdateProfile({Key? key, required this.profile}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();

  String? _selectedGender;
  final List<String> _genderOptions = ['Male', 'Female'];
  bool _genderError = false;

  @override
  void initState() {
    super.initState();
    // Initialize the text controllers with the existing values
    _firstNameController.text = widget.profile.f_name;
    _lastNameController.text = widget.profile.l_name;
    _dateOfBirthController.text = widget.profile.dob;
    _selectedGender = widget.profile.gender;
  }

  // ----------------------------------------------------------------------
  // Dispose

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Select new date

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

  // ----------------------------------------------------------------------
  // Update booking

  void _updateBooking() async {
    if (_formKey.currentState!.validate()) {
      // if (!_selectedFlowerTypes.contains(true)) {
      //   setState(() {
      //     _showCheckboxError = true;
      //   });
      //   return;
      // }

      final firstName = _firstNameController.text;
      final lastName = _lastNameController.text;
      final dateOfBirth = _dateOfBirthController.text;
      final String? selectedGender = _selectedGender;

      // Create a new Appointment instance with the updated data
      final updatedProfile = Profile(
        profile_id: widget.profile.profile_id,
        f_name: firstName,
        l_name: lastName,
        dob: dateOfBirth,
        gender: selectedGender,
        user_id: widget.profile.user_id,
      );

      if (_selectedGender == null) {
        setState(() {
          _genderError = true;
        });
        return;
      }

      try {
        // Update the profile in the database
        await DatabaseService().updateProfile(updatedProfile);

        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Success'),
            content: const Text('Profile updated successfully!'),
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
                const Text('An error occurred while updating the profile.'),
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
        title: const Text('Update Profile',
            style: TextStyle(color: Colors.white)),
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
                controller: _firstNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'First Name',
                ),
                validator: _requiredValidator,
              ),
              const SizedBox(height: 32.0),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Last Name',
                ),
                validator: _requiredValidator,
              ),
              const SizedBox(height: 32.0),
              TextFormField(
                controller: _dateOfBirthController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Date of Birth',
                ),
                readOnly: true,
                onTap: () {
                  _selectDate(context);
                },
                validator: _requiredValidator,
              ),
              const SizedBox(height: 32.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Select Gender:', style: TextStyle(fontSize: 20)),
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
