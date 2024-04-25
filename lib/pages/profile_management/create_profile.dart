import 'package:flutter/material.dart';

import '../../app_drawer/app_drawer_user.dart';
import '../../models/profile.dart';
import '../../models/user.dart';
import '../../services/database_service.dart';
import 'list_profile.dart';

class CreateProfile extends StatefulWidget {
  final User user;

  const CreateProfile({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
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

  // Prefill text fields
  @override
  void initState() {
    super.initState();

    _initializeTextFields();
  }

  // ----------------------------------------------------------------------
  // Initialize text fields
  Future<void> _initializeTextFields() async {
    // Prefill the text fields with the user's information if profile count = 0
    int profileCount =
        await DatabaseService().getProfileCount(widget.user.user_id!);

    if (profileCount == 0 && !(widget.user.role == 'guest')) {
      _nameController.text = widget.user.name;
      _identificationController.text = widget.user.identification;
    }
  }

  // ----------------------------------------------------------------------
  // Submit form

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final String editedName = _nameController.text;
      final String editedIdentification = _identificationController.text;
      final String dateOfBirth = _dateOfBirthController.text;
      final String? selectedGender = _selectedGender;

      final profile = Profile(
        name: editedName,
        identification: editedIdentification,
        dob: dateOfBirth,
        gender: selectedGender,
        height: 0,
        weight: 0,
        body_fat_percentage: 0,
        activity_level: '',
        belly_size: 0,
        maternity: 'No',
        user_id: widget.user.user_id!,
      );

      if (_selectedGender == null) {
        setState(() {
          _genderError = true;
        });
        return;
      }

      try {
        // Insert the profile into the database

        await DatabaseService().insertProfile(profile);

        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Align(
              alignment: Alignment.center,
              child: Text(
                'Success',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            content: Text(
              'Profile for $editedName has been created!',
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              Container(
                margin:
                    const EdgeInsets.only(bottom: 16.0), // Set bottom margin
                child: Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                      _dateOfBirthController.clear();
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListProfile(
                            user: widget.user,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 0, 61, 83),
                      backgroundColor: const Color.fromARGB(255, 167, 224, 245),
                      side: const BorderSide(
                        color: Color.fromARGB(255, 0, 61, 83),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Color.fromARGB(255, 0, 61, 83),
                      ),
                    ),
                  ),
                ),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(48.0), // Adjust the radius
            ),
          ),
          barrierDismissible: false,
        );
      } catch (error) {
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
        title: const Text('Create Profile'),
      ),
      drawer: AppDrawerUser(
        header: 'Create Profile',
        user: widget.user,
        autoImplyLeading: true,
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
                    backgroundColor: const Color.fromARGB(
                        255, 115, 176, 255), // Set the text color

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          25.0), // Adjust the value as needed
                    ),
                  ),
                  child: const Text('Create Profile',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 255, 255, 255))),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
