import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/profile.dart';
import '../../../models/user.dart';
import '../../../services/database_service.dart';

class ViewPatient extends StatefulWidget {
  final User user;
  final Profile profile;
  final bool autoImplyLeading;

  const ViewPatient({
    Key? key,
    required this.user,
    required this.profile,
    required this.autoImplyLeading,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ViewPatientState createState() => _ViewPatientState();
}

class _ViewPatientState extends State<ViewPatient> {
  List<Profile> _profileInfo = [];
  String _maternityValue = 'No';

  @override
  void initState() {
    super.initState();
    _fetchProfileInfo();
    _maternityValue = widget.profile.maternity;
  }

  // ----------------------------------------------------------------------
  // Fetch details

  Future<void> _fetchProfileInfo() async {
    List<Profile> profileInfo =
        await DatabaseService().profileInfo(widget.profile.profile_id);
    setState(() {
      _profileInfo = profileInfo;
    });
  }
  // ----------------------------------------------------------------------

  void _handleMaternitySelection(maternityValue) async {
    print('Maternity to be set: ${widget.profile.profile_id}');

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Set Maternity Status'),
          content: Builder(
            builder: (BuildContext context) {
              return Text(
                  'Are you sure you want to set maternity status for ${widget.profile.name} to $maternityValue?');
            },
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                await DatabaseService()
                    .setMaternity(widget.profile.profile_id!, maternityValue);
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
                _fetchProfileInfo();
              },
              child: const Text('Confirm'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    String cleanedDate = widget.profile.dob.replaceAll(" at", "");
    DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(cleanedDate);
    String formattedDate = DateFormat('dd MMMM yyyy').format(parsedDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Add your desired padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: _profileInfo.length,
                itemBuilder: (context, index) {
                  Profile profile = _profileInfo[index];
                  return SizedBox(
                    width: MediaQuery.of(context)
                        .size
                        .width, // Set width to screen width
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('NAME',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 121, 121, 121))),
                        const SizedBox(height: 4),
                        Text(profile.name,
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 24),
                        const Text('IC/PASSPORT',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 121, 121, 121))),
                        const SizedBox(height: 4),
                        Text(profile.identification,
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 24),
                        const Text('DATE OF BIRTH',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 121, 121, 121))),
                        const SizedBox(height: 4),
                        Text(
                          formattedDate,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 24),
                        const Text('GENDER',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 121, 121, 121))),
                        const SizedBox(height: 4),
                        Text(profile.gender!,
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 24),
                        const Text('MATERNITY STATUS',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 121, 121, 121))),
                        const SizedBox(height: 4),
                        DropdownButton<String>(
                          value: _maternityValue,
                          onChanged: (newValue) {
                            setState(() {
                              _maternityValue = newValue!;
                              _handleMaternitySelection(_maternityValue);
                            });
                          },
                          items: <String>[
                            'No',
                            'First Trimester',
                            'Second Trimester',
                            'Third Trimester'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
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
