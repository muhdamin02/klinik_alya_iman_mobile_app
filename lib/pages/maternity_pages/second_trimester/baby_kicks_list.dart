import 'package:flutter/material.dart';

import '../../../app_drawer/app_drawer_all_pages.dart';
import '../../../models/baby_kicks.dart';
import '../../../models/profile.dart';
import '../../../models/user.dart';
import '../../../services/database_service.dart';
import '../../../services/misc_methods/datetime_display.dart';
import '../../../services/misc_methods/format_duration.dart';
import '../../appointment_management/list_appointment.dart';
import '../../medication_management/list_medication.dart';
import '../../profile_management/profile_page.dart';
import '../../startup/patient_homepage.dart';
import '../maternity_overview.dart';
import 'baby_kicks_counter.dart';

class BabyKicksList extends StatefulWidget {
  final User user;
  final Profile profile;
  final bool autoImplyLeading;

  const BabyKicksList({
    Key? key,
    required this.user,
    required this.profile,
    required this.autoImplyLeading,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BabyKicksListState createState() => _BabyKicksListState();
}

class _BabyKicksListState extends State<BabyKicksList> {
  List<BabyKicks> _babyKicksList = [];
  // List<EducationalResources> _educationResourcesList = [];

  @override
  void initState() {
    super.initState();
    _fetchBabyKicksList();
    // _fetchEducationResourcesList();
  }

  Future<void> _fetchBabyKicksList() async {
    List<BabyKicks> babyKicksList = await DatabaseService()
        .retrieveBabyKicks(widget.user.user_id!, widget.profile.profile_id);

    setState(() {
      _babyKicksList = babyKicksList.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return false to prevent the user from navigating back
        return widget.autoImplyLeading;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Baby Kicks History'),
          automaticallyImplyLeading: widget.autoImplyLeading,
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
                            initialTab: 1,
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
                    iconSize: 25,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListMedication(
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
                    icon: const Icon(Icons.pregnant_woman),
                    iconSize: 23,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MaternityOverview(
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
                ],
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            if (_babyKicksList.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Spacer(),
                    Center(
                      child: Text(
                        'You have not logged any baby kicks.',
                        style:
                            TextStyle(fontSize: 18.0, color: Color(0xFFB6CBFF)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 56.0),
                    Spacer(),
                  ],
                ),
              ),
            ListView.builder(
              itemCount: _babyKicksList.length,
              itemBuilder: (context, index) {
                BabyKicks babyKicks = _babyKicksList[index];
                return Column(
                  children: [
                    if (index == 0) const SizedBox(height: 8),
                    const SizedBox(height: 4.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GestureDetector(
                        onTap: () {
                          // onViewAppointment(appointment);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          elevation: 0,
                          color: const Color(0xFF303E8F),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 24.0),
                            child: ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '${DateTimeDisplay(datetime: babyKicks.kick_datetime).getStringDate()} - ${DateTimeDisplay(datetime: babyKicks.kick_datetime).getStringTime()}',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Color.fromARGB(
                                              255, 203, 218, 255))),
                                  const SizedBox(height: 8),
                                  Text(formatDuration(babyKicks.kick_duration),
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                              trailing: Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Text('${babyKicks.kick_count}',
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFFFD271),
                                      ))),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (index == _babyKicksList.length - 1)
                      const SizedBox(
                          height: 77.0), // Add SizedBox after the last item
                  ],
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BabyKickCounter(
                  user: widget.user,
                  profile: widget.profile,
                  autoImplyLeading: true,
                ),
              ),
            );
          },
          backgroundColor: const Color(0xFFC1D3FF), // Set background color here
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25), // Adjust the border radius
            side: const BorderSide(
                width: 2.5,
                color: Color(0xFF6086f6)), // Set the outline color here
          ),
          foregroundColor: const Color(0xFF1F3299),
          elevation: 0,
          icon: const Icon(Icons.add),
          label: const Text('Count Baby Kicks'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}

// class TabBarBabyKicks extends StatelessWidget {
//   final List<BabyKicks> babyKicksListing;
//   // final Function(Symptoms) onViewAppointment;

//   const TabBarBabyKicks({
//     Key? key,
//     required this.babyKicksListing,
//     // required this.onViewAppointment
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       initialIndex: 0,
//       length: 2,
//       child: Scaffold(
//         body: Column(
//           children: [
//             Expanded(
//               child: TabBarView(
//                 children: <Widget>[
//                   _buildBabyKicksList(babyKicksListing),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBabyKicksList(List<BabyKicks> babyKicksList) {
//     return ListView.builder(
//       itemCount: babyKicksList.length,
//       itemBuilder: (context, index) {
//         BabyKicks babyKicks = babyKicksList[index];
//         return Column(
//           children: [
//             if (index == 0) const SizedBox(height: 8),
//             const SizedBox(height: 4.0),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: GestureDetector(
//                 onTap: () {
//                   // onViewAppointment(appointment);
//                 },
//                 child: Card(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(25.0),
//                   ),
//                   elevation: 0,
//                   color: const Color(0xFF303E8F),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 16.0, vertical: 24.0),
//                     child: ListTile(
//                       title: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                               '${DateTimeDisplay(datetime: babyKicks.kick_datetime).getStringDate()} - ${DateTimeDisplay(datetime: babyKicks.kick_datetime).getStringTime()}',
//                               style: const TextStyle(
//                                   fontSize: 16,
//                                   color: Color.fromARGB(255, 203, 218, 255))),
//                           const SizedBox(height: 8),
//                           Text(formatDuration(babyKicks.kick_duration),
//                               style: const TextStyle(
//                                   fontSize: 16, fontWeight: FontWeight.w600)),
//                         ],
//                       ),
//                       trailing: Padding(
//                           padding: const EdgeInsets.only(right: 8),
//                           child: Text('${babyKicks.kick_count}',
//                               style: const TextStyle(
//                                 fontSize: 28,
//                                 fontWeight: FontWeight.bold,
//                                 color: Color(0xFFFFD271),
//                               ))),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             if (index == babyKicksList.length - 1)
//               const SizedBox(height: 77.0), // Add SizedBox after the last item
//           ],
//         );
//       },
//     );
//   }
// }
