import 'package:flutter/material.dart';
import 'package:klinik_alya_iman_mobile_app/models/user.dart';
import 'package:klinik_alya_iman_mobile_app/pages/profile_management/first_profile.dart';
import 'package:klinik_alya_iman_mobile_app/pages/profile_management/list_profile.dart';
import 'package:klinik_alya_iman_mobile_app/services/database_service.dart';

class Home extends StatelessWidget {
  final User user;

  const Home({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: DatabaseService().getProfileCount(user.user_id ?? 0),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Data is still loading
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Error while fetching data
          return Text('Error: ${snapshot.error}');
        } else {
          // Data has been successfully loaded
          int profileCount = snapshot.data!;

          // Decide which page to navigate based on the profile count
          if (profileCount > 0) {
            return ListProfile(userId: user.user_id ?? 0);
          } else {
            return FirstProfile(
              user: user,
            );
          }
        }
      },
    );
  }
}
