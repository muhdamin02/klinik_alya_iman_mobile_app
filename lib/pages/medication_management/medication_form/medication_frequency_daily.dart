import 'package:flutter/material.dart';

import '../../../models/medication.dart';
import '../../../models/profile.dart';
import '../../../models/user.dart';
import 'medication_dose_times.dart';

class MedicationDailyFrequencyPage extends StatefulWidget {
  final Medication medication;
  final User user;
  final Profile profile;

  const MedicationDailyFrequencyPage({
    Key? key,
    required this.medication,
    required this.user,
    required this.profile,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MedicationDailyFrequencyPageState createState() =>
      _MedicationDailyFrequencyPageState();
}

class _MedicationDailyFrequencyPageState
    extends State<MedicationDailyFrequencyPage> {
  bool buttonIsSelected = false;

  void _setDailyFrequency({required int dailyFrequency}) {
    if (buttonIsSelected == true) {
      final medication = Medication(
        medication_name: widget.medication.medication_name,
        medication_type: widget.medication.medication_type,
        frequency_type: widget.medication.frequency_type,
        frequency_interval: 0,
        daily_frequency: dailyFrequency,
        next_dose_day: '',
        dose_times: '',
        medication_time: '',
        medication_quantity: 0,
        user_id: widget.user.user_id!,
        profile_id: widget.profile.profile_id!,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MedicationDoseTimesPage(
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
        title: const Text('Step 4: Frequency Intervals'),
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
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    const dailyFrequency = 1;
                    buttonIsSelected = true;
                    _setDailyFrequency(dailyFrequency: dailyFrequency);
                  },
                  child: const SizedBox(
                      width: 200.0, child: Center(child: Text('Once a day'))),
                ),
                const SizedBox(height: 5.0),
                ElevatedButton(
                  onPressed: () {
                    const dailyFrequency = 2;
                    buttonIsSelected = true;
                    _setDailyFrequency(dailyFrequency: dailyFrequency);
                  },
                  child: const SizedBox(
                      width: 200.0, child: Center(child: Text('Twice a day'))),
                ),
                const SizedBox(height: 5.0),
                ElevatedButton(
                  onPressed: () {
                    const dailyFrequency = 3;
                    buttonIsSelected = true;
                    _setDailyFrequency(dailyFrequency: dailyFrequency);
                  },
                  child: const SizedBox(
                      width: 200.0,
                      child: Center(child: Text('Three times a day'))),
                ),
                const SizedBox(height: 5.0),
                ElevatedButton(
                  onPressed: () {
                    const dailyFrequency = 4;
                    buttonIsSelected = true;
                    _setDailyFrequency(dailyFrequency: dailyFrequency);
                  },
                  child: const SizedBox(
                      width: 200.0,
                      child: Center(child: Text('Four times a day'))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
