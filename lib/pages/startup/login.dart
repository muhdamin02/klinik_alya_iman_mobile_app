import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../guest_pages/guest_home.dart';
import '../home.dart';
import '../practitioner_pages/practitioner_home.dart';
import '../system_admin_pages/system_admin_home.dart';

class Login extends StatefulWidget {
  final String usernamePlaceholder;
  final String passwordPlaceholder;

  const Login(
      {Key? key,
      required this.usernamePlaceholder,
      required this.passwordPlaceholder})
      : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  int? userId;
  String? userName, userUsername, userPassword, userPhone, userRole;
  bool passwordVisible = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  // Prefill text fields
  @override
  void initState() {
    super.initState();

    // Prefill the text fields with the user's information
    _usernameController.text = widget.usernamePlaceholder;
    _passwordController.text = widget.passwordPlaceholder;
  }

  // ----------------------------------------------------------------------
  // Determines what happens during Log In

  void _onLogin() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed with login
      final userUsername = _usernameController.text;
      final password = _passwordController.text;

      // Call your authentication service to validate login credentials
      _authService.login(userUsername, password).then((success) async {
        if (success) {
          List<Map<String, dynamic>> userData =
              await getUserData(userUsername);

          for (Map<String, dynamic> user in userData) {
            userId = user['user_id'];
            userName = user['name'];
            userPhone = user['phone'];
            userRole = user['role'];
          }

          final user = User(
            user_id: userId,
            username: userUsername,
            name: userName ?? '',
            password: password,
            phone: userPhone ?? '',
            role: userRole ?? '',
          );

          if (userRole == 'patient') {
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Home(
                  user: user,
                ),
              ),
            );
          } else if (userRole == 'practitioner') {
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PractitionerHome(
                  user: user,
                ),
              ),
            );
          } else if (userRole == 'systemadmin') {
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SystemAdminHome(
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

  _guestLogin() async {
    List<Map<String, dynamic>> userData = await getUserData('-');

    for (Map<String, dynamic> user in userData) {
      userId = user['user_id'];
      userUsername = user['username'];
      userName = user['name'];
      userPassword = user['password'];
      userPhone = user['phone'];
      userRole = user['role'];
    }

    final user = User(
      user_id: userId,
      username: userUsername ?? '',
      name: userName ?? '',
      password: userPassword ?? '',
      phone: userPhone ?? '',
      role: userRole ?? '',
    );

    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => GuestHome(
          user: user,
          showTips: true,
        ),
      ),
    );
  }

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
                const Padding(
                  padding: EdgeInsets.only(top: 24.0),
                  child: Image(
                    image: AssetImage('assets/klinik_alya_iman.png'),
                    fit: BoxFit.fitHeight,
                  ),
                ),
                const Text(
                  'Welcome back!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 0, 76, 104),
                  ),
                ),
                const SizedBox(height: 48.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      labelText: 'Username',
                      counterText: '',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 20.0),
                    ),
                    maxLength: 20,
                    validator: (value) {
                      if (value == null || value.isEmpty || value == '') {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    obscureText: passwordVisible,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      labelText: 'Password',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 20.0),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(
                            right: 8.0), // Adjust the right padding as needed
                        child: IconButton(
                          icon: Icon(passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value == null || value.isEmpty || value == '') {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    height: 60.0,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                            255, 115, 176, 255), // Set the text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              25.0), // Adjust the value as needed
                        ),
                      ),
                      child: const Text(
                        'Continue as Member',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32.0),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Color.fromARGB(255, 21, 82, 161),
                          height: 1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'or',
                          style: TextStyle(
                            color: Color.fromARGB(255, 9, 52, 109),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Color.fromARGB(255, 21, 82, 161),
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    height: 60.0,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _guestLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                            255, 255, 220, 106), // Set the text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              25.0), // Adjust the value as needed
                        ),
                      ),
                      child: const Text(
                        'Get Started as Guest',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 112, 92, 0),
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