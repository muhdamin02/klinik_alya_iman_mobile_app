// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:klinik_alya_iman_mobile_app/pages/profile_management/first_profile.dart';

import '../../app_drawer/app_drawer_logout.dart';
import '../../models/profile.dart';
import '../../models/user.dart';
import '../../services/database_service.dart';
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
          title: const Text('Choose Profile',
              style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        drawer: AppDrawerLogout(
          header: 'Choose Profile',
          user: widget.user,
        ),
        body: Stack(
          children: [
            ListView.builder(
              itemCount: _profileList.length,
              itemBuilder: (context, index) {
                Profile profile = _profileList[index];
                return Column(
                  children: [
                    const SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                                25.0), // Adjust the radius
                          ),
                          elevation: 3, // Set the elevation for the card
                          color: const Color.fromARGB(255, 238, 238, 238),
                          child: Padding(
                            padding: const EdgeInsets.all(
                                16.0), // Add SizedBox widget here
                            child: ListTile(
                              title: Text(profile.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4.0),
                                  Text(profile.identification),
                                ],
                              ),
                            ),
                          ),
                        ),
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
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
