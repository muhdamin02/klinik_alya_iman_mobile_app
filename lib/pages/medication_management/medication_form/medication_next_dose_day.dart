import 'package:flutter/material.dart';

import '../../../models/medication.dart';
import '../../../models/profile.dart';
import '../../../models/user.dart';
import 'medication_dose_times.dart';

class MedicationNextDoseDayPage extends StatefulWidget {
  final Medication medication;
  final User user;
  final Profile profile;

  const MedicationNextDoseDayPage({
    Key? key,
    required this.medication,
    required this.user,
    required this.profile,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MedicationNextDoseDayPageState createState() =>
      _MedicationNextDoseDayPageState();
}

class _MedicationNextDoseDayPageState extends State<MedicationNextDoseDayPage> {
  final TextEditingController _nextDoseDayController = TextEditingController();

  bool buttonIsSelected = false;

  // ----------------------------------------------------------------------
  // Date Picker

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (picked != null) {
      setState(() {
        _nextDoseDayController.text = picked.toIso8601String().split('T')[0];
      });
    }
  }

  // ----------------------------------------------------------------------
  // Required validator

  String? _requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  // ----------------------------------------------------------------------

  void _setNextDoseDay({required String day}) {
    final medication = Medication(
      medication_name: widget.medication.medication_name,
      medication_type: widget.medication.medication_type,
      frequency_type: widget.medication.frequency_type,
      frequency_interval: widget.medication.frequency_interval,
      daily_frequency: widget.medication.daily_frequency,
      medication_day: widget.medication.medication_day,
      next_dose_day: day,
      dose_times: '',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Step 5: Next Dose Day'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'When will you take it next?',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Choose when is the next time you will take your medication.',
                  style: TextStyle(fontSize: 16.0, color: Colors.grey),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _nextDoseDayController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Next Dose Day',
                  ),
                  readOnly: true,
                  onTap: () {
                    _selectDate(context);
                  },
                  validator: _requiredValidator,
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  height: 45.0,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _setNextDoseDay(day: _nextDoseDayController.text);
                    },
                    child: const Text('Next',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
