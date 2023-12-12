import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../services/database_service.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({Key? key, this.user, required this.willPopScopeBool}) : super(key: key);
  final User? user;
  final bool willPopScopeBool;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();

  // ----------------------------------------------------------------------
  // Register user to database

  Future<void> _onSave() async {
    final fname = _firstNameController.text;
    final lname = _lastNameController.text;
    final username = _usernameController.text;
    final password = _passwordController.text;
    final email = _emailController.text;

    // Check if username or email already exists in the database
    bool isUsernameExists =
        await _databaseService.checkUsernameExists(username);
    bool isEmailExists = await _databaseService.checkEmailExists(email);

    if (isEmailExists) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Registration Failed'),
            content: const Text(
                'Email already exists. Please use a different email.'),
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
      return; // Exit the method if email exists
    }

    if (isUsernameExists) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Registration Failed'),
            content: const Text(
                'Username already exists. Please choose a different username.'),
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
        f_name: fname,
        l_name: lname,
        username: username,
        password: password,
        email: email,
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login(usernamePlaceholder: username, passwordPlaceholder: password)),
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
                  child: buildFirstName(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 16.0,
                  ),
                  child: buildLastName(),
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
                  child: buildEmail(),
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
                              builder: (context) => const Login(usernamePlaceholder: '', passwordPlaceholder: '',)),
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
  // First Name textfield

  Widget buildFirstName() => TextFormField(
        controller: _firstNameController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'First name',
        ),
        validator: (value) {
          // Validate Input
          if (value == null || value.isEmpty) {
            return 'Please enter your first name';
          }
          return null;
        },
      );

  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Last Name textfield

  Widget buildLastName() => TextFormField(
        controller: _lastNameController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Last name',
        ),
        validator: (value) {
          // Validate Input
          if (value == null || value.isEmpty) {
            return 'Please enter your last name';
          }
          return null;
        },
      );

  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Userame textfield

  Widget buildUsername() => TextFormField(
        controller: _usernameController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Username',
        ),
        validator: (value) {
          // Validate Input
          if (value == null || value.isEmpty) {
            return 'Please enter your username';
          }
          return null;
        },
      );

  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Email textfield

  Widget buildEmail() => TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: _emailController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Email',
        ),
        validator: (value) {
          // Validate Input
          if (value == null || value.isEmpty) {
            return 'Please enter your email address';
          }

          // Email regex pattern
          final emailRegex = RegExp(
              r'^[\w-]+(\.[\w-]+)*@[a-zA-Z\d-]+(\.[a-zA-Z\d-]+)*\.[a-zA-Z\d-]{2,}$');

          if (!emailRegex.hasMatch(value)) {
            return 'Please enter a valid email address';
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
