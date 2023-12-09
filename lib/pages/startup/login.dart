import 'package:klinik_alya_iman_mobile_app/pages/home.dart';
import 'package:klinik_alya_iman_mobile_app/pages/startup/register.dart';
import 'package:klinik_alya_iman_mobile_app/services/auth_service.dart';

import 'package:flutter/material.dart';
import 'package:klinik_alya_iman_mobile_app/services/database_service.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  int? userId;
  String? userFName, userLName, userEmail;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  // ----------------------------------------------------------------------
  // Determines what happens during Log In

  void _onLogin() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed with login
      final username = _usernameController.text;
      final password = _passwordController.text;

      // Call your authentication service to validate login credentials
      _authService.login(username, password).then((success) {
        if (success) {
          _getUserID(username).then((id) {
            // Store the user_id in the userId variable
            setState(() {
              userId = id;
            });

            _getUserFName(username).then((fname) {
              // Store the user_id in the userId variable
              setState(() {
                userFName = fname;
              });

              _getUserLName(username).then((lname) {
                // Store the user_id in the userId variable
                setState(() {
                  userLName = lname;
                });

                _getUserEmail(username).then((email) {
                  // Store the user_id in the userId variable
                  setState(() {
                    userEmail = email;
                  });

                  // Pass the arguments individually when navigating
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Home(
                        userId: userId!,
                        userFName: userFName!,
                        userLName: userLName!,
                        userEmail: userEmail!,
                      ),
                    ),
                  );
                });
              });
            });
          });
        } else {
          // Login failed, display error message
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Login Failed'),
              content: const Text('Invalid username or password.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      });
    }
  }

  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Builder

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Image(
                  image: AssetImage('assets/klinik_alya_iman.png'),
                  fit: BoxFit.fitHeight),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  height: 45.0,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(
                          50, 163, 203, 1), // Set the desired button color here
                    ),
                    child: const Text(
                      'Login',
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
                  const Text('No account? '),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Register()),
                      );
                    },
                    child: const Text(
                      'Click here to register',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------
// get user id

Future<int?> _getUserID(String username) async {
  final db = await DatabaseService().database;
  final List<Map<String, dynamic>> result = await db.query(
    'user',
    columns: ['user_id'],
    where: 'username = ?',
    whereArgs: [username],
    limit: 1,
  );

  if (result.isNotEmpty) {
    return result.first['user_id'] as int?;
  }

  return null;
}

// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
// get user first name

Future<String?> _getUserFName(String username) async {
  final db = await DatabaseService().database;
  final List<Map<String, dynamic>> result = await db.query(
    'user',
    columns: ['f_name'],
    where: 'username = ?',
    whereArgs: [username],
    limit: 1,
  );

  if (result.isNotEmpty) {
    return result.first['f_name'] as String?;
  }

  return null;
}

// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
// get user last name

Future<String?> _getUserLName(String username) async {
  final db = await DatabaseService().database;
  final List<Map<String, dynamic>> result = await db.query(
    'user',
    columns: ['l_name'],
    where: 'username = ?',
    whereArgs: [username],
    limit: 1,
  );

  if (result.isNotEmpty) {
    return result.first['l_name'] as String?;
  }

  return null;
}

// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
// get user email

Future<String?> _getUserEmail(String username) async {
  final db = await DatabaseService().database;
  final List<Map<String, dynamic>> result = await db.query(
    'user',
    columns: ['email'],
    where: 'username = ?',
    whereArgs: [username],
    limit: 1,
  );

  if (result.isNotEmpty) {
    return result.first['email'] as String?;
  }

  return null;
}

// ----------------------------------------------------------------------