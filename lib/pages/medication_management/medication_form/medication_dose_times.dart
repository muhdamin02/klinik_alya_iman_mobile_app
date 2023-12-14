import 'package:flutter/material.dart';

import '../../../models/medication.dart';
import '../../../models/profile.dart';
import '../../../models/user.dart';
import 'medication_time.dart';

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
  _MedicationDoseTimesPageState createState() => _MedicationDoseTimesPageState();
}

class _MedicationDoseTimesPageState extends State<MedicationDoseTimesPage> {
  final TextEditingController _medicationDoseController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      // ... UI for capturing medication name ...
      child: ElevatedButton(
        onPressed: () {
          final medicationDose = _medicationDoseController.text;
          if (medicationDose.isNotEmpty) {
            // Create Medication object with the entered name
            final medication = Medication(
              medication_name: widget.medication.medication_name,
              medication_type: widget.medication.medication_type,
              frequency_type: widget.medication.frequency_type,
              frequency_interval: widget.medication.frequency_interval,
              daily_frequency: widget.medication.daily_frequency,
              next_dose_day: medicationDose,
              dose_times: medicationDose,
              medication_time: 'not yet defined',
              medication_quantity: 0, // not yet defined
              user_id: widget.user.user_id!,
              profile_id: widget.profile.profile_id!,
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MedicationTimePage(
                  medication: medication,
                  user: widget.user,
                  profile: widget.profile,
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please enter a medication dose.'),
              ),
            );
          }
        },
        child: const Text('Next'),
      ),
    );
  }
}
