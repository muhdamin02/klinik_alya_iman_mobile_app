import 'package:flutter/material.dart';

import '../../../models/medication.dart';
import '../../../models/profile.dart';
import '../../../models/user.dart';
import 'medication_type.dart';

class MedicationNamePage extends StatefulWidget {
  final Medication medication;
  final User user;
  final Profile profile;

  const MedicationNamePage({
    Key? key,
    required this.medication,
    required this.user,
    required this.profile,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MedicationNamePageState createState() => _MedicationNamePageState();
}

class _MedicationNamePageState extends State<MedicationNamePage> {
  final TextEditingController _medicationNameController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Step 1: Medication Name'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Enter Medication Name',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Please enter the name of your medication. For example, "Aspirin", "Ibuprofen", etc.',
                  style: TextStyle(fontSize: 16.0, color: Colors.grey),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _medicationNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Medication Name',
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    final medicationName = _medicationNameController.text;
                    if (medicationName.isNotEmpty) {
                      final medication = Medication(
                        medication_name: medicationName,
                        medication_type: '',
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
                          builder: (context) => MedicationTypePage(
                            medication: medication,
                            user: widget.user,
                            profile: widget.profile,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a medication name.'),
                        ),
                      );
                    }
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
