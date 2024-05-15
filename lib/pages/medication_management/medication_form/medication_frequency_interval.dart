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
      appBar: AppBar(title: const Text('New Medication'), elevation: 0),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 32.0, horizontal: 44.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Frequency',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFEDF2FF),
                          letterSpacing: 1),
                    ),
                    const SizedBox(height: 12.0),
                    if (widget.medication.frequency_type == 'EveryXDays')
                      const Text(
                        'How many days between each dose?',
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Color(0xFFB6CBFF),
                            height: 1.5),
                      ),
                    if (widget.medication.frequency_type == 'EveryXWeeks')
                      const Text(
                        'How many weeks between each dose?',
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Color(0xFFB6CBFF),
                            height: 1.5),
                      ),
                    if (widget.medication.frequency_type == 'EveryXMonths')
                      const Text(
                        'How many months between each dose?',
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Color(0xFFB6CBFF),
                            height: 1.5),
                      ),
                    const SizedBox(height: 28.0),
                    if (widget.medication.frequency_type == 'EveryXDays')
                      SizedBox(
                        width: double.infinity, // Adjust padding as needed
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                30.0), // Adjust the radius
                          ),
                          elevation: 0, // Set the elevation for the card
                          color: const Color(0xFF303E8F),
                          child: Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Column(
                              children: [
                                Slider(
                                  value: _value,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _value = newValue;
                                    });
                                  },
                                  min: 2.0,
                                  max: 14.0,
                                  divisions: 13,
                                  label: '${_value.toInt()}',
                                  activeColor: const Color(0xFFFFD271),
                                ),
                                const SizedBox(height: 32.0),
                                const Text(
                                  'You will take this medication every',
                                  style: TextStyle(
                                      fontSize: 16.0, color: Color(0xFFB6CBFF)),
                                ),
                                const SizedBox(height: 12.0),
                                Text(
                                  '${_value.toInt()} days',
                                  style: const TextStyle(
                                      fontSize: 36.0,
                                      color: Color(0xFFFFD271),
                                      letterSpacing: 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    if (widget.medication.frequency_type == 'EveryXWeeks')
                      SizedBox(
                        width: double.infinity, // Adjust padding as needed
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                30.0), // Adjust the radius
                          ),
                          elevation: 0, // Set the elevation for the card
                          color: const Color(0xFF303E8F),
                          child: Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Column(
                              children: [
                                Slider(
                                  value: _value,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _value = newValue;
                                    });
                                  },
                                  min: 1.0,
                                  max: 14.0,
                                  divisions: 14,
                                  label: '${_value.toInt()}',
                                  activeColor: const Color(0xFFFFD271),
                                ),
                                const SizedBox(height: 32.0),
                                const Text(
                                  'You will take this medication every',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                const SizedBox(height: 12.0),
                                if (_value.toInt() == 1)
                                  Text(
                                    '${_value.toInt()}  week',
                                    style: const TextStyle(
                                        fontSize: 36.0,
                                        color: Color(0xFFFFD271),
                                        letterSpacing: 2),
                                  ),
                                if (_value.toInt() > 1)
                                  Text(
                                    '${_value.toInt()} weeks',
                                    style: const TextStyle(
                                        fontSize: 36.0,
                                        color: Color(0xFFFFD271),
                                        letterSpacing: 2),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    if (widget.medication.frequency_type == 'EveryXMonths')
                      SizedBox(
                        width: double.infinity, // Adjust padding as needed
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                30.0), // Adjust the radius
                          ),
                          elevation: 0, // Set the elevation for the card
                          color: const Color(0xFF303E8F),
                          child: Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Column(
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
                                  activeColor: const Color(0xFFFFD271),
                                ),
                                const SizedBox(height: 32.0),
                                const Text(
                                  'You will take this medication every',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                const SizedBox(height: 12.0),
                                if (_value.toInt() == 1)
                                  Text(
                                    '${_value.toInt()}  month',
                                    style: const TextStyle(
                                        fontSize: 36.0,
                                        color: Color(0xFFFFD271),
                                        letterSpacing: 2),
                                  ),
                                if (_value.toInt() > 1)
                                  Text(
                                    '${_value.toInt()} months',
                                    style: const TextStyle(
                                        fontSize: 36.0,
                                        color: Color(0xFFFFD271),
                                        letterSpacing: 2),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(
                  bottom: 16.0,
                  left: 16.0,
                  right: 16.0), // Set your desired margin
              child: SizedBox(
                height: 60.0,
                width: double.infinity,
                child: ElevatedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFFC1D3FF), // Set the fill color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          50.0), // Adjust the value as needed
                    ),
                    side: const BorderSide(
                      color: Color(0xFF6086f6), // Set the outline color
                      width: 2.5, // Set the outline width
                    ),
                  ),
                  onPressed: () {
                    _setMedicationFrequencyInterval(
                        frequencyInterval: _value.toInt());
                  },
                  child: const Text(
                    'Next',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1F3299)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
