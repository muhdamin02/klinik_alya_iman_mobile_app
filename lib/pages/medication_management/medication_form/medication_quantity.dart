import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  @override
  void initState() {
    super.initState();

    // Prefill the text fields
    if (widget.medication.medication_type == 'Pills' ||
        widget.medication.medication_type == 'Drops' ||
        widget.medication.medication_type == 'Inhaler') {
      _medicationQuantityController.text = '1';
    } else {
      _medicationQuantityController.text = '100';
    }
  }

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
        medication_day: widget.medication.medication_day,
        next_dose_day: widget.medication.next_dose_day,
        dose_times: widget.medication.dose_times,
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Step 7: Medication Quantity'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Enter Medication Quantity',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'How much will you take per dose?',
                  style: TextStyle(fontSize: 16.0, color: Colors.grey),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 100.0,
                        child: TextField(
                          controller: _medicationQuantityController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            alignLabelWithHint: true,
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 10.0),
                          ),
                          textAlign: TextAlign.center,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 40.0),
                      Text(
                        () {
                          if (widget.medication.medication_type == 'Pills') {
                            return 'pill(s)';
                          } else if (widget.medication.medication_type ==
                              'Drops') {
                            return 'drop(s)';
                          } else if (widget.medication.medication_type ==
                              'Inhaler') {
                            return 'puff(s)';
                          } else if (widget.medication.medication_type ==
                              'Powder') {
                            return 'packets(s)';
                          } else {
                            return 'ml';
                          }
                        }(),
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    int medicationQuantity =
                        int.parse(_medicationQuantityController.text);
                    _submitForm(quantity: medicationQuantity);
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
