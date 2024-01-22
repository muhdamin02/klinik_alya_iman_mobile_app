import 'package:flutter/material.dart';

import '../../models/profile.dart';
import '../../models/user.dart';

class FirstTrimester extends StatefulWidget {
  final User user;
  final Profile profile;

  const FirstTrimester({
    Key? key,
    required this.user,
    required this.profile,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FirstTrimesterState createState() => _FirstTrimesterState();
}

class _FirstTrimesterState extends State<FirstTrimester> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return false to prevent the user from navigating back
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('First Trimester'),
          automaticallyImplyLeading: false,
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'First Trimester Page Placeholder',
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
