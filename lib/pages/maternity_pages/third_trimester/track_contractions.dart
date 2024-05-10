import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/contractions.dart';
import '../../../models/profile.dart';
import '../../../models/user.dart';
import '../../../services/database_service.dart';
import 'contractions_list.dart';

class TrackContractions extends StatefulWidget {
  final User user;
  final Profile profile;
  final bool autoImplyLeading;

  const TrackContractions({
    Key? key,
    required this.user,
    required this.profile,
    required this.autoImplyLeading,
  }) : super(key: key);

  @override
  _TrackContractionsState createState() => _TrackContractionsState();
}

class _TrackContractionsState extends State<TrackContractions> {
  late Stopwatch _stopwatch;
  late Timer _timer;
  int _milliseconds = 0;
  bool _isRunning = false;
  int _contractionIntensity = 0;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _timer = Timer.periodic(Duration(milliseconds: 100), _updateTime);
  }

  void _updateTime(Timer timer) {
    if (_stopwatch.isRunning) {
      setState(() {
        _milliseconds = _stopwatch.elapsedMilliseconds;
      });
    }
  }

  @override
  void dispose() {
    _stopwatch.stop();
    _timer.cancel();
    super.dispose();
  }

  void _startStopwatch() {
    setState(() {
      _isRunning = true;
      _stopwatch.start();
    });
  }

  void _stopStopwatch() {
    setState(() {
      _isRunning = false;
      _stopwatch.stop();
      _showRatingDialog();
    });
  }

  void _resetStopwatch() {
    setState(() {
      _stopwatch.reset();
      _milliseconds = 0;
      _isRunning = false;
    });
  }

  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rate the intensity of the contractions'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Please rate the intensity from 1 to 5:'),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  5,
                  (index) => InkWell(
                    onTap: () {
                      setState(() {
                        _contractionIntensity = index + 1;
                      });
                      Navigator.of(context).pop();
                      _showRatingSnackBar();
                    },
                    child: Icon(
                      index < _contractionIntensity
                          ? Icons.star
                          : Icons.star_border,
                      size: 40,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showRatingSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Contractions intensity rated: $_contractionIntensity'),
      ),
    );
  }

  void _saveContraction() async {
    // Create a new appointment instance with the form data
    final contraction = Contraction(
      contraction_duration: _milliseconds ~/ 1000, // just to test if it can save this
      contraction_rating: _contractionIntensity, // just to test if it can save this
      contraction_datetime:
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      user_id: widget.user.user_id!,
      profile_id: widget.profile.profile_id,
    );

    try {
      // Insert the appointment into the database
      await DatabaseService().newContraction(contraction);

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
                    builder: (context) => ContractionsList(
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
    String formattedTime =
        Duration(milliseconds: _milliseconds).toString().split('.').first;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Contractions'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Elapsed Time: $formattedTime',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (!_isRunning && _milliseconds == 0) {
                  _startStopwatch();
                } else if (_isRunning) {
                  _stopStopwatch();
                } else {
                  _resetStopwatch();
                }
              },
              child: Text(
                _isRunning ? 'Stop' : (_milliseconds == 0 ? 'Start' : 'Reset'),
              ),
            ),
            if (!_isRunning && _milliseconds > 0)
              ElevatedButton(
                onPressed: () {
                  _saveContraction();
                },
                child: Text('Save'),
              ),
          ],
        ),
      ),
    );
  }
}
