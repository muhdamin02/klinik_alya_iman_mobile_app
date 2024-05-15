import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../models/medication.dart';
import '../../../models/profile.dart';
import '../../../models/user.dart';
import '../../../services/database_service.dart';
import '../../../services/misc_methods/show_hovering_message.dart';
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
        widget.medication.medication_type == 'Inhaler' ||
        widget.medication.medication_type == 'Powder') {
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
          backgroundColor: const Color(0xFF303E8F),
          title: const Text('Success'),
          content: const Text('Form submitted successfully!'),
          actions: <Widget>[
            TextButton(
              child:
                  const Text('OK', style: TextStyle(color: Color(0xFFEDF2FF))),
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
        barrierDismissible: false,
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
              child:
                  const Text('OK', style: TextStyle(color: Color(0xFFEDF2FF))),
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
      appBar: AppBar(title: const Text('New Medication'), elevation: 0),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 32.0, horizontal: 44.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Quantity',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFEDF2FF),
                          letterSpacing: 1),
                    ),
                    const SizedBox(height: 12.0),
                    const Text(
                      'How much will you take per dose?',
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Color(0xFFB6CBFF),
                          height: 1.5),
                    ),
                    const SizedBox(height: 32.0),
                    SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 100.0,
                            child: TextField(
                              style: const TextStyle(
                                  fontSize: 18.0, color: Color(0xFFEDF2FF)),
                              controller: _medicationQuantityController,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.number,
                              maxLength: 5,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFF4D5FC0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 20.0),
                                counterText:
                                    '', // This hides the default counter text
                              ),
                            ),
                          ),
                          const SizedBox(width: 40.0),
                          Text(
                            () {
                              if (widget.medication.medication_type ==
                                  'Pills') {
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
                            style: const TextStyle(
                                fontSize: 18.0,
                                color: Color(0xFFEDF2FF),
                                letterSpacing: 1),
                          ),
                        ],
                      ),
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
                    if (_medicationQuantityController.text.isNotEmpty) {
                      int medicationQuantity =
                          int.parse(_medicationQuantityController.text);
                      _submitForm(quantity: medicationQuantity);
                    } else {
                      showHoveringMessage(
                          context, 'Please specify quantity', 0.82, 0.15, 0.7);
                    }
                  },
                  child: const Text(
                    'Save Medication',
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
