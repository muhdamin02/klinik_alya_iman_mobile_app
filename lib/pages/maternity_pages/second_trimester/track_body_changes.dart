import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/body_changes.dart';
import '../../../models/profile.dart';
import '../../../models/user.dart';
import '../../../services/database_service.dart';
import '../../../services/misc_methods/datetime_display.dart';
import '../second_trimester.dart';

// ignore: must_be_immutable
class TrackBodyChanges extends StatefulWidget {
  User user;
  Profile profile;
  bool autoImplyLeading;
  int initialIndex;

  TrackBodyChanges({
    Key? key,
    required this.user,
    required this.profile,
    required this.autoImplyLeading,
    required this.initialIndex,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TrackBodyChangesState createState() => _TrackBodyChangesState();
}

class _TrackBodyChangesState extends State<TrackBodyChanges> {
  List<BodyChanges> _weightChangesList = [];
  List<BodyChanges> _bellyChangesList = [];
  double _profileWeight = 0;
  double _profileBellySize = 0;

  @override
  void initState() {
    super.initState();
    _fetchWeightChangesList();
    _fetchBellyChangesList();
    _fetchProfileInfo();
  }

  // Future<void> _fetchBodyChangesList() async {
  //   List<BodyChanges> bodyChangesList = await DatabaseService()
  //       .retrieveBodyChanges(widget.user.user_id!, widget.profile.profile_id);

  //   bodyChangesList.sort((a, b) => b.datetime.compareTo(a.datetime));

  //   setState(() {
  //     _bodyChangesList = bodyChangesList;
  //   });
  // }

  Future<void> _fetchWeightChangesList() async {
    List<BodyChanges> weightChangesList = await DatabaseService()
        .retrieveBodyChanges(
            widget.user.user_id!, widget.profile.profile_id, 0);

    weightChangesList.sort((a, b) => b.datetime.compareTo(a.datetime));

    setState(() {
      _weightChangesList = weightChangesList;
    });
  }

  Future<void> _fetchBellyChangesList() async {
    List<BodyChanges> bellyChangesList = await DatabaseService()
        .retrieveBodyChanges(
            widget.user.user_id!, widget.profile.profile_id, 1);

    bellyChangesList.sort((a, b) => b.datetime.compareTo(a.datetime));

    setState(() {
      _bellyChangesList = bellyChangesList;
    });
  }

  Future<void> _fetchProfileInfo() async {
    double profileWeight = await DatabaseService()
        .retrieveProfileWeight(widget.profile.profile_id);

    double profileBellySize = await DatabaseService()
        .retrieveProfileBellySize(widget.profile.profile_id);

    setState(() {
      _profileWeight = profileWeight;
      _profileBellySize = profileBellySize;
    });
  }

  void _showWeightInputDialog(BuildContext context) {
    TextEditingController weightController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF303E8F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: const Text("Enter Weight"),
          content: TextField(
            controller: weightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Weight in kilograms',
              hintStyle: TextStyle(color: Color(0xFFB6CBFF)),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Submit",
                  style: TextStyle(color: Color(0xFFEDF2FF))),
              onPressed: () {
                String enteredWeight = weightController.text;
                double weight = double.parse(enteredWeight);
                _saveChanges(0, weight);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Cancel",
                  style: TextStyle(color: Color(0xFFEDF2FF))),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showBellySizeInputDialog(BuildContext context) {
    TextEditingController bellySizeController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF303E8F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: const Text("Enter Belly Size"),
          content: TextField(
            controller: bellySizeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                hintText: 'Circumference in centimetres',
                hintStyle: TextStyle(color: Color(0xFFB6CBFF))),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Submit",
                  style: TextStyle(color: Color(0xFFEDF2FF))),
              onPressed: () {
                String enteredBellySize = bellySizeController.text;
                double bellySize = double.parse(enteredBellySize);
                _saveChanges(1, bellySize);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Cancel",
                  style: TextStyle(color: Color(0xFFEDF2FF))),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _saveChanges(int choice, double changedValue) async {
    BodyChanges bodyChanges;
    int initialIndexByChoice;
    int increasedBool = 2;

    if (choice == 0) {
      initialIndexByChoice = 0;
      if (changedValue - _profileWeight > 0) {
        increasedBool = 1;
      }
      if (changedValue - _profileWeight < 0) {
        increasedBool = 0;
      }
      if (changedValue - _profileWeight == 0) {
        increasedBool = 2;
      }
      bodyChanges = BodyChanges(
        body_changes: '{$_profileWeight}kg updated to ${changedValue}kg.',
        weightbelly: 0,
        increased: increasedBool,
        p_body_weight: _profileWeight,
        p_belly_size: _profileBellySize,
        c_body_weight: changedValue,
        c_belly_size: _profileBellySize,
        datetime: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        user_id: widget.user.user_id!,
        profile_id: widget.profile.profile_id,
      );
      await DatabaseService()
          .setWeight(widget.profile.profile_id, changedValue);
    } else {
      initialIndexByChoice = 1;
      if (changedValue - _profileBellySize > 0) {
        increasedBool = 1;
      }
      if (changedValue - _profileBellySize < 0) {
        increasedBool = 0;
      }
      if (changedValue - _profileBellySize == 0) {
        increasedBool = 2;
      }
      bodyChanges = BodyChanges(
        body_changes: '${_profileBellySize}cm updated to ${changedValue}cm.',
        weightbelly: 1,
        increased: increasedBool,
        p_body_weight: _profileWeight,
        p_belly_size: _profileBellySize,
        c_body_weight: _profileWeight,
        c_belly_size: changedValue,
        datetime: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        user_id: widget.user.user_id!,
        profile_id: widget.profile.profile_id,
      );
      await DatabaseService()
          .setBellySize(widget.profile.profile_id, changedValue);
    }

    try {
      // Insert the appointment into the database
      await DatabaseService().newBodyChanges(bodyChanges);

      await _fetchWeightChangesList();
      await _fetchBellyChangesList();
      await _fetchProfileInfo();

      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TrackBodyChanges(
            user: widget.user,
            profile: widget.profile,
            autoImplyLeading: true,
            initialIndex: initialIndexByChoice,
          ),
        ),
      );

      // // ignore: use_build_context_synchronously
      // showDialog(
      //   context: context,
      //   builder: (context) => AlertDialog(
      //     title: const Text('Success'),
      //     content: const Text('Form submitted successfully!'),
      //     actions: <Widget>[
      //       TextButton(
      //         child: const Text('OK'),
      //         onPressed: () {
      //           Navigator.of(context).pop();
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) => TrackBodyChanges(
      //                 user: widget.user,
      //                 profile: widget.profile,
      //                 autoImplyLeading: true,
      //                 initialIndex: initialIndexByChoice,
      //               ),
      //             ),
      //           );
      //         },
      //       ),
      //     ],
      //   ),
      // );
    } catch (error) {
      // Handle any errors that occur during the database operation
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('An error occurred: $error'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
      // }
    }
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
          title: const Text('Track Body Changes'),
          automaticallyImplyLeading: widget.autoImplyLeading,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Navigate to a specific page when the back button is pressed
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => SecondTrimester(
                          user: widget.user,
                          profile: widget.profile,
                          autoImplyLeading: false,
                        )),
              );
            },
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0), // Add your desired padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 150.0,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              _showWeightInputDialog(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(
                                  0xFF3848A1), // Background color of the ElevatedButton
                              elevation: 0, // Set the elevation for the button
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20.0), // Adjust the radius
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.scale, // Use any icon you want
                                  color: Color(0xFFB6CBFF),
                                  size: 32,
                                ),
                                const SizedBox(
                                    height:
                                        8), // Adjust the spacing between icon and text
                                const Text(
                                  'WEIGHT',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFB6CBFF),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  '$_profileWeight kg',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFEDF2FF),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SizedBox(
                          height: 150.0,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              _showBellySizeInputDialog(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(
                                  0xFF3848A1), // Background color of the ElevatedButton
                              elevation: 0, // Set the elevation for the button
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20.0), // Adjust the radius
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.pregnant_woman, // Use any icon you want
                                  color: Color(0xFFB6CBFF),
                                  size: 32,
                                ),
                                const SizedBox(
                                    height:
                                        8), // Adjust the spacing between icon and text
                                const Text(
                                  'BELLY SIZE',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFB6CBFF),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  '$_profileBellySize cm',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFEDF2FF),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            Expanded(
              child: TabBarBodyChanges(
                weightChangesListing: _weightChangesList,
                bellyChangesListing: _bellyChangesList,
                initialIndex: widget.initialIndex,
                // onViewAppointment: _viewAppointment
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TabBarBodyChanges extends StatelessWidget {
  final List<BodyChanges> weightChangesListing;
  final List<BodyChanges> bellyChangesListing;
  final int initialIndex;

  const TabBarBodyChanges({
    Key? key,
    required this.weightChangesListing,
    required this.bellyChangesListing,
    required this.initialIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: initialIndex,
      length: 2,
      child: Scaffold(
        body: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF0A0F2C),
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
                indicatorColor: Color(0xFFB6CBFF),
                indicatorWeight: 6,
                tabs: <Widget>[
                  Tab(
                    text: 'Weight',
                  ),
                  Tab(text: 'Belly Size'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  _buildWeightChangesList(weightChangesListing),
                  _buildBellyChangesList(bellyChangesListing),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeightChangesList(List<BodyChanges> weightChangesList) {
    return ListView.builder(
      itemCount: weightChangesList.length,
      itemBuilder: (context, index) {
        BodyChanges weightChanges = weightChangesList[index];
        return Column(
          children: [
            if (index == 0) const SizedBox(height: 8.0),
            const SizedBox(height: 4.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(25.0), // Adjust the radius
                ),
                elevation: 0, // Set the elevation for the card
                color: const Color(0xFF303E8F),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListTile(
                    title: Text(weightChanges.body_changes),
                    // '${symptoms.symptom_name} - ${DateDisplay(date: symptoms.symptom_entry_date).getStringDate()}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4.0),
                        Text(
                            '${DateTimeDisplay(datetime: weightChanges.datetime).getStringDate()} - ${DateTimeDisplay(datetime: weightChanges.datetime).getStringTime()}',
                            style: const TextStyle(color: Color(0xFFB6CBFF))),
                      ],
                    ),
                    trailing: Icon(getIconForIncreased(weightChanges.increased),
                        color:
                            getIconColorForIncreased(weightChanges.increased)),
                  ),
                ),
              ),
            ),

            if (index == weightChangesList.length - 1)
              const SizedBox(height: 77.0), // Add SizedBox after the last item
          ],
        );
      },
    );
  }

  Widget _buildBellyChangesList(List<BodyChanges> bellyChangesList) {
    return ListView.builder(
      itemCount: bellyChangesList.length,
      itemBuilder: (context, index) {
        BodyChanges bellyChanges = bellyChangesList[index];
        return Column(
          children: [
            if (index == 0) const SizedBox(height: 8.0),
            const SizedBox(height: 4.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(25.0), // Adjust the radius
                ),
                elevation: 0, // Set the elevation for the card
                color: const Color(0xFF303E8F),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListTile(
                    title: Text(bellyChanges.body_changes),
                    // '${symptoms.symptom_name} - ${DateDisplay(date: symptoms.symptom_entry_date).getStringDate()}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4.0),
                        Text(
                            '${DateTimeDisplay(datetime: bellyChanges.datetime).getStringDate()} - ${DateTimeDisplay(datetime: bellyChanges.datetime).getStringTime()}',
                            style: const TextStyle(color: Color(0xFFB6CBFF))),
                      ],
                    ),
                    trailing: Icon(getIconForIncreased(bellyChanges.increased),
                        color:
                            getIconColorForIncreased(bellyChanges.increased)),
                  ),
                ),
              ),
            ),

            if (index == bellyChangesList.length - 1)
              const SizedBox(height: 77.0), // Add SizedBox after the last item
          ],
        );
      },
    );
  }
}

IconData getIconForIncreased(int increased) {
  switch (increased) {
    case 0:
      return Icons.trending_down_rounded;
    case 1:
      return Icons.trending_up_rounded;
    case 2:
      return Icons.trending_flat_rounded;
    default:
      return Icons.help;
  }
}

Color getIconColorForIncreased(int increased) {
  switch (increased) {
    case 0:
      return const Color(0xFFD47171);
    case 1:
      return const Color(0xFF6FC276);
    case 2:
      return const Color(0xFFFFD271);
    default:
      return const Color(0xFFFFD271);
  }
}
