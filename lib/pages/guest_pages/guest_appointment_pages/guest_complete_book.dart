// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../models/appointment.dart';
import '../../../models/user.dart';
import '../../../services/misc_methods/date_display.dart';
import '../../../services/misc_methods/show_hovering_message.dart';
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
  int countdown = 10;

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
          backgroundColor: const Color(0xFF303E8F),
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
              child:
                  const Text('No', style: TextStyle(color: Color(0xFFEDF2FF))),
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
              child:
                  const Text('Yes', style: TextStyle(color: Color(0xFFEDF2FF))),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return false to prevent the user from navigating back
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Booking Complete!',
          ),
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                'Reference Number',
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
                      const SizedBox(height: 20.0),
                      SizedBox(
                        width: double.infinity, // Adjust padding as needed
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Clipboard.setData(ClipboardData(
                                  text: widget.appointment.random_id));
                              showHoveringMessage(context,
                                  'Copied to clipboard', 0.205, 0.25, 0.5);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(
                                  0xFF2B3885), // Background color of the ElevatedButton
                              elevation: 0, // Set the elevation for the button
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20.0), // Adjust the radius
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.appointment.random_id,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 42,
                                      letterSpacing: 8,
                                      color: Color(0xFFFFD271),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
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
                                'Appointment Summary',
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
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              width:
                                  double.infinity, // Adjust padding as needed
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20.0), // Adjust the radius
                                ),
                                elevation: 0, // Set the elevation for the card
                                color: const Color(0xFF303E8F),
                                child: Padding(
                                  padding: const EdgeInsets.all(28.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          // Handle onTap action here
                                        },
                                        child: const Text(
                                          "DATE",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: Color(0xFFB6CBFF),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        DateDisplay(
                                                date: widget.appointment
                                                    .appointment_date)
                                            .getStringDate(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Color(0xFFEDF2FF),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: SizedBox(
                              width:
                                  double.infinity, // Adjust padding as needed
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20.0), // Adjust the radius
                                ),
                                elevation: 0, // Set the elevation for the card
                                color: const Color(0xFF303E8F),
                                child: Padding(
                                  padding: const EdgeInsets.all(28.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          // Handle onTap action here
                                        },
                                        child: const Text(
                                          "TIME",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: Color(0xFFB6CBFF),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        widget.appointment.appointment_time,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Color(0xFFEDF2FF),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      SizedBox(
                        width: double.infinity, // Adjust padding as needed
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20.0), // Adjust the radius
                          ),
                          elevation: 0, // Set the elevation for the card
                          color: const Color(0xFF3848A1),
                          child: Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Handle onTap action here
                                  },
                                  child: const Text(
                                    "BRANCH",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Color(0xFFB6CBFF),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  widget.appointment.branch,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Color(0xFFEDF2FF),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 64.0),
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
                                'Screenshot this Page',
                                style: TextStyle(
                                  color: Color(0xFFB6CBFF), fontSize: 24,
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
                      const SizedBox(height: 48.0),
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
                                          color: const Color(0xFFC1D3FF),
                                          strokeWidth: 10,
                                        ),
                                        Text(
                                          '$countdown',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Color(0xFFC1D3FF)),
                                        ),
                                      ],
                                    )
                                  : Container(); // Hide the Stack when countdown is 0 or less
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 24.0,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width:
                      MediaQuery.of(context).size.width - 34, // Adjust padding
                  child: FloatingActionButton.extended(
                    onPressed: isButtonEnabled
                        ? () {
                            _showConfirmationDialog();
                          }
                        : null,
                    label: Text('Return',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                            color: isButtonEnabled
                                ? const Color(0xFFB6CBFF)
                                : const Color(0xFF1F3299))),
                    elevation: 0,
                    backgroundColor: isButtonEnabled
                        ? const Color(0xFF0B1655)
                        : const Color(0xFF020722), // Set the fill color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          50.0), // Adjust the value as needed
                      side: BorderSide(
                        color: isButtonEnabled
                            ? const Color(0xFF6086f6)
                            : const Color(0x00000000), // Set the outline color
                        width: 2.5, // Set the outline width
                      ),
                    ),
                    foregroundColor: const Color(0xFF1F3299),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
