// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/medication.dart';
import '../../models/user.dart';
import '../../services/database_service.dart';

class ViewMedication extends StatefulWidget {
  final Medication medication;
  final User user;

  const ViewMedication({Key? key, required this.medication, required this.user})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ViewMedicationState createState() => _ViewMedicationState();
}

class _ViewMedicationState extends State<ViewMedication> {
  List<Medication> _medicationInfo = [];

  @override
  void initState() {
    super.initState();
    _fetchMedicationInfo();
  }

  // ----------------------------------------------------------------------
  // Fetch details

  Future<void> _fetchMedicationInfo() async {
    List<Medication> medicationInfo =
        await DatabaseService().medicationInfo(widget.medication.medication_id);
    setState(() {
      _medicationInfo = medicationInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Medication'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        shrinkWrap: true,
        itemCount: _medicationInfo.length,
        itemBuilder: (context, index) {
          Medication medication = _medicationInfo[index];

          // Split the dose times string by semicolons to get individual time strings
          List<String> timeStrings = medication.dose_times.split(';');

          // Remove any leading or trailing whitespace from each time string
          timeStrings = timeStrings.map((time) => time.trim()).toList();

          // Convert time strings to DateTime objects
          List<DateTime> times = [];
          for (String timeString in timeStrings) {
            try {
              // Split the time string into hours, minutes, and AM/PM components
              List<String> components = timeString.split(':');
              int hours = int.parse(components[0]);
              int minutes = int.parse(components[1].split(' ')[0]);
              String amPm = components[1].split(' ')[1];

              // Adjust hours for PM times
              if (amPm == 'PM') {
                hours += 12;
              }

              // Create a DateTime object with the parsed hours and minutes
              DateTime time = DateTime(DateTime.now().year,
                  DateTime.now().month, DateTime.now().day, hours, minutes);
              times.add(time);
            } catch (e) {
              print('Error parsing time string: $timeString');
            }
          }

          // Sort the DateTime objects in ascending order
          times.sort();

          // Format the sorted times back into strings
          List<String> formattedTimes =
              times.map((time) => DateFormat.jm().format(time)).toList();

          // Join the formatted time strings using commas
          String finalFormattedTimes = formattedTimes.join(', ');

          return SizedBox(
            width:
                MediaQuery.of(context).size.width, // Set width to screen width
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Color(0xFFB6CBFF),
                          height: 1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'Medication Details',
                          style: TextStyle(
                            color: Color(0xFFEDF2FF),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Color(0xFFB6CBFF),
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: double.infinity, // Adjust padding as needed
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20.0), // Adjust the radius
                    ),
                    elevation: 0, // Set the elevation for the card
                    color: const Color(0xFF303E8F),
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Handle onTap action here
                            },
                            child: const Text(
                              "MEDICATION NAME",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xFFB6CBFF),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            medication.medication_name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color(0xFFEDF2FF),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: double.infinity, // Adjust padding as needed
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20.0), // Adjust the radius
                          ),
                          elevation: 0, // Set the elevation for the card
                          color: const Color(0xFF3848A1),
                          child: Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Handle onTap action here
                                  },
                                  child: const Text(
                                    "TYPE",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Color(0xFFB6CBFF),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  medication.medication_type,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Color(0xFFEDF2FF),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity, // Adjust padding as needed
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20.0), // Adjust the radius
                          ),
                          elevation: 0, // Set the elevation for the card
                          color: const Color(0xFF3848A1),
                          child: Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Handle onTap action here
                                  },
                                  child: const Text(
                                    "QUANTITY",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Color(0xFFB6CBFF),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${medication.medication_quantity} ${_getSuffixForType(medication.medication_type)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Color(0xFFEDF2FF),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: double.infinity, // Adjust padding as needed
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20.0), // Adjust the radius
                    ),
                    elevation: 0, // Set the elevation for the card
                    color: const Color(0xFF4151B1),
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Handle onTap action here
                            },
                            child: const Text(
                              'FREQUENCY',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xFFB6CBFF),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (medication.frequency_type == 'EveryDay' &&
                              medication.daily_frequency == 1)
                            Text(
                              '${medication.medication_quantity} ${_getSuffixForType(medication.medication_type)} once a day',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xFFEDF2FF),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          if (medication.daily_frequency == 2)
                            Text(
                              '${medication.medication_quantity} ${_getSuffixForType(medication.medication_type)} twice a day',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xFFEDF2FF),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          if (medication.daily_frequency == 3)
                            Text(
                              '${medication.medication_quantity} ${_getSuffixForType(medication.medication_type)} three times a day',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xFFEDF2FF),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          if (medication.daily_frequency == 4)
                            Text(
                              '${medication.medication_quantity} ${_getSuffixForType(medication.medication_type)} four times a day',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xFFEDF2FF),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          if (medication.medication_day != '')
                            Text(
                              '${medication.medication_quantity} ${_getSuffixForType(medication.medication_type)} every ${medication.medication_day}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xFFEDF2FF),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          if (medication.frequency_type == 'EveryXDays')
                            Text(
                              '${medication.medication_quantity} ${_getSuffixForType(medication.medication_type)} every ${medication.frequency_interval} days',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xFFEDF2FF),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          if (medication.frequency_type == 'EveryXWeeks' &&
                              medication.frequency_interval == 1)
                            Text(
                              '${medication.medication_quantity} ${_getSuffixForType(medication.medication_type)} every week',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xFFEDF2FF),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          if (medication.frequency_type == 'EveryXWeeks' &&
                              medication.frequency_interval > 1)
                            Text(
                              '${medication.medication_quantity} ${_getSuffixForType(medication.medication_type)} every ${medication.frequency_interval} weeks',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xFFEDF2FF),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          if (medication.frequency_type == 'EveryXMonths' &&
                              medication.frequency_interval == 1)
                            Text(
                              '${medication.medication_quantity} ${_getSuffixForType(medication.medication_type)} every month',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xFFEDF2FF),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          if (medication.frequency_type == 'EveryXMonths' &&
                              medication.frequency_interval > 1)
                            Text(
                              '${medication.medication_quantity} ${_getSuffixForType(medication.medication_type)} every ${medication.frequency_interval} months',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xFFEDF2FF),
                              ),
                              textAlign: TextAlign.center,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4.0),
                SizedBox(
                  width: double.infinity, // Adjust padding as needed
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20.0), // Adjust the radius
                    ),
                    elevation: 0, // Set the elevation for the card
                    color: const Color(0xFF3848A1),
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Handle onTap action here
                            },
                            child: const Text(
                              "TIME(S) TO TAKE MEDICATION",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xFFB6CBFF),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            finalFormattedTimes,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color(0xFFEDF2FF),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Text('medication_name: ${medication.medication_name}'),
                // const SizedBox(height: 8.0),
                // Text('medication_type: ${medication.medication_type}'),
                // const SizedBox(height: 8.0),
                // Text('frequency_type: ${medication.frequency_type}'),
                // const SizedBox(height: 8.0),
                // Text('frequency_interval: ${medication.frequency_interval}'),
                // const SizedBox(height: 8.0),
                // Text('daily_frequency: ${medication.daily_frequency}'),
                // const SizedBox(height: 8.0),
                // Text('medication_day: ${medication.medication_day}'),
                // const SizedBox(height: 8.0),
                // Text('next_dose_day: ${medication.next_dose_day}'),
                // const SizedBox(height: 8.0),
                // Text('dose_times: ${medication.dose_times}'),
                // const SizedBox(height: 8.0),
                // Text('medication_quantity: ${medication.medication_quantity}'),
                // const SizedBox(height: 8.0),
                // Text('user_id: ${medication.user_id}'),
                // const SizedBox(height: 8.0),
                // Text('profile_id: ${medication.profile_id}'),
                // const SizedBox(height: 8.0),
              ],
            ),
          );
        },
      ),
    );
  }
}

String _getSuffixForType(String type) {
  switch (type) {
    case 'Pills':
      return 'pill(s)';
    case 'Injection':
      return 'ml';
    case 'Solution':
      return 'ml';
    case 'Drops':
      return 'drop(s)';
    case 'Inhaler':
      return 'puff(s)';
    case 'Powder':
      return 'packet(s)';
    default:
      return '';
  }
}
