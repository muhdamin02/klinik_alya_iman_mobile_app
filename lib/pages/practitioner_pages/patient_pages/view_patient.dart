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
  String maternityValue = 'No';

  @override
  void initState() {
    super.initState();
    maternityValue = widget.profile.maternity;
  }

  @override
  Widget build(BuildContext context) {
    String cleanedDate = widget.profile.dob.replaceAll(" at", "");
    DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(cleanedDate);
    String formattedDate = DateFormat('dd MMMM yyyy').format(parsedDate);

    return WillPopScope(
      onWillPop: () async {
        // Return false to prevent the user from navigating back
        return widget.autoImplyLeading;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Patient Info'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0), // Add your desired padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('NAME',
                  style: TextStyle(
                      fontSize: 14, color: Color.fromARGB(255, 121, 121, 121))),
              const SizedBox(height: 4),
              Text(widget.profile.name, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 24),
              const Text('IC/PASSPORT',
                  style: TextStyle(
                      fontSize: 14, color: Color.fromARGB(255, 121, 121, 121))),
              const SizedBox(height: 4),
              Text(widget.profile.identification,
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 24),
              const Text('DATE OF BIRTH',
                  style: TextStyle(
                      fontSize: 14, color: Color.fromARGB(255, 121, 121, 121))),
              const SizedBox(height: 4),
              Text(
                formattedDate,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              const Text('GENDER',
                  style: TextStyle(
                      fontSize: 14, color: Color.fromARGB(255, 121, 121, 121))),
              const SizedBox(height: 4),
              Text('${widget.profile.gender}',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 24),
              const Text('MATERNITY STATUS',
                  style: TextStyle(
                      fontSize: 14, color: Color.fromARGB(255, 121, 121, 121))),
              const SizedBox(height: 4),
              DropdownButton<String>(
                value: maternityValue,
                onChanged: (newValue) {
                  setState(() {
                    maternityValue = newValue!;
                    // Call functions based on selected value if needed
                    switch (maternityValue) {
                      case 'No':
                        DatabaseService().setMaternity(widget.profile.profile_id!, 'No');
                        break;
                      case 'First Trimester':
                        DatabaseService().setMaternity(widget.profile.profile_id!, 'First Trimester');
                        break;
                      case 'Second Trimester':
                        DatabaseService().setMaternity(widget.profile.profile_id!, 'Second Trimester');
                        break;
                      case 'Third Trimester':
                        DatabaseService().setMaternity(widget.profile.profile_id!, 'Third Trimester');
                        break;
                    }
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
        ),
      ),
    );
  }
}
