import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:klinik_alya_iman_mobile_app/pages/maternity_pages/second_trimester/baby_kicks_list.dart';

import '../../../models/baby_kicks.dart';
import '../../../models/profile.dart';
import '../../../models/user.dart';
import '../../../services/database_service.dart';

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
          _elapsedTime += Duration(seconds: 1);
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
      kick_datetime: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      user_id: widget.user.user_id!,
      profile_id: widget.profile.profile_id,
    );

    try {
      // Insert the appointment into the database
      await DatabaseService().newBabyKicks(babyKicks);

      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Form submitted successfully!'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Baby Kick Count:',
              style: TextStyle(fontSize: 24.0),
            ),
            Text(
              '$kickCount',
              style: const TextStyle(fontSize: 48.0),
            ),
            const SizedBox(height: 20),
            const Text(
              'Time Remaining:',
              style: TextStyle(fontSize: 24.0),
            ),
            Text(
              _formatDuration(Duration(seconds: _secondsRemaining)),
              style: const TextStyle(fontSize: 48.0),
            ),
            const SizedBox(height: 16),
            if (_timerStarted && !_timerStopped)
              FloatingActionButton(
                onPressed: _stopTimer,
                tooltip: 'Stop Timer',
                child: const Icon(Icons.stop),
              ),
            if (!_timerStarted && !_timerStopped)
              ElevatedButton(
                onPressed: _startTimer,
                child: const Text('Start Timer'),
              ),
            if (_timerStopped)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton(
                  onPressed: _saveKicks,
                  child: const Text('Save'),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
                kickCount++;
              });
            },
            tooltip: 'Add Kick',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _addTime,
            tooltip: 'Add 5 Minutes',
            child: const Icon(Icons.timer),
          ),
        ],
      ),
    );
  }
}
