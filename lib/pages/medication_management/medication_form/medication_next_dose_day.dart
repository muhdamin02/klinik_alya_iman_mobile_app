import 'package:flutter/material.dart';

import '../../../models/medication.dart';
import '../../../models/profile.dart';
import '../../../models/user.dart';
import '../../../services/misc_methods/show_hovering_message.dart';
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
    if (_nextDoseDayController.text.isNotEmpty) {
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
    } else {
      showHoveringMessage(
          context, 'Please enter next dose day', 0.82, 0.15, 0.7);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Medication'), elevation: 0),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 32.0, horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        'Next Dose Day',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFEDF2FF),
                            letterSpacing: 1),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        'When will you take your medication next?',
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Color(0xFFB6CBFF),
                            height: 1.5),
                      ),
                    ),
                    const SizedBox(height: 32.0),
                    TextFormField(
                      controller: _nextDoseDayController,
                      style: const TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF303E8F),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        labelText: 'Enter Date',
                        labelStyle: const TextStyle(color: Color(0xFFB6CBFF)),
                        counterText: '',
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 20.0),
                      ),
                      readOnly: true,
                      onTap: () {
                        _selectDate(context);
                      },
                      validator: _requiredValidator,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(
                  bottom: 16.0,
                  left: 16.0,
                  right: 16.0), // Set your desired margin
              child: SizedBox(
                height: 60.0,
                width: double.infinity,
                child: ElevatedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFFC1D3FF), // Set the fill color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          50.0), // Adjust the value as needed
                    ),
                    side: const BorderSide(
                      color: Color(0xFF6086f6), // Set the outline color
                      width: 2.5, // Set the outline width
                    ),
                  ),
                  onPressed: () {
                    _setNextDoseDay(day: _nextDoseDayController.text);
                  },
                  child: const Text(
                    'Next',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1F3299)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
