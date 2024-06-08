import 'package:flutter/material.dart';

import '../../../models/profile.dart';
import '../../../models/user.dart';
import '../../appointment_management/list_appointment.dart';
import '../../medication_management/list_medication.dart';
import '../../profile_management/profile_page.dart';
import '../../startup/patient_homepage.dart';
import '../first_trimester.dart';

class EducationalResources extends StatefulWidget {
  final User user;
  final Profile profile;
  final bool autoImplyLeading;

  const EducationalResources({
    Key? key,
    required this.user,
    required this.profile,
    required this.autoImplyLeading,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EducationalResourcesState createState() => _EducationalResourcesState();
}

class _EducationalResourcesState extends State<EducationalResources>
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
          title: const Text('Educational Resources'),
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
                    icon: const Icon(Icons.looks_one),
                    iconSize: 25,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FirstTrimester(
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
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TabPageSelector(
                controller: _tabController,
                selectedColor: const Color(0xFFEDF2FF),
                color: const Color(
                    0xFF303E8F), // Adjust the color of unselected dots as needed
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  VitaminNutrition(),
                  PrenatalCare(),
                  SymptomsChanges(),
                  Vaccinations(),
                  MentalHealth(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VitaminNutrition extends StatelessWidget {
  const VitaminNutrition({super.key});

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
                          'assets/vitaminnutrition.jpg'), // Replace with your image path
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
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
                      'Vitamins and Nutritions',
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
              'Pregnancy requires you to take extra care of your nutrition to support your baby\'s development and your well-being. Learn about essential nutrients, healthy eating plans, and tips to manage morning sickness.',
              style:
                  TextStyle(fontSize: 18, height: 2, color: Color(0xFFC5D6FF)),
            ),
            const SizedBox(height: 42),
            SizedBox(
              height: 70.0,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  //
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
                        Icons.book_outlined,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                    Spacer(), // Adjust the spacing between icon and text
                    Text(
                      'Educational Resources',
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
                        Icons.book_outlined,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 70.0,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  //
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
                        Icons.book_outlined,
                        color: Color(0xFF1F3299),
                        size: 28,
                      ),
                    ),
                    Spacer(), // Adjust the spacing between icon and text
                    Text(
                      'Educational Resources',
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
                        Icons.book_outlined,
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

class PrenatalCare extends StatelessWidget {
  const PrenatalCare({super.key});

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
                        'assets/prenatalcare.jpg'), // Replace with your image path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24.0),
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
                    'Prenatal Care',
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
            'Regular prenatal check-ups are crucial for monitoring the health of you and your baby. Understand the importance of these visits and get an overview of the screenings and tests you\'ll encounter.',
            style: TextStyle(fontSize: 18, height: 2, color: Color(0xFFC5D6FF)),
          ),
          const SizedBox(height: 42),
          SizedBox(
            height: 70.0,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                //
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
                      Icons.book_outlined,
                      color: Color(0xFF1F3299),
                      size: 28,
                    ),
                  ),
                  Spacer(), // Adjust the spacing between icon and text
                  Text(
                    'Educational Resources',
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
                      Icons.book_outlined,
                      color: Color(0xFF1F3299),
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 70.0,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                //
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
                      Icons.book_outlined,
                      color: Color(0xFF1F3299),
                      size: 28,
                    ),
                  ),
                  Spacer(), // Adjust the spacing between icon and text
                  Text(
                    'Educational Resources',
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
                      Icons.book_outlined,
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

class SymptomsChanges extends StatelessWidget {
  const SymptomsChanges({super.key});

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
                        'assets/symptomschanges.jpg'), // Replace with your image path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24.0),
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
                //
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
                      Icons.book_outlined,
                      color: Color(0xFF1F3299),
                      size: 28,
                    ),
                  ),
                  Spacer(), // Adjust the spacing between icon and text
                  Text(
                    'Educational Resources',
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
                      Icons.book_outlined,
                      color: Color(0xFF1F3299),
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 70.0,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                //
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
                      Icons.book_outlined,
                      color: Color(0xFF1F3299),
                      size: 28,
                    ),
                  ),
                  Spacer(), // Adjust the spacing between icon and text
                  Text(
                    'Educational Resources',
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
                      Icons.book_outlined,
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

class Vaccinations extends StatelessWidget {
  const Vaccinations({super.key});

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
                        'assets/vaccination.jpg'), // Replace with your image path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24.0),
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
                    'Vaccinations',
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
            'Protecting your health during pregnancy is vital. Find out which vaccinations are necessary and get tips on preventing infections to keep you and your baby safe.',
            style: TextStyle(fontSize: 18, height: 2, color: Color(0xFFC5D6FF)),
          ),
          const SizedBox(height: 42),
          SizedBox(
            height: 70.0,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                //
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
                      Icons.book_outlined,
                      color: Color(0xFF1F3299),
                      size: 28,
                    ),
                  ),
                  Spacer(), // Adjust the spacing between icon and text
                  Text(
                    'Educational Resources',
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
                      Icons.book_outlined,
                      color: Color(0xFF1F3299),
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 70.0,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                //
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
                      Icons.book_outlined,
                      color: Color(0xFF1F3299),
                      size: 28,
                    ),
                  ),
                  Spacer(), // Adjust the spacing between icon and text
                  Text(
                    'Educational Resources',
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
                      Icons.book_outlined,
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

class MentalHealth extends StatelessWidget {
  const MentalHealth({super.key});

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
                        'assets/mentalhealth.jpg'), // Replace with your image path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24.0),
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
                    'Mental Health',
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
            'Emotional well-being is as important as physical health. Explore resources for managing emotional changes, and find support for dealing with anxiety and depression during pregnancy.',
            style: TextStyle(fontSize: 18, height: 2, color: Color(0xFFC5D6FF)),
          ),
          const SizedBox(height: 42),
          SizedBox(
            height: 70.0,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                //
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
                      Icons.book_outlined,
                      color: Color(0xFF1F3299),
                      size: 28,
                    ),
                  ),
                  Spacer(), // Adjust the spacing between icon and text
                  Text(
                    'Educational Resources',
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
                      Icons.book_outlined,
                      color: Color(0xFF1F3299),
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 70.0,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                //
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
                      Icons.book_outlined,
                      color: Color(0xFF1F3299),
                      size: 28,
                    ),
                  ),
                  Spacer(), // Adjust the spacing between icon and text
                  Text(
                    'Educational Resources',
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
                      Icons.book_outlined,
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
