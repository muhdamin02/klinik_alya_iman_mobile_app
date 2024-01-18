import 'package:flutter/material.dart';

import '../../app_drawer/app_drawer_all_pages.dart';
import '../../models/homefeed.dart';
import '../../models/profile.dart';
import '../../models/user.dart';
import '../../services/database_service.dart';

class PatientHomepage extends StatefulWidget {
  final User user;
  final Profile profile;
  final bool autoImplyLeading;

  const PatientHomepage(
      {Key? key,
      required this.user,
      required this.profile,
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
        return widget.autoImplyLeading;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        drawer: AppDrawerAllPages(
          header: 'Home',
          user: widget.user,
          profile: widget.profile,
          autoImplyLeading: true,
        ),
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
