import 'package:klinik_alya_iman_mobile_app/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:klinik_alya_iman_mobile_app/pages/appointment_management/appointment_form.dart';
import 'package:klinik_alya_iman_mobile_app/pages/profile_management/create_profile.dart';
import 'package:klinik_alya_iman_mobile_app/pages/profile_management/profile_page.dart';
import 'package:klinik_alya_iman_mobile_app/pages/profile_management/update_profile.dart';
import 'package:klinik_alya_iman_mobile_app/services/database_service.dart';

class ListProfile extends StatefulWidget {
  final int userId;

  const ListProfile({super.key, required this.userId});

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
  // View list of booking

  Future<void> _fetchProfileList() async {
    List<Profile> profileList = await DatabaseService().profile(widget.userId);
    setState(() {
      _profileList = profileList;
    });
  }
  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Update Booking

  void _updateProfile(Profile profile) {
    // Navigate to the update booking page with the selected booking
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateProfile(profile: profile),
      ),
    ).then((result) {
      if (result == true) {
        // If the booking was updated, refresh the booking history
        _fetchProfileList();
      }
    });
  }

  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Delete Booking

  void _deleteProfile(int? profileId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Profile (ID: $profileId)'),
          content: const Text('Are you sure you want to delete this profile?'),
          actions: <Widget>[
            ElevatedButton(
              child:
                  const Text('Delete', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                // Call the deleteProfile method and pass the profileId
                await DatabaseService().deleteProfile(profileId!);
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
                // Refresh the profile list
                _fetchProfileList();
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

  // ----------------------------------------------------------------------
  // Builder

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              const Text('Profile List', style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        body: Stack(children: [
          ListView.builder(
            itemCount: _profileList.length,
            itemBuilder: (context, index) {
              Profile profile = _profileList[index];
              return Column(
                children: [
                  const SizedBox(height: 16.0), // Add SizedBox widget here
                  ListTile(
                    title: Text('${profile.f_name} ${profile.l_name}',
                        style: const TextStyle(fontSize: 20)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4.0),
                        Text('Date of Birth: ${profile.dob}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check_circle),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AppointmentForm(
                                  userId: widget.userId,
                                  profile: profile,
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.visibility),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfilePage(
                                  profile: profile,
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // Call a method to handle the update functionality
                            _updateProfile(profile);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            // Call a method to handle the delete functionality
                            _deleteProfile(profile.profile_id);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            bottom: 32.0,
            right: 32.0,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateProfile(
                      userId: widget.userId,
                      userFName: "",
                      userLName: "",
                    ),
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
          ),
        ]));
  }

  // ----------------------------------------------------------------------
}
