import 'package:flutter/material.dart';

import '../../../models/medication.dart';
import '../../../models/profile.dart';
import '../../../models/user.dart';
import 'medication_frequency_type.dart';

class MedicationTypePage extends StatefulWidget {
  final Medication medication;
  final User user;
  final Profile profile;

  const MedicationTypePage({
    Key? key,
    required this.medication,
    required this.user,
    required this.profile,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MedicationTypePageState createState() => _MedicationTypePageState();
}

class _MedicationTypePageState extends State<MedicationTypePage> {
  bool buttonIsSelected = false;

  void _setMedicationType({required String type}) {
    if (buttonIsSelected == true) {
      final medication = Medication(
        medication_name: widget.medication.medication_name,
        medication_type: type,
        frequency_type: '',
        frequency_interval: 0,
        daily_frequency: 0,
        medication_day: '',
        next_dose_day: '',
        dose_times: '',
        medication_quantity: 0,
        user_id: widget.user.user_id!,
        profile_id: widget.profile.profile_id!,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MedicationFrequencyTypePage(
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
        title: const Text('Step 2: Medication Type'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Choose Medication Type',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Please choose the type of your medication.',
                  style: TextStyle(fontSize: 16.0, color: Colors.grey),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    const medicationType = 'Pills';
                    buttonIsSelected = true;
                    _setMedicationType(type: medicationType);
                  },
                  child: const SizedBox(
                      width: 200.0,
                      child: Center(child: Text('Pills'))),
                ),
                const SizedBox(height: 5.0),
                ElevatedButton(
                  onPressed: () {
                    const medicationType = 'Injection';
                    buttonIsSelected = true;
                    _setMedicationType(type: medicationType);
                  },
                  child: const SizedBox(
                      width: 200.0,
                      child: Center(child: Text('Injection'))),
                ),
                const SizedBox(height: 5.0),
                ElevatedButton(
                  onPressed: () {
                    const medicationType = 'Solution (liquid)';
                    buttonIsSelected = true;
                    _setMedicationType(type: medicationType);
                  },
                  child: const SizedBox(
                      width: 200.0,
                      child: Center(child: Text('Solution (liquid)'))),
                ),
                const SizedBox(height: 5.0),
                ElevatedButton(
                  onPressed: () {
                    const medicationType = 'Drops';
                    buttonIsSelected = true;
                    _setMedicationType(type: medicationType);
                  },
                  child: const SizedBox(
                      width: 200.0,
                      child: Center(child: Text('Drops'))),
                ),
                const SizedBox(height: 5.0),
                ElevatedButton(
                  onPressed: () {
                    const medicationType = 'Inhaler';
                    buttonIsSelected = true;
                    _setMedicationType(type: medicationType);
                  },
                  child: const SizedBox(
                      width: 200.0,
                      child: Center(child: Text('Inhaler'))),
                ),
                const SizedBox(height: 5.0),
                ElevatedButton(
                  onPressed: () {
                    const medicationType = 'Powder';
                    buttonIsSelected = true;
                    _setMedicationType(type: medicationType);
                  },
                  child: const SizedBox(
                      width: 200.0,
                      child: Center(child: Text('Powder'))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
