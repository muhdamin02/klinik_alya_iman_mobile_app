import 'package:flutter/material.dart';

import '../../../models/medication.dart';
import '../../../models/profile.dart';
import '../../../models/user.dart';
import 'medication_frequency_daily.dart';
import 'medication_frequency_day.dart';
import 'medication_frequency_interval.dart';
import 'medication_next_dose_day.dart';

class MedicationFrequencyTypePage extends StatefulWidget {
  final Medication medication;
  final User user;
  final Profile profile;

  const MedicationFrequencyTypePage({
    Key? key,
    required this.medication,
    required this.user,
    required this.profile,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MedicationFrequencyTypePageState createState() =>
      _MedicationFrequencyTypePageState();
}

class _MedicationFrequencyTypePageState
    extends State<MedicationFrequencyTypePage> {
  bool buttonIsSelected = false;

  void _setMedicationFrequency({required String frequency}) {
    if (buttonIsSelected == true) {
      final medication = Medication(
        medication_name: widget.medication.medication_name,
        medication_type: widget.medication.medication_type,
        frequency_type: frequency,
        frequency_interval: 0,
        daily_frequency: 0,
        medication_day: '',
        next_dose_day: '',
        dose_times: '',
        medication_quantity: 0,
        user_id: widget.user.user_id!,
        profile_id: widget.profile.profile_id!,
      );

      if (frequency == 'EveryDay') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MedicationDailyFrequencyPage(
              medication: medication,
              user: widget.user,
              profile: widget.profile,
            ),
          ),
        );
      }

      if (frequency == 'EveryOtherDay') {
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

      if (frequency == 'SpecificDays') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MedicationFrequencyDayPage(
              medication: medication,
              user: widget.user,
              profile: widget.profile,
            ),
          ),
        );
      }

      if (frequency == 'EveryXDays' ||
          frequency == 'EveryXWeeks' ||
          frequency == 'EveryXMonths') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MedicationFrequencyIntervalPage(
              medication: medication,
              user: widget.user,
              profile: widget.profile,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Step 3: Frequency Type'),
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
                  'Choose the frequency of taking your medication.',
                  style: TextStyle(fontSize: 16.0, color: Colors.grey),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    const medicationFrequency = 'EveryDay';
                    buttonIsSelected = true;
                    _setMedicationFrequency(frequency: medicationFrequency);
                  },
                  child: const SizedBox(
                      width: 200.0, child: Center(child: Text('Every day'))),
                ),
                const SizedBox(height: 5.0),
                ElevatedButton(
                  onPressed: () {
                    const medicationFrequency = 'EveryOtherDay';
                    buttonIsSelected = true;
                    _setMedicationFrequency(frequency: medicationFrequency);
                  },
                  child: const SizedBox(
                      width: 200.0,
                      child: Center(child: Text('Every other day'))),
                ),
                const SizedBox(height: 5.0),
                ElevatedButton(
                  onPressed: () {
                    const medicationFrequency = 'SpecificDays';
                    buttonIsSelected = true;
                    _setMedicationFrequency(frequency: medicationFrequency);
                  },
                  child: const SizedBox(
                      width: 200.0,
                      child: Center(child: Text('Specific days of the week'))),
                ),
                const SizedBox(height: 5.0),
                ElevatedButton(
                  onPressed: () {
                    const medicationFrequency = 'EveryXDays';
                    buttonIsSelected = true;
                    _setMedicationFrequency(frequency: medicationFrequency);
                  },
                  child: const SizedBox(
                      width: 200.0, child: Center(child: Text('Every X days'))),
                ),
                const SizedBox(height: 5.0),
                ElevatedButton(
                  onPressed: () {
                    const medicationFrequency = 'EveryXWeeks';
                    buttonIsSelected = true;
                    _setMedicationFrequency(frequency: medicationFrequency);
                  },
                  child: const SizedBox(
                      width: 200.0,
                      child: Center(child: Text('Every X weeks'))),
                ),
                const SizedBox(height: 5.0),
                ElevatedButton(
                  onPressed: () {
                    const medicationFrequency = 'EveryXMonths';
                    buttonIsSelected = true;
                    _setMedicationFrequency(frequency: medicationFrequency);
                  },
                  child: const SizedBox(
                      width: 200.0,
                      child: Center(child: Text('Every X months'))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
