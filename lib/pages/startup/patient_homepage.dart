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
    homeFeed.sort((b, a) => a.datetime_posted.compareTo(b.datetime_posted));

    setState(() {
      _homeFeed = homeFeed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Information Hub'),
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
          bottom: const TabBar(
            labelStyle: TextStyle(
              // Set your desired text style for the selected (active) tab here
              fontWeight: FontWeight.w500,
              fontSize: 16,
              fontFamily: 'ProductSans',
              // You can set other text style properties as needed
            ),
            unselectedLabelStyle: TextStyle(
              // Set your desired text style for the unselected tabs here
              fontSize: 16,
              fontFamily: 'ProductSans',
              // You can set other text style properties as needed
            ),
            indicatorColor: Color(0xFFB6CBFF),
            indicatorWeight: 6,
            tabs: [
              Tab(text: 'Announcements'),
              Tab(text: 'About Clinic'),
              // Add more tabs as needed
            ],
          ),
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
        body: PatientTabBarView(homeFeed: _homeFeed),
      ),
    );
  }
}

class PatientTabBarView extends StatelessWidget {
  final List<HomeFeed> homeFeed;

  const PatientTabBarView({Key? key, required this.homeFeed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        Tab1Page(homeFeedList: homeFeed),
        const Tab2Page(),
      ],
    );
  }
}

class Tab1Page extends StatefulWidget {
  final List<HomeFeed> homeFeedList;

  const Tab1Page({Key? key, required this.homeFeedList}) : super(key: key);

  @override
  _Tab1PageState createState() => _Tab1PageState();
}

class _Tab1PageState extends State<Tab1Page> {
  String selectedCategory = 'All';

  List<HomeFeed> getFilteredHomeFeedList() {
    if (selectedCategory == 'All') {
      return widget.homeFeedList;
    } else {
      return widget.homeFeedList
          .where((homeFeed) => homeFeed.category == selectedCategory)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<HomeFeed> filteredHomeFeedList = getFilteredHomeFeedList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 25, top: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'Filter by ',
                style: TextStyle(
                  color: Color(0xFFB6CBFF),
                  fontSize: 16, // Set your desired font size
                ),
              ),
              DropdownButton<String>(
                value: selectedCategory,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue!;
                  });
                },
                dropdownColor: const Color(
                    0xFF303E8F), // Set your desired background color
                items: <String>['All', 'News', 'Promotion']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredHomeFeedList.length,
            itemBuilder: (context, index) {
              HomeFeed homeFeed = filteredHomeFeedList[index];
              return Column(
                children: [
                  const SizedBox(height: 5.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GestureDetector(
                      onTap: () {
                        print('tapped');
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        elevation: 0,
                        color: const Color(0xFF303E8F),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ListTile(
                            title: Text(
                              homeFeed.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFD271),
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8.0),
                                Text(
                                  homeFeed.body,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(height: 1.4),
                                ),
                                const SizedBox(height: 20.0),
                                Row(
                                  children: [
                                    Text(
                                      homeFeed.category,
                                      style: const TextStyle(
                                          color: Color(0xFFB6CBFF)),
                                    ),
                                    const Spacer(),
                                    Text(
                                      'Posted on ${homeFeed.datetime_posted}',
                                      style: const TextStyle(
                                          color: Color(0xFFB6CBFF)),
                                    ),
                                  ],
                                )
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
        ),
      ],
    );
  }
}

class Tab2Page extends StatelessWidget {
  const Tab2Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Implement your Tab 2 content here
    return Container(
      color: Colors.green,
      child: const Center(
        child: Text(
          'Tab 2',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}
