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
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();
  String _selectedRole = 'patient';

  bool passwordVisible = true;

  // ----------------------------------------------------------------------
  // Register user to databas

  Future<void> _onSave() async {
    final name = _nameController.text;
    final username = _usernameController.text;
    final password = _passwordController.text;
    final phone = _phoneController.text;
    final role = _selectedRole;

    // Check if username or email already exists in the database
    bool isUsernameExists = await _databaseService.checkUserExists(username);

    if (isUsernameExists) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color(0xFF303E8F),
            title: const Text('Registration Failed'),
            content: const Text('Account already exists.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK',
                    style: TextStyle(color: Color(0xFFEDF2FF))),
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
        username: username,
        name: name,
        password: password,
        phone: phone,
        role: role,
      ),
    );

    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          backgroundColor: const Color(0xFF303E8F),
          title: const Text('Registration Successful'),
          content: const Text('Account has been registered successfully.'),
          actions: <Widget>[
            TextButton(
              child:
                  const Text('OK', style: TextStyle(color: Color(0xFFEDF2FF))),
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
        ),
      ),
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
                                  'User Information',
                                  style: TextStyle(
                                    color: Color(0xFFEDF2FF),
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
                        const SizedBox(height: 18.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 6.0,
                            horizontal: 3.0,
                          ),
                          child: buildName(),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 6.0,
                            horizontal: 3.0,
                          ),
                          child: buildUsername(),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 6.0,
                            horizontal: 3.0,
                          ),
                          child: buildPhone(),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 6.0,
                            horizontal: 3.0,
                          ),
                          child: buildPassword(),
                        ),
                        const SizedBox(height: 40.0),
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
                                  'Role',
                                  style: TextStyle(
                                    color: Color(0xFFEDF2FF),
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
                        const SizedBox(height: 18),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 6.0,
                            horizontal: 3.0,
                          ),
                          child: DropdownButtonFormField<String>(
                            value: _selectedRole,
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedRole = newValue!;
                              });
                            },
                            dropdownColor: const Color(0xFF303E8F),
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
                              fillColor: const Color(0xFF4D5FC0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 20.0,
                                horizontal: 20.0,
                              ),
                              labelText: 'User Role',
                              labelStyle:
                                  const TextStyle(color: Color(0xFFB6CBFF)),
                            ),
                            style: const TextStyle(
                                color: Color(0xFFEDF2FF),
                                fontFamily: 'ProductSans',
                                fontSize: 16),
                          ),
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
                  child: SizedBox(
                    height: 60.0,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
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
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await _onSave();
                        }
                      },
                      child: const Text('Register User',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1F3299))),
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
          fillColor: const Color(0xFF4D5FC0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          labelText: 'Full Name',
          labelStyle: const TextStyle(color: Color(0xFFB6CBFF)),
        ),
        validator: (value) {
          // Validate Input
          if (value == null || value.isEmpty) {
            return 'Please enter your full name';
          }
          return null;
        },
        style: const TextStyle(color: Color(0xFFEDF2FF)),
      );

  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // username textfield

  Widget buildUsername() => TextFormField(
        controller: _usernameController,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFF4D5FC0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          labelText: 'Username',
          labelStyle: const TextStyle(color: Color(0xFFB6CBFF)),
        ),
        validator: (value) {
          // Validate Input
          if (value == null || value.isEmpty) {
            return 'Please enter your username';
          }
          return null;
        },
        style: const TextStyle(color: Color(0xFFEDF2FF)),
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
          fillColor: const Color(0xFF4D5FC0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          labelText: 'Phone Number',
          labelStyle: const TextStyle(color: Color(0xFFB6CBFF)),
        ),
        validator: (value) {
          // Validate Input
          if (value == null || value.isEmpty) {
            return 'Please enter your phone number';
          }

          return null;
        },
        style: const TextStyle(color: Color(0xFFEDF2FF)),
      );

  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Password textfield

  Widget buildPassword() => TextFormField(
        controller: _passwordController,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFF4D5FC0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          labelText: 'Password',
          labelStyle: const TextStyle(color: Color(0xFFB6CBFF)),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(
                right: 8.0), // Adjust the right padding as needed
            child: IconButton(
              icon: Icon(
                passwordVisible ? Icons.visibility : Icons.visibility_off,
                color: const Color(0xFFB6CBFF),
              ),
              onPressed: () {
                setState(() {
                  passwordVisible = !passwordVisible;
                });
              },
            ),
          ),
        ),
        obscureText: passwordVisible,
        validator: (value) {
          // Validate Input
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          }
          return null;
        },
        style: const TextStyle(color: Color(0xFFEDF2FF)),
      );

  // ----------------------------------------------------------------------
}
