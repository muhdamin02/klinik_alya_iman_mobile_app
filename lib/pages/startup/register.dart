import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/user.dart';
import '../../services/database_service.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({Key? key, this.user, required this.willPopScopeBool})
      : super(key: key);
  final User? user;
  final bool willPopScopeBool;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();

  // ----------------------------------------------------------------------
  // Register user to database

  Future<void> _onSave() async {
    final name = _nameController.text;
    final username = _usernameController.text;
    final password = _passwordController.text;
    final phone = _phoneController.text;

    // Check if username already exists in the database
    bool isUsernameExists =
        await _databaseService.checkUserExists(username);

    if (isUsernameExists) {
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
        username: username,
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
          content: const Text('Account has been registered successfully.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Login(
                          usernamePlaceholder: username,
                          passwordPlaceholder: password)),
                );
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
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Image(
                    image: AssetImage('assets/klinik_alya_iman.png'),
                    fit: BoxFit.fitHeight),
                const SizedBox(height: 16),
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
                  child: buildUsername(),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account? '),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login(
                                    usernamePlaceholder: '',
                                    passwordPlaceholder: '',
                                  )),
                        );
                      },
                      child: const Text(
                        'Click here to login',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
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
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
          labelText: 'Full name',
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
  // Username textfield

  Widget buildUsername() => TextFormField(
        controller: _usernameController,
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'IC or Passport Number',
            counterText: ''),
        maxLength: 20,
        validator: (value) {
          // Validate Input
          if (value == null || value.isEmpty) {
            return 'Please enter your IC or password number';
          }
          return null;
        },
      );

  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Phone textfield

  Widget buildPhone() => TextFormField(
        keyboardType: TextInputType.phone,
        controller: _phoneController,
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Phone Number',
            counterText: ''),
        inputFormatters: [
          // Use the FilteringTextInputFormatter to allow only digits and certain characters
          FilteringTextInputFormatter.digitsOnly,
        ],
        maxLength: 15,
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
