import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/profile.dart';
import '../../../models/user.dart';
import '../../appointment_management/list_appointment.dart';
import '../../medication_management/list_medication.dart';
import '../../profile_management/profile_page.dart';
import '../../startup/patient_homepage.dart';
import '../first_trimester.dart';
import '../third_trimester.dart';

class NewbornCare extends StatefulWidget {
  final User user;
  final Profile profile;
  final bool autoImplyLeading;

  const NewbornCare({
    Key? key,
    required this.user,
    required this.profile,
    required this.autoImplyLeading,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NewbornCareState createState() => _NewbornCareState();
}

class _NewbornCareState extends State<NewbornCare>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return false to prevent the user from navigating back
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Newborn Care'),
          automaticallyImplyLeading: false,
          elevation: 0,
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
                    icon: const Icon(Icons.looks_3),
                    iconSize: 25,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ThirdTrimester(
                            user: widget.user,
                            profile: widget.profile,
                            autoImplyLeading: false,
                          ),
                        ),
                      );
                    },
                    color: const Color(0xFFFFD271), // Set the color of the icon
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 24.0),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: TabPageSelector(
                controller: _tabController,
                selectedColor: const Color(0xFFEDF2FF),
                color: const Color(0xFF303E8F),
                indicatorSize:
                    10, // Adjust the color of unselected dots as needed
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  BasicCareInformation(),
                  HealthAndSafety(),
                  DevelopmentalMilestones(),
                  PracticalTipsAndAdvice(),
                  EmergencyPreparedness(),
                  MiscellaneousResources(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BasicCareInformation extends StatelessWidget {
  const BasicCareInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8.0),
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                gradient: const LinearGradient(
                  colors: [Color(0xFFB6CBFF), Color(0xFF4D5FC0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  margin: const EdgeInsets.all(
                      3.0), // The width of the gradient border
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: const DecorationImage(
                      image: AssetImage(
                          'assets/educational_resources/vitaminnutrition.jpg'), // Replace with your image path
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32.0),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 0),
              child: const Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Color(0xFFB6CBFF),
                      height: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Basic Care Information',
                      style: TextStyle(
                          color: Color(0xFFEDF2FF),
                          letterSpacing: 2,
                          fontSize: 18),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Color(0xFFB6CBFF),
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Pregnancy requires you to take extra care of your nutrition to support your baby\'s development and your well-being. Learn about essential nutrients, healthy eating plans, and how to deal with food aversions.',
              style:
                  TextStyle(fontSize: 18, height: 2, color: Color(0xFFC5D6FF)),
            ),
            const SizedBox(height: 42),
            SizedBox(
              height: 70.0,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const EssentialNutrients(),
                  //   ),
                  // );
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFDBE5FF), // Set the fill color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        25.0), // Adjust the value as needed
                  ),
                  side: const BorderSide(
                    color: Color(0xFF6086f6), // Set the outline color
                    width: 2.5, // Set the outline width
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(
                        Icons.dinner_dining,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                    Spacer(), // Adjust the spacing between icon and text
                    Text(
                      'Essential Nutrients',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F3299),
                        letterSpacing: 1.2,
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(
                        Icons.dinner_dining,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 70.0,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const HealthyDiet(),
                  //   ),
                  // );
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFC4D6FF), // Set the fill color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        25.0), // Adjust the value as needed
                  ),
                  side: const BorderSide(
                    color: Color(0xFF6086f6), // Set the outline color
                    width: 2.5, // Set the outline width
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(
                        Icons.local_dining,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                    Spacer(), // Adjust the spacing between icon and text
                    Text(
                      'Healthy Diet',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F3299),
                        letterSpacing: 1.2,
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(
                        Icons.local_dining,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HealthAndSafety extends StatelessWidget {
  const HealthAndSafety({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8.0),
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                gradient: const LinearGradient(
                  colors: [Color(0xFFB6CBFF), Color(0xFF4D5FC0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  margin: const EdgeInsets.all(
                      3.0), // The width of the gradient border
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: const DecorationImage(
                      image: AssetImage(
                          'assets/educational_resources/vitaminnutrition.jpg'), // Replace with your image path
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32.0),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 0),
              child: const Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Color(0xFFB6CBFF),
                      height: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Basic Care Information',
                      style: TextStyle(
                          color: Color(0xFFEDF2FF),
                          letterSpacing: 2,
                          fontSize: 18),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Color(0xFFB6CBFF),
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Pregnancy requires you to take extra care of your nutrition to support your baby\'s development and your well-being. Learn about essential nutrients, healthy eating plans, and how to deal with food aversions.',
              style:
                  TextStyle(fontSize: 18, height: 2, color: Color(0xFFC5D6FF)),
            ),
            const SizedBox(height: 42),
            SizedBox(
              height: 70.0,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const EssentialNutrients(),
                  //   ),
                  // );
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFDBE5FF), // Set the fill color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        25.0), // Adjust the value as needed
                  ),
                  side: const BorderSide(
                    color: Color(0xFF6086f6), // Set the outline color
                    width: 2.5, // Set the outline width
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(
                        Icons.dinner_dining,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                    Spacer(), // Adjust the spacing between icon and text
                    Text(
                      'Essential Nutrients',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F3299),
                        letterSpacing: 1.2,
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(
                        Icons.dinner_dining,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 70.0,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const HealthyDiet(),
                  //   ),
                  // );
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFC4D6FF), // Set the fill color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        25.0), // Adjust the value as needed
                  ),
                  side: const BorderSide(
                    color: Color(0xFF6086f6), // Set the outline color
                    width: 2.5, // Set the outline width
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(
                        Icons.local_dining,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                    Spacer(), // Adjust the spacing between icon and text
                    Text(
                      'Healthy Diet',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F3299),
                        letterSpacing: 1.2,
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(
                        Icons.local_dining,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DevelopmentalMilestones extends StatelessWidget {
  const DevelopmentalMilestones({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8.0),
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                gradient: const LinearGradient(
                  colors: [Color(0xFFB6CBFF), Color(0xFF4D5FC0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  margin: const EdgeInsets.all(
                      3.0), // The width of the gradient border
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: const DecorationImage(
                      image: AssetImage(
                          'assets/educational_resources/vitaminnutrition.jpg'), // Replace with your image path
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32.0),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 0),
              child: const Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Color(0xFFB6CBFF),
                      height: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Basic Care Information',
                      style: TextStyle(
                          color: Color(0xFFEDF2FF),
                          letterSpacing: 2,
                          fontSize: 18),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Color(0xFFB6CBFF),
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Pregnancy requires you to take extra care of your nutrition to support your baby\'s development and your well-being. Learn about essential nutrients, healthy eating plans, and how to deal with food aversions.',
              style:
                  TextStyle(fontSize: 18, height: 2, color: Color(0xFFC5D6FF)),
            ),
            const SizedBox(height: 42),
            SizedBox(
              height: 70.0,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const EssentialNutrients(),
                  //   ),
                  // );
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFDBE5FF), // Set the fill color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        25.0), // Adjust the value as needed
                  ),
                  side: const BorderSide(
                    color: Color(0xFF6086f6), // Set the outline color
                    width: 2.5, // Set the outline width
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(
                        Icons.dinner_dining,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                    Spacer(), // Adjust the spacing between icon and text
                    Text(
                      'Essential Nutrients',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F3299),
                        letterSpacing: 1.2,
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(
                        Icons.dinner_dining,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 70.0,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const HealthyDiet(),
                  //   ),
                  // );
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFC4D6FF), // Set the fill color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        25.0), // Adjust the value as needed
                  ),
                  side: const BorderSide(
                    color: Color(0xFF6086f6), // Set the outline color
                    width: 2.5, // Set the outline width
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(
                        Icons.local_dining,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                    Spacer(), // Adjust the spacing between icon and text
                    Text(
                      'Healthy Diet',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F3299),
                        letterSpacing: 1.2,
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(
                        Icons.local_dining,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PracticalTipsAndAdvice extends StatelessWidget {
  const PracticalTipsAndAdvice({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8.0),
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                gradient: const LinearGradient(
                  colors: [Color(0xFFB6CBFF), Color(0xFF4D5FC0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  margin: const EdgeInsets.all(
                      3.0), // The width of the gradient border
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: const DecorationImage(
                      image: AssetImage(
                          'assets/educational_resources/vitaminnutrition.jpg'), // Replace with your image path
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32.0),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 0),
              child: const Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Color(0xFFB6CBFF),
                      height: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Basic Care Information',
                      style: TextStyle(
                          color: Color(0xFFEDF2FF),
                          letterSpacing: 2,
                          fontSize: 18),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Color(0xFFB6CBFF),
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Pregnancy requires you to take extra care of your nutrition to support your baby\'s development and your well-being. Learn about essential nutrients, healthy eating plans, and how to deal with food aversions.',
              style:
                  TextStyle(fontSize: 18, height: 2, color: Color(0xFFC5D6FF)),
            ),
            const SizedBox(height: 42),
            SizedBox(
              height: 70.0,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const EssentialNutrients(),
                  //   ),
                  // );
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFDBE5FF), // Set the fill color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        25.0), // Adjust the value as needed
                  ),
                  side: const BorderSide(
                    color: Color(0xFF6086f6), // Set the outline color
                    width: 2.5, // Set the outline width
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(
                        Icons.dinner_dining,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                    Spacer(), // Adjust the spacing between icon and text
                    Text(
                      'Essential Nutrients',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F3299),
                        letterSpacing: 1.2,
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(
                        Icons.dinner_dining,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 70.0,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const HealthyDiet(),
                  //   ),
                  // );
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFC4D6FF), // Set the fill color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        25.0), // Adjust the value as needed
                  ),
                  side: const BorderSide(
                    color: Color(0xFF6086f6), // Set the outline color
                    width: 2.5, // Set the outline width
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(
                        Icons.local_dining,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                    Spacer(), // Adjust the spacing between icon and text
                    Text(
                      'Healthy Diet',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F3299),
                        letterSpacing: 1.2,
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(
                        Icons.local_dining,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmergencyPreparedness extends StatelessWidget {
  const EmergencyPreparedness({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8.0),
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                gradient: const LinearGradient(
                  colors: [Color(0xFFB6CBFF), Color(0xFF4D5FC0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  margin: const EdgeInsets.all(
                      3.0), // The width of the gradient border
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: const DecorationImage(
                      image: AssetImage(
                          'assets/educational_resources/vitaminnutrition.jpg'), // Replace with your image path
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32.0),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 0),
              child: const Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Color(0xFFB6CBFF),
                      height: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Basic Care Information',
                      style: TextStyle(
                          color: Color(0xFFEDF2FF),
                          letterSpacing: 2,
                          fontSize: 18),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Color(0xFFB6CBFF),
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Pregnancy requires you to take extra care of your nutrition to support your baby\'s development and your well-being. Learn about essential nutrients, healthy eating plans, and how to deal with food aversions.',
              style:
                  TextStyle(fontSize: 18, height: 2, color: Color(0xFFC5D6FF)),
            ),
            const SizedBox(height: 42),
            SizedBox(
              height: 70.0,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const EssentialNutrients(),
                  //   ),
                  // );
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFDBE5FF), // Set the fill color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        25.0), // Adjust the value as needed
                  ),
                  side: const BorderSide(
                    color: Color(0xFF6086f6), // Set the outline color
                    width: 2.5, // Set the outline width
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(
                        Icons.dinner_dining,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                    Spacer(), // Adjust the spacing between icon and text
                    Text(
                      'Essential Nutrients',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F3299),
                        letterSpacing: 1.2,
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(
                        Icons.dinner_dining,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 70.0,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const HealthyDiet(),
                  //   ),
                  // );
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFC4D6FF), // Set the fill color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        25.0), // Adjust the value as needed
                  ),
                  side: const BorderSide(
                    color: Color(0xFF6086f6), // Set the outline color
                    width: 2.5, // Set the outline width
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(
                        Icons.local_dining,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                    Spacer(), // Adjust the spacing between icon and text
                    Text(
                      'Healthy Diet',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F3299),
                        letterSpacing: 1.2,
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(
                        Icons.local_dining,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MiscellaneousResources extends StatelessWidget {
  const MiscellaneousResources({super.key});

  Future<void> _launchURL(String urlString) async {
    final Uri uri = Uri.parse(urlString);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $urlString';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8.0),
          Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              gradient: const LinearGradient(
                colors: [Color(0xFFB6CBFF), Color(0xFF4D5FC0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                margin: const EdgeInsets.all(
                    3.0), // The width of the gradient border
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: const DecorationImage(
                    image: AssetImage(
                        'assets/educational_resources/symptomschanges.jpg'), // Replace with your image path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32.0),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 0),
            child: const Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Color(0xFFB6CBFF),
                    height: 1,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'Symptoms and Changes',
                    style: TextStyle(
                        color: Color(0xFFEDF2FF),
                        letterSpacing: 2,
                        fontSize: 18),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Color(0xFFB6CBFF),
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Pregnancy comes with various symptoms, some more challenging than others. Learn what to expect, how to cope with common discomforts, and when to seek medical advice.',
            style: TextStyle(fontSize: 18, height: 2, color: Color(0xFFC5D6FF)),
          ),
          const SizedBox(height: 42),
          SizedBox(
            height: 70.0,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const CommonSymptoms(),
                //   ),
                // );
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFFDBE5FF), // Set the fill color
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(25.0), // Adjust the value as needed
                ),
                side: const BorderSide(
                  color: Color(0xFF6086f6), // Set the outline color
                  width: 2.5, // Set the outline width
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Icon(
                      Icons.pregnant_woman,
                      color: Color(0xFF1F3299),
                      size: 28,
                    ),
                  ),
                  Spacer(), // Adjust the spacing between icon and text
                  Text(
                    'Common Symptoms',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F3299),
                      letterSpacing: 1.2,
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Icon(
                      Icons.pregnant_woman,
                      color: Color(0xFF1F3299),
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 60.0,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _launchURL(
                    'https://www.webmd.com/baby/first-trimester-of-pregnancy');
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFFC4D6FF), // Set the fill color
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(25.0), // Adjust the value as needed
                ),
                side: const BorderSide(
                  color: Color(0xFF6086f6), // Set the outline color
                  width: 2.5, // Set the outline width
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Icon(
                      Icons.open_in_new,
                      color: Color(0xFF1F3299),
                      size: 28,
                    ),
                  ),
                  Spacer(), // Adjust the spacing between icon and text
                  Text(
                    'Additional Reading',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F3299),
                      letterSpacing: 1.2,
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Icon(
                      Icons.open_in_new,
                      color: Color(0xFF1F3299),
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}