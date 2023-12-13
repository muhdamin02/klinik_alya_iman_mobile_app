import 'package:flutter/material.dart';

import '../../appbar/appbar_profiles_logout_only.dart';
import '../../models/medication.dart';
import '../../models/profile.dart';
import '../../models/user.dart';
import '../../services/database_service.dart';
import 'medication_form.dart';

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

  @override
  void initState() {
    super.initState();
    _fetchMedicationList();
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
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) =>
    //         ViewMedication(medication: medication, user: widget.user),
    //   ),
    // );
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
    // Sort the _medicationList list by appointment time
    // _medicationList
    //     .sort((a, b) => a.medication_time.compareTo(b.medication_time));

    return WillPopScope(
      onWillPop: () async {
        return widget.autoImplyLeading;
      },
      child: Scaffold(
        appBar: AlyaImanAppBarOnlySeeProfilesAndLogout(
          title: 'Medication List',
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
                      title: Text(
                          '${medication.medication_name} - ${medication.medication_time}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4.0),
                          Text('Status: ${medication.medication_type}'),
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
            // Navigate to the page where you want to medication form
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MedicationForm(
                        user: widget.user,
                        profile: widget.profile,
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
