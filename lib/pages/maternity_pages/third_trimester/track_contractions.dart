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
    _timer = Timer.periodic(const Duration(milliseconds: 100), _updateTime);
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

  final List<Color> _ratingColors = [
    Colors.green,
    Colors.lightGreen,
    Colors.yellow,
    Colors.orange,
    Colors.red,
  ];

  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          backgroundColor: const Color(0xFF303E8F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: const Text('Rate the intensity'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                  'Please rate the intensity of the contractions from 1 (mild) to 5 (severe):'),
              const SizedBox(height: 20),
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
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _contractionIntensity == index + 1
                            ? _ratingColors[index]
                            : Colors.grey[300],
                      ),
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 24,
                          color: _contractionIntensity == index + 1
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
      contraction_duration:
          _milliseconds ~/ 1000, // just to test if it can save this
      contraction_rating:
          _contractionIntensity, // just to test if it can save this
      contraction_datetime: DateTime.now().toString(),
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
                        vertical: 42.0, horizontal: 14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Center(
                          child: Text(
                            "ELAPSED TIME",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 24,
                              color: Color(0xFFB6CBFF),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          formattedTime,
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
            // Text(
            //   'Elapsed Time: $formattedTime',
            //   style: TextStyle(fontSize: 24.0),
            // ),
            const SizedBox(height: 32),
            if (!_isRunning && _milliseconds == 0)
              ElevatedButton(
                onPressed: _startStopwatch,
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
            if (_isRunning)
              ElevatedButton(
                onPressed: _stopStopwatch,
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
                    Icons.stop_rounded,
                    size: 32,
                    color: Color(0xFF1F3299),
                  ),
                ),
              ),
            if (!_isRunning && _milliseconds > 0)
              ElevatedButton(
                onPressed: _saveContraction,
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
                    Icons.save_rounded,
                    size: 32,
                    color: Color(0xFF1F3299),
                  ),
                ),
              ),

            // ElevatedButton(
            //   onPressed: () {
            //     if (!_isRunning && _milliseconds == 0) {
            //       _startStopwatch();
            //     } else if (_isRunning) {
            //       _stopStopwatch();
            //     } else {
            //       _resetStopwatch();
            //     }
            //   },
            //   child: Text(
            //     _isRunning ? 'Stop' : (_milliseconds == 0 ? 'Start' : 'Reset'),
            //   ),
            // ),
            // if (!_isRunning && _milliseconds > 0)
            //   ElevatedButton(
            //     onPressed: () {
            //       _saveContraction();
            //     },
            //     child: Text('Save'),
            //   ),
          ],
        ),
      ),
    );
  }
}
