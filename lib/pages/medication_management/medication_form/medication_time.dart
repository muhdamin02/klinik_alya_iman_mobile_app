import 'package:flutter/material.dart';

import '../../../models/medication.dart';
import '../../../models/profile.dart';
import '../../../models/user.dart';
import 'medication_quantity.dart';

class MedicationTimePage extends StatefulWidget {
  final Medication medication;
  final User user;
  final Profile profile;

  const MedicationTimePage({
    Key? key,
    required this.medication,
    required this.user,
    required this.profile,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MedicationTimePageState createState() => _MedicationTimePageState();
}

class _MedicationTimePageState extends State<MedicationTimePage> {
  final TextEditingController _medicationTimeController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      // ... UI for capturing medication name ...
      child: ElevatedButton(
        onPressed: () {
          final medicationTime = _medicationTimeController.text;
          if (medicationTime.isNotEmpty) {
            // Create Medication object with the entered name
            final medication = Medication(
              medication_name: widget.medication.medication_name,
              medication_type: widget.medication.medication_type,
              frequency_type: widget.medication.frequency_type,
              frequency_interval: widget.medication.frequency_interval,
              daily_frequency: widget.medication.daily_frequency,
              next_dose_day: widget.medication.next_dose_day,
              dose_times: widget.medication.dose_times,
              medication_time: medicationTime,
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
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please enter a medication time.'),
              ),
            );
          }
        },
        child: const Text('Next'),
      ),
    );
  }
}
