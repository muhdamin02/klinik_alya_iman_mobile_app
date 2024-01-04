import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../guest_pages/guest_home.dart';
import '../home.dart';
import '../practitioner_pages/practitioner_home.dart';
import '../system_admin_pages/system_admin_home.dart';

class Login extends StatefulWidget {
  final String identificationPlaceholder;
  final String passwordPlaceholder;

  const Login(
      {Key? key,
      required this.identificationPlaceholder,
      required this.passwordPlaceholder})
      : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  int? userId;
  String? userName, userIdentification, userPassword, userPhone, userRole;
  bool passwordVisible = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _identificationController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  // Prefill text fields
  @override
  void initState() {
    super.initState();

    // Prefill the text fields with the user's information
    _identificationController.text = widget.identificationPlaceholder;
    _passwordController.text = widget.passwordPlaceholder;
  }

  // ----------------------------------------------------------------------
  // Determines what happens during Log In

  void _onLogin() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed with login
      final identification = _identificationController.text;
      final password = _passwordController.text;

      // Call your authentication service to validate login credentials
      _authService.login(identification, password).then((success) async {
        if (success) {
          List<Map<String, dynamic>> userData =
              await getUserData(identification);

          for (Map<String, dynamic> user in userData) {
            userId = user['user_id'];
            userName = user['name'];
            userPhone = user['phone'];
            userRole = user['role'];
          }

          final user = User(
            user_id: userId,
            name: userName ?? '',
            identification: identification,
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
              content: const Text('Invalid ID or password.'),
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
      userName = user['name'];
      userIdentification = user['identification'];
      userPassword = user['password'];
      userPhone = user['phone'];
      userRole = user['role'];
    }

    final user = User(
      user_id: userId,
      name: userName ?? '',
      identification: userIdentification ?? '',
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
                const Image(
                    image: AssetImage('assets/klinik_alya_iman.png'),
                    fit: BoxFit.fitHeight),
                const SizedBox(height: 32.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    controller: _identificationController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'IC or Passport Number',
                      counterText: '',
                    ),
                    maxLength: 20,
                    validator: (value) {
                      if (value == null || value.isEmpty || value == '') {
                        return 'Please enter your IC  or Passport Number';
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
                      border: const OutlineInputBorder(),
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(
                            () {
                              passwordVisible = !passwordVisible;
                            },
                          );
                        },
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
                    const Text('One-time user? '),
                    GestureDetector(
                      onTap: _guestLogin,
                      child: const Text(
                        'Click here',
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

Future<List<Map<String, dynamic>>> getUserData(String identification) async {
  final db = await DatabaseService().database;

  // Fetch all columns for the user with the given identification
  final List<Map<String, dynamic>> result = await db.query(
    'user',
    where: 'identification = ?',
    whereArgs: [identification],
  );

  return result;
}

// ----------------------------------------------------------------------