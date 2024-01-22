import 'package:flutter/material.dart';

import '../../models/profile.dart';
import '../../models/user.dart';

class ThirdTrimester extends StatefulWidget {
  final User user;
  final Profile profile;

  const ThirdTrimester({
    Key? key,
    required this.user,
    required this.profile,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ThirdTrimesterState createState() => _ThirdTrimesterState();
}

class _ThirdTrimesterState extends State<ThirdTrimester> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return false to prevent the user from navigating back
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Second Trimester'),
          automaticallyImplyLeading: false,
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Second Trimester Page Placeholder',
                style: TextStyle(fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
