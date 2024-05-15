import 'package:flutter/material.dart';

import '../../../models/medication.dart';
import '../../../models/profile.dart';
import '../../../models/user.dart';
import '../../../services/misc_methods/show_hovering_message.dart';
import 'medication_dose_times.dart';

class MedicationFrequencyDayPage extends StatefulWidget {
  final Medication medication;
  final User user;
  final Profile profile;

  const MedicationFrequencyDayPage({
    Key? key,
    required this.medication,
    required this.user,
    required this.profile,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MedicationFrequencyDayPageState createState() =>
      _MedicationFrequencyDayPageState();
}

class _MedicationFrequencyDayPageState
    extends State<MedicationFrequencyDayPage> {
  bool buttonIsSelected = false;
  int _selectedDay = -1;

  void _onDayPressed(int index) {
    setState(() {
      _selectedDay = index;
    });
  }

  void _setMedicationDay({required String medicationDay}) {
    if (buttonIsSelected == true) {
      final medication = Medication(
        medication_name: widget.medication.medication_name,
        medication_type: widget.medication.medication_type,
        frequency_type: widget.medication.frequency_type,
        frequency_interval: 0,
        daily_frequency: 1,
        medication_day: medicationDay,
        next_dose_day: '',
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
      showHoveringMessage(context, 'Please choose day of the week', 0.82, 0.15, 0.7);
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
                      'Day of the Week',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFEDF2FF),
                          letterSpacing: 1),
                    ),
                    const SizedBox(height: 12.0),
                    const Text(
                      'On what day do you take your medication?',
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
                          backgroundColor: _selectedDay == 0
                              ? const Color(0xFFFFE2A2)
                              : const Color(0xFF303E8F),
                          fixedSize: const Size.fromHeight(60.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          foregroundColor: const Color(0xFFFFB938),
                          side: BorderSide(
                            color: _selectedDay == 0
                                ? const Color(0xFF5F4712)
                                : const Color.fromARGB(0, 255, 255, 255),
                            width: 2.5,
                          ),
                        ),
                        onPressed: () {
                          _onDayPressed(0);
                          buttonIsSelected = true;
                        },
                        child: Text('Sunday',
                            style: TextStyle(
                                fontSize: 18,
                                color: _selectedDay == 0
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
                          backgroundColor: _selectedDay == 1
                              ? const Color(0xFFFFE2A2)
                              : const Color(0xFF303E8F),
                          fixedSize: const Size.fromHeight(60.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          foregroundColor: const Color(0xFFFFB938),
                          side: BorderSide(
                            color: _selectedDay == 1
                                ? const Color(0xFF5F4712)
                                : const Color.fromARGB(0, 255, 255, 255),
                            width: 2.5,
                          ),
                        ),
                        onPressed: () {
                          _onDayPressed(1);
                          buttonIsSelected = true;
                        },
                        child: Text('Monday',
                            style: TextStyle(
                                fontSize: 18,
                                color: _selectedDay == 1
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
                          backgroundColor: _selectedDay == 2
                              ? const Color(0xFFFFE2A2)
                              : const Color(0xFF303E8F),
                          fixedSize: const Size.fromHeight(60.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          foregroundColor: const Color(0xFFFFB938),
                          side: BorderSide(
                            color: _selectedDay == 2
                                ? const Color(0xFF5F4712)
                                : const Color.fromARGB(0, 255, 255, 255),
                            width: 2.5,
                          ),
                        ),
                        onPressed: () {
                          _onDayPressed(2);
                          buttonIsSelected = true;
                        },
                        child: Text('Tuesday',
                            style: TextStyle(
                                fontSize: 18,
                                color: _selectedDay == 2
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
                          backgroundColor: _selectedDay == 3
                              ? const Color(0xFFFFE2A2)
                              : const Color(0xFF303E8F),
                          fixedSize: const Size.fromHeight(60.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          foregroundColor: const Color(0xFFFFB938),
                          side: BorderSide(
                            color: _selectedDay == 3
                                ? const Color(0xFF5F4712)
                                : const Color.fromARGB(0, 255, 255, 255),
                            width: 2.5,
                          ),
                        ),
                        onPressed: () {
                          _onDayPressed(3);
                          buttonIsSelected = true;
                        },
                        child: Text('Wednesday',
                            style: TextStyle(
                                fontSize: 18,
                                color: _selectedDay == 3
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
                          backgroundColor: _selectedDay == 4
                              ? const Color(0xFFFFE2A2)
                              : const Color(0xFF303E8F),
                          fixedSize: const Size.fromHeight(60.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          foregroundColor: const Color(0xFFFFB938),
                          side: BorderSide(
                            color: _selectedDay == 4
                                ? const Color(0xFF5F4712)
                                : const Color.fromARGB(0, 255, 255, 255),
                            width: 2.5,
                          ),
                        ),
                        onPressed: () {
                          _onDayPressed(4);
                          buttonIsSelected = true;
                        },
                        child: Text('Thursday',
                            style: TextStyle(
                                fontSize: 18,
                                color: _selectedDay == 4
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
                          backgroundColor: _selectedDay == 5
                              ? const Color(0xFFFFE2A2)
                              : const Color(0xFF303E8F),
                          fixedSize: const Size.fromHeight(60.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          foregroundColor: const Color(0xFFFFB938),
                          side: BorderSide(
                            color: _selectedDay == 5
                                ? const Color(0xFF5F4712)
                                : const Color.fromARGB(0, 255, 255, 255),
                            width: 2.5,
                          ),
                        ),
                        onPressed: () {
                          _onDayPressed(5);
                          buttonIsSelected = true;
                        },
                        child: Text('Friday',
                            style: TextStyle(
                                fontSize: 18,
                                color: _selectedDay == 5
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
                          backgroundColor: _selectedDay == 6
                              ? const Color(0xFFFFE2A2)
                              : const Color(0xFF303E8F),
                          fixedSize: const Size.fromHeight(60.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          foregroundColor: const Color(0xFFFFB938),
                          side: BorderSide(
                            color: _selectedDay == 6
                                ? const Color(0xFF5F4712)
                                : const Color.fromARGB(0, 255, 255, 255),
                            width: 2.5,
                          ),
                        ),
                        onPressed: () {
                          _onDayPressed(6);
                          buttonIsSelected = true;
                        },
                        child: Text('Saturday',
                            style: TextStyle(
                                fontSize: 18,
                                color: _selectedDay == 6
                                    ? const Color(0xFF5F4712)
                                    : const Color(0xFFEDF2FF))),
                      ),
                    ),
                    const SizedBox(height: 12.0),
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
                    String medicationDay = 'Undefined';
                    switch (_selectedDay) {
                      case 0:
                        medicationDay = 'Sunday';
                        break;
                      case 1:
                        medicationDay = 'Monday';
                        break;
                      case 2:
                        medicationDay = 'Tuesday';
                        break;
                      case 3:
                        medicationDay = 'Wednesday';
                        break;
                      case 4:
                        medicationDay = 'Thursday';
                        break;
                      case 5:
                        medicationDay = 'Friday';
                        break;
                      case 6:
                        medicationDay = 'Saturday';
                        break;
                      default:
                        medicationDay = 'Undefined';
                    }

                    print(medicationDay);
                    _setMedicationDay(medicationDay: medicationDay);
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
