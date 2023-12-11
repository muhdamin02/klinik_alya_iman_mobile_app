import 'package:flutter/material.dart';

import '../pages/profile_management/list_profile.dart';
import '../pages/startup/login.dart';


class AlyaImanAppBarUser extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final int? userId;
  final bool autoImplyLeading;

  const AlyaImanAppBarUser({
    Key? key,
    required this.title,
    required this.userId,
    required this.autoImplyLeading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(title),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        automaticallyImplyLeading: autoImplyLeading,
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'profile',
                  child: ListTile(
                    leading: Icon(Icons.list),
                    title: Text('Profiles'),
                  ),
                ),
                const PopupMenuItem(
                  value: 'logout',
                  child: ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Logout'),
                  ),
                ),
              ];
            },
            onSelected: (value) {
              if (value == 'profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListProfile(
                      userId: userId!,
                    ),
                  ),
                );
              }
              else if (value == 'logout') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Login(),
                  ),
                );
              }
            },
          ),
        ]);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
