import 'package:flutter/material.dart';

import '../../../models/profile.dart';
import '../../../models/user.dart';
import '../../appointment_management/appointment_form.dart';
import '../../startup/login.dart';
import '../guest_home.dart';
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

  String? _selectedGender, _selectedEthnicity, _selectedMaritalStatus;
  final List<String> _genderOptions = ['Male', 'Female'];
  final List<String> _ethnicityOptions = [
    'Malay',
    'Chinese',
    'Indian',
    'Others'
  ];
  final List<String> _maritalStatusOptions = [
    'Single',
    'Married',
    'Divorced',
    'Widowed'
  ];
  bool _genderError = false;
  bool _ethnicityError = false;
  bool _maritalStatusError = false;

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
      final String? selectedEthnicity = _selectedEthnicity;
      final String? selectedMaritalStatus = _selectedMaritalStatus;

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
        maternity_due: 'Not set',
        ethnicity: selectedEthnicity,
        marital_status: selectedMaritalStatus,
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
          title: const Text('Book Appointment'),
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        bottomNavigationBar: SizedBox(
          height: 56.0, // Adjust the height as needed
          child: BottomAppBar(
            color: const Color(
              0xFF0A0F2C,
            ), // Set the background color of the BottomAppBar
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.event),
                    iconSize: 27,
                    onPressed: () {},
                    color: const Color(
                      0xFF5464BB,
                    ), // Set the color of the icon
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.home),
                    iconSize: 25,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GuestHome(
                            user: widget.user,
                            showTips: false,
                          ),
                        ),
                      );
                    },
                    color: const Color(
                      0xFFEDF2FF,
                    ), // Set the color of the icon
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.login),
                    iconSize: 25,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Login(
                              usernamePlaceholder: '', passwordPlaceholder: ''),
                        ),
                      );
                    },
                    color: const Color(
                      0xFFEDF2FF,
                    ), // Set the color of the icon
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
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
                                  'Patient Information',
                                  style: TextStyle(
                                    color: Color(0xFFEDF2FF), letterSpacing: 2
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
                          controller: _nameController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFF4D5FC0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            labelText: 'Full Name',
                            labelStyle:
                                const TextStyle(color: Color(0xFFB6CBFF)),
                            counterText: '',
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 20.0),
                          ),
                          validator: _requiredValidator,
                          style: const TextStyle(color: Color(0xFFEDF2FF)),
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _identificationController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFF4D5FC0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            labelText: 'IC or Passport',
                            labelStyle:
                                const TextStyle(color: Color(0xFFB6CBFF)),
                            counterText: '',
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 20.0),
                          ),
                          validator: _requiredValidator,
                          style: const TextStyle(color: Color(0xFFEDF2FF)),
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _dateOfBirthController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFF4D5FC0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            labelText: 'Date of Birth',
                            labelStyle:
                                const TextStyle(color: Color(0xFFB6CBFF)),
                            counterText: '',
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 20.0),
                          ),
                          readOnly: true,
                          onTap: () {
                            _selectDate(context);
                          },
                          validator: _requiredValidator,
                          style: const TextStyle(color: Color(0xFFEDF2FF)),
                        ),
                        const SizedBox(height: 32.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(
                                  left: 8.0), // Adjust the value as needed
                              child: Text(
                                'Gender:',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFFEDF2FF),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                for (String gender in _genderOptions)
                                  Expanded(
                                    child: Theme(
                                      data: ThemeData(
                                        unselectedWidgetColor: const Color(
                                            0xFFEDF2FF), // Change the color to your desired unselected color
                                      ),
                                      child: RadioListTile<String>(
                                        title: Text(
                                          gender,
                                          style: const TextStyle(
                                            color: Color(0xFFEDF2FF),
                                            fontFamily: 'ProductSans',
                                          ),
                                        ),
                                        activeColor: const Color(0xFFABBFFF),
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
                                  ),
                              ],
                            ),
                            if (_genderError)
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Please select a gender',
                                  style: TextStyle(
                                    color: Color(0xFFFF6262),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 24.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(
                                  left: 8.0), // Adjust the value as needed
                              child: Text(
                                'Ethnicity:',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFFEDF2FF),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            for (String ethnicity in _ethnicityOptions)
                              Theme(
                                data: ThemeData(
                                  unselectedWidgetColor: const Color(
                                      0xFFEDF2FF), // Change the color to your desired unselected color
                                ),
                                child: RadioListTile<String>(
                                  title: Text(
                                    ethnicity,
                                    style: const TextStyle(
                                      color: Color(0xFFEDF2FF),
                                      fontFamily: 'ProductSans',
                                    ),
                                  ),
                                  activeColor: const Color(0xFFABBFFF),
                                  value: ethnicity,
                                  groupValue: _selectedEthnicity,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _selectedEthnicity = value;
                                      _ethnicityError = false;
                                    });
                                  },
                                ),
                              ),
                            if (_ethnicityError)
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Please select an ethnicity',
                                  style: TextStyle(
                                    color: Color(0xFFFF6262),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 24.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(
                                  left: 8.0), // Adjust the value as needed
                              child: Text(
                                'Marital Status:',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFFEDF2FF),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            for (String maritalStatus in _maritalStatusOptions)
                              Theme(
                                data: ThemeData(
                                  unselectedWidgetColor: const Color(
                                      0xFFEDF2FF), // Change the color to your desired unselected color
                                ),
                                child: RadioListTile<String>(
                                  title: Text(
                                    maritalStatus,
                                    style: const TextStyle(
                                      color: Color(0xFFEDF2FF),
                                      fontFamily: 'ProductSans',
                                    ),
                                  ),
                                  activeColor: const Color(0xFFABBFFF),
                                  value: maritalStatus,
                                  groupValue: _selectedMaritalStatus,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _selectedMaritalStatus = value;
                                      _maritalStatusError = false;
                                    });
                                  },
                                ),
                              ),
                            if (_maritalStatusError)
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Please select marital status',
                                  style: TextStyle(
                                    color: Color(0xFFFF6262),
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
                    style: OutlinedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFC1D3FF), // Set the fill color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            50.0), // Adjust the value as needed
                      ),
                      side: const BorderSide(
                        color: Color(0xFF6086f6), // Set the outline color
                        width: 2.5, // Set the outline width
                      ),
                    ),
                    child: const Text('Continue',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1F3299))),
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
