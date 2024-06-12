import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/profile.dart';
import '../../../models/user.dart';
import '../../appointment_management/list_appointment.dart';
import '../../medication_management/list_medication.dart';
import '../../profile_management/profile_page.dart';
import '../../startup/patient_homepage.dart';
import '../third_trimester.dart';
import 'newborn_care/basic_care_information/bathing.dart';
import 'newborn_care/basic_care_information/clothing.dart';
import 'newborn_care/basic_care_information/diapering.dart';
import 'newborn_care/basic_care_information/feeding.dart';
import 'newborn_care/basic_care_information/sleeping.dart';
import 'newborn_care/developmental_milestones/cognitive_dev.dart';
import 'newborn_care/developmental_milestones/language_dev.dart';
import 'newborn_care/developmental_milestones/physical_dev.dart';
import 'newborn_care/developmental_milestones/socioemo_dev.dart';
import 'newborn_care/developmental_milestones/track_milestones.dart';
import 'newborn_care/emergency_preparedness/emergency_contacts.dart';
import 'newborn_care/emergency_preparedness/emergency_supplies.dart';
import 'newborn_care/emergency_preparedness/first_aid.dart';
import 'newborn_care/emergency_preparedness/hospital_visits.dart';
import 'newborn_care/health_and_safety/babyproofing.dart';
import 'newborn_care/health_and_safety/common_illness.dart';
import 'newborn_care/health_and_safety/doctor_visits.dart';
import 'newborn_care/health_and_safety/sids.dart';
import 'newborn_care/health_and_safety/vaccinations.dart';
import 'newborn_care/practical_tips/parenting_support.dart';
import 'newborn_care/practical_tips/self_care.dart';
import 'newborn_care/practical_tips/soothing.dart';
import 'newborn_care/practical_tips/traveling.dart';
import 'newborn_care/practical_tips/work_life_balance.dart';

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
    _tabController = TabController(length: 5, vsync: this);
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
              height: 200,
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
                          'assets/newborn_care/basic_care.jpg'), // Replace with your image path
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
              'This section provides essential guidance on caring for your newborn, covering key areas such as feeding, diapering, bathing, sleeping, and dressing. Learn breastfeeding techniques, formula feeding guidelines, safe diaper changing practices, and how to create a safe sleep environment.',
              style:
                  TextStyle(fontSize: 18, height: 2, color: Color(0xFFC5D6FF)),
            ),
            const SizedBox(height: 42),
            SizedBox(
              height: 70.0,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Feeding(),
                    ),
                  );
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
                        Icons.restaurant,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                    Spacer(), // Adjust the spacing between icon and text
                    Text(
                      'Feeding',
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
                        Icons.restaurant,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Diapering(),
                    ),
                  );
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
                        Icons.baby_changing_station,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                    Spacer(), // Adjust the spacing between icon and text
                    Text(
                      'Diapering',
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
                        Icons.baby_changing_station,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Bathing(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFB9CEFF), // Set the fill color
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
                        Icons.bathtub,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                    Spacer(), // Adjust the spacing between icon and text
                    Text(
                      'Bathing',
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
                        Icons.bathtub,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Sleeping(),
                    ),
                  );
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
                        Icons.bedtime,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                    Spacer(), // Adjust the spacing between icon and text
                    Text(
                      'Sleeping',
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
                        Icons.bedtime,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Clothing(),
                    ),
                  );
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
                        Icons.checkroom,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                    Spacer(), // Adjust the spacing between icon and text
                    Text(
                      'Clothing',
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
                        Icons.checkroom,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
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
              height: 200,
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
                          'assets/newborn_care/health_safety.jpg'), // Replace with your image path
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
                      'Health and Safety',
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
              'Ensure your newborn\'s health and safety with information on vaccinations, recognizing common illnesses, and creating a safe home environment. Understand the importance of regular doctor visits and how to reduce the risk of Sudden Infant Death Syndrome (SIDS).',
              style:
                  TextStyle(fontSize: 18, height: 2, color: Color(0xFFC5D6FF)),
            ),
            const SizedBox(height: 42),
            SizedBox(
              height: 70.0,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Vaccination(),
                    ),
                  );
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
                        Icons.vaccines,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                    Spacer(), // Adjust the spacing between icon and text
                    Text(
                      'Vaccination',
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
                        Icons.vaccines,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CommonIllness(),
                    ),
                  );
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
                        Icons.sick,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                    Spacer(), // Adjust the spacing between icon and text
                    Text(
                      'Common Illness',
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
                        Icons.sick,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SIDS(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFB9CEFF), // Set the fill color
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
                        Icons.shield_outlined,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                    Spacer(), // Adjust the spacing between icon and text
                    Text(
                      'SIDS Prevention',
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
                        Icons.shield_outlined,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Babyproofing(),
                    ),
                  );
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
                        Icons.security,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                    Spacer(), // Adjust the spacing between icon and text
                    Text(
                      'Babyproofing',
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
                        Icons.security,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DoctorVisits(),
                    ),
                  );
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
                        Icons.local_hospital,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                    Spacer(), // Adjust the spacing between icon and text
                    Text(
                      'Doctor Visits',
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
                        Icons.local_hospital,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
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
              height: 200,
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
                          'assets/newborn_care/development.jpg'), // Replace with your image path
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
                      'Developmental Milestones',
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
              'Track your baby\'s growth and development with insights into physical, cognitive, social, emotional, and language milestones. Utilize tools and resources to monitor and support your baby\'s progress.',
              style:
                  TextStyle(fontSize: 18, height: 2, color: Color(0xFFC5D6FF)),
            ),
            const SizedBox(height: 42),
            SizedBox(
              height: 70.0,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PhysicalDev(),
                    ),
                  );
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
                        Icons.directions_run,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                    Spacer(), // Adjust the spacing between icon and text
                    Text(
                      'Physical Development',
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
                        Icons.directions_run,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CognitiveDev(),
                    ),
                  );
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
                        Icons.lightbulb_outline,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                    Spacer(), // Adjust the spacing between icon and text
                    Text(
                      'Cognitive Development',
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
                        Icons.lightbulb_outline,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SocioEmoDev(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFB9CEFF), // Set the fill color
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
                        Icons.sentiment_satisfied,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                    Spacer(), // Adjust the spacing between icon and text
                    Text(
                      'Social and Emotional\nDevelopment',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F3299),
                        letterSpacing: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(
                        Icons.sentiment_satisfied,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LanguageDev(),
                    ),
                  );
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
                        Icons.record_voice_over,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                    Spacer(), // Adjust the spacing between icon and text
                    Text(
                      'Language Development',
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
                        Icons.record_voice_over,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TrackMilestones(),
                    ),
                  );
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
                        Icons.timeline,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                    Spacer(), // Adjust the spacing between icon and text
                    Text(
                      'Tracking Milestones',
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
                        Icons.timeline,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
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
              height: 200,
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
                          'assets/newborn_care/tips.jpg'), // Replace with your image path
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
                      'Practical Tips and Advice',
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
              'Get practical advice for everyday parenting challenges, including traveling with your newborn, calming a fussy baby, balancing work and parenting, and maintaining self-care.',
              style:
                  TextStyle(fontSize: 18, height: 2, color: Color(0xFFC5D6FF)),
            ),
            const SizedBox(height: 42),
            SizedBox(
              height: 70.0,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Traveling(),
                    ),
                  );
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
                        Icons.directions_car,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                    Spacer(), // Adjust the spacing between icon and text
                    Text(
                      'Traveling with Newborn',
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
                        Icons.directions_car,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Soothing(),
                    ),
                  );
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
                        Icons.music_note,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                    Spacer(), // Adjust the spacing between icon and text
                    Text(
                      'Soothing Techniques',
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
                        Icons.music_note,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ParentingSupport(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFB9CEFF), // Set the fill color
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
                        Icons.group,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                    Spacer(), // Adjust the spacing between icon and text
                    Text(
                      'Parenting Support',
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
                        Icons.group,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WorkLifeBalance(),
                    ),
                  );
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
                        Icons.balance,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                    Spacer(), // Adjust the spacing between icon and text
                    Text(
                      'Work-Life Balance',
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
                        Icons.balance,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SelfCare(),
                    ),
                  );
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
                        Icons.self_improvement,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                    Spacer(), // Adjust the spacing between icon and text
                    Text(
                      'Self-Care',
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
                        Icons.self_improvement,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
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
              height: 200,
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
                          'assets/newborn_care/prepared.jpg'), // Replace with your image path
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
                      'Emergency Preparedness',
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
              'Be prepared for emergencies with essential information on emergency contacts, first aid, emergency supplies, and disaster preparedness. Learn what to pack for hospital visits and how to handle urgent situations.',
              style:
                  TextStyle(fontSize: 18, height: 2, color: Color(0xFFC5D6FF)),
            ),
            const SizedBox(height: 42),
            SizedBox(
              height: 70.0,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EmergencyContacts(),
                    ),
                  );
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
                        Icons.contact_phone,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                    Spacer(), // Adjust the spacing between icon and text
                    Text(
                      'Emergency Contacts',
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
                        Icons.contact_phone,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FirstAid(),
                    ),
                  );
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
                        Icons.medical_services,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                    Spacer(), // Adjust the spacing between icon and text
                    Text(
                      'First Aid',
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
                        Icons.medical_services,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EmergencySupplies(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFB9CEFF), // Set the fill color
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
                        Icons.health_and_safety,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                    Spacer(), // Adjust the spacing between icon and text
                    Text(
                      'Emergency Supplies',
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
                        Icons.health_and_safety,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HospitalVisits(),
                    ),
                  );
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
                        Icons.local_hospital,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                    Spacer(), // Adjust the spacing between icon and text
                    Text(
                      'Hospital Visits',
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
                        Icons.local_hospital,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
