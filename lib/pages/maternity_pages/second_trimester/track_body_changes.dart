import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/body_changes.dart';
import '../../../models/profile.dart';
import '../../../models/user.dart';
import '../../../services/database_service.dart';

// ignore: must_be_immutable
class TrackBodyChanges extends StatefulWidget {
  User user;
  Profile profile;
  bool autoImplyLeading;

  TrackBodyChanges({
    Key? key,
    required this.user,
    required this.profile,
    required this.autoImplyLeading,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TrackBodyChangesState createState() => _TrackBodyChangesState();
}

class _TrackBodyChangesState extends State<TrackBodyChanges> {
  List<BodyChanges> _bodyChangesList = [];
  double _profileWeight = 0;
  double _profileBellySize = 0;

  @override
  void initState() {
    super.initState();
    _fetchBodyChangesList();
    _fetchProfileInfo();
  }

  Future<void> _fetchBodyChangesList() async {
    List<BodyChanges> bodyChangesList = await DatabaseService()
        .retrieveBodyChanges(widget.user.user_id!, widget.profile.profile_id);

    bodyChangesList.sort((a, b) => b.datetime.compareTo(a.datetime));

    setState(() {
      _bodyChangesList = bodyChangesList;
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
          title: const Text("Enter Weight"),
          content: TextField(
            controller: weightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Enter weight in kilograms',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Submit"),
              onPressed: () {
                String enteredWeight = weightController.text;
                double weight = double.parse(enteredWeight);
                _saveChanges(0, weight);
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
          title: const Text("Enter Belly Size"),
          content: TextField(
            controller: bellySizeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Enter belly size (circumference) in centimetres',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Submit"),
              onPressed: () {
                String enteredBellySize = bellySizeController.text;
                double bellySize = double.parse(enteredBellySize);
                _saveChanges(1, bellySize);
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

    if (choice == 0) {
      bodyChanges = BodyChanges(
        body_changes:
            'Weight updated. ${_profileWeight}kg to ${changedValue}kg.',
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
      bodyChanges = BodyChanges(
        body_changes:
            'Belly size updated. ${_profileBellySize}cm to ${changedValue}cm.',
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

      await _fetchBodyChangesList();
      await _fetchProfileInfo();

      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Form submitted successfully!'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TrackBodyChanges(
                      user: widget.user,
                      profile: widget.profile,
                      autoImplyLeading: true,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
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
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0), // Add your desired padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Track Body Changes',
                style: TextStyle(fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 90.0,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _showWeightInputDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                              255, 233, 243, 255), // Set the text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                32.0), // Adjust the value as needed
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.scale, // Use any icon you want
                              color: Color.fromARGB(255, 37, 101, 184),
                              size: 32,
                            ),
                            const SizedBox(
                                height:
                                    8), // Adjust the spacing between icon and text
                            Text(
                              'Weight: $_profileWeight kg',
                              style: const TextStyle(
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
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 90.0,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _showBellySizeInputDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                              255, 233, 243, 255), // Set the text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                32.0), // Adjust the value as needed
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.pregnant_woman, // Use any icon you want
                              color: Color.fromARGB(255, 37, 101, 184),
                              size: 32,
                            ),
                            const SizedBox(
                                height:
                                    8), // Adjust the spacing between icon and text
                            Text(
                              'Belly Size: $_profileBellySize cm',
                              style: const TextStyle(
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
              const SizedBox(height: 32),
              Expanded(
                child: TabBarBodyChanges(
                  bodyChangesListing: _bodyChangesList,
                  // onViewAppointment: _viewAppointment
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TabBarBodyChanges extends StatelessWidget {
  final List<BodyChanges> bodyChangesListing;

  const TabBarBodyChanges({
    Key? key,
    required this.bodyChangesListing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 1,
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
                    text: 'Body Changes History',
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  _buildBodyChangesList(bodyChangesListing),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyChangesList(List<BodyChanges> bodyChangesList) {
    return ListView.builder(
      itemCount: bodyChangesList.length,
      itemBuilder: (context, index) {
        BodyChanges bodyChanges = bodyChangesList[index];
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
                      title: Text(bodyChanges.body_changes),
                      // '${symptoms.symptom_name} - ${DateDisplay(date: symptoms.symptom_entry_date).getStringDate()}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4.0),
                          Text(bodyChanges.datetime),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (index == bodyChangesList.length - 1)
              const SizedBox(height: 77.0), // Add SizedBox after the last item
          ],
        );
      },
    );
  }
}
