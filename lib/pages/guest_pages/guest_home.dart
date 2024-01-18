import 'package:flutter/material.dart';
import '../../app_drawer/app_drawer_guest_home.dart';
import '../../models/homefeed.dart';
import '../../models/user.dart';
import '../../services/database_service.dart';

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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          title: const Text('Tips'),
          content: const Text(
              'As a guest, you can pre-register for booking appointments.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
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
        // Return false to prevent the user from navigating back
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Home',
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
                    const SizedBox(height: 12.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GestureDetector(
                        onTap: () {
                          // function
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
