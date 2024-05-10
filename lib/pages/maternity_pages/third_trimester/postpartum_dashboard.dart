import 'package:flutter/material.dart';

import '../../../models/profile.dart';
import '../../../models/user.dart';
import 'newborn_care_page.dart';
import 'postpartum_page.dart';

// ignore: must_be_immutable
class PostpartumDashboard extends StatefulWidget {
  User user;
  Profile profile;
  bool autoImplyLeading;

  PostpartumDashboard({
    Key? key,
    required this.user,
    required this.profile,
    required this.autoImplyLeading,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PostpartumDashboardState createState() => _PostpartumDashboardState();
}

class _PostpartumDashboardState extends State<PostpartumDashboard> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return false to prevent the user from navigating back
        return widget.autoImplyLeading;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Postpartum Resources'),
          automaticallyImplyLeading: widget.autoImplyLeading,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0), // Add your desired padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Postpartum Resources',
                style: TextStyle(fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 120.0,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostpartumPage(
                                user: widget.user,
                                profile: widget.profile,
                                autoImplyLeading: true,
                                category: 1,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                              255, 233, 243, 255), // Set the text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                32.0), // Adjust the value as needed
                          ),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.info, // Use any icon you want
                              color: Color.fromARGB(255, 37, 101, 184),
                              size: 32,
                            ),
                            SizedBox(
                                height:
                                    8), // Adjust the spacing between icon and text
                            Text(
                              'Basic Care Information',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 37, 101, 184),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 120.0,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostpartumPage(
                                user: widget.user,
                                profile: widget.profile,
                                autoImplyLeading: true,
                                category: 2,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                              255, 233, 243, 255), // Set the text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                32.0), // Adjust the value as needed
                          ),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.medical_services, // Use any icon you want
                              color: Color.fromARGB(255, 37, 101, 184),
                              size: 32,
                            ),
                            SizedBox(
                                height:
                                    8), // Adjust the spacing between icon and text
                            Text(
                              'Health and Safety',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 37, 101, 184),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 120.0,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostpartumPage(
                                user: widget.user,
                                profile: widget.profile,
                                autoImplyLeading: true,
                                category: 3,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                              255, 233, 243, 255), // Set the text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                32.0), // Adjust the value as needed
                          ),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.timeline, // Use any icon you want
                              color: Color.fromARGB(255, 37, 101, 184),
                              size: 32,
                            ),
                            SizedBox(
                                height:
                                    8), // Adjust the spacing between icon and text
                            Text(
                              'Developmental Milestones',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 37, 101, 184),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 120.0,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostpartumPage(
                                user: widget.user,
                                profile: widget.profile,
                                autoImplyLeading: true,
                                category: 4,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                              255, 233, 243, 255), // Set the text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                32.0), // Adjust the value as needed
                          ),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.lightbulb_outline, // Use any icon you want
                              color: Color.fromARGB(255, 37, 101, 184),
                              size: 32,
                            ),
                            SizedBox(
                                height:
                                    8), // Adjust the spacing between icon and text
                            Text(
                              'Practical Tips and Advice',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 37, 101, 184),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 120.0,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostpartumPage(
                                user: widget.user,
                                profile: widget.profile,
                                autoImplyLeading: true,
                                category: 5,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                              255, 233, 243, 255), // Set the text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                32.0), // Adjust the value as needed
                          ),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.warning, // Use any icon you want
                              color: Color.fromARGB(255, 37, 101, 184),
                              size: 32,
                            ),
                            SizedBox(
                                height:
                                    8), // Adjust the spacing between icon and text
                            Text(
                              'Emergency Preparedness',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 37, 101, 184),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 120.0,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostpartumPage(
                                user: widget.user,
                                profile: widget.profile,
                                autoImplyLeading: true,
                                category: 6,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                              255, 233, 243, 255), // Set the text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                32.0), // Adjust the value as needed
                          ),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.build, // Use any icon you want
                              color: Color.fromARGB(255, 37, 101, 184),
                              size: 32,
                            ),
                            SizedBox(
                                height:
                                    8), // Adjust the spacing between icon and text
                            Text(
                              'Miscellaneous Resources',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 37, 101, 184),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
