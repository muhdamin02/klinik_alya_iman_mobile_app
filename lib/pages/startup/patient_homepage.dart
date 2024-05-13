// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import '../../app_drawer/app_drawer_all_pages.dart';
import '../../models/homefeed.dart';
import '../../models/profile.dart';
import '../../models/user.dart';
import '../../services/database_service.dart';
import '../../services/misc_methods/notification_singleton.dart';
import '../../services/notification_service.dart';
import '../appointment_management/list_appointment.dart';
import '../medication_management/list_medication.dart';
import '../profile_management/first_profile.dart';
import '../profile_management/list_profile.dart';
import '../profile_management/profile_page.dart';
import 'login.dart';

class PatientHomepage extends StatefulWidget {
  final User user;
  final Profile profile;
  final bool hasProfiles;
  final bool hasChosenProfile;
  final bool autoImplyLeading;

  const PatientHomepage(
      {Key? key,
      required this.user,
      required this.profile,
      required this.hasProfiles,
      required this.hasChosenProfile,
      required this.autoImplyLeading})
      : super(key: key);

  @override
  _PatientHomepageState createState() => _PatientHomepageState();
}

class _PatientHomepageState extends State<PatientHomepage> {
  List<HomeFeed> _homeFeed = [];

  @override
  void initState() {
    super.initState();
    _fetchHomeFeed();
  }

  // ----------------------------------------------------------------------
  // View homefeed

  Future<void> _fetchHomeFeed() async {
    List<HomeFeed> homeFeed = await DatabaseService().homeFeedAll();
    setState(() {
      _homeFeed = homeFeed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return false to prevent the user from navigating back
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
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
              0xFF0A0F2C,
            ), // Set the background color of the BottomAppBar
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  const Spacer(),
                  if (widget.hasChosenProfile)
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
                      color: const Color(
                        0xFFEDF2FF,
                      ), // Set the color of the icon
                    ),
                  if (!widget.hasChosenProfile)
                    IconButton(
                      icon: const Icon(Icons.group),
                      iconSize: 25,
                      onPressed: () {
                        if (widget.hasProfiles) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListProfile(
                                user: widget.user,
                              ),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FirstProfile(
                                user: widget.user,
                                showTips: false,
                              ),
                            ),
                          );
                        }
                      },
                      color: const Color(
                        0xFFEDF2FF,
                      ), // Set the color of the icon
                    ),
                  const Spacer(),
                  if (widget.hasChosenProfile)
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
                            ),
                          ),
                        );
                      },
                      color: const Color(
                        0xFFEDF2FF,
                      ), // Set the color of the icon
                    ),
                  if (widget.hasChosenProfile) const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.home),
                    iconSize: 30,
                    onPressed: () {
                      // Method associated with the home icon
                    },
                    color: const Color(
                      0xFF5464BB,
                    ), // Set the color of the icon
                  ),
                  const Spacer(),
                  if (widget.hasChosenProfile)
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
                      color: const Color(
                        0xFFEDF2FF,
                      ), // Set the color of the icon
                    ),
                  if (widget.hasChosenProfile) const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    iconSize: 23,
                    onPressed: () {
                      // Method associated with the settings icon
                    },
                    color: const Color(
                      0xFFEDF2FF,
                    ), // Set the color of the icon
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),

        // drawer: AppDrawerAllPages(
        //   header: 'Home',
        //   user: widget.user,
        //   profile: widget.profile,
        //   autoImplyLeading: true,
        // ),
        body: Stack(
          children: [
            ListView.builder(
              itemCount: _homeFeed.length,
              itemBuilder: (context, index) {
                HomeFeed homeFeed = _homeFeed[index];
                return Column(
                  children: [
                    const SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GestureDetector(
                        onTap: () {
                          print('tapped');
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                25.0), // Adjust the radius
                          ),
                          elevation: 8, // Set the elevation for the card
                          color: const Color.fromARGB(255, 238, 238, 238),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ListTile(
                              title: Text(
                                homeFeed.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight
                                      .bold, // You can adjust other font styles as well
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4.0),
                                  Text(
                                    homeFeed.body,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  // Text(homeFeed.datetime_posted),
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
      ),
    );
  }
}
