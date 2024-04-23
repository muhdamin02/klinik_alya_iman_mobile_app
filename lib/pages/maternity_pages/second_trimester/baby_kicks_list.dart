import 'package:flutter/material.dart';

import '../../../models/baby_kicks.dart';
import '../../../models/profile.dart';
import '../../../models/user.dart';
import '../../../services/database_service.dart';
import 'baby_kicks_counter.dart';

class BabyKicksList extends StatefulWidget {
  final User user;
  final Profile profile;
  final bool autoImplyLeading;

  const BabyKicksList({
    Key? key,
    required this.user,
    required this.profile,
    required this.autoImplyLeading,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BabyKicksListState createState() => _BabyKicksListState();
}

class _BabyKicksListState extends State<BabyKicksList> {
  List<BabyKicks> _babyKicksList = [];
  // List<EducationalResources> _educationResourcesList = [];

  @override
  void initState() {
    super.initState();
    _fetchBabyKicksList();
    // _fetchEducationResourcesList();
  }

  Future<void> _fetchBabyKicksList() async {
    List<BabyKicks> babyKicksList = await DatabaseService()
        .retrieveBabyKicks(widget.user.user_id!, widget.profile.profile_id);

    setState(() {
      _babyKicksList = babyKicksList;
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
          title: const Text('Sec Trimester'),
          automaticallyImplyLeading: widget.autoImplyLeading,
        ),
        body: TabBarBabyKicks(
          babyKicksListing: _babyKicksList,
          babyKicksListing2: _babyKicksList,
          // onViewAppointment: _viewAppointment
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BabyKickCounter(
                  user: widget.user,
                  profile: widget.profile,
                  autoImplyLeading: true,
                ),
              ),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text('Count Baby Kicks'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}

class TabBarBabyKicks extends StatelessWidget {
  final List<BabyKicks> babyKicksListing;
  final List<BabyKicks> babyKicksListing2;
  // final Function(Symptoms) onViewAppointment;

  const TabBarBabyKicks({
    Key? key,
    required this.babyKicksListing,
    required this.babyKicksListing2,
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
                    text: 'Baby Kicks List',
                  ),
                  Tab(
                    text: 'Baby Kicks List 2',
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  _buildBabyKicksList(babyKicksListing),
                  _buildBabyKicksList(babyKicksListing2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBabyKicksList(List<BabyKicks> babyKicksList) {
    return ListView.builder(
      itemCount: babyKicksList.length,
      itemBuilder: (context, index) {
        BabyKicks babyKicks = babyKicksList[index];
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
                          '${babyKicks.kick_datetime} - ${babyKicks.kick_count}'),
                      // '${symptoms.symptom_name} - ${DateDisplay(date: symptoms.symptom_entry_date).getStringDate()}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4.0),
                          Text('${babyKicks.kick_count}'),
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
            if (index == babyKicksList.length - 1)
              const SizedBox(height: 77.0), // Add SizedBox after the last item
          ],
        );
      },
    );
  }
}
