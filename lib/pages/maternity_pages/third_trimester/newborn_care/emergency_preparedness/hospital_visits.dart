// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';

class HospitalVisits extends StatefulWidget {
  const HospitalVisits({
    Key? key,
  }) : super(key: key);

  @override
  _HospitalVisitsState createState() => _HospitalVisitsState();
}

class _HospitalVisitsState extends State<HospitalVisits>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Preparedness'),
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Color(0xFFEDF2FF),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24.0),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
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
                    'Hospital Visits',
                    style: TextStyle(
                        color: Color(0xFFEDF2FF),
                        letterSpacing: 2,
                        fontSize: 16),
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
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                Content(),
                Content2(),
              ],
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: TabPageSelector(
                controller: _tabController,
                selectedColor: const Color(0xFFEDF2FF),
                color: const Color(0xFF303E8F),
                indicatorSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Content extends StatelessWidget {
  const Content({super.key});

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
              height: 150,
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
                      image: AssetImage('assets/visit/pack.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            const Text(
              'What to Pack',
              style: TextStyle(
                  fontSize: 24,
                  color: Color(0xFFFFE2A2),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                  height: 1.5),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 18.0),
            const Text(
              'For Baby',
              style: TextStyle(
                fontSize: 18,
                height: 1.6,
                color: Color(0xFFEDF2FF),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Diapers, wipes, a change of clothes, a blanket, pacifiers, and any necessary medications.',
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Color(0xFFC5D6FF),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 16.0),
            const Text(
              'For Parents',
              style: TextStyle(
                fontSize: 18,
                height: 1.6,
                color: Color(0xFFEDF2FF),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Personal identification, insurance information, phone charger, snacks, water, and a change of clothes.',
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Color(0xFFC5D6FF),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Comfort Items',
              style: TextStyle(
                fontSize: 18,
                height: 1.6,
                color: Color(0xFFEDF2FF),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Bring items to comfort your baby, such as a favorite toy or blanket.',
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Color(0xFFC5D6FF),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }
}

class Content2 extends StatelessWidget {
  const Content2({super.key});

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
              height: 150,
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
                      image: AssetImage('assets/visit/er.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            const Text(
              'When to Go to the Emergency Room',
              style: TextStyle(
                  fontSize: 24,
                  color: Color(0xFFFFE2A2),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                  height: 1.5),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 18.0),
            const Text(
              'Serious Symptoms',
              style: TextStyle(
                fontSize: 18,
                height: 1.6,
                color: Color(0xFFEDF2FF),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Go to the ER if your baby has trouble breathing, persistent high fever, severe injury, or symptoms of dehydration.',
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Color(0xFFC5D6FF),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Medical Advice',
              style: TextStyle(
                fontSize: 18,
                height: 1.6,
                color: Color(0xFFEDF2FF),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 8.0),
            const Text(
              'If in doubt, call your pediatrician for guidance on whether to seek emergency care.',
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Color(0xFFC5D6FF),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }
}