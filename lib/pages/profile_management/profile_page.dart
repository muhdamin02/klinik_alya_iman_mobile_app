import 'package:flutter/material.dart';

import '../../appbar/appbar_all_pages.dart';
import '../../models/medication.dart';
import '../../models/profile.dart';
import '../../models/user.dart';
import '../appointment_management/appointment_form.dart';
import '../medication_management/medication_form/medication_name.dart';

class ProfilePage extends StatelessWidget {
  final User user;
  final Profile profile;
  final bool autoImplyLeading;

  const ProfilePage(
      {Key? key,
      required this.user,
      required this.profile,
      required this.autoImplyLeading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return false to prevent the user from navigating back
        return autoImplyLeading;
      },
      child: Scaffold(
        appBar: AlyaImanAppBarSeeAllPages(
          title: 'Profile Page',
          user: user,
          profile: profile,
          autoImplyLeading: autoImplyLeading,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${profile.f_name} ${profile.l_name}',
                  style: const TextStyle(fontSize: 20)),
              Text('Date of Birth: ${profile.dob}',
                  style: const TextStyle(fontSize: 16)),
              Text('Gender: ${profile.gender}',
                  style: const TextStyle(fontSize: 16)),
              // Add more details as needed
            ],
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton.extended(
              onPressed: () {
                // Navigate to the page where you want to appointment form
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppointmentForm(
                      user: user,
                      profile: profile,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.event),
              label: const Text('Book Appointment'),
            ),
            const SizedBox(height: 10),
            FloatingActionButton.extended(
              onPressed: () {
                final medication = Medication(
                  medication_name: '',
                  medication_type: '',
                  frequency_type: '',
                  frequency_interval: 0,
                  daily_frequency: 0,
                  next_dose_day: '',
                  dose_times: '',
                  medication_time: '',
                  medication_quantity: 0,
                  user_id: user.user_id!,
                  profile_id: profile.profile_id!,
                );

                // Navigate to the page where you want to medication form
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MedicationNamePage(
                      medication: medication,
                      user: user,
                      profile: profile,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.medication),
              label: const Text('Add Medication'),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
