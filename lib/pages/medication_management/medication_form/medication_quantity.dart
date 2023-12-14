import 'package:flutter/material.dart';

import '../../../models/medication.dart';
import '../../../models/profile.dart';
import '../../../models/user.dart';
import '../../../services/database_service.dart';
import '../list_medication.dart';

class MedicationQuantityPage extends StatefulWidget {
  final Medication medication;
  final User user;
  final Profile profile;

  const MedicationQuantityPage({
    Key? key,
    required this.medication,
    required this.user,
    required this.profile,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MedicationQuantityPageState createState() => _MedicationQuantityPageState();
}

class _MedicationQuantityPageState extends State<MedicationQuantityPage> {
  final TextEditingController _medicationQuantityController =
      TextEditingController();

  void _submitForm({required int quantity}) async {
    // Last step, submit the form
    try {
      // Create a new medication instance with the form data
      final medication = Medication(
        medication_name: widget.medication.medication_name,
        medication_type: widget.medication.medication_type,
        frequency_type: widget.medication.frequency_type,
        frequency_interval: widget.medication.frequency_interval,
        daily_frequency: widget.medication.daily_frequency,
        next_dose_day: widget.medication.next_dose_day,
        dose_times: widget.medication.dose_times,
        medication_time: widget.medication.medication_time,
        medication_quantity: quantity,
        user_id: widget.user.user_id!,
        profile_id: widget.profile.profile_id!,
      );

      // Insert the medication into the database
      await DatabaseService().insertMedication(medication);

      // Show success dialog
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Form submitted successfully!'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                // Navigate to the medication list
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListMedication(
                      user: widget.user,
                      profile: widget.profile,
                      autoImplyLeading: false,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    } catch (error) {
      // Show error dialog
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('An error occurred: $error'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // ... UI for capturing medication name ...
      child: ElevatedButton(
        onPressed: () {
          final medicationQuantity =
              int.parse(_medicationQuantityController.text);
          if (_medicationQuantityController.text.isNotEmpty) {
            _submitForm(quantity: medicationQuantity);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please enter a medication quantity.'),
              ),
            );
          }
        },
        child: const Text('Finish'),
      ),
    );
  }
}
