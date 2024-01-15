import 'package:flutter/material.dart';
import 'package:klinik_alya_iman_mobile_app/pages/medical_history/create_new_med_history_entry.dart';

import '../../app_drawer/app_drawer_all_pages.dart';
import '../../models/medical_history.dart';
import '../../models/profile.dart';
import '../../models/user.dart';
import '../../services/database_service.dart';

class ListMedicalHistory extends StatefulWidget {
  final User user;
  final Profile profile;
  final bool autoImplyLeading;

  const ListMedicalHistory(
      {Key? key,
      required this.user,
      required this.profile,
      required this.autoImplyLeading})
      : super(key: key);

  @override
  _ListMedicalHistoryState createState() => _ListMedicalHistoryState();
}

class _ListMedicalHistoryState extends State<ListMedicalHistory> {
  List<MedicalHistory> _medicalHistory = [];

  @override
  void initState() {
    super.initState();
    _fetchMedicalHistory();
  }

  // ----------------------------------------------------------------------
  // View medicalHistory

  Future<void> _fetchMedicalHistory() async {
    List<MedicalHistory> medicalHistory = await DatabaseService()
        .retrieveMedHistory(widget.user.user_id!, widget.profile.profile_id);
    setState(() {
      _medicalHistory = medicalHistory;
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
        drawer: AppDrawerAllPages(
          header: 'Medical History',
          user: widget.user,
          profile: widget.profile,
          autoImplyLeading: true,
        ),
        body: Stack(
          children: [
            ListView.builder(
              itemCount: _medicalHistory.length,
              itemBuilder: (context, index) {
                MedicalHistory medicalHistory = _medicalHistory[index];
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
                            title: Text(medicalHistory.title),
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
                                    medicalHistory.body,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(medicalHistory.datetime_posted),
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
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Navigate to the page where you want to appointment form
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateNewMedHistoryEntry(
                  user: widget.user,
                  profile: widget.profile,
                ),
              ),
            );
          },
          icon: const Icon(Icons.create),
          label: const Text('Create New Entry'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
