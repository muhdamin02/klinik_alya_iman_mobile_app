import 'package:flutter/material.dart';
import 'package:klinik_alya_iman_mobile_app/models/profile.dart';
import 'package:klinik_alya_iman_mobile_app/pages/profile_management/list_profile.dart';
import 'package:klinik_alya_iman_mobile_app/pages/profile_management/profile_page.dart';
import 'package:klinik_alya_iman_mobile_app/pages/startup/login.dart';
import 'package:klinik_alya_iman_mobile_app/services/database_service.dart';

class CreateProfile extends StatefulWidget {
  final int userId;
  final String userFName, userLName;

  const CreateProfile({
    Key? key,
    required this.userId,
    required this.userFName,
    required this.userLName,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
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

    // Prefill the text fields with the user's information
    _firstNameController.text = widget.userFName;
    _lastNameController.text = widget.userLName;
  }

  // ----------------------------------------------------------------------
  // Submit form

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final String editedFirstName = _firstNameController.text;
      final String editedLastName = _lastNameController.text;
      final String dateOfBirth = _dateOfBirthController.text;
      final String? selectedGender = _selectedGender;

      final profile = Profile(
        f_name: editedFirstName,
        l_name: editedLastName,
        dob: dateOfBirth,
        gender: selectedGender,
        user_id: widget.userId,
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
            title: const Text('Success'),
            content: const Text('Form submitted successfully!'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  _formKey.currentState!.reset();
                  _dateOfBirthController.clear();
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        profile: profile,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
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
        title:
            const Text('Create Profile', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
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
              if (value == 'history') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListProfile(
                      userId: widget.userId,
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
                const SizedBox(height: 32.0),
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'First Name',
                  ),
                  validator: _requiredValidator,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Last Name',
                  ),
                  validator: _requiredValidator,
                ),
                const SizedBox(height: 16.0),
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
                SizedBox(
                  height: 45.0,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Create Profile',
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
}
