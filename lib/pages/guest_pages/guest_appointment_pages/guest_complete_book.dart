// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/appointment.dart';
import '../../../models/user.dart';
import '../../../services/misc_methods/date_display.dart';
import '../guest_home.dart';

class GuestCompleteBook extends StatefulWidget {
  final User user;
  final Appointment appointment;

  const GuestCompleteBook({
    Key? key,
    required this.user,
    required this.appointment,
  }) : super(key: key);

  @override
  _GuestCompleteBookState createState() => _GuestCompleteBookState();
}

class _GuestCompleteBookState extends State<GuestCompleteBook>
    with SingleTickerProviderStateMixin {
  bool isButtonEnabled = false;
  int countdown = 5;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: countdown),
    );

    // Create a linear tween that goes from 1.0 to 0.0
    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);

    // Start the countdown timer
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        setState(() {
          countdown--;
        });
      } else {
        timer.cancel(); // Stop the timer when countdown reaches 0
        _controller.forward(); // Start the animation
        setState(() {
          isButtonEnabled = true;
        });
      }
    });

    // Start the animation immediately
    _controller.forward();
  }

  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to return to the home page?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        GuestHome(user: widget.user, showTips: false),
                  ),
                );
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime appointmentDate =
        DateTime.parse(widget.appointment.appointment_date);
    String dayOfWeek = DateFormat('EEEE').format(appointmentDate);
    return WillPopScope(
        onWillPop: () async {
          // Return false to prevent the user from navigating back
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Guest placeholder',
              style: TextStyle(color: Colors.white),
            ),
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            automaticallyImplyLeading: false,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.appointment.random_id,
                    style: const TextStyle(fontSize: 60)),
                const SizedBox(height: 16.0),
                Text('Patient ID: ${widget.appointment.profile_id}'),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    const Text('Date: '),
                    DateDisplay(date: widget.appointment.appointment_date),
                    Text(' ($dayOfWeek)'),
                  ],
                ),
                const SizedBox(height: 8.0),
                Text('Time: ${widget.appointment.appointment_time}'),
                const SizedBox(height: 8.0),
                Text('Status: ${widget.appointment.status}'),
                const SizedBox(height: 64.0),
                const Text('Screenshot this page.'),
                const SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return countdown > 0
                            ? Stack(
                                alignment: Alignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    value: _animation.value,
                                    color: Colors.blue,
                                    strokeWidth: 10,
                                  ),
                                  Text(
                                    '$countdown',
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.blue),
                                  ),
                                ],
                              )
                            : Container(); // Hide the Stack when countdown is 0 or less
                      },
                    ),
                    const SizedBox(width: 16.0), // Adjust spacing as needed
                    ElevatedButton(
                      onPressed: isButtonEnabled
                          ? () {
                              _showConfirmationDialog();
                            }
                          : null, // Disable the button if not enabled
                      child: const Text('Return'),
                    ),
                  ],
                ),

                // Add more details
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
