import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:klinik_alya_iman_mobile_app/pages/maternity_pages/third_trimester/track_contractions.dart';

import '../../../app_drawer/app_drawer_all_pages.dart';
import '../../../models/contractions.dart';
import '../../../models/profile.dart';
import '../../../models/user.dart';
import '../../../services/database_service.dart';

class ContractionsList extends StatefulWidget {
  final User user;
  final Profile profile;
  final bool autoImplyLeading;

  const ContractionsList({
    Key? key,
    required this.user,
    required this.profile,
    required this.autoImplyLeading,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ContractionsListState createState() => _ContractionsListState();
}

class _ContractionsListState extends State<ContractionsList> {
  List<Contraction> _contractionList = [];
  // List<EducationalResources> _educationResourcesList = [];

  @override
  void initState() {
    super.initState();
    _fetchContractionList();
    // _fetchEducationResourcesList();
  }

  Future<void> _fetchContractionList() async {
    List<Contraction> contractionList = await DatabaseService()
        .retrieveContraction(widget.user.user_id!, widget.profile.profile_id);

    setState(() {
      _contractionList = contractionList;
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
          title: const Text('Contractions'),
          automaticallyImplyLeading: widget.autoImplyLeading,
        ),
        drawer: AppDrawerAllPages(
          header: 'Contractions',
          user: widget.user,
          profile: widget.profile,
          autoImplyLeading: true,
        ),
        body: TabBarContraction(
          contractionListing: _contractionList,
          contractionListing2: _contractionList,
          // onViewAppointment: _viewAppointment
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TrackContractions(
                  user: widget.user,
                  profile: widget.profile,
                  autoImplyLeading: true,
                ),
              ),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text('Track Contraction'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}

class TabBarContraction extends StatelessWidget {
  final List<Contraction> contractionListing;
  final List<Contraction> contractionListing2;
  // final Function(Symptoms) onViewAppointment;

  const TabBarContraction({
    Key? key,
    required this.contractionListing,
    required this.contractionListing2,
    // required this.onViewAppointment
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        body: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 74, 142, 230),
              ),
              child: const TabBar(
                labelStyle: TextStyle(
                  // Set your desired text style for the selected (active) tab here
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  fontFamily: 'ProductSans',
                  // You can set other text style properties as needed
                ),
                unselectedLabelStyle: TextStyle(
                  // Set your desired text style for the unselected tabs here
                  fontSize: 16,
                  fontFamily: 'ProductSans',
                  // You can set other text style properties as needed
                ),
                indicatorColor: Color.fromARGB(255, 37, 101, 184),
                indicatorWeight: 6,
                tabs: <Widget>[
                  Tab(
                    text: 'Contractions List',
                  ),
                  Tab(
                    text: 'Contractions List 2',
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  _buildContractionList(contractionListing),
                  _buildContractionList(contractionListing2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContractionList(List<Contraction> contractionList) {
    return ListView.builder(
      itemCount: contractionList.length,
      itemBuilder: (context, index) {
        Contraction contraction = contractionList[index];
        return Column(
          children: [
            const SizedBox(height: 12.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GestureDetector(
                onTap: () {
                  // onViewAppointment(appointment);
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(25.0), // Adjust the radius
                  ),
                  elevation: 8, // Set the elevation for the card
                  color: const Color.fromARGB(255, 238, 238, 238),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListTile(
                      title: Text(
                          '${_formatDateTime(contraction.contraction_datetime)} - ${_getContractionLabel(contraction.contraction_rating)}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4.0),
                          Text(
                              'Duration: ${_formatDuration(contraction.contraction_duration)}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.visibility),
                            onPressed: () {
                              // onViewAppointment(appointment);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (index == contractionList.length - 1)
              const SizedBox(height: 77.0), // Add SizedBox after the last item
          ],
        );
      },
    );
  }
}

String _getContractionLabel(int rating) {
  switch (rating) {
    case 1:
      return 'Minimal';
    case 2:
      return 'Mild';
    case 3:
      return 'Moderate';
    case 4:
      return 'Strong';
    case 5:
      return 'Severe';
    default:
      return 'Unknown';
  }
}

String _formatDateTime(String dateTimeString) {
  final dateTime = DateTime.parse(dateTimeString);
  final formattedDate =
      DateFormat.yMMMMd().format(dateTime); // Formats date like '5 May 2024'
  final formattedTime =
      DateFormat.jm().format(dateTime); // Formats time like '10:00 PM'
  return '$formattedDate, $formattedTime';
}

String _formatDuration(int durationInSeconds) {
  final Duration duration = Duration(seconds: durationInSeconds);
  final minutes = duration.inMinutes;
  final seconds = durationInSeconds % 60;

  if (minutes == 0) {
    return '$seconds seconds';
  } else if (seconds == 0) {
    return '$minutes minutes';
  } else {
    return '$minutes minutes and $seconds seconds';
  }
}
