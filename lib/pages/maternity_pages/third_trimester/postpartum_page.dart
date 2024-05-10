import 'package:flutter/material.dart';

import '../../../models/postpartum.dart';
import '../../../models/profile.dart';
import '../../../models/user.dart';
import '../../../services/database_service.dart';

class PostpartumPage extends StatefulWidget {
  final User user;
  final Profile profile;
  final int category;
  final bool autoImplyLeading;

  const PostpartumPage(
      {Key? key,
      required this.user,
      required this.profile,
      required this.category,
      required this.autoImplyLeading})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PostpartumPageState createState() => _PostpartumPageState();
}

class _PostpartumPageState extends State<PostpartumPage> {
  List<Postpartum> _postpartumContent = [];

  @override
  void initState() {
    super.initState();
    _fetchPostpartumContent();
  }

  // ----------------------------------------------------------------------
  // View contents

  Future<void> _fetchPostpartumContent() async {
    List<Postpartum> postpartumContent = await DatabaseService()
        .retrievePostpartumContent(widget.category);
    setState(() {
      _postpartumContent = postpartumContent;
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
              itemCount: _postpartumContent.length,
              itemBuilder: (context, index) {
                Postpartum postpartumContent = _postpartumContent[index];
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
                              title: Text(postpartumContent.postpartum_title,
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
                                      postpartumContent.postpartum_content,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(postpartumContent.last_edited),
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
