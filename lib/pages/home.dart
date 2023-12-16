// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import '../models/medication.dart';
import '../models/user.dart';
import '../services/database_service.dart';
import '../services/misc_methods/notification_scheduler.dart';
import 'profile_management/first_profile.dart';
import 'profile_management/list_profile.dart';

class Home extends StatefulWidget {
  final User user;

  const Home({Key? key, required this.user}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
    NotificationScheduler().scheduleNotificationDaily();
    await _getMedication();
    await _setMedicationCount();
    await _getMedicationIds();
    print(_medicationList);
    print(_medicationCount);
    await _logic();
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

  Future<void> _logic() async {
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
        String frequencyType = target.frequency_type;
        int frequencyInterval = target.frequency_interval;
        int dailyFrequency = target.daily_frequency;
        String medicationDay = target.medication_day;
        // String nextDoseDay = target.next_dose_day;
        // String doseTimes = target.dose_times;

        print('Frequency Type of medication_id $id: $frequencyType');

        if (frequencyType == 'EveryDay') {
          switch (dailyFrequency) {
            case 1:
              print('$id: You take it everyday but only once a day');
              break;
            case 2:
              print('$id: You take it everyday but only once twice day');
              break;
            case 3:
              print('$id: You take it everyday, three times a day');
              break;
            case 4:
              print('$id: You take it everyday, four times a day');
              break;
            default:
              print('$id: Something wrong happened');
          }
        }

        if (frequencyType == 'EveryOtherDay') {
          print('$id: You take it every other day.');
        }

        if (frequencyType == 'SpecificDays') {
          switch (medicationDay) {
            case 'Sunday':
              print('$id: You take it on Sundays');
              break;
            case 'Monday':
              print('$id: You take it on Mondays');
              break;
            case 'Tuesday':
              print('$id: You take it on Tuesdays');
              break;
            case 'Wednesday':
              print('$id: You take it on Wednesdays');
              break;
            case 'Thursday':
              print('$id: You take it on Thursdays');
              break;
            case 'Friday':
              print('$id: You take it on Fridays');
              break;
            case 'Saturday':
              print('$id: You take it on Saturdays');
              break;
          }
        }

        if (frequencyType == 'EveryXDays') {
          print('$id: You take it every $frequencyInterval days.');
        }

        if (frequencyType == 'EveryXWeeks') {
          print('$id: You take it every $frequencyInterval weeks.');
        }

        if (frequencyType == 'EveryXMonths') {
          print('$id: You take it every $frequencyInterval months.');
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

          // Decide which page to navigate based on the profile count
          if (profileCount > 0) {
            return ListProfile(user: widget.user);
          } else {
            return FirstProfile(
              user: widget.user,
            );
          }
        }
      },
    );
  }
}
