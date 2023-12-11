import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../home.dart';
import '../practitioner_pages/practitioner_home.dart';
import 'register.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  int? userId;
  String? userFName, userLName, userEmail, userRole;
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
      _authService.login(username, password).then((success) async {
        if (success) {
          List<Map<String, dynamic>> userData = await getUserData(username);

          for (Map<String, dynamic> user in userData) {
            userId = user['user_id'];
            userFName = user['f_name'];
            userLName = user['l_name'];
            userEmail = user['email'];
            userRole = user['role'];
          }

          final user = User(
            user_id: userId,
            f_name: userFName ?? '',
            l_name: userLName ?? '',
            username: username,
            password: password,
            email: userEmail ?? '',
            role: userRole ?? '',
          );

          if (userRole == 'practitioner') {
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PractitionerHome(
                  user: user,
                ),
              ),
            );
          } else if (userRole == 'patient') {
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Home(
                  user: user,
                ),
              ),
            );
          }
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
    return WillPopScope(
      onWillPop: () async {
        // Return false to prevent the user from navigating back
        return false;
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
                        backgroundColor: const Color.fromRGBO(50, 163, 203,
                            1), // Set the desired button color here
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
                              builder: (context) => const Register(willPopScopeBool: true)),
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
      ),
    );
  }
}

// ----------------------------------------------------------------------
// get user data

Future<List<Map<String, dynamic>>> getUserData(String username) async {
  final db = await DatabaseService().database;

  // Fetch all columns for the user with the given username
  final List<Map<String, dynamic>> result = await db.query(
    'user',
    where: 'username = ?',
    whereArgs: [username],
  );

  return result;
}

// ----------------------------------------------------------------------

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

// ----------------------------------------------------------------------
// get user role

Future<String?> _getUserRole(String username) async {
  final db = await DatabaseService().database;
  final List<Map<String, dynamic>> result = await db.query(
    'user',
    columns: ['role'],
    where: 'username = ?',
    whereArgs: [username],
    limit: 1,
  );

  if (result.isNotEmpty) {
    return result.first['role'] as String?;
  }

  return null;
}

// ----------------------------------------------------------------------