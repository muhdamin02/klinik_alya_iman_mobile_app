import 'package:flutter/material.dart';

import '../../models/homefeed.dart';
import '../../models/user.dart';
import '../../services/database_service.dart';
import '../startup/login.dart';
import 'admin_appt_management/admin_appt_management.dart';
import 'announcement_management/new_announcement.dart';
import 'user_management/manage_user.dart';

class SystemAdminHome extends StatefulWidget {
  final User user;

  const SystemAdminHome({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SystemAdminHomeState createState() => _SystemAdminHomeState();
}

class _SystemAdminHomeState extends State<SystemAdminHome> {
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
      child: DefaultTabController(
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
                    IconButton(
                      icon: const Icon(Icons.event),
                      iconSize: 22,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ManageAppointmentAdmin(
                              user: widget.user,
                              autoImplyLeading: false,
                            ),
                          ),
                        );
                      },
                      color: const Color(
                        0xFFEDF2FF,
                      ), // Set the color of the icon
                    ),
                    const Spacer(),
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
                    IconButton(
                      icon: const Icon(Icons.group),
                      iconSize: 25,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ManageUser(
                              user: widget.user,
                              autoImplyLeading: false,
                              initialTab: 0,
                            ),
                          ),
                        );
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
          body: Stack(
            children: [
              PatientTabBarView(homeFeed: _homeFeed),
              Positioned(
                bottom: 24.0,
                left: 0,
                right: 0,
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width -
                        34, // Adjust padding
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewAnnouncement(
                              user: widget.user,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.announcement),
                      label: const Text('Add New Announcement'),
                      elevation: 0,
                      backgroundColor:
                          const Color(0xFFC1D3FF), // Set background color here
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            25), // Adjust the border radius
                        side: const BorderSide(
                            width: 2.5,
                            color: Color(
                                0xFF6086f6)), // Set the outline color here
                      ),
                      foregroundColor: const Color(
                          0xFF1F3299), // Set text and icon color here
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
                dropdownColor: const Color(0xFF303E8F),
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
