// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Medication Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16.0),
              // Display medication details using ListView.builder
              ListView.builder(
                shrinkWrap: true,
                itemCount: _medicationInfo.length,
                itemBuilder: (context, index) {
                  Medication medication = _medicationInfo[index];
                  return SizedBox(
                    width: MediaQuery.of(context)
                        .size
                        .width, // Set width to screen width
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8.0),
                        Text('medication_name: ${medication.medication_name}'),
                        const SizedBox(height: 8.0),
                        Text('medication_type: ${medication.medication_type}'),
                        const SizedBox(height: 8.0),
                        Text('frequency_type: ${medication.frequency_type}'),
                        const SizedBox(height: 8.0),
                        Text(
                            'frequency_interval: ${medication.frequency_interval}'),
                        const SizedBox(height: 8.0),
                        Text('daily_frequency: ${medication.daily_frequency}'),
                        const SizedBox(height: 8.0),
                        Text('medication_day: ${medication.medication_day}'),
                        const SizedBox(height: 8.0),
                        Text('next_dose_day: ${medication.next_dose_day}'),
                        const SizedBox(height: 8.0),
                        Text('dose_times: ${medication.dose_times}'),
                        const SizedBox(height: 8.0),
                        Text(
                            'medication_quantity: ${medication.medication_quantity}'),
                        const SizedBox(height: 8.0),
                        Text('user_id: ${medication.user_id}'),
                        const SizedBox(height: 8.0),
                        Text('profile_id: ${medication.profile_id}'),
                        const SizedBox(height: 8.0),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
