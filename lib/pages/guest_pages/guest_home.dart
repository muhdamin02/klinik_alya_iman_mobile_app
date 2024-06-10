import 'package:flutter/material.dart';
import 'package:klinik_alya_iman_mobile_app/pages/guest_pages/guest_appointment_pages/guest_appointment.dart';
import '../../models/homefeed.dart';
import '../../models/user.dart';
import '../../services/database_service.dart';
import '../profile_management/create_profile.dart';
import '../startup/login.dart';
import 'guest_appointment_pages/guest_profile.dart';

class GuestHome extends StatefulWidget {
  final User user;
  final bool showTips;

  const GuestHome({
    Key? key,
    required this.user,
    required this.showTips,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _GuestHomeState createState() => _GuestHomeState();
}

class _GuestHomeState extends State<GuestHome> {
  List<HomeFeed> _homeFeed = [];

  @override
  void initState() {
    super.initState();
    _fetchHomeFeed();

    if (widget.showTips) {
      Future.delayed(Duration.zero, () {
        _showTipsDialog();
      });
    }
  }

  // ----------------------------------------------------------------------
  // View homefeed

  Future<void> _fetchHomeFeed() async {
    List<HomeFeed> homeFeed = await DatabaseService().homeFeedAll();
    setState(() {
      _homeFeed = homeFeed;
    });
  }

  void _showTipsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF303E8F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          title: const Text('Tips', style: TextStyle(color: Color(0xFFFFD271))),
          content: const Text(
              'As a guest, you can pre-register for booking appointments.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:
                  const Text('OK', style: TextStyle(color: Color(0xFFEDF2FF))),
            ),
          ],
        );
      },
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
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
                            builder: (context) => CreateTempProfile(
                              user: widget.user,
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
                      icon: const Icon(Icons.login),
                      iconSize: 25,
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Login(
                                usernamePlaceholder: '',
                                passwordPlaceholder: ''),
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
          body: PatientTabBarView(homeFeed: _homeFeed),
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
