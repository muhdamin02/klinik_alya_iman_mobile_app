import 'package:flutter/material.dart';

import '../../../models/medication.dart';
import '../../../models/profile.dart';
import '../../../models/user.dart';
import 'medication_frequency_type.dart';

class MedicationTypePage extends StatefulWidget {
  final Medication medication;
  final User user;
  final Profile profile;

  const MedicationTypePage({
    Key? key,
    required this.medication,
    required this.user,
    required this.profile,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MedicationTypePageState createState() => _MedicationTypePageState();
}

class _MedicationTypePageState extends State<MedicationTypePage> {
  bool buttonIsSelected = false;

  void _setMedicationType({required String type}) {
    if (buttonIsSelected == true) {
      final medication = Medication(
        medication_name: widget.medication.medication_name,
        medication_type: type,
        frequency_type: '',
        frequency_interval: 0,
        daily_frequency: 1,
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
          builder: (context) => MedicationFrequencyTypePage(
            medication: medication,
            user: widget.user,
            profile: widget.profile,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Step 2: Medication Type'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Choose Medication Type',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Please choose the type of your medication.',
                style: TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 90.0,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          const medicationType = 'Pills';
                          buttonIsSelected = true;
                          _setMedicationType(type: medicationType);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                              255, 221, 236, 255), // Set the text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                25.0), // Adjust the value as needed
                          ),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.medication, // Use any icon you want
                              color: Color.fromARGB(255, 37, 101, 184),
                              size: 36,
                            ),
                            SizedBox(
                                height:
                                    8), // Adjust the spacing between icon and text
                            Text(
                              'Pills',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 37, 101, 184),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: SizedBox(
                      height: 90.0,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                              255, 221, 236, 255), // Set the text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                25.0), // Adjust the value as needed
                          ),
                        ),
                        onPressed: () {
                          const medicationType = 'Injection';
                          buttonIsSelected = true;
                          _setMedicationType(type: medicationType);
                        },
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.vaccines_outlined, // Use any icon you want
                              color: Color.fromARGB(255, 37, 101, 184),
                              size: 36,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Injection',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 37, 101, 184),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 90.0,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                              255, 221, 236, 255), // Set the text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                25.0), // Adjust the value as needed
                          ),
                        ),
                        onPressed: () {
                          const medicationType = 'Solution (liquid)';
                          buttonIsSelected = true;
                          _setMedicationType(type: medicationType);
                        },
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.water_outlined, // Use any icon you want
                              color: Color.fromARGB(255, 37, 101, 184),
                              size: 36,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Solution',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 37, 101, 184),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: SizedBox(
                      height: 90.0,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                              255, 221, 236, 255), // Set the text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                25.0), // Adjust the value as needed
                          ),
                        ),
                        onPressed: () {
                          const medicationType = 'Drops';
                          buttonIsSelected = true;
                          _setMedicationType(type: medicationType);
                        },
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons
                                  .water_drop_outlined, // Use any icon you want
                              color: Color.fromARGB(255, 37, 101, 184),
                              size: 36,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Drops',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 37, 101, 184),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 90.0,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                              255, 221, 236, 255), // Set the text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                25.0), // Adjust the value as needed
                          ),
                        ),
                        onPressed: () {
                          const medicationType = 'Inhaler';
                          buttonIsSelected = true;
                          _setMedicationType(type: medicationType);
                        },
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.air, // Use any icon you want
                              color: Color.fromARGB(255, 37, 101, 184),
                              size: 36,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Inhaler',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 37, 101, 184),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: SizedBox(
                      height: 90.0,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                              255, 221, 236, 255), // Set the text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                25.0), // Adjust the value as needed
                          ),
                        ),
                        onPressed: () {
                          const medicationType = 'Powder';
                          buttonIsSelected = true;
                          _setMedicationType(type: medicationType);
                        },
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons
                                  .auto_awesome_rounded, // Use any icon you want
                              color: Color.fromARGB(255, 37, 101, 184),
                              size: 36,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Powder',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 37, 101, 184),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
