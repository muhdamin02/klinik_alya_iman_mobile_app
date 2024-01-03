import 'package:flutter/material.dart';

import '../../app_drawer/app_drawer_logout.dart';
import '../../models/user.dart';
import 'user_management/manage_user.dart';

class SystemAdminHome extends StatelessWidget {
  final User user;

  const SystemAdminHome({
    Key? key,
    required this.user,
  }) : super(key: key);

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
            'SystemAdminHome placeholder',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        drawer: AppDrawerLogout(
          header: 'System Admin Home',
          user: user,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome, ${user.name}!',
                  style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 16.0),
              Text('User ID: ${user.user_id}',
                  style: const TextStyle(fontSize: 16)),
              Text('User ID: ${user.identification}',
                  style: const TextStyle(fontSize: 16)),
              Text('Email: ${user.phone}',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ManageUser(
                        user: user,
                        autoImplyLeading: true,
                      ),
                    ),
                  );
                },
                child: const Text('Manage Users'),
              ),
              // Add more details specific to practitioners
            ],
          ),
        ),
      ),
    );
  }
}
