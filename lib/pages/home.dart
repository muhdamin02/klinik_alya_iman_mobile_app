// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../models/medication.dart';
import '../models/profile.dart';
import '../models/user.dart';
import '../services/database_service.dart';
import '../services/misc_methods/notification_scheduler.dart';
import '../services/misc_methods/notification_singleton.dart';
import '../services/notification_service.dart';
import 'profile_management/first_profile.dart';
import 'profile_management/list_profile.dart';
import 'startup/patient_homepage.dart';

class Home extends StatefulWidget {
  final User user;

  const Home({Key? key, required this.user}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  NotificationCounter notificationCounter = NotificationCounter();
  List<Medication> _medicationList = [];
  int _medicationCount = 0;
  List<int> _medicationIds = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    // NotificationScheduler().scheduleNotificationInFiveSeconds();
    // NotificationScheduler().scheduleNotificationDaily(
    //     notificationCounter.notificationCount, const Time(16, 29));
    // notificationCounter.increment();
    // Testing purposes only

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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: DatabaseService().getProfileCount(widget.user.user_id!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Data is still loading
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Error while fetching data
          return Text('Error: ${snapshot.error}');
        } else {
          // Data has been successfully loaded
          int profileCount = snapshot.data!;

          final tempProfile = Profile(
            name: 'unknown',
            identification: 'unknown',
            dob: 'unknown',
            gender: 'unknown',
            height: 0,
            weight: 0,
            body_fat_percentage: 0,
            activity_level: 'unknown',
            belly_size: 0,
            maternity: 'No',
            ethnicity: 'unknown',
            marital_status: 'unknown',
            occupation: 'unknown',
            medical_alert: 'unknown',
            profile_pic: 'unknown',
            creation_date: 'unknown',
            user_id: widget.user.user_id!,
          );

          // Decide which page to navigate based on the profile count
          if (profileCount > 0) {
            bool hasProfiles = true;

            return PatientHomepage(
              user: widget.user,
              profile: tempProfile,
              hasProfiles: hasProfiles,
              hasChosenProfile: false,
              autoImplyLeading: false,
            );
            // return ListProfile(user: widget.user);
          } else {
            bool hasProfiles = false;

            return PatientHomepage(
              user: widget.user,
              profile: tempProfile,
              hasProfiles: hasProfiles,
              hasChosenProfile: false,
              autoImplyLeading: false,
            );
            // return FirstProfile(
            //   user: widget.user,
            //   showTips: true,
            // );
          }
        }
      },
    );
  }
}
