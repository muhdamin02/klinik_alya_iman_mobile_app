import 'package:flutter/material.dart';

import '../../../models/medication.dart';
import '../../../models/profile.dart';
import '../../../models/user.dart';
import 'medication_quantity.dart';

class MedicationDoseTimesPage extends StatefulWidget {
  final Medication medication;
  final User user;
  final Profile profile;

  const MedicationDoseTimesPage({
    Key? key,
    required this.medication,
    required this.user,
    required this.profile,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MedicationDoseTimesPageState createState() =>
      _MedicationDoseTimesPageState();
}

class _MedicationDoseTimesPageState extends State<MedicationDoseTimesPage> {
  final List<TimeOfDay> _selectedTimesList = [];

// Function to show the time picker
  Future<void> _selectTime(BuildContext context, int index) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        // Ensure that _selectedTimesList has enough elements
        while (_selectedTimesList.length <= index) {
          _selectedTimesList.add(picked);
        }
        _selectedTimesList[index] = picked;
      });
    }
  }

// Function to build a list of time pickers based on daily_frequency
  List<Widget> _buildTimePickers() {
    List<Widget> timePickers = [];

    for (int i = 0; i < widget.medication.daily_frequency; i++) {
      timePickers.add(
        Column(
          children: [
            ElevatedButton(
              onPressed: () {
                _selectTime(context, i);
              },
              child: const Text('Select Time'),
            ),
            // ignore: unnecessary_null_comparison
            if (_selectedTimesList.length > i && _selectedTimesList[i] != null)
              Text(
                'Selected Time ${i + 1}: ${_selectedTimesList[i].format(context)}',
                style: const TextStyle(fontSize: 18.0),
              ),
            const SizedBox(height: 16.0),
          ],
        ),
      );
    }

    return timePickers;
  }

  void _setMedicationDoseTimes() {
    final List<String> formattedTimes =
        _selectedTimesList.map((time) => time.format(context)).toList();

    final medication = Medication(
      medication_name: widget.medication.medication_name,
      medication_type: widget.medication.medication_type,
      frequency_type: widget.medication.frequency_type,
      frequency_interval: widget.medication.frequency_interval,
      daily_frequency: widget.medication.daily_frequency,
      medication_day: widget.medication.medication_day,
      next_dose_day: widget.medication.next_dose_day,
      dose_times:
          formattedTimes.join('; '), // Use a delimiter between time pickers
      medication_quantity: 0,
      user_id: widget.user.user_id!,
      profile_id: widget.profile.profile_id!,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MedicationQuantityPage(
          medication: medication,
          user: widget.user,
          profile: widget.profile,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Step 6: Select Dose Times'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'At what time will you take it?',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Choose the time you will take your medication.',
                  style: TextStyle(fontSize: 16.0, color: Colors.grey),
                ),
                const SizedBox(height: 16.0),
                ..._buildTimePickers(),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    _setMedicationDoseTimes();
                  },
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
