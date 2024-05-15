import 'package:flutter/material.dart';

import '../../../models/medication.dart';
import '../../../models/profile.dart';
import '../../../models/user.dart';
import '../../../services/misc_methods/show_hovering_message.dart';
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
  int _selectedType = -1;

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
    } else {
      showHoveringMessage(context, 'Please choose medication type', 0.82, 0.15, 0.7);
    }
  }

  void _onTypePressed(int index) {
    setState(() {
      _selectedType = index;
    });
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
                      'Medication Type',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFEDF2FF),
                          letterSpacing: 1),
                    ),
                    const SizedBox(height: 12.0),
                    const Text(
                      'What type of medication is it?',
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Color(0xFFB6CBFF),
                          height: 1.5),
                    ),
                    const SizedBox(height: 32.0),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 120.0,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                _onTypePressed(0);
                                buttonIsSelected = true;
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _selectedType == 0
                                    ? const Color(0xFFFFE2A2)
                                    : const Color(0xFF303E8F),
                                fixedSize: const Size.fromHeight(60.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                foregroundColor: const Color(0xFFFFB938),
                                side: BorderSide(
                                  color: _selectedType == 0
                                      ? const Color(0xFF5F4712)
                                      : const Color.fromARGB(0, 255, 255, 255),
                                  width: 2.0,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.medication, // Use any icon you want
                                    color: _selectedType == 0
                                        ? const Color(0xFF5F4712)
                                        : const Color(0xFFEDF2FF),
                                    size: 48,
                                  ),
                                  const SizedBox(
                                      height:
                                          8), // Adjust the spacing between icon and text
                                  Text(
                                    'Pills',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: _selectedType == 0
                                          ? const Color(0xFF5F4712)
                                          : const Color(0xFFEDF2FF),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: SizedBox(
                            height: 120.0,
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _selectedType == 1
                                    ? const Color(0xFFFFE2A2)
                                    : const Color(0xFF303E8F),
                                fixedSize: const Size.fromHeight(60.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                foregroundColor: const Color(0xFFFFB938),
                                side: BorderSide(
                                  color: _selectedType == 1
                                      ? const Color(0xFF5F4712)
                                      : const Color.fromARGB(0, 255, 255, 255),
                                  width: 2.0,
                                ),
                              ),
                              onPressed: () {
                                _onTypePressed(1);
                                buttonIsSelected = true;
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons
                                        .vaccines_outlined, // Use any icon you want
                                    color: _selectedType == 1
                                        ? const Color(0xFF5F4712)
                                        : const Color(0xFFEDF2FF),
                                    size: 48,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Injection',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: _selectedType == 1
                                          ? const Color(0xFF5F4712)
                                          : const Color(0xFFEDF2FF),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 120.0,
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _selectedType == 2
                                    ? const Color(0xFFFFE2A2)
                                    : const Color(0xFF303E8F),
                                fixedSize: const Size.fromHeight(60.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                foregroundColor: const Color(0xFFFFB938),
                                side: BorderSide(
                                  color: _selectedType == 2
                                      ? const Color(0xFF5F4712)
                                      : const Color.fromARGB(0, 255, 255, 255),
                                  width: 2.0,
                                ),
                              ),
                              onPressed: () {
                                _onTypePressed(2);
                                buttonIsSelected = true;
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons
                                        .water_outlined, // Use any icon you want
                                    color: _selectedType == 2
                                        ? const Color(0xFF5F4712)
                                        : const Color(0xFFEDF2FF),
                                    size: 48,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Solution',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: _selectedType == 2
                                          ? const Color(0xFF5F4712)
                                          : const Color(0xFFEDF2FF),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: SizedBox(
                            height: 120.0,
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _selectedType == 3
                                    ? const Color(0xFFFFE2A2)
                                    : const Color(0xFF303E8F),
                                fixedSize: const Size.fromHeight(60.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                foregroundColor: const Color(0xFFFFB938),
                                side: BorderSide(
                                  color: _selectedType == 3
                                      ? const Color(0xFF5F4712)
                                      : const Color.fromARGB(0, 255, 255, 255),
                                  width: 2.0,
                                ),
                              ),
                              onPressed: () {
                                _onTypePressed(3);
                                buttonIsSelected = true;
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons
                                        .water_drop_outlined, // Use any icon you want
                                    color: _selectedType == 3
                                        ? const Color(0xFF5F4712)
                                        : const Color(0xFFEDF2FF),
                                    size: 48,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Drops',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: _selectedType == 3
                                          ? const Color(0xFF5F4712)
                                          : const Color(0xFFEDF2FF),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 120.0,
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _selectedType == 4
                                    ? const Color(0xFFFFE2A2)
                                    : const Color(0xFF303E8F),
                                fixedSize: const Size.fromHeight(60.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                foregroundColor: const Color(0xFFFFB938),
                                side: BorderSide(
                                  color: _selectedType == 4
                                      ? const Color(0xFF5F4712)
                                      : const Color.fromARGB(0, 255, 255, 255),
                                  width: 2.0,
                                ),
                              ),
                              onPressed: () {
                                _onTypePressed(4);
                                buttonIsSelected = true;
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.air, // Use any icon you want
                                    color: _selectedType == 4
                                        ? const Color(0xFF5F4712)
                                        : const Color(0xFFEDF2FF),
                                    size: 48,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Inhaler',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: _selectedType == 4
                                          ? const Color(0xFF5F4712)
                                          : const Color(0xFFEDF2FF),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: SizedBox(
                            height: 120.0,
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _selectedType == 5
                                    ? const Color(0xFFFFE2A2)
                                    : const Color(0xFF303E8F),
                                fixedSize: const Size.fromHeight(60.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                foregroundColor: const Color(0xFFFFB938),
                                side: BorderSide(
                                  color: _selectedType == 5
                                      ? const Color(0xFF5F4712)
                                      : const Color.fromARGB(0, 255, 255, 255),
                                  width: 2.0,
                                ),
                              ),
                              onPressed: () {
                                _onTypePressed(5);
                                buttonIsSelected = true;
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons
                                        .auto_awesome_rounded, // Use any icon you want
                                    color: _selectedType == 5
                                        ? const Color(0xFF5F4712)
                                        : const Color(0xFFEDF2FF),
                                    size: 48,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Powder',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: _selectedType == 5
                                          ? const Color(0xFF5F4712)
                                          : const Color(0xFFEDF2FF),
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
                    String medicationType = 'Undefined';
                    switch (_selectedType) {
                      case 0:
                        medicationType = 'Pills';
                        break;
                      case 1:
                        medicationType = 'Injection';
                        break;
                      case 2:
                        medicationType = 'Solution';
                        break;
                      case 3:
                        medicationType = 'Drops';
                        break;
                      case 4:
                        medicationType = 'Inhaler';
                        break;
                      case 5:
                        medicationType = 'Powder';
                        break;
                      default:
                        medicationType = 'Undefined';
                    }

                    print(medicationType);
                    _setMedicationType(type: medicationType);
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