import 'package:flutter/material.dart';

import '../../models/medication.dart';
import '../../models/profile.dart';
import '../../models/user.dart';
import 'medication_form/medication_name.dart';

class MedicationForm extends StatefulWidget {
  final User user;
  final Profile profile;

  const MedicationForm({Key? key, required this.user, required this.profile})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MedicationFormState createState() => _MedicationFormState();
}

class _MedicationFormState extends State<MedicationForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Medication'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Please be patient as we guide you through the process.',
                style: TextStyle(fontSize: 20.0),
              ),
              const SizedBox(height: 32.0),
              SizedBox(
                height: 45.0,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final medication = Medication(
                      medication_name: '',
                      medication_type: '',
                      frequency_type: '',
                      frequency_interval: 0,
                      daily_frequency: 0,
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
                        builder: (context) => MedicationNamePage(
                          medication: medication,
                          user: widget.user,
                          profile: widget.profile,
                        ),
                      ),
                    );
                  },
                  child: const Text('Continue',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
