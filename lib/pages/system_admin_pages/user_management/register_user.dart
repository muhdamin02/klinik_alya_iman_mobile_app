import 'package:flutter/material.dart';

import '../../../models/user.dart';
import '../../../services/database_service.dart';

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
  final TextEditingController _identificationController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();

  // ----------------------------------------------------------------------
  // Register user to databas

  Future<void> _onSave() async {
    final name = _nameController.text;
    final identification = _identificationController.text;
    final password = _passwordController.text;
    final phone = _phoneController.text;

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
            content: const Text(
                'Account already exists.'),
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
        role: 'patient',
      ),
    );

    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registration Successful'),
          content: const Text('You have been registered successfully.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
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
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
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
                const SizedBox(height: 12.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    height: 45.0,
                    width: double.infinity,
                    child: ElevatedButton(
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
                const SizedBox(height: 32.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Name textfield

  Widget buildName() => TextFormField(
        controller: _nameController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
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
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
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
        keyboardType: TextInputType.emailAddress,
        controller: _phoneController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Phone',
        ),
        validator: (value) {
          // Validate Input
          if (value == null || value.isEmpty) {
            return 'Please enter your phone number';
          }

          // Email regex pattern
          final emailRegex = RegExp(
              r'^[\w-]+(\.[\w-]+)*@[a-zA-Z\d-]+(\.[a-zA-Z\d-]+)*\.[a-zA-Z\d-]{2,}$');

          if (!emailRegex.hasMatch(value)) {
            return 'Please enter a valid phone number';
          }

          return null;
        },
      );

  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Password textfield

  Widget buildPassword() => TextFormField(
        controller: _passwordController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
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
