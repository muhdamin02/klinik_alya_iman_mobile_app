import 'package:flutter/material.dart';
import 'package:klinik_alya_iman_mobile_app/models/newborn_care.dart';

import '../../../models/profile.dart';
import '../../../models/user.dart';
import '../../../services/database_service.dart';

class NewbornCarePage extends StatefulWidget {
  final User user;
  final Profile profile;
  final int category;
  final bool autoImplyLeading;

  const NewbornCarePage(
      {Key? key,
      required this.user,
      required this.profile,
      required this.category,
      required this.autoImplyLeading})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NewbornCarePageState createState() => _NewbornCarePageState();
}

class _NewbornCarePageState extends State<NewbornCarePage> {
  List<NewbornCare> _newbornCareContent = [];

  @override
  void initState() {
    super.initState();
    _fetchNewbornCareContent();
  }

  // ----------------------------------------------------------------------
  // View contents

  Future<void> _fetchNewbornCareContent() async {
    List<NewbornCare> newbornCareContent = await DatabaseService()
        .retrieveNewbornCareContent(widget.category);
    setState(() {
      _newbornCareContent = newbornCareContent;
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
          title: const Text('Medical History'),
        ),
        body: Stack(
          children: [
            ListView.builder(
              itemCount: _newbornCareContent.length,
              itemBuilder: (context, index) {
                NewbornCare newbornCareContent = _newbornCareContent[index];
                return Column(
                  children: [
                    const SizedBox(height: 16.0),
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
                              title: Text(newbornCareContent.care_title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500)),
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
                                      newbornCareContent.care_content,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(newbornCareContent.last_edited),
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
