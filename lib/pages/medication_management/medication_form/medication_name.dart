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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Enter Medication Name',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Please enter the name of your medication. For example, "Aspirin", "Ibuprofen", etc.',
                      style: TextStyle(fontSize: 16.0, color: Colors.grey),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _medicationNameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0)),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 20.0),
                        labelText: 'Medication Name',
                      ),
                    ),
                    const SizedBox(height: 16.0),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 115, 176, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          25.0), // Adjust the value as needed
                    ),
                  ),
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
                          content: Text('Please enter a medication name.',
                              style: TextStyle(fontFamily: 'ProductSans')),
                        ),
                      );
                    }
                  },
                  child: const Text('Next'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
