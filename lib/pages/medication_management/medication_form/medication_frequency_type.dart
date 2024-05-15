import 'package:flutter/material.dart';

import '../../../models/medication.dart';
import '../../../models/profile.dart';
import '../../../models/user.dart';
import 'medication_frequency_daily.dart';
import 'medication_frequency_day.dart';
import 'medication_frequency_interval.dart';
import 'medication_next_dose_day.dart';

class MedicationFrequencyTypePage extends StatefulWidget {
  final Medication medication;
  final User user;
  final Profile profile;

  const MedicationFrequencyTypePage({
    Key? key,
    required this.medication,
    required this.user,
    required this.profile,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MedicationFrequencyTypePageState createState() =>
      _MedicationFrequencyTypePageState();
}

class _MedicationFrequencyTypePageState
    extends State<MedicationFrequencyTypePage> {
  bool buttonIsSelected = false;
  int _selectedType = -1;

  void _onTypePressed(int index) {
    setState(() {
      _selectedType = index;
    });
  }

  void _setMedicationFrequency({required String frequency}) {
    if (buttonIsSelected == true) {
      final medication = Medication(
        medication_name: widget.medication.medication_name,
        medication_type: widget.medication.medication_type,
        frequency_type: frequency,
        frequency_interval: 0,
        daily_frequency: 1,
        medication_day: '',
        next_dose_day: '',
        dose_times: '',
        medication_quantity: 0,
        user_id: widget.user.user_id!,
        profile_id: widget.profile.profile_id!,
      );

      if (frequency == 'EveryDay') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MedicationDailyFrequencyPage(
              medication: medication,
              user: widget.user,
              profile: widget.profile,
            ),
          ),
        );
      }

      if (frequency == 'EveryOtherDay') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MedicationNextDoseDayPage(
              medication: medication,
              user: widget.user,
              profile: widget.profile,
            ),
          ),
        );
      }

      if (frequency == 'SpecificDays') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MedicationFrequencyDayPage(
              medication: medication,
              user: widget.user,
              profile: widget.profile,
            ),
          ),
        );
      }

      if (frequency == 'EveryXDays' ||
          frequency == 'EveryXWeeks' ||
          frequency == 'EveryXMonths') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MedicationFrequencyIntervalPage(
              medication: medication,
              user: widget.user,
              profile: widget.profile,
            ),
          ),
        );
      }
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
                      'Frequency',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFEDF2FF),
                          letterSpacing: 1),
                    ),
                    const SizedBox(height: 12.0),
                    const Text(
                      'How frequent do you take your medication?',
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Color(0xFFB6CBFF),
                          height: 1.5),
                    ),
                    const SizedBox(height: 32.0),
                    SizedBox(
                      height: 60.0,
                      width: double.infinity,
                      child: ElevatedButton(
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
                            width: 2.5,
                          ),
                        ),
                        onPressed: () {
                          // const medicationFrequency = 'EveryDay';
                          _onTypePressed(0);
                          buttonIsSelected = true;
                          // _setMedicationFrequency(
                          //     frequency: medicationFrequency);
                        },
                        child: Text('Every day',
                            style: TextStyle(
                                fontSize: 18,
                                color: _selectedType == 0
                                    ? const Color(0xFF5F4712)
                                    : const Color(0xFFEDF2FF))),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    SizedBox(
                      height: 60.0,
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
                          // const medicationFrequency = 'EveryOtherDay';
                          _onTypePressed(1);
                          buttonIsSelected = true;
                          // _setMedicationFrequency(
                          //     frequency: medicationFrequency);
                        },
                        child: Text(
                          'Every other day',
                          style: TextStyle(
                            fontSize: 18,
                            color: _selectedType == 1
                                ? const Color(0xFF5F4712)
                                : const Color(0xFFEDF2FF),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    SizedBox(
                      height: 60.0,
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
                          // const medicationFrequency = 'SpecificDays';
                          _onTypePressed(2);
                          buttonIsSelected = true;
                          // _setMedicationFrequency(
                          //     frequency: medicationFrequency);
                        },
                        child: Text(
                          'Specific days of the week',
                          style: TextStyle(
                            fontSize: 18,
                            color: _selectedType == 2
                                ? const Color(0xFF5F4712)
                                : const Color(0xFFEDF2FF),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    SizedBox(
                      height: 60.0,
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
                          // const medicationFrequency = 'EveryXDays';
                          _onTypePressed(3);
                          buttonIsSelected = true;
                          // _setMedicationFrequency(
                          //     frequency: medicationFrequency);
                        },
                        child: Text(
                          'Every X days',
                          style: TextStyle(
                            fontSize: 18,
                            color: _selectedType == 3
                                ? const Color(0xFF5F4712)
                                : const Color(0xFFEDF2FF),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    SizedBox(
                      height: 60.0,
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
                          // const medicationFrequency = 'EveryXWeeks';
                          _onTypePressed(4);
                          buttonIsSelected = true;
                          // _setMedicationFrequency(
                          //     frequency: medicationFrequency);
                        },
                        child: Text(
                          'Every X weeks',
                          style: TextStyle(
                            fontSize: 18,
                            color: _selectedType == 4
                                ? const Color(0xFF5F4712)
                                : const Color(0xFFEDF2FF),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    SizedBox(
                      height: 60.0,
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
                          // const medicationFrequency = 'EveryXMonths';
                          _onTypePressed(5);
                          buttonIsSelected = true;
                          // _setMedicationFrequency(
                          //     frequency: medicationFrequency);
                        },
                        child: Text(
                          'Every X months',
                          style: TextStyle(
                            fontSize: 18,
                            color: _selectedType == 5
                                ? const Color(0xFF5F4712)
                                : const Color(0xFFEDF2FF),
                          ),
                        ),
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
                    String medicationFrequency = 'Undefined';
                    switch (_selectedType) {
                      case 0:
                        medicationFrequency = 'EveryDay';
                        break;
                      case 1:
                        medicationFrequency = 'EveryOtherDay';
                        break;
                      case 2:
                        medicationFrequency = 'SpecificDays';
                        break;
                      case 3:
                        medicationFrequency = 'EveryXDays';
                        break;
                      case 4:
                        medicationFrequency = 'EveryXWeeks';
                        break;
                      case 5:
                        medicationFrequency = 'EveryXMonths';
                        break;
                      default:
                        medicationFrequency = 'Undefined';
                    }

                    print(medicationFrequency);
                    _setMedicationFrequency(frequency: medicationFrequency);
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
