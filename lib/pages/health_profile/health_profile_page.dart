// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klinik_alya_iman_mobile_app/pages/medical_history/list_medical_history.dart';

import '../../models/health_profile.dart';
import '../../models/profile.dart';
import '../../models/user.dart';
import '../../services/database_service.dart';
import '../../services/misc_methods/notification_singleton.dart';
import '../../services/notification_service.dart';
import '../appointment_management/list_appointment.dart';
import '../medication_management/list_medication.dart';
import '../profile_management/profile_page.dart';
import '../startup/login.dart';
import '../startup/patient_homepage.dart';

class HealthProfilePage extends StatefulWidget {
  final User user;
  final Profile profile;
  final bool autoImplyLeading;
  final bool initialTabOthers;

  const HealthProfilePage(
      {Key? key,
      required this.user,
      required this.profile,
      required this.autoImplyLeading,
      required this.initialTabOthers})
      : super(key: key);

  @override
  _HealthProfilePageState createState() => _HealthProfilePageState();
}

class _HealthProfilePageState extends State<HealthProfilePage> {
  List<Profile> _profileInfo = [];
  List<HealthProfile> _healthInfo = [];
  // double _bmi = 0;
  bool viewMore = false;
  bool viewLess = true;
  int initialTab = 0;

  @override
  void initState() {
    super.initState();
    _fetchHealthInfo();
    if (widget.initialTabOthers) {
      initialTab = 2;
    }
  }

  // ----------------------------------------------------------------------
  // Fetch details

  Future<void> _fetchHealthInfo() async {
    List<Profile> profileInfo =
        await DatabaseService().profileInfo(widget.profile.profile_id);
    setState(() {
      _profileInfo = profileInfo;
    });

    List<HealthProfile> healthInfo =
        await DatabaseService().healthInfo(widget.profile.profile_id);
    setState(() {
      _healthInfo = healthInfo;
    });
  }

  void _editProfile(String element, Profile profile) async {
    switch (element) {
      case 'height':
        TextEditingController heightController = TextEditingController();
        final int? profileId = profile.profile_id;
        double height;
        final GlobalKey<FormState> formKey = GlobalKey<FormState>();

        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: const Color(0xFF303E8F),
              title: const Text('Update Height'),
              content: Builder(
                builder: (BuildContext context) {
                  return Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: heightController,
                          decoration: const InputDecoration(
                            hintText: 'Enter height...',
                            hintStyle: TextStyle(color: Color(0xFFB6CBFF)),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(
                                      0xFFB6CBFF)), // Set the color of the underline
                            ),
                          ),
                          style: const TextStyle(fontSize: 15),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9.]')),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter height.';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      height = double.parse(heightController.text);
                      await DatabaseService().editHeight(profileId!, height);
                      Navigator.pop(context); // Close the dialog
                      setState(() {
                        _fetchHealthInfo();
                      });
                    }
                  },
                  child: const Text('Confirm',
                      style: TextStyle(color: Color(0xFFEDF2FF))),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('Cancel',
                      style: TextStyle(color: Color(0xFFEDF2FF))),
                ),
              ],
            );
          },
          barrierDismissible: false,
        );
        break;
      case 'weight':
        TextEditingController weightController = TextEditingController();
        final int? profileId = profile.profile_id;
        double height;
        final GlobalKey<FormState> formKey = GlobalKey<FormState>();

        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: const Color(0xFF303E8F),
              title: const Text('Update Weight'),
              content: Builder(
                builder: (BuildContext context) {
                  return Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: weightController,
                          decoration: const InputDecoration(
                            hintText: 'Enter weight...',
                            hintStyle: TextStyle(color: Color(0xFFB6CBFF)),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(
                                      0xFFB6CBFF)), // Set the color of the underline
                            ),
                          ),
                          style: const TextStyle(fontSize: 15),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9.]')),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter height.';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      height = double.parse(weightController.text);
                      await DatabaseService().editWeight(profileId!, height);
                      Navigator.pop(context); // Close the dialog
                      setState(() {
                        _fetchHealthInfo();
                      });
                    }
                  },
                  child: const Text('Confirm',
                      style: TextStyle(color: Color(0xFFEDF2FF))),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('Cancel',
                      style: TextStyle(color: Color(0xFFEDF2FF))),
                ),
              ],
            );
          },
          barrierDismissible: false,
        );
        break;
      case 'bfp':
        TextEditingController bfpController = TextEditingController();
        final int? profileId = profile.profile_id;
        double bfp;
        final GlobalKey<FormState> formKey = GlobalKey<FormState>();

        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: const Color(0xFF303E8F),
              title: const Text('Update Body Fat Percentage'),
              content: Builder(
                builder: (BuildContext context) {
                  return Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: bfpController,
                          decoration: const InputDecoration(
                            hintText: 'Enter body fat percentage...',
                            hintStyle: TextStyle(color: Color(0xFFB6CBFF)),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(
                                      0xFFB6CBFF)), // Set the color of the underline
                            ),
                          ),
                          style: const TextStyle(fontSize: 15),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9.]')),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter body fat percentage.';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      bfp = double.parse(bfpController.text);
                      await DatabaseService().editBFP(profileId!, bfp);
                      Navigator.pop(context); // Close the dialog
                      setState(() {
                        _fetchHealthInfo();
                      });
                    }
                  },
                  child: const Text('Confirm',
                      style: TextStyle(color: Color(0xFFEDF2FF))),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('Cancel',
                      style: TextStyle(color: Color(0xFFEDF2FF))),
                ),
              ],
            );
          },
          barrierDismissible: false,
        );
        break;
      case 'activity_level':
        await showDialog(
          context: context,
          builder: (context) => ActivityLevelDialog(
              fetchHealthInfo: _fetchHealthInfo, profileId: profile.profile_id),
        );
        break;
      default:
        return;
    }
  }

  void _editHealth(String element, HealthProfile health) async {
    switch (element) {
      case 'bsl':
        TextEditingController bslController = TextEditingController();
        final int? id = health.health_profile_id;
        double bsl;
        final GlobalKey<FormState> formKey = GlobalKey<FormState>();

        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: const Color(0xFF303E8F),
              title: const Text('Update Blood Sugar Level'),
              content: Builder(
                builder: (BuildContext context) {
                  return Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: bslController,
                          decoration: const InputDecoration(
                            hintText: 'Enter blood sugar level...',
                            hintStyle: TextStyle(color: Color(0xFFB6CBFF)),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(
                                      0xFFB6CBFF)), // Set the color of the underline
                            ),
                          ),
                          style: const TextStyle(fontSize: 15),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9.]')),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter blood sugar level.';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      bsl = double.parse(bslController.text);
                      await DatabaseService().editBSL(id!, bsl);
                      Navigator.pop(context); // Close the dialog
                      setState(() {
                        _fetchHealthInfo();
                      });
                    }
                  },
                  child: const Text('Confirm',
                      style: TextStyle(color: Color(0xFFEDF2FF))),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('Cancel',
                      style: TextStyle(color: Color(0xFFEDF2FF))),
                ),
              ],
            );
          },
          barrierDismissible: false,
        );
        break;
      case 'bp':
        TextEditingController systolicController = TextEditingController();
        TextEditingController diastolicController = TextEditingController();
        final int? id = health.health_profile_id;
        String bp;
        final GlobalKey<FormState> formKey = GlobalKey<FormState>();

        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: const Color(0xFF303E8F),
              title: const Text('Update Blood Pressure'),
              content: Builder(
                builder: (BuildContext context) {
                  return Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                width: double.infinity,
                                child: TextFormField(
                                  controller: systolicController,
                                  decoration: const InputDecoration(
                                    hintText: 'Systolic',
                                    hintStyle:
                                        TextStyle(color: Color(0xFFB6CBFF)),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(
                                              0xFFB6CBFF)), // Set the color of the underline
                                    ),
                                  ),
                                  style: const TextStyle(fontSize: 15),
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please fill.';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text('/')),
                            Expanded(
                              child: SizedBox(
                                width: double.infinity,
                                child: TextFormField(
                                  controller: diastolicController,
                                  decoration: const InputDecoration(
                                    hintText: 'Diastolic',
                                    hintStyle:
                                        TextStyle(color: Color(0xFFB6CBFF)),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(
                                              0xFFB6CBFF)), // Set the color of the underline
                                    ),
                                  ),
                                  style: const TextStyle(fontSize: 15),
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please fill.';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      bp =
                          '${systolicController.text} / ${diastolicController.text}';
                      await DatabaseService().editBP(id!, bp);
                      Navigator.pop(context); // Close the dialog
                      setState(() {
                        _fetchHealthInfo();
                      });
                    }
                  },
                  child: const Text('Confirm',
                      style: TextStyle(color: Color(0xFFEDF2FF))),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('Cancel',
                      style: TextStyle(color: Color(0xFFEDF2FF))),
                ),
              ],
            );
          },
          barrierDismissible: false,
        );
        break;
      case 'allergies':
        TextEditingController allergiesController = TextEditingController();
        final int? id = health.health_profile_id;
        String allergies;
        final GlobalKey<FormState> formKey = GlobalKey<FormState>();

        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: const Color(0xFF303E8F),
              title: const Text('Update Allergies'),
              content: Builder(
                builder: (BuildContext context) {
                  return Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: allergiesController,
                          decoration: const InputDecoration(
                            hintText: 'Enter allergies...',
                            hintStyle: TextStyle(color: Color(0xFFB6CBFF)),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(
                                      0xFFB6CBFF)), // Set the color of the underline
                            ),
                          ),
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  );
                },
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      allergies = allergiesController.text;
                      await DatabaseService().editAllergies(id!, allergies);
                      Navigator.pop(context); // Close the dialog
                      setState(() {
                        _fetchHealthInfo();
                      });
                    }
                  },
                  child: const Text('Confirm',
                      style: TextStyle(color: Color(0xFFEDF2FF))),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('Cancel',
                      style: TextStyle(color: Color(0xFFEDF2FF))),
                ),
              ],
            );
          },
          barrierDismissible: false,
        );
        break;
      case 'condition':
        TextEditingController conditionController = TextEditingController();
        final int? id = health.health_profile_id;
        String condition;
        final GlobalKey<FormState> formKey = GlobalKey<FormState>();

        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: const Color(0xFF303E8F),
              title: const Text('Update Medical Condition'),
              content: Builder(
                builder: (BuildContext context) {
                  return Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: conditionController,
                          decoration: const InputDecoration(
                            hintText: 'Enter medical condition...',
                            hintStyle: TextStyle(color: Color(0xFFB6CBFF)),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(
                                      0xFFB6CBFF)), // Set the color of the underline
                            ),
                          ),
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  );
                },
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      condition = conditionController.text;
                      await DatabaseService().editCondition(id!, condition);
                      Navigator.pop(context); // Close the dialog
                      setState(() {
                        _fetchHealthInfo();
                      });
                    }
                  },
                  child: const Text('Confirm',
                      style: TextStyle(color: Color(0xFFEDF2FF))),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('Cancel',
                      style: TextStyle(color: Color(0xFFEDF2FF))),
                ),
              ],
            );
          },
          barrierDismissible: false,
        );
        break;
      default:
        return;
    }
  }

  void _onOtherHealth(String element, User user, Profile profile) {
    switch (element) {
      case 'health_diary':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ListMedicalHistory(
                user: user, profile: profile, autoImplyLeading: true),
          ),
        );
      default:
        return;
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
          title: Text(_getFirstTwoWords(widget.profile.name)),
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Color(0xFFEDF2FF),
          ),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                // Show a dialog to confirm logout
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: const Color(0xFF303E8F),
                      title: const Text('Confirm Logout'),
                      content: const Text('Are you sure you want to log out?',
                          style: TextStyle(color: Color(0xFFEDF2FF))),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () async {
                            // Perform logout actions
                            NotificationCounter notificationCounter =
                                NotificationCounter();
                            notificationCounter.reset();
                            await NotificationService()
                                .cancelAllNotifications();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Login(
                                  usernamePlaceholder: widget.user.username,
                                  passwordPlaceholder: widget.user.password,
                                ),
                              ),
                            );
                          },
                          child: const Text('Yes',
                              style: TextStyle(color: Color(0xFFEDF2FF))),
                        ),
                        TextButton(
                          onPressed: () {
                            // Close the dialog
                            Navigator.of(context).pop();
                          },
                          child: const Text('No',
                              style: TextStyle(color: Color(0xFFEDF2FF))),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
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
                    icon: const Icon(Icons.health_and_safety_outlined),
                    iconSize: 28,
                    onPressed: () {},
                    color: const Color(0xFF5464BB), // Set the color of the icon
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            TabBarHealthProfile(
              user: widget.user,
              profile: widget.profile,
              profileInfo: _profileInfo,
              healthInfo: _healthInfo,
              onOtherHealth: _onOtherHealth,
              editProfile: _editProfile,
              editHealth: _editHealth,
              initialTabIndex: initialTab,
            ),
          ],
        ),
      ),
    );
  }
}

class TabBarHealthProfile extends StatelessWidget {
  final User user;
  final Profile profile;
  final List<Profile> profileInfo;
  final List<HealthProfile> healthInfo;
  final Function(String, User, Profile) onOtherHealth;
  final Function(String, Profile) editProfile;
  final Function(String, HealthProfile) editHealth;
  final int initialTabIndex;

  const TabBarHealthProfile({
    Key? key,
    required this.user,
    required this.profile,
    required this.profileInfo,
    required this.healthInfo,
    required this.onOtherHealth,
    required this.editProfile,
    required this.editHealth,
    required this.initialTabIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: initialTabIndex,
      length: 3,
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
                    text: 'General',
                  ),
                  Tab(
                    text: 'Medical',
                  ),
                  Tab(
                    text: 'Others',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  _buildGeneral(profileInfo),
                  _buildMedical(profile, healthInfo),
                  _buildOthers(user, profile),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneral(List<Profile> profileInfo) {
    String bmiRounded = '0.00';
    String activityLevel = 'Not specified';
    return ListView.builder(
      shrinkWrap: true,
      itemCount: profileInfo.length,
      itemBuilder: (context, index) {
        Profile profile = profileInfo[index];

        if (profile.weight > 0 && profile.height > 0) {
          double bmi = profile.weight /
              ((profile.height / 100) * (profile.height / 100));
          bmiRounded = bmi.toStringAsFixed(2);
        }

        if (profile.activity_level != '') {
          activityLevel = profile.activity_level;
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: double.infinity, // Adjust padding as needed
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ElevatedButton(
                          onPressed: () {
                            editProfile('height', profile);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                                0xFF303E8F), // Background color of the ElevatedButton
                            elevation: 0, // Set the elevation for the button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20.0), // Adjust the radius
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "HEIGHT",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Color(0xFFB6CBFF),
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            8), // Add some spacing between text and icon
                                    Icon(
                                      Icons.expand,
                                      color: Color(
                                          0xFFB6CBFF), // Set the color of the icon
                                      size:
                                          16, // Adjust the size of the icon as needed
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${profile.height} cm',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Color(0xFFEDF2FF),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: SizedBox(
                      width: double.infinity, // Adjust padding as needed
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ElevatedButton(
                          onPressed: () {
                            editProfile('weight', profile);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                                0xFF303E8F), // Background color of the ElevatedButton
                            elevation: 0, // Set the elevation for the button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20.0), // Adjust the radius
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "WEIGHT",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Color(0xFFB6CBFF),
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            8), // Add some spacing between text and icon
                                    Icon(
                                      Icons.scale,
                                      color: Color(
                                          0xFFB6CBFF), // Set the color of the icon
                                      size:
                                          16, // Adjust the size of the icon as needed
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${profile.weight} kg',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Color(0xFFEDF2FF),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: double.infinity, // Adjust padding as needed
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ElevatedButton(
                          onPressed: () {
                            editProfile('bfp', profile);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                                0xFF303E8F), // Background color of the ElevatedButton
                            elevation: 0, // Set the elevation for the button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20.0), // Adjust the radius
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "BFP",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Color(0xFFB6CBFF),
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            8), // Add some spacing between text and icon
                                    Icon(
                                      Icons.accessibility_new,
                                      color: Color(
                                          0xFFB6CBFF), // Set the color of the icon
                                      size:
                                          16, // Adjust the size of the icon as needed
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${profile.body_fat_percentage} %',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Color(0xFFEDF2FF),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: SizedBox(
                      width: double.infinity, // Adjust padding as needed
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                                0xFF303E8F), // Background color of the ElevatedButton
                            elevation: 0, // Set the elevation for the button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20.0), // Adjust the radius
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "BMI",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Color(0xFFB6CBFF),
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            8), // Add some spacing between text and icon
                                    Icon(
                                      Icons.monitor_weight,
                                      color: Color(
                                          0xFFB6CBFF), // Set the color of the icon
                                      size:
                                          16, // Adjust the size of the icon as needed
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  bmiRounded,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Color(0xFFEDF2FF),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity, // Adjust padding as needed
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ElevatedButton(
                    onPressed: () {
                      editProfile('activity_level', profile);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                          0xFF303E8F), // Background color of the ElevatedButton
                      elevation: 0, // Set the elevation for the button
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20.0), // Adjust the radius
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "ACTIVITY LEVEL",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Color(0xFFB6CBFF),
                                ),
                              ),
                              SizedBox(
                                  width:
                                      8), // Add some spacing between text and icon
                              Icon(
                                Icons.fitness_center,
                                color: Color(
                                    0xFFB6CBFF), // Set the color of the icon
                                size:
                                    16, // Adjust the size of the icon as needed
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            activityLevel,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color(0xFFEDF2FF),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 36),
            ]),
          ),
        );
      },
    );
  }

  Widget _buildMedical(profile, List<HealthProfile> healthInfo) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: healthInfo.length,
      itemBuilder: (context, index) {
        HealthProfile health = healthInfo[index];
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 8.0),
              SizedBox(
                width: double.infinity, // Adjust padding as needed
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ElevatedButton(
                    onPressed: () {
                      editHealth('bsl', health);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                          0xFF303E8F), // Background color of the ElevatedButton
                      elevation: 0, // Set the elevation for the button
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20.0), // Adjust the radius
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "BLOOD SUGAR LEVEL",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Color(0xFFB6CBFF),
                                ),
                              ),
                              SizedBox(
                                  width:
                                      8), // Add some spacing between text and icon
                              Icon(
                                Icons.bloodtype,
                                color: Color(
                                    0xFFB6CBFF), // Set the color of the icon
                                size:
                                    16, // Adjust the size of the icon as needed
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${health.blood_sugar_level} mmol/L',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color(0xFFEDF2FF),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity, // Adjust padding as needed
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ElevatedButton(
                    onPressed: () {
                      editHealth('bp', health);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                          0xFF303E8F), // Background color of the ElevatedButton
                      elevation: 0, // Set the elevation for the button
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20.0), // Adjust the radius
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "BLOOD PRESSURE",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Color(0xFFB6CBFF),
                                ),
                              ),
                              SizedBox(
                                  width:
                                      8), // Add some spacing between text and icon
                              Icon(
                                Icons.favorite,
                                color: Color(
                                    0xFFB6CBFF), // Set the color of the icon
                                size:
                                    16, // Adjust the size of the icon as needed
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${health.blood_pressure} mmHg',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color(0xFFEDF2FF),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity, // Adjust padding as needed
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ElevatedButton(
                    onPressed: () {
                      editHealth('allergies', health);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                          0xFF303E8F), // Background color of the ElevatedButton
                      elevation: 0, // Set the elevation for the button
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20.0), // Adjust the radius
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "ALLERGIES",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Color(0xFFB6CBFF),
                                ),
                              ),
                              SizedBox(
                                  width:
                                      8), // Add some spacing between text and icon
                              Icon(
                                Icons.warning_rounded,
                                color: Color(
                                    0xFFB6CBFF), // Set the color of the icon
                                size:
                                    16, // Adjust the size of the icon as needed
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            health.allergies,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color(0xFFEDF2FF),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity, // Adjust padding as needed
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ElevatedButton(
                    onPressed: () {
                      editHealth('condition', health);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                          0xFF303E8F), // Background color of the ElevatedButton
                      elevation: 0, // Set the elevation for the button
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20.0), // Adjust the radius
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "MEDICAL CONDITION",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Color(0xFFB6CBFF),
                                ),
                              ),
                              SizedBox(
                                  width:
                                      8), // Add some spacing between text and icon
                              Icon(
                                Icons.health_and_safety,
                                color: Color(
                                    0xFFB6CBFF), // Set the color of the icon
                                size:
                                    16, // Adjust the size of the icon as needed
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            health.current_condition,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color(0xFFEDF2FF),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 36),
              const SizedBox(height: 10),
            ]),
          ),
        );
      },
    );
  }

  Widget _buildOthers(User user, Profile profile) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 8.0),
          SizedBox(
            width: double.infinity, // Adjust padding as needed
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ElevatedButton(
                onPressed: () {
                  onOtherHealth('health_diary', user, profile);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                      0xFF303E8F), // Background color of the ElevatedButton
                  elevation: 0, // Set the elevation for the button
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20.0), // Adjust the radius
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(28.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Health Diary',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Color(0xFFEDF2FF),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity, // Adjust padding as needed
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ElevatedButton(
                onPressed: () {
                  onOtherHealth('surgeries', user, profile);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                      0xFF303E8F), // Background color of the ElevatedButton
                  elevation: 0, // Set the elevation for the button
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20.0), // Adjust the radius
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(28.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Surgeries and Procedures',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Color(0xFFEDF2FF),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity, // Adjust padding as needed
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ElevatedButton(
                onPressed: () {
                  onOtherHealth('family_med', user, profile);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                      0xFF303E8F), // Background color of the ElevatedButton
                  elevation: 0, // Set the elevation for the button
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20.0), // Adjust the radius
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(28.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Family Medical History',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Color(0xFFEDF2FF),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity, // Adjust padding as needed
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ElevatedButton(
                onPressed: () {
                  onOtherHealth('immunization', user, profile);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                      0xFF303E8F), // Background color of the ElevatedButton
                  elevation: 0, // Set the elevation for the button
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20.0), // Adjust the radius
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(28.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Immunization Records',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Color(0xFFEDF2FF),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity, // Adjust padding as needed
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ElevatedButton(
                onPressed: () {
                  onOtherHealth('diet', user, profile);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                      0xFF303E8F), // Background color of the ElevatedButton
                  elevation: 0, // Set the elevation for the button
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20.0), // Adjust the radius
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(28.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Dietary Restrictions',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Color(0xFFEDF2FF),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 36),
          const SizedBox(height: 10),
        ]),
      ),
    );
  }
}

// Function to get the first two words from a string
String _getFirstTwoWords(String fullName) {
  // Split the string into words
  List<String> words = fullName.split(' ');

  // Take the first two words and join them back into a string
  return words.take(2).join(' ');
}

class ActivityLevelDialog extends StatefulWidget {
  final Future<void> Function() fetchHealthInfo;
  final int? profileId;

  const ActivityLevelDialog({
    Key? key,
    required this.fetchHealthInfo,
    required this.profileId,
  }) : super(key: key);

  @override
  _ActivityLevelDialogState createState() => _ActivityLevelDialogState();
}

class _ActivityLevelDialogState extends State<ActivityLevelDialog> {
  double _currentSliderValue = 1;

  final List<String> _levelLabels = [
    'Least Active',
    'Slightly Active',
    'Moderately Active',
    'Very Active',
    'Most Active'
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF303E8F),
      title: const Text('Select Your Activity Level'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Text(_levelLabels[_currentSliderValue.toInt() - 1],
              style: const TextStyle(color: Color(0xFFFFD271), fontSize: 18)),
          const SizedBox(height: 8),
          Slider(
            value: _currentSliderValue,
            min: 1,
            max: 5,
            divisions: 4,
            label: _currentSliderValue.round().toString(),
            onChanged: (double value) {
              setState(() {
                _currentSliderValue = value;
              });
            },
            activeColor: const Color(0xFFFFD271),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            await DatabaseService().editActivityLevel(widget.profileId!,
                _levelLabels[_currentSliderValue.toInt() - 1]);
            Navigator.pop(context);
            setState(() {
              widget.fetchHealthInfo();
            });
          },
          child: const Text('OK', style: TextStyle(color: Color(0xFFEDF2FF))),
        ),
      ],
    );
  }
}
