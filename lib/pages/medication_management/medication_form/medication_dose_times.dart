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
  List<TimeOfDay> _selectedTimesList = [];

  @override
  void initState() {
    super.initState();
    _selectedTimesList = List.generate(
      widget.medication.daily_frequency,
      (_) => TimeOfDay.now(),
    );
  }

  List<Widget> _buildTimePickers() {
    List<Widget> timePickers = [];

    for (int i = 0; i < widget.medication.daily_frequency; i++) {
      int j = i + 1;
      String buttonText =
          _selectedTimesList.length > i && _selectedTimesList[i] != null
              ? _selectedTimesList[i]!.format(context)
              : 'Time $j';

      timePickers.add(
        Column(
          children: [
            SizedBox(
              height: 60.0,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC1D3FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  side: const BorderSide(
                    color: Color(0xFF6086f6),
                    width: 2.5,
                  ),
                ),
                onPressed: () async {
                  await _selectTime(context, i);
                  setState(() {});
                },
                child: Text(
                  buttonText,
                  style: const TextStyle(
                      fontSize: 24, color: Color(0xFF1F3299), letterSpacing: 1),
                ),
              ),
            ),
            const SizedBox(height: 12.0),
          ],
        ),
      );
    }

    return timePickers;
  }

  // Function to show the time picker
  Future<void> _selectTime(BuildContext context, int index) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTimesList[index],
    );

    if (picked != null) {
      _selectedTimesList[index] = picked;
    }
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
                      'Dose Times',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFEDF2FF),
                          letterSpacing: 1),
                    ),
                    const SizedBox(height: 12.0),
                    const Text(
                      'At what time will you take your medication?',
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Color(0xFFB6CBFF),
                          height: 1.5),
                    ),
                    const SizedBox(height: 32.0),
                    ..._buildTimePickers(),
                    const SizedBox(height: 16.0),
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
                    _setMedicationDoseTimes();
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
