import 'package:flutter/material.dart';
import '../../app_drawer/app_drawer_guest_home.dart';
import '../../models/homefeed.dart';
import '../../models/user.dart';
import '../../services/database_service.dart';
import '../../services/misc_methods/truncate_body_text.dart';

class GuestHome extends StatefulWidget {
  final User user;
  final bool showTips;

  const GuestHome({
    Key? key,
    required this.user,
    required this.showTips,
  }) : super(key: key);

  @override
  _GuestHomeState createState() => _GuestHomeState();
}

class _GuestHomeState extends State<GuestHome> {
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

  bool showOverlay = true;

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
            'Guest placeholder',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        drawer: AppDrawerGuest(
          header: 'Guest Home',
          user: widget.user,
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
                      child: Card(
                        elevation: 3, // Set the elevation for the card
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ListTile(
                            title: Text(homeFeed.title),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4.0),
                                GestureDetector(
                                  onTap: () {
                                    // Add logic to navigate to the full article or perform any desired action
                                    // _viewArticle(homeFeed);
                                  },
                                  child: Text(
                                    truncateText(homeFeed.body),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(homeFeed.datetime_posted),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.visibility),
                                  onPressed: () {
                                    // _viewArticle(homeFeed);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            if (showOverlay &&
                widget.showTips) // Show overlay only when showOverlay is true
              GestureDetector(
                onTap: () {
                  // Optional: Add logic here if you want to dismiss the overlay when tapped outside the textbox
                },
                child: Container(
                  color: Colors.black
                      .withOpacity(0.7), // Adjust the opacity as needed
                  child: Center(
                    child: Container(
                      width: 300, // Adjust the width as needed
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: SingleChildScrollView(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Tips',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              const Text(
                                'As a guest, you can pre-register for booking appointments.',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center, // Center the text
                              ),
                              const SizedBox(height: 16.0),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    showOverlay = false;
                                  });
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        ),
                      ),
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