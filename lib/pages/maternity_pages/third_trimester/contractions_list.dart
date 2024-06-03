import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:klinik_alya_iman_mobile_app/pages/maternity_pages/third_trimester/track_contractions.dart';

import '../../../app_drawer/app_drawer_all_pages.dart';
import '../../../models/contractions.dart';
import '../../../models/profile.dart';
import '../../../models/user.dart';
import '../../../services/database_service.dart';
import '../../../services/misc_methods/datetime_display.dart';
import '../../../services/misc_methods/format_duration.dart';
import '../../appointment_management/list_appointment.dart';
import '../../medication_management/list_medication.dart';
import '../../profile_management/profile_page.dart';
import '../../startup/patient_homepage.dart';
import '../maternity_overview.dart';

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
      _contractionList = contractionList.reversed.toList();
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
        bottomNavigationBar: SizedBox(
          height: 56.0, // Adjust the height as needed
          child: BottomAppBar(
            color: const Color(
                0xFF0A0F2C), // Set the background color of the BottomAppBar
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.person),
                    iconSize: 25,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(
                            user: widget.user,
                            profile: widget.profile,
                            autoImplyLeading: false,
                          ),
                        ),
                      );
                    },
                    color: const Color(0xFFEDF2FF), // Set the color of the icon
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.event),
                    iconSize: 22,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListAppointment(
                            user: widget.user,
                            profile: widget.profile,
                            autoImplyLeading: false,
                            initialTab: 1,
                          ),
                        ),
                      );
                    },
                    color: const Color(0xFFEDF2FF), // Set the color of the icon
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.home),
                    iconSize: 25,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PatientHomepage(
                            user: widget.user,
                            profile: widget.profile,
                            hasProfiles: true,
                            hasChosenProfile: true,
                            autoImplyLeading: false,
                          ),
                        ),
                      );
                    },
                    color: const Color(0xFFEDF2FF), // Set the color of the icon
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.medication),
                    iconSize: 25,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListMedication(
                            user: widget.user,
                            profile: widget.profile,
                            autoImplyLeading: false,
                          ),
                        ),
                      );
                    },
                    color: const Color(0xFFEDF2FF), // Set the color of the icon
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.pregnant_woman),
                    iconSize: 23,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MaternityOverview(
                            user: widget.user,
                            profile: widget.profile,
                            autoImplyLeading: false,
                          ),
                        ),
                      );
                    },
                    color: const Color(0xFFEDF2FF), // Set the color of the icon
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            if (_contractionList.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Spacer(),
                    Center(
                      child: Text(
                        'You have not tracked any contractions.',
                        style:
                            TextStyle(fontSize: 18.0, color: Color(0xFFB6CBFF)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 56.0),
                    Spacer(),
                  ],
                ),
              ),
            ListView.builder(
              itemCount: _contractionList.length,
              itemBuilder: (context, index) {
                Contraction contraction = _contractionList[index];
                return Column(
                  children: [
                    if (index == 0) const SizedBox(height: 8),
                    const SizedBox(height: 4.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GestureDetector(
                        onTap: () {
                          // onViewAppointment(appointment);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          elevation: 0,
                          color: const Color(0xFF303E8F),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 20.0),
                            child: ListTile(
                              title: Text(
                                  _getContractionLabel(
                                      contraction.contraction_rating),
                                  style: const TextStyle(
                                      color: Color(0xFFFFD271),
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1,
                                      fontSize: 18)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 6.0),
                                  Text(
                                      'Duration: ${formatDuration(contraction.contraction_duration)}'),
                                  const SizedBox(height: 12.0),
                                  Text(
                                    '${DateTimeDisplay(datetime: contraction.contraction_datetime).getStringDate()} - ${DateTimeDisplay(datetime: contraction.contraction_datetime).getStringTime()}',
                                    style: const TextStyle(
                                        color: Color(0xFFB6CBFF)),
                                  ),
                                ],
                              ),
                              trailing: Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, right: 5),
                                child: Text(
                                  '${contraction.contraction_rating}',
                                  style: const TextStyle(
                                      color: Color(0xFFFFD271),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 32),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (index == _contractionList.length - 1)
                      const SizedBox(
                          height: 77.0), // Add SizedBox after the last item
                  ],
                );
              },
            ),
          ],
          // onViewAppointment: _viewAppointment
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: const Color(0xFFC1D3FF), // Set background color here
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25), // Adjust the border radius
            side: const BorderSide(
                width: 2.5,
                color: Color(0xFF6086f6)), // Set the outline color here
          ),
          foregroundColor: const Color(0xFF1F3299),
          elevation: 0,
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
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  elevation: 0,
                  color: const Color(0xFF303E8F),
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
