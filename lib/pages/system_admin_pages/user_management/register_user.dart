import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../models/user.dart';
import '../../../services/database_service.dart';
import 'manage_user.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({Key? key, this.user, required this.willPopScopeBool})
      : super(key: key);
  final User? user;
  final bool willPopScopeBool;

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _identificationController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();
  String _selectedRole = 'patient';

  // ----------------------------------------------------------------------
  // Register user to databas

  Future<void> _onSave() async {
    final name = _nameController.text;
    final identification = _identificationController.text;
    final password = _passwordController.text;
    final phone = _phoneController.text;
    final role = _selectedRole;

    // Check if username or email already exists in the database
    bool isIdentificationExists =
        await _databaseService.checkUserExists(identification);

    if (isIdentificationExists) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Registration Failed'),
            content: const Text('Account already exists.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return; // Exit the method if username exists
    }

    // Registration successful, insert the user into the database
    await _databaseService.insertUser(
      User(
        name: name,
        identification: identification,
        password: password,
        phone: phone,
        role: role,
      ),
    );

    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registration Successful'),
          content: const Text('Account has been registered successfully.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManageUser(
                      user: widget.user!,
                      autoImplyLeading: false,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
      barrierDismissible: false,
    );
  }

  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Builder

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return false to prevent the user from navigating back
        return widget.willPopScopeBool;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Register New User',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 16.0,
                        ),
                        child: buildName(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 16.0,
                        ),
                        child: buildIdentification(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 16.0,
                        ),
                        child: buildPhone(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 16.0,
                        ),
                        child: buildPassword(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 16.0,
                        ),
                        child: DropdownButtonFormField<String>(
                          value: _selectedRole,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedRole = newValue!;
                            });
                          },
                          items: const [
                            DropdownMenuItem<String>(
                              value: 'patient',
                              child: Text('Patient'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'practitioner',
                              child: Text('Practitioner'),
                            ),
                          ],
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 20.0,
                              horizontal: 20.0,
                            ),
                            labelText: 'User Role',
                          ),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                    ],
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
                  child: SizedBox(
                    height: 60.0,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 115, 176, 255),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              25.0), // Adjust the value as needed
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await _onSave();
                        }
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Name textfield

  Widget buildName() => TextFormField(
        controller: _nameController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          labelText: 'Name',
        ),
        validator: (value) {
          // Validate Input
          if (value == null || value.isEmpty) {
            return 'Please enter your full name';
          }
          return null;
        },
      );

  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Identification textfield

  Widget buildIdentification() => TextFormField(
        controller: _identificationController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          labelText: 'Identification',
        ),
        validator: (value) {
          // Validate Input
          if (value == null || value.isEmpty) {
            return 'Please enter your identification';
          }
          return null;
        },
      );

  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Phone textfield

  Widget buildPhone() => TextFormField(
        keyboardType: TextInputType.phone,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(11), // Limit the length to 10 digits
        ],
        controller: _phoneController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          labelText: 'Phone',
        ),
        validator: (value) {
          // Validate Input
          if (value == null || value.isEmpty) {
            return 'Please enter your phone number';
          }

          return null;
        },
      );

  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Password textfield

  Widget buildPassword() => TextFormField(
        controller: _passwordController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          labelText: 'Password',
        ),
        obscureText: true,
        validator: (value) {
          // Validate Input
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          }
          return null;
        },
      );

  // ----------------------------------------------------------------------
}
