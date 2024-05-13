// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:klinik_alya_iman_mobile_app/pages/profile_management/first_profile.dart';

import '../../app_drawer/app_drawer_logout.dart';
import '../../models/profile.dart';
import '../../models/user.dart';
import '../../services/database_service.dart';
import '../../services/misc_methods/notification_singleton.dart';
import '../../services/notification_service.dart';
import '../startup/login.dart';
import '../startup/patient_homepage.dart';
import 'create_profile.dart';
import 'profile_page.dart';
import 'update_profile.dart';

class ListProfile extends StatefulWidget {
  final User user;

  const ListProfile({super.key, required this.user});

  @override
  // ignore: library_private_types_in_public_api
  _ListProfileState createState() => _ListProfileState();
}

class _ListProfileState extends State<ListProfile> {
  List<Profile> _profileList = [];

  @override
  void initState() {
    super.initState();
    _fetchProfileList();
  }

  // ----------------------------------------------------------------------
  // View list of profiles

  Future<void> _fetchProfileList() async {
    List<Profile> profileList =
        await DatabaseService().profile(widget.user.user_id!);
    setState(() {
      _profileList = profileList;
    });
  }
  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Update list of profiles

  void _updateProfile(Profile profile) {
    // Navigate to the list of profiles page with the selected profiles
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateProfile(profile: profile),
      ),
    ).then((result) {
      if (result == true) {
        // If the list of profiles was updated, refresh the list of profiles
        _fetchProfileList();
      }
    });
  }

  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Delete Profile

  void _deleteProfile(int? profileId) async {
    // Check if there are associated appointments
    bool hasAppointments = await DatabaseService().hasAppointments(profileId!);
    bool hasMedication = await DatabaseService().hasMedication(profileId);

    if (hasAppointments || hasMedication) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Profile'),
            content: const Text(
                'This profile has associated appointments and/or medication. Deleting the profile will also delete the appointments and/or medication. Are you sure you want to proceed?'),
            actions: <Widget>[
              ElevatedButton(
                child:
                    const Text('Delete', style: TextStyle(color: Colors.white)),
                onPressed: () async {
                  // Delete associated appointments
                  await DatabaseService()
                      .deleteAppointmentsByProfile(profileId);

                  // Delete associated medication
                  await DatabaseService().deleteMedicationByProfile(profileId);

                  // Delete the profile
                  await DatabaseService().deleteProfile(profileId);

                  if (await DatabaseService()
                          .getProfileCount(widget.user.user_id!) ==
                      0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FirstProfile(
                          user: widget.user,
                          showTips: false,
                        ),
                      ),
                    );
                  } else {
                    Navigator.of(context).pop(); // Close the dialog
                    // Refresh the profile list
                    _fetchProfileList();
                  }
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
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Profile'),
            content:
                const Text('Are you sure you want to delete this profile?'),
            actions: <Widget>[
              ElevatedButton(
                child:
                    const Text('Delete', style: TextStyle(color: Colors.white)),
                onPressed: () async {
                  // Call the deleteProfile method and pass the profileId
                  await DatabaseService().deleteProfile(profileId);
                  if (await DatabaseService()
                          .getProfileCount(widget.user.user_id!) ==
                      0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FirstProfile(
                          user: widget.user,
                          showTips: false,
                        ),
                      ),
                    );
                  } else {
                    Navigator.of(context).pop(); // Close the dialog
                    // Refresh the profile list
                    _fetchProfileList();
                  }
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
  }

  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Builder

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return false to prevent the user from navigating back
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'My Profiles',
            style: TextStyle(color: Color(0xFFEDF2FF)),
          ),
          automaticallyImplyLeading: false,
          elevation: 0,
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
                    icon: const Icon(Icons.group),
                    iconSize: 30,
                    onPressed: () {},
                    color: const Color(0xFF5464BB), // Set the color of the icon
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.home),
                    iconSize: 25,
                    onPressed: () {
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PatientHomepage(
                            user: widget.user,
                            profile: tempProfile,
                            hasProfiles: true,
                            hasChosenProfile: false,
                            autoImplyLeading: false,
                          ),
                        ),
                      );
                    },
                    color: const Color(0xFFEDF2FF), // Set the color of the icon
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

        // drawer: AppDrawerLogout(
        //   header: 'Choose Profile',
        //   user: widget.user,
        // ),
        body: Stack(
          children: [
            ListView.builder(
              itemCount:
                  _profileList.length + 1, // Add 1 to account for the SizedBox
              itemBuilder: (context, index) {
                if (index == _profileList.length) {
                  // Add SizedBox after the final item
                  return const SizedBox(height: 90.0);
                } else {
                  Profile profile = _profileList[index];
                  return Column(
                    children: [
                      if (index == 0) // Add SizedBox only for the first item
                        const SizedBox(height: 8.0),
                      const SizedBox(height: 8.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfilePage(
                                  user: widget.user,
                                  profile: profile,
                                  autoImplyLeading: true,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  30.0), // Adjust the radius
                            ),
                            elevation: 0, // Set the elevation for the card
                            color: const Color(0xFF303E8F),
                            child: Padding(
                              padding: const EdgeInsets.all(28.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      _getFirstTwoWords(profile.name),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        color: Color(0xFFEDF2FF),
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.play_arrow_rounded, // Your icon
                                    color: Color(0xFFFFD271), // Icon color
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
            Positioned(
              bottom: 24.0,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width:
                      MediaQuery.of(context).size.width - 34, // Adjust padding
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      // Navigate to the page where you want to appointment form
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateProfile(
                            user: widget.user,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.person_add),
                    label: const Text('Add New Profile'),
                    elevation: 0,
                    backgroundColor:
                        const Color(0xFFC1D3FF), // Set background color here
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(25), // Adjust the border radius
                      side: const BorderSide(
                          width: 2.5,
                          color:
                              Color(0xFF6086f6)), // Set the outline color here
                    ),
                    foregroundColor:
                        const Color(0xFF1F3299), // Set text and icon color here
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Function to get the first two words from a string
String _getFirstTwoWords(String fullName) {
  // Split the string into words
  List<String> words = fullName.split(' ');

  // Take the first two words and join them back into a string
  return words.take(2).join(' ');
}
