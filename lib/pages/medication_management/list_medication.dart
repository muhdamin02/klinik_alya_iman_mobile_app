// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../app_drawer/app_drawer_profiles_logout_only.dart';
import '../../models/medication.dart';
import '../../models/profile.dart';
import '../../models/user.dart';
import '../../services/database_service.dart';
import '../../services/misc_methods/notification_scheduler.dart';
import '../../services/misc_methods/notification_singleton.dart';
import '../../services/notification_service.dart';
import '../appointment_management/list_appointment.dart';
import '../profile_management/profile_page.dart';
import '../startup/login.dart';
import '../startup/patient_homepage.dart';
import 'medication_form/medication_name.dart';
import 'view_medication.dart';

class ListMedication extends StatefulWidget {
  final User user;
  final Profile profile;
  final bool autoImplyLeading;

  const ListMedication(
      {super.key,
      required this.user,
      required this.profile,
      required this.autoImplyLeading});

  @override
  // ignore: library_private_types_in_public_api
  _ListMedicationState createState() => _ListMedicationState();
}

// ----------------------------------------------------------------------

class _ListMedicationState extends State<ListMedication> {
  List<Medication> _medicationList = [];
  NotificationCounter notificationCounter = NotificationCounter();
  int _medicationCount = 0;
  List<int> _medicationIds = [];

  @override
  void initState() {
    super.initState();
    _fetchMedicationList();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _getMedication();
    await _setMedicationCount();
    await _getMedicationIds();
    print(_medicationList);
    print(_medicationCount);
    await _setNotifications();
  }

  Future<void> _getMedication() async {
    List<Medication> medicationList =
        await DatabaseService().medicationUser(widget.user.user_id!);
    setState(() {
      _medicationList = medicationList;
    });
  }

  Future<void> _setMedicationCount() async {
    int medicationCount = _medicationList.length;
    setState(() {
      _medicationCount = medicationCount;
    });
  }

  Future<void> _getMedicationIds() async {
    List<int> medicationIds = _medicationList
        .map((medication) => medication.medication_id)
        .where((medicationId) => medicationId != null)
        .cast<int>() // Cast to non-nullable int
        .toList();
    setState(() {
      _medicationIds = medicationIds;
    });
  }

  List<String> extractDoseTimesAMPM(String doseTimesString) {
    List<String> doseTimesList = doseTimesString.split(';');
    doseTimesList = doseTimesList.map((doseTime) => doseTime.trim()).toList();
    return doseTimesList;
  }

  List<TimeOfDay> extractDoseTimes(String doseTimesString) {
    List<TimeOfDay> doseTimes = [];

    List<String> timeStrings = doseTimesString.split(';');
    for (String timeString in timeStrings) {
      List<String> components = timeString.trim().split(':');
      int hour = int.parse(components[0]);
      int minute = int.parse(components[1].split(' ')[0]);
      String period = components[1].split(' ')[1];

      if (period == 'PM' && hour != 12) {
        hour += 12;
      } else if (period == 'AM' && hour == 12) {
        hour = 0;
      }

      doseTimes.add(TimeOfDay(hour: hour, minute: minute));
    }

    return doseTimes;
  }

  DateTime convertStringToDate(String dateString) {
    List<int> dateParts = dateString.split('-').map(int.parse).toList();
    return DateTime(dateParts[0], dateParts[1], dateParts[2]);
  }

  Future<void> _setNotifications() async {
    NotificationCounter notificationCounter = NotificationCounter();
    notificationCounter.reset();
    await NotificationService().cancelAllNotifications();
    print('Reset notifications');

    for (int count = 0; count < _medicationCount; count++) {
      Medication? target;
      int id = _medicationIds[count];
      for (Medication medication in _medicationList) {
        if (medication.medication_id == id) {
          target = medication;
          break;
        }
      }
      if (target != null) {
        String medicationName = target.medication_name;
        String medicationType = target.medication_type;
        String medicationSuffix = '';

        String frequencyType = target.frequency_type;
        int frequencyInterval = target.frequency_interval;
        int dailyFrequency = target.daily_frequency;
        String medicationDay = target.medication_day;
        String nextDoseDay = target.next_dose_day;
        String doseTimes = target.dose_times;
        int medicationQuantity = target.medication_quantity;

        if (medicationType == 'Pills') {
          if (medicationQuantity > 1) {
            medicationSuffix = 'pills';
          } else {
            medicationSuffix = 'pill';
          }
        }

        if (medicationType == 'Injection' ||
            medicationType == 'Solution (liquid)') {
          medicationSuffix = 'ml';
        }

        if (medicationType == 'Drops') {
          if (medicationQuantity > 1) {
            medicationSuffix = 'drops';
          } else {
            medicationSuffix = 'drop';
          }
        }

        if (medicationType == 'Inhaler') {
          if (medicationQuantity > 1) {
            medicationSuffix = 'puffs';
          } else {
            medicationSuffix = 'puff';
          }
        }

        if (medicationType == 'Powder') {
          if (medicationQuantity > 1) {
            medicationSuffix = 'packets';
          } else {
            medicationSuffix = 'packet';
          }
        }

        List<String> doseTimesStrList = extractDoseTimesAMPM(doseTimes);
        List<TimeOfDay> doseTimesToD = extractDoseTimes(doseTimes);

        print('Frequency Type of medication_id $id: $frequencyType');

        if (frequencyType == 'EveryDay') {
          switch (dailyFrequency) {
            case 1:
              print('$id: You take it everyday but only once a day');
              print('$id: ${doseTimesToD[0].hour}:${doseTimesToD[0].minute}');
              NotificationScheduler().scheduleNotificationDaily(
                  notificationCounter.notificationCount,
                  medicationName,
                  'Take $medicationQuantity $medicationSuffix at ${doseTimesStrList[0]}',
                  Time(doseTimesToD[0].hour, doseTimesToD[0].minute));
              notificationCounter.increment();
              break;
            case 2:
              print('$id: You take it everyday but only once twice day');
              for (int i = 0; i < 2; i++) {
                print('$id: ${doseTimesToD[i].hour}:${doseTimesToD[i].minute}');
                NotificationScheduler().scheduleNotificationDaily(
                    notificationCounter.notificationCount,
                    medicationName,
                    'Take $medicationQuantity $medicationSuffix at ${doseTimesStrList[i]}',
                    Time(doseTimesToD[i].hour, doseTimesToD[i].minute));
                notificationCounter.increment();
              }
              break;
            case 3:
              print('$id: You take it everyday, three times a day');
              for (int i = 0; i < 3; i++) {
                print('$id: ${doseTimesToD[i].hour}:${doseTimesToD[i].minute}');
                NotificationScheduler().scheduleNotificationDaily(
                    notificationCounter.notificationCount,
                    medicationName,
                    'Take $medicationQuantity $medicationSuffix at ${doseTimesStrList[i]}',
                    Time(doseTimesToD[i].hour, doseTimesToD[i].minute));
                notificationCounter.increment();
              }
              break;
            case 4:
              print('$id: You take it everyday, four times a day');
              for (int i = 0; i < 4; i++) {
                print('$id: ${doseTimesToD[i].hour}:${doseTimesToD[i].minute}');
                NotificationScheduler().scheduleNotificationDaily(
                    notificationCounter.notificationCount,
                    medicationName,
                    'Take $medicationQuantity $medicationSuffix at ${doseTimesStrList[i]}',
                    Time(doseTimesToD[i].hour, doseTimesToD[i].minute));
                notificationCounter.increment();
              }
              break;
            default:
              print('$id: Something wrong happened');
          }
        }

        if (frequencyType == 'EveryOtherDay') {
          DateTime nextDoseDayDate = convertStringToDate(nextDoseDay);
          print('$id: You take it every other day, starting on $nextDoseDay.');
          print('$id: $nextDoseDayDate');
          NotificationScheduler().scheduleNotificationBiDaily(
              notificationCounter.notificationCount,
              medicationName,
              'Take $medicationQuantity $medicationSuffix at ${doseTimesStrList[0]}',
              Time(doseTimesToD[0].hour, doseTimesToD[0].minute),
              nextDoseDayDate);
          notificationCounter.increment();
        }

        if (frequencyType == 'SpecificDays') {
          switch (medicationDay) {
            case 'Sunday':
              print('$id: You take it on Sundays');
              NotificationScheduler().scheduleNotificationEverySpecificDays(
                  notificationCounter.notificationCount,
                  medicationName,
                  'Take $medicationQuantity $medicationSuffix at ${doseTimesStrList[0]}',
                  Time(doseTimesToD[0].hour, doseTimesToD[0].minute),
                  7,
                  7);
              notificationCounter.increment();
              break;
            case 'Monday':
              print('$id: You take it on Mondays');
              NotificationScheduler().scheduleNotificationEverySpecificDays(
                  notificationCounter.notificationCount,
                  medicationName,
                  'Take $medicationQuantity $medicationSuffix at ${doseTimesStrList[0]}',
                  Time(doseTimesToD[0].hour, doseTimesToD[0].minute),
                  7,
                  1);
              notificationCounter.increment();
              break;
            case 'Tuesday':
              print('$id: You take it on Tuesdays');
              NotificationScheduler().scheduleNotificationEverySpecificDays(
                  notificationCounter.notificationCount,
                  medicationName,
                  'Take $medicationQuantity $medicationSuffix at ${doseTimesStrList[0]}',
                  Time(doseTimesToD[0].hour, doseTimesToD[0].minute),
                  7,
                  2);
              notificationCounter.increment();
              break;
            case 'Wednesday':
              print('$id: You take it on Wednesdays');
              NotificationScheduler().scheduleNotificationEverySpecificDays(
                  notificationCounter.notificationCount,
                  medicationName,
                  'Take $medicationQuantity $medicationSuffix at ${doseTimesStrList[0]}',
                  Time(doseTimesToD[0].hour, doseTimesToD[0].minute),
                  7,
                  3);
              notificationCounter.increment();
              break;
            case 'Thursday':
              print('$id: You take it on Thursdays');
              NotificationScheduler().scheduleNotificationEverySpecificDays(
                  notificationCounter.notificationCount,
                  medicationName,
                  'Take $medicationQuantity $medicationSuffix at ${doseTimesStrList[0]}',
                  Time(doseTimesToD[0].hour, doseTimesToD[0].minute),
                  7,
                  4);
              notificationCounter.increment();
              break;
            case 'Friday':
              print('$id: You take it on Fridays');
              NotificationScheduler().scheduleNotificationEverySpecificDays(
                  notificationCounter.notificationCount,
                  medicationName,
                  'Take $medicationQuantity $medicationSuffix at ${doseTimesStrList[0]}',
                  Time(doseTimesToD[0].hour, doseTimesToD[0].minute),
                  7,
                  5);
              notificationCounter.increment();
              break;
            case 'Saturday':
              print('$id: You take it on Saturdays');
              NotificationScheduler().scheduleNotificationEverySpecificDays(
                  notificationCounter.notificationCount,
                  medicationName,
                  'Take $medicationQuantity $medicationSuffix at ${doseTimesStrList[0]}',
                  Time(doseTimesToD[0].hour, doseTimesToD[0].minute),
                  7,
                  6);
              notificationCounter.increment();
              break;
            default:
              print('$id: Something wrong happened');
          }
        }

        if (frequencyType == 'EveryXDays') {
          DateTime nextDoseDayDate = convertStringToDate(nextDoseDay);
          print(
              '$id: You take it every $frequencyInterval day(s), starting on $nextDoseDay.');
          print('$id: $nextDoseDayDate');
          NotificationScheduler().scheduleNotificationEveryXDays(
              notificationCounter.notificationCount,
              medicationName,
              'Take $medicationQuantity $medicationSuffix at ${doseTimesStrList[0]}',
              Time(doseTimesToD[0].hour, doseTimesToD[0].minute),
              nextDoseDayDate,
              frequencyInterval);
          notificationCounter.increment();
        }

        if (frequencyType == 'EveryXWeeks') {
          DateTime nextDoseDayDate = convertStringToDate(nextDoseDay);
          print(
              '$id: You take it every $frequencyInterval week(s), starting on $nextDoseDay.');
          print('$id: $nextDoseDayDate');
          NotificationScheduler().scheduleNotificationEveryXWeeks(
              notificationCounter.notificationCount,
              medicationName,
              'Take $medicationQuantity $medicationSuffix at ${doseTimesStrList[0]}',
              Time(doseTimesToD[0].hour, doseTimesToD[0].minute),
              nextDoseDayDate,
              frequencyInterval);
          notificationCounter.increment();
        }

        if (frequencyType == 'EveryXMonths') {
          DateTime nextDoseDayDate = convertStringToDate(nextDoseDay);
          print(
              '$id: You take it every $frequencyInterval month(s), starting on $nextDoseDay.');
          print('$id: $nextDoseDayDate');
          NotificationScheduler().scheduleNotificationEveryXMonths(
              notificationCounter.notificationCount,
              medicationName,
              'Take $medicationQuantity $medicationSuffix at ${doseTimesStrList[0]}',
              Time(doseTimesToD[0].hour, doseTimesToD[0].minute),
              nextDoseDayDate,
              frequencyInterval);
          notificationCounter.increment();
        }
      } else {
        print('Medication with medication_id $id not found.');
      }
    }
  }

  // ----------------------------------------------------------------------
  // View list of appointments

  Future<void> _fetchMedicationList() async {
    List<Medication> medicationList = await DatabaseService()
        .medication(widget.user.user_id!, widget.profile.profile_id);
    setState(() {
      _medicationList = medicationList;
    });
  }
  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // View Appointment

  void _viewMedication(Medication medication) {
    // Navigate to the view medication details page with the selected medication
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ViewMedication(medication: medication, user: widget.user),
      ),
    );
  }

  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Update Medication

  void _updateMedication(Medication medication) {
    // Navigate to the update medication page with the selected medication
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => UpdateMedication(
    //       medication: medication,
    //       reschedulerIsPatient: true,
    //     ),
    //   ),
    // ).then((result) {
    //   if (result == true) {
    //     // If the medication was updated, refresh the medication list
    //     _fetchMedicationList();
    //   }
    // });
  }

  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Delete Medication

  void _deleteMedication(int? medicationId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Medication'),
          content:
              const Text('Are you sure you want to remove this medication?'),
          actions: <Widget>[
            ElevatedButton(
              child:
                  const Text('Remove', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                // Call the deleteMedication method and pass the medicationId
                await DatabaseService().deleteMedication(medicationId!);
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
                // Refresh the medication list
                _fetchMedicationList();
              },
            ),
            ElevatedButton(
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // ----------------------------------------------------------------------
  // Builder

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return widget.autoImplyLeading;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Medications'),
          iconTheme: const IconThemeData(
            color: Color(0xFFEDF2FF),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                NotificationCounter notificationCounter = NotificationCounter();
                notificationCounter.reset();
                await NotificationService().cancelAllNotifications();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login(
                        usernamePlaceholder: widget.user.username,
                        passwordPlaceholder: widget.user.password),
                  ),
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: SizedBox(
          height: 56.0, // Adjust the height as needed
          child: BottomAppBar(
            color: const Color(
                0xFF0A0F2C), // Set the background color of the BottomAppBar
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.person),
                    iconSize: 25,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(
                            user: widget.user,
                            profile: widget.profile,
                            autoImplyLeading: false,
                          ),
                        ),
                      );
                    },
                    color: const Color(0xFFEDF2FF), // Set the color of the icon
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.event),
                    iconSize: 22,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListAppointment(
                            user: widget.user,
                            profile: widget.profile,
                            autoImplyLeading: false,
                          ),
                        ),
                      );
                    },
                    color: const Color(0xFFEDF2FF), // Set the color of the icon
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.home),
                    iconSize: 25,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PatientHomepage(
                            user: widget.user,
                            profile: widget.profile,
                            hasProfiles: true,
                            hasChosenProfile: true,
                            autoImplyLeading: false,
                          ),
                        ),
                      );
                    },
                    color: const Color(0xFFEDF2FF), // Set the color of the icon
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.medication),
                    iconSize: 30,
                    onPressed: () {},
                    color: const Color(0xFF5464BB), // Set the color of the icon
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    iconSize: 23,
                    onPressed: () {},
                    color: const Color(0xFFEDF2FF), // Set the color of the icon
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
        drawer: AppDrawerProfilesLogout(
          header: 'Medication List',
          user: widget.user,
          profile: widget.profile,
          autoImplyLeading: widget.autoImplyLeading,
        ),
        body: Stack(
          children: [
            ListView.builder(
              itemCount: _medicationList.length,
              itemBuilder: (context, index) {
                Medication medication = _medicationList[index];
                return Column(
                  children: [
                    const SizedBox(height: 16.0),
                    ListTile(
                      title: Text(medication.medication_name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4.0),
                          Text(
                              'Medication Type: ${medication.medication_type}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.visibility),
                            onPressed: () {
                              // Call a method to handle the view functionality
                              _viewMedication(medication);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              // Call a method to handle the update functionality
                              _updateMedication(medication);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              // Call a method to handle the delete functionality
                              _deleteMedication(medication.medication_id);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            final medication = Medication(
              medication_name: '',
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

            // Navigate to the page where you want to medication form
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MedicationNamePage(
                  user: widget.user,
                  profile: widget.profile,
                  medication: medication,
                ),
              ),
            );
          },
          icon: const Icon(Icons.medication),
          label: const Text('Add New Medication'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
