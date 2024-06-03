import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:klinik_alya_iman_mobile_app/pages/maternity_pages/second_trimester/baby_kicks_list.dart';

import '../../../models/baby_kicks.dart';
import '../../../models/profile.dart';
import '../../../models/user.dart';
import '../../../services/database_service.dart';
import '../../../services/misc_methods/show_hovering_message.dart';

class BabyKickCounter extends StatefulWidget {
  final User user;
  final Profile profile;
  final bool autoImplyLeading;

  const BabyKickCounter({
    Key? key,
    required this.user,
    required this.profile,
    required this.autoImplyLeading,
  }) : super(key: key);

  @override
  _BabyKickCounterState createState() => _BabyKickCounterState();
}

class _BabyKickCounterState extends State<BabyKickCounter> {
  int kickCount = 0;
  int _secondsRemaining = 3600;
  late Timer _timer;

  Duration _elapsedTime = Duration.zero;

  bool _timerStarted = false;
  bool _timerStopped = false;
  bool _timerPaused = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimerManually() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (Timer timer) {
      setState(() {
        if (_secondsRemaining == 0) {
          timer.cancel();
        } else {
          _secondsRemaining--;
          _elapsedTime += const Duration(seconds: 1);
        }
      });
    });
  }

  void _startTimer() {
    if (!_timerStarted) {
      _startTimerManually();
      _timerStarted = true;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Timer started.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _resumeTimer() {
    if (_timerPaused) {
      _startTimerManually();
      _timerStarted = true;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Timer resumed.'),
          duration: Duration(seconds: 2),
        ),
      );
      setState(() {
        _timerPaused = false;
      });
    }
  }

  void _pauseTimer() {
    _timer.cancel();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Timer paused.'),
        duration: Duration(seconds: 2),
      ),
    );
    setState(() {
      _timerPaused = true;
    });
  }

  void _stopTimer() {
    _timer.cancel();
    String totalDuration = _formatDuration(_elapsedTime);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Timer stopped. Total time: $totalDuration'),
        duration: const Duration(seconds: 5),
      ),
    );
    setState(() {
      _timerStopped = true;
    });
  }

  void _addTime() {
    const int maxSeconds = 7200; // 2 hours in seconds
    if (!_timerStarted && !_timerStopped) {
      showHoveringMessage(context, 'Timer hasn\'t started', 0.915, 0.25, 0.5);
    } else {
      if (_secondsRemaining + 300 <= maxSeconds) {
        setState(() {
          _secondsRemaining += 300; // 300 seconds = 5 minutes
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Timer should not exceed 2 hours.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitHours = twoDigits(duration.inHours);
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return '$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds';
    } else {
      return '$twoDigitMinutes:$twoDigitSeconds';
    }
  }

// Submit form
  void _saveKicks() async {
    // if (_isDateSelected) {

    // 'symptom_category': symptom_category,
    // 'symptom_name': symptom_name,
    // 'symptom_description': symptom_description,
    // 'symptom_entry_date': symptom_entry_date,
    // 'symptom_last_edit_date': symptom_last_edit_date,

    // Create a new appointment instance with the form data
    final babyKicks = BabyKicks(
      kick_count: kickCount,
      kick_duration: _elapsedTime.inSeconds,
      kick_datetime: DateTime.now().toString(),
      user_id: widget.user.user_id!,
      profile_id: widget.profile.profile_id,
    );

    try {
      // Insert the appointment into the database
      await DatabaseService().newBabyKicks(babyKicks);

      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            backgroundColor: const Color(0xFF303E8F),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            title: const Text('Done'),
            content: const Text('Baby kicks recorded!'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK',
                    style: TextStyle(color: Color(0xFFEDF2FF))),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BabyKicksList(
                        user: widget.user,
                        profile: widget.profile,
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
    } catch (error) {
      // Handle any errors that occur during the database operation
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('An error occurred: $error'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Baby Kick Counter'),
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 36),
              SizedBox(
                width: double.infinity, // Adjust padding as needed
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                          0xFF3848A1), // Background color of the ElevatedButton
                      elevation: 0, // Set the elevation for the button
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20.0), // Adjust the radius
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 28.0, horizontal: 14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Center(
                            child: Text(
                              "KICK COUNT",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 24,
                                color: Color(0xFFB6CBFF),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$kickCount',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 56,
                              color: Color(0xFFFFD271),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity, // Adjust padding as needed
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                          0xFF3848A1), // Background color of the ElevatedButton
                      elevation: 0, // Set the elevation for the button
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20.0), // Adjust the radius
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 28.0, horizontal: 14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Center(
                            child: Text(
                              "TIME REMAINING",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 24,
                                color: Color(0xFFB6CBFF),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _formatDuration(
                                Duration(seconds: _secondsRemaining)),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 56,
                              color: Color(0xFFEDF2FF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              if (_timerPaused && !_timerStopped)
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 84),
                        child: SizedBox(
                          width: 200, // Adjust padding as needed
                          child: ElevatedButton(
                            onPressed: _resumeTimer,
                            style: OutlinedButton.styleFrom(
                              elevation: 0,
                              backgroundColor:
                                  const Color(0xFFDBE5FF), // Set the fill color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20.0), // Adjust the value as needed
                              ),
                              side: const BorderSide(
                                color:
                                    Color(0xFF6086f6), // Set the outline color
                                width: 3, // Set the outline width
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(20),
                              child: Icon(
                                Icons.play_arrow_rounded,
                                size: 32,
                                color: Color(0xFF1F3299),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 84),
                        child: SizedBox(
                          width: 200, // Adjust padding as needed
                          child: ElevatedButton(
                            onPressed: _stopTimer,
                            style: OutlinedButton.styleFrom(
                              elevation: 0,
                              backgroundColor:
                                  const Color(0xFFDBE5FF), // Set the fill color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20.0), // Adjust the value as needed
                              ),
                              side: const BorderSide(
                                color:
                                    Color(0xFF6086f6), // Set the outline color
                                width: 3, // Set the outline width
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(20),
                              child: Icon(
                                Icons.stop_rounded,
                                size: 32,
                                color: Color(0xFF1F3299),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              if (_timerStarted && !_timerStopped && !_timerPaused)
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 84),
                        child: SizedBox(
                          width: 200, // Adjust padding as needed
                          child: ElevatedButton(
                            onPressed: _pauseTimer,
                            style: OutlinedButton.styleFrom(
                              elevation: 0,
                              backgroundColor:
                                  const Color(0xFFDBE5FF), // Set the fill color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20.0), // Adjust the value as needed
                              ),
                              side: const BorderSide(
                                color:
                                    Color(0xFF6086f6), // Set the outline color
                                width: 3, // Set the outline width
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(20),
                              child: Icon(
                                Icons.pause_rounded,
                                size: 32,
                                color: Color(0xFF1F3299),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 84),
                        child: SizedBox(
                          width: 200, // Adjust padding as needed
                          child: ElevatedButton(
                            onPressed: _stopTimer,
                            style: OutlinedButton.styleFrom(
                              elevation: 0,
                              backgroundColor:
                                  const Color(0xFFDBE5FF), // Set the fill color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20.0), // Adjust the value as needed
                              ),
                              side: const BorderSide(
                                color:
                                    Color(0xFF6086f6), // Set the outline color
                                width: 3, // Set the outline width
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(20),
                              child: Icon(
                                Icons.stop_rounded,
                                size: 32,
                                color: Color(0xFF1F3299),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              if (!_timerStarted && !_timerStopped)
                ElevatedButton(
                  onPressed: _startTimer,
                  style: OutlinedButton.styleFrom(
                    elevation: 0,
                    backgroundColor:
                        const Color(0xFFDBE5FF), // Set the fill color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          20.0), // Adjust the value as needed
                    ),
                    side: const BorderSide(
                      color: Color(0xFF6086f6), // Set the outline color
                      width: 3, // Set the outline width
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(20),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      size: 32,
                      color: Color(0xFF1F3299),
                    ),
                  ),
                ),
              if (_timerStopped)
                ElevatedButton(
                    onPressed: _saveKicks,
                    style: OutlinedButton.styleFrom(
                      elevation: 0,
                      backgroundColor:
                          const Color(0xFFDBE5FF), // Set the fill color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20.0), // Adjust the value as needed
                      ),
                      side: const BorderSide(
                        color: Color(0xFF6086f6), // Set the outline color
                        width: 3, // Set the outline width
                      ),
                    ),
                    child: const Padding(
                        padding: EdgeInsets.all(20),
                        child: Icon(Icons.save_rounded,
                            size: 32, color: Color(0xFF1F3299)))),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    height: 70.0,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!_timerStarted && !_timerStopped) {
                          showHoveringMessage(context, 'Timer hasn\'t started',
                              0.81, 0.25, 0.5);
                        }
                        if (_timerStarted) {
                          setState(() {
                            kickCount++;
                          });
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        elevation: 0,
                        backgroundColor:
                            const Color(0xFFFFE2A2), // Set the fill color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20.0), // Adjust the value as needed
                        ),
                        side: const BorderSide(
                          color: Color(0xFF5F4712), // Set the outline color
                          width: 2.5, // Set the outline width
                        ),
                      ),
                      child: const Text(
                        'Kick',
                        style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF5F4712),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1 // Text color
                            ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    height: 70.0,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _addTime,
                      style: OutlinedButton.styleFrom(
                        elevation: 0,
                        backgroundColor:
                            const Color(0xFF0B1655), // Set the fill color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20.0), // Adjust the value as needed
                        ),
                        side: const BorderSide(
                          color: Color(0xFFC1D3FF), // Set the outline color
                          width: 3, // Set the outline width
                        ),
                      ),
                      child: const Text(
                        '+ 5 minutes',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFFC1D3FF), // Text color
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// floatingActionButton: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           FloatingActionButton(
//             onPressed: () {
              // setState(() {
              //   kickCount++;
              // });
//             },
//             tooltip: 'Add Kick',
//             child: const Icon(Icons.add),
//           ),
//           const SizedBox(height: 16),
//           FloatingActionButton(
//             onPressed: _addTime,
//             tooltip: 'Add 5 Minutes',
//             child: const Icon(Icons.timer),
//           ),
//         ],
//       )