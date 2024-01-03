// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import '../../../models/user.dart';
import '../../../services/database_service.dart';

class ViewUser extends StatefulWidget {
  final User user;

  const ViewUser({Key? key, required this.user}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ViewUserState createState() => _ViewUserState();
}

class _ViewUserState extends State<ViewUser> {
  List<User> _userInfo = [];
  String? _userName;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
    _loadUserName();
  }

  // ----------------------------------------------------------------------
  // Fetch details

  Future<void> _fetchUserInfo() async {
    List<User> userInfo = await DatabaseService().userInfo(widget.user.user_id);
    setState(() {
      _userInfo = userInfo;
    });
  }
  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // load user name
  Future<void> _loadUserName() async {
    _userName = await DatabaseService().getUserName(widget.user.user_id);
    setState(() {}); // Update the UI to display the patient name
  }
  // ----------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // DateTime appointmentDate =
    //     DateTime.parse(widget.appointment.appointment_date);
    // String dayOfWeek = DateFormat('EEEE').format(appointmentDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'User Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              // Display appointment details using ListView.builder
              ListView.builder(
                shrinkWrap: true,
                itemCount: _userInfo.length,
                itemBuilder: (context, index) {
                  User user = _userInfo[index];
                  return SizedBox(
                    width: MediaQuery.of(context)
                        .size
                        .width, // Set width to screen width
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('User: $_userName'),
                        const SizedBox(height: 8.0),
                        // Row(
                        //   children: [
                        //     const Text('Date: '),
                        //     DateDisplay(date: appointment.appointment_date),
                        //     Text(' ($dayOfWeek)'),
                        //   ],
                        // ),
                        const SizedBox(height: 8.0),
                        Text('Username: ${user.identification}'),
                        const SizedBox(height: 8.0),
                        Text('Password: ${user.password}'),
                        const SizedBox(height: 12.0),
                        Text('Email: ${user.phone}'),
                        const SizedBox(height: 12.0),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // _leaveRemarks(widget.appointment);
        },
        icon: const Icon(Icons.rate_review),
        label: const Text('Placeholder'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
