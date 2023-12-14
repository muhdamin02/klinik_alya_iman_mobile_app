import 'package:flutter/material.dart';

import '../../../models/medication.dart';
import '../../../models/profile.dart';
import '../../../models/user.dart';
import 'medication_next_dose_day.dart';

class MedicationFrequencyIntervalPage extends StatefulWidget {
  final Medication medication;
  final User user;
  final Profile profile;

  const MedicationFrequencyIntervalPage({
    Key? key,
    required this.medication,
    required this.user,
    required this.profile,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MedicationFrequencyIntervalPageState createState() =>
      _MedicationFrequencyIntervalPageState();
}

class _MedicationFrequencyIntervalPageState
    extends State<MedicationFrequencyIntervalPage> {
  @override
  void initState() {
    super.initState();
    _initializeValueBasedOnFrequencyType();
  }

  late double _value;

  void _initializeValueBasedOnFrequencyType() {
    if (widget.medication.frequency_type == 'EveryXDays') {
      _value = 2.0;
    } else {
      _value = 1.0;
    }
  }

  void _setMedicationFrequencyInterval({required int frequencyInterval}) {
    final medication = Medication(
      medication_name: widget.medication.medication_name,
      medication_type: widget.medication.medication_type,
      frequency_type: widget.medication.frequency_type,
      frequency_interval: frequencyInterval,
      medication_day: '',
      daily_frequency: 1,
      next_dose_day: '',
      dose_times: '',
      medication_quantity: 0,
      user_id: widget.user.user_id!,
      profile_id: widget.profile.profile_id!,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MedicationNextDoseDayPage(
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
        title: const Text('Step 4: Frequency Interval'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'How often do you take it?',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Specify the frequency of taking your medication.',
                  style: TextStyle(fontSize: 16.0, color: Colors.grey),
                ),
                const SizedBox(height: 32.0),
                if (widget.medication.frequency_type == 'EveryXDays')
                  Column(
                    children: [
                      Slider(
                        value: _value,
                        onChanged: (newValue) {
                          setState(() {
                            _value = newValue;
                          });
                        },
                        min: 2.0,
                        max: 30.0,
                        divisions: 29,
                        label: '${_value.toInt()}',
                      ),
                      Text(
                        'You will take this medication every ${_value.toInt()} days.',
                        style: const TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),
                if (widget.medication.frequency_type == 'EveryXWeeks')
                  Column(
                    children: [
                      Slider(
                        value: _value,
                        onChanged: (newValue) {
                          setState(() {
                            _value = newValue;
                          });
                        },
                        min: 1.0,
                        max: 21.0,
                        divisions: 21,
                        label: '${_value.toInt()}',
                      ),
                      Text(
                        'You will take this medication every ${_value.toInt()} ${_value.toInt() == 1 ? 'week' : 'weeks'}.',
                        style: const TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),
                if (widget.medication.frequency_type == 'EveryXMonths')
                  Column(
                    children: [
                      Slider(
                        value: _value,
                        onChanged: (newValue) {
                          setState(() {
                            _value = newValue;
                          });
                        },
                        min: 1.0,
                        max: 12.0,
                        divisions: 12,
                        label: '${_value.toInt()}',
                      ),
                      Text(
                        'You will take this medication every ${_value.toInt()} ${_value.toInt() == 1 ? 'month' : 'months'}.',
                        style: const TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),
                const SizedBox(height: 48.0),
                ElevatedButton(
                  onPressed: () {
                    _setMedicationFrequencyInterval(
                        frequencyInterval: _value.toInt());
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
