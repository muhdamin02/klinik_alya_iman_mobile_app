import 'package:flutter/material.dart';
import 'package:klinik_alya_iman_mobile_app/services/misc_methods/show_hovering_message.dart';

import '../../../models/medication.dart';
import '../../../models/profile.dart';
import '../../../models/user.dart';
import 'medication_dose_times.dart';

class MedicationDailyFrequencyPage extends StatefulWidget {
  final Medication medication;
  final User user;
  final Profile profile;

  const MedicationDailyFrequencyPage({
    Key? key,
    required this.medication,
    required this.user,
    required this.profile,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MedicationDailyFrequencyPageState createState() =>
      _MedicationDailyFrequencyPageState();
}

class _MedicationDailyFrequencyPageState
    extends State<MedicationDailyFrequencyPage> {
  bool buttonIsSelected = false;
  int _selectedDaily = -1;

  void _onDailyPressed(int index) {
    setState(() {
      _selectedDaily = index;
    });
  }

  void _setDailyFrequency({required int dailyFrequency}) {
    if (buttonIsSelected == true) {
      final medication = Medication(
        medication_name: widget.medication.medication_name,
        medication_type: widget.medication.medication_type,
        frequency_type: widget.medication.frequency_type,
        frequency_interval: 0,
        daily_frequency: dailyFrequency,
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
          builder: (context) => MedicationDoseTimesPage(
            medication: medication,
            user: widget.user,
            profile: widget.profile,
          ),
        ),
      );
    } else {
      showHoveringMessage(context, 'Please specify daily frequency', 0.82, 0.15, 0.7);
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
                      'How many times a day?',
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
                          backgroundColor: _selectedDaily == 0
                              ? const Color(0xFFFFE2A2)
                              : const Color(0xFF303E8F),
                          fixedSize: const Size.fromHeight(60.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          foregroundColor: const Color(0xFFFFB938),
                          side: BorderSide(
                            color: _selectedDaily == 0
                                ? const Color(0xFF5F4712)
                                : const Color.fromARGB(0, 255, 255, 255),
                            width: 2.5,
                          ),
                        ),
                        onPressed: () {
                          // const dailyFrequency = 1;
                          buttonIsSelected = true;
                          _onDailyPressed(0);
                          // _setDailyFrequency(dailyFrequency: dailyFrequency);
                        },
                        child: Text('1',
                            style: TextStyle(
                                fontSize: 24,
                                color: _selectedDaily == 0
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
                          backgroundColor: _selectedDaily == 1
                              ? const Color(0xFFFFE2A2)
                              : const Color(0xFF303E8F),
                          fixedSize: const Size.fromHeight(60.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          foregroundColor: const Color(0xFFFFB938),
                          side: BorderSide(
                            color: _selectedDaily == 1
                                ? const Color(0xFF5F4712)
                                : const Color.fromARGB(0, 255, 255, 255),
                            width: 2.5,
                          ),
                        ),
                        onPressed: () {
                          // const dailyFrequency = 2;
                          buttonIsSelected = true;
                          _onDailyPressed(1);
                          // _setDailyFrequency(dailyFrequency: dailyFrequency);
                        },
                        child: Text('2',
                            style: TextStyle(
                                fontSize: 24,
                                color: _selectedDaily == 1
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
                          backgroundColor: _selectedDaily == 2
                              ? const Color(0xFFFFE2A2)
                              : const Color(0xFF303E8F),
                          fixedSize: const Size.fromHeight(60.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          foregroundColor: const Color(0xFFFFB938),
                          side: BorderSide(
                            color: _selectedDaily == 2
                                ? const Color(0xFF5F4712)
                                : const Color.fromARGB(0, 255, 255, 255),
                            width: 2.5,
                          ),
                        ),
                        onPressed: () {
                          // const dailyFrequency = 3;
                          buttonIsSelected = true;
                          _onDailyPressed(2);
                          // _setDailyFrequency(dailyFrequency: dailyFrequency);
                        },
                        child: Text('3',
                            style: TextStyle(
                                fontSize: 24,
                                color: _selectedDaily == 2
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
                          backgroundColor: _selectedDaily == 3
                              ? const Color(0xFFFFE2A2)
                              : const Color(0xFF303E8F),
                          fixedSize: const Size.fromHeight(60.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          foregroundColor: const Color(0xFFFFB938),
                          side: BorderSide(
                            color: _selectedDaily == 3
                                ? const Color(0xFF5F4712)
                                : const Color.fromARGB(0, 255, 255, 255),
                            width: 2.5,
                          ),
                        ),
                        onPressed: () {
                          // const dailyFrequency = 4;
                          buttonIsSelected = true;
                          _onDailyPressed(3);
                          // _setDailyFrequency(dailyFrequency: dailyFrequency);
                        },
                        child: Text('4',
                            style: TextStyle(
                                fontSize: 24,
                                color: _selectedDaily == 3
                                    ? const Color(0xFF5F4712)
                                    : const Color(0xFFEDF2FF))),
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
                    int dailyFrequency = 0;
                    switch (_selectedDaily) {
                      case 0:
                        dailyFrequency = 1;
                        break;
                      case 1:
                        dailyFrequency = 2;
                        break;
                      case 2:
                        dailyFrequency = 3;
                        break;
                      case 3:
                        dailyFrequency = 4;
                        break;
                    }

                    print(dailyFrequency);
                    _setDailyFrequency(dailyFrequency: dailyFrequency);
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
