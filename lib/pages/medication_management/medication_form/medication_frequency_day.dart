import 'package:flutter/material.dart';

import '../../../models/medication.dart';
import '../../../models/profile.dart';
import '../../../models/user.dart';
import 'medication_next_dose_day.dart';

class MedicationFrequencyDayPage extends StatefulWidget {
  final Medication medication;
  final User user;
  final Profile profile;

  const MedicationFrequencyDayPage({
    Key? key,
    required this.medication,
    required this.user,
    required this.profile,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MedicationFrequencyDayPageState createState() =>
      _MedicationFrequencyDayPageState();
}

class _MedicationFrequencyDayPageState
    extends State<MedicationFrequencyDayPage> {
  bool buttonIsSelected = false;

  void _setMedicationDay({required String medicationDay}) {
    if (buttonIsSelected == true) {
      final medication = Medication(
        medication_name: widget.medication.medication_name,
        medication_type: widget.medication.medication_type,
        frequency_type: widget.medication.frequency_type,
        frequency_interval: 0,
        daily_frequency: 1,
        medication_day: medicationDay,
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
                  'On what day do you take it?',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Choose the day of taking your medication.',
                  style: TextStyle(fontSize: 16.0, color: Colors.grey),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    const medicationDay = 'Sunday';
                    buttonIsSelected = true;
                    _setMedicationDay(medicationDay: medicationDay);
                  },
                  child: const SizedBox(
                      width: 200.0, child: Center(child: Text('Sunday'))),
                ),
                const SizedBox(height: 5.0),
                ElevatedButton(
                  onPressed: () {
                    const medicationDay = 'Monday';
                    buttonIsSelected = true;
                    _setMedicationDay(medicationDay: medicationDay);
                  },
                  child: const SizedBox(
                      width: 200.0, child: Center(child: Text('Monday'))),
                ),
                const SizedBox(height: 5.0),
                ElevatedButton(
                  onPressed: () {
                    const medicationDay = 'Tuesday';
                    buttonIsSelected = true;
                    _setMedicationDay(medicationDay: medicationDay);
                  },
                  child: const SizedBox(
                      width: 200.0, child: Center(child: Text('Tuesday'))),
                ),
                const SizedBox(height: 5.0),
                ElevatedButton(
                  onPressed: () {
                    const medicationDay = 'Wednesday';
                    buttonIsSelected = true;
                    _setMedicationDay(medicationDay: medicationDay);
                  },
                  child: const SizedBox(
                      width: 200.0, child: Center(child: Text('Wednesday'))),
                ),
                const SizedBox(height: 5.0),
                ElevatedButton(
                  onPressed: () {
                    const medicationDay = 'Thursday';
                    buttonIsSelected = true;
                    _setMedicationDay(medicationDay: medicationDay);
                  },
                  child: const SizedBox(
                      width: 200.0, child: Center(child: Text('Thursday'))),
                ),
                const SizedBox(height: 5.0),
                ElevatedButton(
                  onPressed: () {
                    const medicationDay = 'Friday';
                    buttonIsSelected = true;
                    _setMedicationDay(medicationDay: medicationDay);
                  },
                  child: const SizedBox(
                      width: 200.0, child: Center(child: Text('Friday'))),
                ),
                const SizedBox(height: 5.0),
                ElevatedButton(
                  onPressed: () {
                    const medicationDay = 'Saturday';
                    buttonIsSelected = true;
                    _setMedicationDay(medicationDay: medicationDay);
                  },
                  child: const SizedBox(
                      width: 200.0, child: Center(child: Text('Saturday'))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
